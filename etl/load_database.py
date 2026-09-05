import csv, os, getpass
import mysql.connector
from mysql.connector import Error

DB='bangladesh_tourism_museum'
BASE=os.path.dirname(os.path.abspath(__file__))
TABLES=[
 ('division.csv','division'),('district.csv','district'),('city.csv','city'),('owner.csv','owner'),('category.csv','category'),
 ('museum.csv','museum'),('gallery.csv','gallery'),('dimension.csv','dimension'),('artifact.csv','artifact'),
 ('donor.csv','donor'),('artifact_type.csv','artifact_type'),('material.csv','material'),
 ('artifact_has_donor.csv','artifact_has_donor'),('artifact_has_type.csv','artifact_has_type'),('artifact_has_material.csv','artifact_has_material'),
 ('image.csv','image'),('museum_phone.csv','museum_phone'),('entry_fee.csv','entry_fee'),('opening_hours.csv','opening_hours'),('closed_days.csv','closed_days'),('contact.csv','contact'),('source.csv','source')]

def clean(v):
    if v is None: return None
    v=str(v).strip()
    return None if v=='' or v.lower() in {'nan','null'} else v

def read_csv(filename):
    path=os.path.join(BASE,filename)
    with open(path,encoding='utf-8-sig',newline='') as f:
        reader=csv.reader(f); headers=next(reader); rows=[]
        for line_no,row in enumerate(reader,2):
            if len(row)!=len(headers): raise ValueError(f'{filename}: line {line_no} has {len(row)} fields; expected {len(headers)}')
            rows.append([clean(x) for x in row])
    return headers,rows

def preflight():
    loaded={}
    for filename,table in TABLES:
        headers,rows=read_csv(filename); loaded[table]=(headers,rows)
    # Required values that must exist in the normalized dataset.
    required={
      'division':['Division_ID','Division_Name'],'district':['District_ID','District_Name','Division_ID'],
      'city':['City_ID','City_Name','District_ID'],'owner':['Owner_ID','Owner_Name'],'category':['Category_ID','Category_Name'],
      'museum':['Museum_ID','City_ID','Museum_Name'],'gallery':['Museum_ID','Gallery_No'],
      'dimension':['Dimension_ID'],'artifact':['Artifact_ID','Artifact_Name','Museum_ID'],
      'donor':['Donor_ID','Donor_Name'],'artifact_type':['Artifact_Type_ID','Artifact_Type_Name'],
      'material':['Material_ID','Material_Name'],'artifact_has_donor':['Artifact_ID','Donor_ID'],
      'artifact_has_type':['Artifact_ID','Artifact_Type_ID'],'artifact_has_material':['Artifact_ID','Material_ID'],
      'image':['Artifact_ID','Image_URL'],'museum_phone':['Museum_ID','Phone_Number'],
      'entry_fee':['Museum_ID','Fee_Type'],'opening_hours':['Museum_ID','Day_Name'],
      'closed_days':['Museum_ID','Closed_Day_Name'],'contact':['Museum_ID'],'source':['Museum_ID','Source_Link']}
    for table,cols in required.items():
        headers,rows=loaded[table]; idx={h:i for i,h in enumerate(headers)}
        missing=[c for c in cols if c not in idx]
        if missing:
            raise ValueError(f'Preflight failed: {table}.csv missing column(s): {missing}')

        for col in cols:
            bad=[i+2 for i,r in enumerate(rows) if not r[idx[col]]]
            if bad: raise ValueError(f'Preflight failed: {table}.{col} is blank at CSV lines {bad[:10]}')
    # PK/relationship checks
    def vals(table,col):
        h,r=loaded[table]; return {x[h.index(col)] for x in r if x[h.index(col)]}
    checks=[('artifact_has_donor','Artifact_ID','artifact','Artifact_ID'),('artifact_has_donor','Donor_ID','donor','Donor_ID'),
            ('artifact_has_type','Artifact_ID','artifact','Artifact_ID'),('artifact_has_type','Artifact_Type_ID','artifact_type','Artifact_Type_ID'),
            ('artifact_has_material','Artifact_ID','artifact','Artifact_ID'),('artifact_has_material','Material_ID','material','Material_ID'),
            ('image','Artifact_ID','artifact','Artifact_ID')]
    for t,c,rt,rc in checks:
        h,r=loaded[t]; i=h.index(c); ref=vals(rt,rc); bad=[j+2 for j,x in enumerate(r) if x[i] not in ref]
        if bad: raise ValueError(f'Preflight failed: {t}.{c} has unknown referenced value at CSV lines {bad[:10]}')
    return loaded

def load_table(cur, filename, table, cached):
    headers,rows=cached[table]
    cols=', '.join('`'+h+'`' for h in headers); ph=', '.join(['%s']*len(headers))
    sql=f'INSERT INTO `{table}` ({cols}) VALUES ({ph})'
    for vals in rows: cur.execute(sql, vals)
    return len(rows)

user=input('MySQL user [root]: ') or 'root'
host=input('MySQL host [localhost]: ') or 'localhost'
password=getpass.getpass('MySQL password: ')
cn=None
try:
    print('Running dataset preflight...')
    cached=preflight()
    print('Preflight OK: all required CSV values and checked FK references are valid.')
    cn=mysql.connector.connect(host=host,user=user,password=password)
    cur=cn.cursor()
    cur.execute(f'CREATE DATABASE IF NOT EXISTS `{DB}` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci')
    cur.execute(f'USE `{DB}`')
    with open(os.path.join(BASE,'01_create_tables.sql'),encoding='utf-8') as f:
        for statement in f.read().split(';'):
            s=statement.strip()
            if s and not s.upper().startswith('CREATE DATABASE') and not s.upper().startswith('USE '): cur.execute(s)
    total=0
    for filename,table in TABLES:
        n=load_table(cur,filename,table,cached); total+=n; print(f'Loaded {n:>5} rows -> {table}')
    cn.commit(); print(f'ETL LOAD COMPLETE. Total rows loaded: {total}')
except (Error, ValueError) as e:
    if cn: cn.rollback()
    print('ERROR:',e)
    raise
finally:
    if cn and cn.is_connected(): cn.close()
