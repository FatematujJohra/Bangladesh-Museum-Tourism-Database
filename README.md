# Bangladesh Museum Tourism Database

## Project Overview

This project is a relational database system designed to store and manage information about museums and tourism-related cultural artifacts in Bangladesh.

The database includes information about:

* Divisions
* Districts
* Cities
* Museums
* Museum owners
* Categories
* Galleries
* Artifacts
* Donors
* Artifact types
* Materials
* Images
* Museum contact information
* Entry fees
* Opening hours
* Closed days
* Sources

## Project Structure

```text
Bangladesh-Museum-Tourism-Database/
│
├── README.md
│
├── database/
│   ├── schema/
│   │   └── 01_create_tables.sql
│   │
│   ├── data/
│   │   └── CSV data files
│   │
│   └── queries/
│       ├── 01_validation.sql
│       ├── 02_basic_queries.sql
│       └── 03_finding_queries.sql
│
├── etl/
│   ├── load_database.py
│   ├── requirements.txt
│   └── README.md
│
├── documentation/
│   ├── ER_Diagram.png
│   ├── ER_Diagram.pdf
│   ├── ETL_Documentation.pdf
│   └── Finding_Table.pdf
│
└── evidence/
    ├── preflight_success.png
    ├── mysql_load_success.png
    └── sql_validation.png
```

## Database Features

* Relational database design
* Normalized tables
* Primary and foreign key relationships
* Museum and artifact management
* Donor and material information
* Data validation queries
* Basic SQL queries
* Finding and analysis queries

## Technologies Used

* MySQL
* SQL
* Python
* Pandas
* Git and GitHub

## Documentation

The project documentation includes:

* Entity Relationship Diagram
* ETL Documentation
* Finding Tables
* Database validation results

## Author

Sadia Binte Bokhtiar, Sabina Sultana, Nowshin Ara Nargish, Fatema Tuj Johra 

## License

This project is created for educational purposes.
