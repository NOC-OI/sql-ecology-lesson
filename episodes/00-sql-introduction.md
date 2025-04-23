---
title: Introducing Databases and SQL
teaching: 60
exercises: 5
---

::::::::::::::::::::::::::::::::::::::: objectives

- Describe why relational databases are useful.
- Create and populate a database from a text file.
- Define Oracle data types.

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- What is a relational database and why should I use it?
- What is SQL?

::::::::::::::::::::::::::::::::::::::::::::::::::

### Setup

*Note: this should have been done by participants before the start of the workshop.*

We use [Adminer](https://oracle-access.shop/) and the
[Portal Project dataset](https://nocacuk-my.sharepoint.com/:f:/g/personal/tobfer_noc_ac_uk/Episk-ovbHdAv-CwEsJppjcB4Sei4kId3rGezf2qZiv8Qw?e=bAGdol)
throughout this lesson. See [Setup](../learners/setup.md) for
instructions on how to download the data, and also how to have access to the database credentials

## Motivation

To start, let's orient ourselves in our project workflow.  Previously,
we used Excel and OpenRefine to go from messy, human created data
to cleaned, computer-readable data.  Now we're going to move to the next piece
of the data workflow, using the computer to read in our data, and then
use it for analysis and visualisation.

### What is SQL?

SQL stands for Structured Query Language. SQL allows us to interact with relational databases through queries.
These queries can allow you to perform a number of actions such as: insert, select, update and delete information in a database.

### Dataset Description

The data we will be using is a time-series for a small mammal community in
southern Arizona. This is part of a project studying the effects of rodents and
ants on the plant community that has been running for almost 40 years.  The
rodents are sampled on a series of 24 plots, with different experimental
manipulations controlling which rodents are allowed to access which plots.

This is a real dataset that has been used in over 100 publications. We've
simplified it for the workshop, but you can download the
[full dataset](https://esapubs.org/archive/ecol/E090/118/) and work with it using
exactly the same tools we'll learn about today.

### Questions

Let's look at some of the cleaned spreadsheets you downloaded during [Setup](../learners/setup.md) to complete this challenge. You'll need the following three files:

- `surveys.csv`
- `species.csv`
- `plots.csv`

:::::::::::::::::::::::::::::::::::::::  challenge

### Challenge

Open each of these csv files and explore them.
What information is contained in each file?  Specifically, if I had
the following research questions:

- How has the hindfoot length and weight of *Dipodomys* species changed over time?
- What is the average weight of each species, per year?
- What information can I learn about *Dipodomys* species in the 2000s, over time?

What would I need to answer these questions?  Which files have the data I need? What
operations would I need to perform if I were doing these analyses by hand?


::::::::::::::::::::::::::::::::::::::::::::::::::

### Goals

In order to answer the questions described above, we'll need to do the
following basic data operations:

- select subsets of the data (rows and columns)
- group subsets of data
- do math and other calculations
- combine data across spreadsheets

In addition, we don't want to do this manually!  Instead of searching
for the right pieces of data ourselves, or clicking between spreadsheets,
or manually sorting columns, we want to make the computer do the work.

In particular, we want to use a tool where it's easy to repeat our analysis
in case our data changes. We also want to do all this searching without
actually modifying our source data.

Putting our data into a relational database and using SQL will help us achieve these goals.

:::::::::::::::::::::::::::::::::::::::::  callout

### Definition: *Relational Database*

A relational database stores data in *relations* made up of *records* with *fields*.
The relations are usually represented as *tables*;
each record is usually shown as a row, and the fields as columns.
In most cases, each record will have a unique identifier, called a *key*,
which is stored as one of its fields.
Records may also contain keys that refer to records in other tables,
which enables us to combine information from two or more sources.


::::::::::::::::::::::::::::::::::::::::::::::::::

## Databases

### Why use relational databases

Using a relational database serves several purposes.

- It keeps your data separate from your analysis.
  - This means there's no risk of accidentally changing data when you analyze it.
  - If we get new data we can rerun the query.
- It's fast, even for large amounts of data.
- It improves quality control of data entry (type constraints and use of forms in MS Access, Filemaker, Oracle Application Express etc.)
- The concepts of relational database querying are core to understanding how to do similar things using programming languages such as R or Python.

### Database Management Systems

There are different database management systems to work with relational databases
such as SQLite, MySQL, PostgreSQL, MSSQL Server, and many more. Each of them differ
mainly based on their scalability, but they all share the same core principles of
relational databases. In this lesson, we use Oracle, which is a commercial database
management system. This is the database system used by many large companies,
like National Oceanography Centre (NOC).

### Relational databases

Let's look at a pre-existing database, using the main BODC user that we described in the
[Setup](../learners/setup.md). In [Adminer link](https://oracle-access.shop/), use the following credentials:

- **System**: Oracle (beta)
- **Server**: `//oracle-service.default.svc.cluster.local:1521/PORTAL_MAMMALS`
- **Username**: `BODC`
- **Password**: `bodc`

Once you log in, you will see a screen with a side bar on the left and a main panel on the right.
On the left side bar, please set **DB** to `USERS` and **Schema** to `BODC`. This will show you the tables in the database on the main panel and allows us to browse the data in those tables.

You can see the tables in the database by looking at the left side bar. Here you will see a list under with some "Tables" starting with "select" before the name of the table." Each item listed here corresponds to one of the `csv` files
we were exploring earlier. To see the contents of any table, right-click on it, and
then click the "Select data" from the main panel. This will
give us a view that we're used to - a copy of the table. Hopefully this
helps to show that a database is, in some sense, only a collection of tables,
where there's some value in the tables that allows them to be connected to each
other (the "related" part of "relational database").

On the main panel, if you click on "Show Structure" you will see some metadata about each table, like information about the columns, which in databases are referred to as "fields," and their assigned data types.
(The rows of a database table
are called *records*.) Each field contains
one variety or type of data, often numbers or text. You can see in the
`surveys` table that most fields contain numbers (NUMBER and FLOAT, or floating point numbers/decimals) while the `species`
table is entirely made up of text fields (VARCHAR).

The "SQL Command" option on the left side bar is blank now - this is where we'll be typing our queries
to retrieve information from the database tables.

To summarize:

- Relational databases store data in tables with fields (columns) and records
  (rows)
- Data in tables has types, and all values in a field have
  the same type ([list of data types](#datatypes))
- Queries let us look up data or make calculations based on columns

### Database Design

- Every row-column combination contains a single *atomic* value, i.e., not
  containing parts we might want to work with separately.
- One field per type of information
- No redundant information
  - Split into separate tables with one table per class of information
  - Needs an identifier in common between tables – shared column - to
    reconnect (known as a *foreign key*).

### Import

Before we get started with writing our own queries, we are going to start work with your own empty databases (just the tables are already created). We'll be seeding the database using the data from teh three `csv` files we downloaded earlier. However, as it is not possible to directly open a csv file on a Oracle Database, on the same download folder you have access to the `sql`files that has the convertion from the csv to sql commands. Logout in the current database (button in the upper right part of the screen) and follow these instructions:

1. Connect to the new database. Please use the credentials provided by your instructor.
2. Set **DB** to `USERS` and **Schema** to `BODC`. After that, you should see the tables in the database on the main panel. You can see that all tables are empty.
3. Click on the **Import** link in the left sidebar.
4. We are going to update the *surveys* data. However, because the number of the records and the limitation of the servers, we broke the file in for parts: `surveys1.sql`, `surveys2.sql`, `surveys3.sql`, `surveys4.sql`. You are going to repeat the operation described on **5** four times, one for each file.
5. On the **File upload**, choose `surveys1.sql` (or 2, 3, 4) from the data folder we downloaded and click **Execute**. You are going to see a message that the table was imported.
6. Now, click on **select SURVEYS >> Select data** to see the data in the table.

:::::::::::::::::::::::::::::::::::::::  challenge

### Challenge

- Import data into `plots` and `species` tables


::::::::::::::::::::::::::::::::::::::::::::::::::


### Information about the tables


The following table shows the fields in each of the tables, their data types, and the motivation for their data type.



| Field                                                 | Data Type                                                                                                | Motivation                                                              | Table(s)         |
| ----------------------------------------------------- | :------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- | ---------------- |
| day                                                   | NUMBER                                                                                                  | Having data as numeric allows for meaningful arithmetic and comparisons | surveys          |
| genus                                                 | VARCHAR2(50)                                                                                                     | Field contains text data                                                | species          |
| hindfoot\_length                                       | FLOAT(126,)                                                                                                     | Field contains measured numeric data                                    | surveys          |
| month                                                 | NUMBER                                                                                                  | Having data as numeric allows for meaningful arithmetic and comparisons | surveys          |
| plot\_id                                               | NUMBER                                                                                                  | Field contains numeric data                                             | plots, surveys   |
| plot\_type                                             | VARCHAR2(100)                                                                                                     | Field contains text data                                                | plots            |
| record\_id                                             | NUMBER                                                                                                  | Field contains numeric data                                             | surveys          |
| sex                                                   | VARCHAR2(1)                                                                                                     | Field contains text data                                                | surveys          |
| species\_id                                            | VARCHAR2(10)                                                                                                     | Field contains text data                                                | species, surveys |
| species                                               | VARCHAR2(50)                                                                                                     | Field contains text data                                                | species          |
| taxa                                                  | VARCHAR2(20)                                                                                                     | Field contains text data                                                | species          |
| weight                                                | FLOAT(126,)                                                                                                     | Field contains measured numerical data                                  | surveys          |
| year                                                  | NUMBER                                                                                                  | Allows for meaningful arithmetic and comparisons                        | surveys          |


### Modifying/Adding fields to existing tables

You can also use this same approach to modify/append new fields to an existing table.


1. To alter table, go  **select SURVEYS >> Alter table**. This will show you the fields in the table and their data types and will allow you to change them.
2. In the same option, you can add an item, by clicking in the **+** icon. This will allow you to add a new field and assign it a data type.
3. You can also delete a field by clicking on the **x** icon. This will delete the field from the table.
4. To save the changes, click on the **Save** button in the bottom right corner of the main panel.

### Data Types {#datatypes}

| Data Type                     | Description                                                                 |
|------------------------------|------------------------------------------------------------------------------|
| `CHAR(n)`                    | Fixed-length character string. Maximum size is 2000 bytes.                   |
| `VARCHAR2(n)`                | Variable-length character string. Maximum size is 4000 bytes.               |
| `NCHAR(n)`                   | Fixed-length national character set string.                                 |
| `NVARCHAR2(n)`               | Variable-length national character set string.                              |
| `NUMBER(p, s)`               | Numeric value with precision `p` and scale `s`. Can represent integers and decimals. |
| `FLOAT`                      | Approximate numeric with binary precision. Synonym for `NUMBER`.            |
| `BINARY_FLOAT`               | 32-bit floating point number (approximate numeric).                         |
| `BINARY_DOUBLE`              | 64-bit floating point number (approximate numeric).                         |
| `DATE`                       | Stores date and time to the second (YYYY-MM-DD HH24:MI:SS).                 |
| `TIMESTAMP`                  | More precise date-time, optionally with fractional seconds and time zone.   |
| `INTERVAL YEAR TO MONTH`     | Represents a period of time in years and months.                            |
| `INTERVAL DAY TO SECOND`     | Represents a period of time in days, hours, minutes, and seconds.           |
| `CLOB`                       | Character Large Object—used to store large text data.                       |
| `BLOB`                       | Binary Large Object—used to store large binary data.                        |
| `BFILE`                      | A pointer to binary file stored outside the database.                       |
| `RAW(n)`                     | Variable-length binary or byte data. Maximum size is 2000 bytes.            |
| `LONG`                       | Variable-length character data (deprecated; use `CLOB` instead).            |
| `XMLTYPE`                    | Used to store and query XML data.                                           |


### SQL Data Type Quick Reference {#datatypediffs}

Different databases offer different choices for the data type definition.

The following table shows some of the common names of data types between the various database platforms:

Data Type | MS Access | SQL Server | Oracle | MySQL | PostgreSQL | SQLite
Boolean | Yes/No | BIT | No native boolean* | No native boolean** | BOOLEAN | No native boolean***
Integer | Number (Integer) | INT / INTEGER | NUMBER | INT / INTEGER | INT / INTEGER | INTEGER
Float / Real | Number (Single) | FLOAT / REAL | FLOAT / NUMBER | FLOAT | NUMERIC / REAL | REAL / FLOAT
Currency / Money | Currency | MONEY | No native type | No native type | MONEY | No native type
String (fixed length) | — | CHAR(n) | CHAR(n) | CHAR(n) | CHAR(n) | TEXT (no strict typing)
String (variable length) | Text (<256) / Memo (65K+) | VARCHAR(n) | VARCHAR2(n) | VARCHAR(n) | VARCHAR(n) / TEXT | TEXT
Large text | Memo | TEXT | CLOB | TEXT | TEXT | TEXT
Binary (fixed) | — | BINARY(n) | RAW(n) | BINARY(n) | BYTEA | No strict support
Binary (variable / large) | OLE Object | VARBINARY, IMAGE | BLOB, LONG RAW | BLOB | BYTEA, BLOB | BLOB
Date/Time | Date/Time | DATETIME, SMALLDATETIME | DATE, TIMESTAMP | DATETIME, TIMESTAMP | TIMESTAMP / DATE | DATETIME, TEXT

:::::::::::::::::::::::::::::::::::::::: keypoints

- SQL allows us to select and group subsets of data, do math and other calculations, and combine data.
- A relational database is made up of tables which are related to each other by shared keys.
- Different database management systems (DBMS) use slightly different vocabulary, but they are all based on the same ideas.

::::::::::::::::::::::::::::::::::::::::::::::::::
