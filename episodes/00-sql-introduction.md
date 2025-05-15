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

> **Note:** Participants should complete this setup *before* the start of the workshop.

This lesson uses [SQL Developer](https://www.oracle.com/uk/database/sqldeveloper/) along with the [Portal Project dataset](https://figshare.com/articles/Portal_Project_Teaching_Database/1314459).

Please refer to the [Setup instructions](../learners/setup.md) for detailed guidance on:

* Downloading and extracting the dataset.
* Installing and configuring SQL Developer.
* Accessing the Oracle database, including how to obtain the necessary credentials.

Make sure you’ve completed all steps before attending the session, as we will begin working with the data and database right away.

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

Let’s explore the data available in the database. Once you have your credentials, connect to the database by following these steps:

#### 1. Create a New Connection in SQL Developer

1. Open **SQL Developer** and click the green `+` icon to create a new connection.
2. Enter the following details:

   * **Name**: *PORTAL MAMMALS* (or any name you prefer)
   * **Username**: (provided by your instructor)
   * **Password**: (provided by your instructor)
   * **Connection Type**: `TNS`
   * **Network Alias**: `LIVDV1`
3. Click **Connect**.

Once connected, you’ll see a list of schemas on the left panel. Select the `DIGIOCEAN` schema. This will display the database tables in the main panel: **PLOTS**, **SPECIES**, and **SURVEYS**. Each table corresponds to one of the CSV files you explored earlier.

To view the contents of a table, click on the table name, then go to the **Data** tab. This provides a spreadsheet-like view of the table contents.

This visual structure helps to reinforce a key idea: a database is essentially a collection of tables, where the "relational" part comes from the links—or **relationships**—between those tables.

If you click the **Columns** tab, you’ll see metadata about the table: column names (also known as *fields*), their data types, and other information. For example:

* The **surveys** table contains mostly numerical data (e.g., `NUMBER`, `FLOAT`).
* The **species** table contains mostly text fields (`VARCHAR`).

To summarize:

* A **relational database** stores data in **tables** made up of **fields** (columns) and **records** (rows).
* Each field stores only one type of data, and all entries in a field share the same data type.
* You can use **queries** to extract and analyze data, often by joining tables together based on shared information.

### Database Design

- Every row-column combination contains a single *atomic* value, i.e., not
  containing parts we might want to work with separately.
- One field per type of information
- No redundant information
  - Split into separate tables with one table per class of information
  - Needs an identifier in common between tables – shared column - to
    reconnect (known as a *foreign key*).

### Import

In this workshop, we’ve already imported data into the **PLOTS** and **SURVEYS** tables. The **SPECIES** table, however, is intentionally left empty so you can practice importing data yourself.

There are two common ways to import data into a database using **SQL Developer**:

1. **Using SQL scripts** (e.g., `.sql` files with `INSERT` statements).
2. **Using the graphical interface (GUI) to import the `csv` file** — this is what we’ll use.

To import the `species.csv` file:

1. Right-click on the **SPECIES** table.
2. Select **Import Data**.
3. In the window that opens, browse to select the `species.csv` file.
4. Click **Next** through the prompts until you reach **Finish**.
5. Monitor the import process in the bottom panel. When it’s complete, you’ll see a success message.

And now we can start writing our own queries!

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

You can also modify existing tables to add, edit, or remove fields (columns) using the SQL Developer interface.

1. **Edit the Table**:
   Right-click on the table name in the left-hand panel and select **Edit**. This opens a new window displaying the table structure.

2. **Add a New Field**:
   Click the **`+` (Add Column)** icon to insert a new field. You’ll be prompted to:

   * Enter a name for the new column.
   * Choose an appropriate data type (e.g., `VARCHAR`, `NUMBER`, etc.).

3. **Delete a Field**:
   To remove a column, click the **`x` (Delete Column)** icon next to the field you want to remove.

4. **Save Your Changes**:
   Once you’re done, click **OK** in the bottom-right corner of the window to apply the changes to the table.


### Data Types {#datatypes}

You can see below a list of data types used in Oracle databases. The data types are used to define the type of data that can be stored in a field. Each data type has its own characteristics and limitations.

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


As we mention before, there are other database management systems (DBMS) that use
different data types. The data types used in Oracle are not the same as those used in other DBMSs. The following table shows some of the common names of data types between the various database platforms:

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
