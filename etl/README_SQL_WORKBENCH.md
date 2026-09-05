# Bangladesh Tourism & Museum Database — SQL Workbench ETL Package

This package is prepared for MySQL Workbench and Python ETL.

## Important
The conceptual ER diagram should remain a Chen ER model. M:N relationships are shown as relationships. The relational implementation uses junction tables for the M:N relationships.

## Run
1. Install MySQL Server + MySQL Workbench.
2. Install Python 3.10+ and run `python -m pip install -r requirements.txt`.
3. Run `01_create_tables.sql` in MySQL Workbench, or simply run `python load_database.py`.
4. Execute `02_queries.sql` to explore the database.
5. Execute `03_validation_queries.sql` to demonstrate ETL validation.

## Load order
Division → District → City → Owner → Category → Museum → Gallery/Dimension → Artifact → Donor/Type/Material → junction tables → Image → museum_phone → visiting-information tables → Contact → Source.

## Staging
`staging/` contains LWM extraction/full/index files kept for traceability. They are not loaded as additional normalized tables.

IMPORTANT v3 FIX: Number_of_Galleries is stored as VARCHAR because the source contains values such as "4 galleries" and "44-46 galleries". Fee_Amount is also VARCHAR because some source fee values contain explanatory text. Ten empty artifact rows without Artifact_Name were removed rather than inventing names. Two missing gallery references for Museum_ID 62 were added: Coin Collection and Stone Sculpture Collection.
