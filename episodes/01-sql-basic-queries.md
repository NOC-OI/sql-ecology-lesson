---
title: Accessing Data With Queries
teaching: 30
exercises: 5
---

::::::::::::::::::::::::::::::::::::::: objectives

- Write and build queries.
- Filter data given various criteria.
- Sort the results of a query.

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- How do I write a basic query in SQL?

::::::::::::::::::::::::::::::::::::::::::::::::::

## Writing my First Query

Let’s begin by using the **surveys** table. This table contains data on every individual captured at the site, including when and where they were captured, their species ID, sex, and weight in grams.

We’ll start by writing an SQL query to select all columns from the surveys table. In **SQL Developer**, right click on the `DIGIOCEAN` name on the left side bar. And then click in **Open SQL Worksheet**. You can type your SQL statement in the query box and then click on the **>** button to run the query. (Alternatively, you can use the keyboard shortcut **Cmd-Enter** on a Mac or **Ctrl-Enter** on a Windows/Unix machine.) The results will appear in the box below your query.

To select all columns from a table, use the asterisk (`*`) wildcard, like so:

```sql
SELECT *
FROM surveys;
```
We have capitalized the words SELECT and FROM because they are SQL keywords.
SQL is case insensitive, but it helps for readability, and is good style.

If we want to select a single column, we can type the column name instead of the wildcard \*.

```sql
SELECT year
FROM surveys;
```

If we want more information, we can add more columns to the list of fields,
right after SELECT:

```sql
SELECT year, month, day
FROM surveys;
```

### Limiting Results

Sometimes, you don’t need to view all the results—just a sample to understand what’s being returned. In such cases, particularly when working with large databases, you can use the `FETCH FIRST` clause in Oracle to limit the number of rows shown.

```sql
SELECT *
FROM surveys
FETCH FIRST 10 ROWS ONLY;
```

### Unique Values

If we want to see only the unique values—for example, to get a quick look at which species have been sampled—we can use `DISTINCT`:

```sql
SELECT DISTINCT species_id
FROM surveys;
```

If you select more than one column, `DISTINCT` returns unique combinations of values across those columns:

```sql
SELECT DISTINCT year, species_id
FROM surveys;
```

### Calculated values

We can also do calculations with the values in a query.
For example, if we wanted to look at the mass of each individual
on different dates, but we needed it in kg instead of g we would use

```sql
SELECT year, month, day, weight / 1000
FROM surveys;
```

When we run the query, the expression `weight / 1000` is evaluated for each
row and appended in a new column to the table returned by the query. Note that
the new column only exists in the query results—the surveys table itself is
not changed. Expressions can use any fields, any arithmetic
operators (`+`, `-`, `*`, and `/`) and a variety of built-in functions. For
example, we could round the values to make them easier to read.

```sql
SELECT plot_id, species_id, sex, weight, ROUND(weight / 1000, 2)
FROM surveys;
```

:::::::::::::::::::::::::::::::::::::::::  callout

### Importing data using *SQL Commands*

In Oracle Databases, you can import data using the **SQL Commands**. This allows you to execute SQL statements directly on the database. You can use this feature to create tables, insert data, and perform various operations on your database.

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::  challenge

## Challenge

- Write a query that returns the year, month, day, species\_id and weight in mg.

:::::::::::::::  solution

## Solution

```sql
SELECT day, month, year, species_id, weight * 1000
FROM surveys;
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

## Filtering

Databases can also filter data – selecting only the data meeting certain
criteria.  For example, let's say we only want data for the species
*Dipodomys merriami*, which has a species code of DM.  We need to add a
`WHERE` clause to our query:

```sql
SELECT *
FROM surveys
WHERE species_id='DM';
```

We can do the same thing with numbers.
Here, we only want the data since 2000:

```sql
SELECT * FROM surveys
WHERE year >= 2000;
```

If the `year` field is stored as a `CHAR` or `VARCHAR2` (i.e., as text), the condition should be:


```sql
WHERE year >= '2000'
```

We can use more sophisticated conditions by combining tests
with `AND` and `OR`.  For example, suppose we want the data on *Dipodomys merriami*
starting in the year 2000:

```sql
SELECT *
FROM surveys
WHERE (year >= 2000) AND (species_id = 'DM');
```

Note that the parentheses are not needed, but again, they help with
readability.  They also ensure that the computer combines `AND` and `OR`
in the way that we intend.

If we wanted to get data for any of the *Dipodomys* species, which have
species codes `DM`, `DO`, and `DS`, we could combine the tests using OR:

```sql
SELECT *
FROM surveys
WHERE (species_id = 'DM') OR (species_id = 'DO') OR (species_id = 'DS');
```
Alternatively, we can simplify this using the `IN` operator:

```sql
SELECT *
FROM surveys
WHERE species_id IN ('DM', 'DO', 'DS');
```
This is equivalent to the previous query, but is easier to read.

You can also write a negative condition using `NOT`:

```sql
SELECT *
FROM surveys
WHERE NOT (species_id = 'DM');
```

This will return all rows where the species ID is not *Dipodomys merriami*.

:::::::::::::::::::::::::::::::::::::::  challenge

## Challenge

- Produce a table listing the data for all individuals in Plot 1
  that weighed more than 75 grams, telling us the date, species id code, and weight
  (in kg).

:::::::::::::::  solution

## Solution

```sql
SELECT day, month, year, species_id, weight / 1000
FROM surveys
WHERE (plot_id = 1) AND (weight > 75);
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

## Building more complex queries

Now, let's combine the above queries to get data for the 3 *Dipodomys* species from
the year 2000 on.  This time, let's use IN as one way to make the query easier
to understand:

```sql
SELECT *
FROM surveys
WHERE (year >= 2000) AND (species_id IN ('DM', 'DO', 'DS'));
```

We started with something simple, then added more clauses one by one, testing
their effects as we went along.  For complex queries, this is a good strategy,
to make sure you are getting what you want.  Sometimes it might help to take a
subset of the data that you can easily see in a temporary database to practice
your queries on before working on a larger or more complicated database.

When the queries become more complex, it can be useful to add comments. In SQL,
comments are started by `--`, and end at the end of the line. For example, a
commented version of the above query can be written as:

```sql
-- Get post 2000 data on Dipodomys' species
-- These are in the surveys table, and we are interested in all columns
SELECT * FROM surveys
-- Sampling year is in the column `year`, and we want to include 2000
WHERE (year >= 2000)
-- Dipodomys' species have the `species_id` DM, DO, and DS
AND (species_id IN ('DM', 'DO', 'DS'));
```

Although SQL queries often read like plain English, it is *always* useful to add
comments; this is especially true of more complex queries.

## Sorting

We can also sort the results of our queries by using `ORDER BY`.
For simplicity, let's go back to the **species** table and alphabetize it by taxa.

First, let's look at what's in the **species** table. It's a table of the species\_id and the full genus, species and taxa information for each species\_id. Having this in a separate table is nice, because we didn't need to include all
this information in our main **surveys** table.

```sql
SELECT *
FROM species;
```

Now let's order it by taxa.

```sql
SELECT *
FROM species
ORDER BY taxa ASC;
```

The keyword `ASC` tells us to order it in ascending order.
We could alternately use `DESC` to get descending order.

```sql
SELECT *
FROM species
ORDER BY taxa DESC;
```

`ASC` is the default, so it can be omitted.

We can also sort on several fields at once.
To truly be alphabetical, we might want to order by genus then species.

```sql
SELECT *
FROM species
ORDER BY genus ASC, species ASC;
```

:::::::::::::::::::::::::::::::::::::::  challenge

## Challenge

- Write a query that returns `year`, `species_id`, and `weight` in kg from the `surveys`
table, sorted with the largest weights at the top. Please note that you may need to remove the `NULL` values from the `weight` column to ensure proper sorting. To do this, you can use the `WHERE` clause to filter out the `NULL` values, using `WHERE weight IS NOT NULL`.

:::::::::::::::  solution

## Solution

```sql
-- Get the year, species_id, and weight in kg
SELECT year, species_id, weight / 1000
-- from the surveys table
FROM surveys
-- only include rows where weight is not null
WHERE weight IS NOT NULL
-- sort by weight in descending order
ORDER BY weight DESC;
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

## Order of execution

Another note for ordering. We don't actually have to display a column to sort by
it.  For example, let's say we want to order the birds by their species ID, but
we only want to see genus and species.

```sql
SELECT genus, species
FROM species
WHERE taxa = 'Bird'
ORDER BY species_id ASC;
```

We can do this because sorting occurs earlier in the computational pipeline than
field selection.

The computer is basically doing this:

1. Filtering rows according to WHERE
2. Sorting results according to ORDER BY
3. Displaying requested columns or expressions.

Clauses are written in a fixed order: `SELECT`, `FROM`, `WHERE`, then `ORDER BY`.

::::::::::::::::::::::::::::::::::::::  discussion

## Multiple statements

It is possible to write a query as a single line, but for readability, we recommend to put each clause on its own line.
The standard way to separate a whole SQL statement is with a semicolon. This allows more than one SQL statement to be executed together.


::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::  challenge

## Challenge

- Let's try to combine what we've learned so far in a single
  query. Using the surveys table, write a query to display the three date fields,
  `species_id`, and weight in kilograms (rounded to two decimal places), for
  individuals captured in 1999, ordered alphabetically by the `species_id`.
- Write the query as a single line, then put each clause on its own line, and
  see how more legible the query becomes!

:::::::::::::::  solution

## Solution

```sql
SELECT year, month, day, species_id, ROUND(weight / 1000, 2)
FROM surveys
WHERE year = 1999
ORDER BY species_id;
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: keypoints

- It is useful to apply conventions when writing SQL queries to aid readability.
- Use logical connectors such as AND or OR to create more complex queries.
- Calculations using mathematical symbols can also be performed on SQL queries.
- Adding comments in SQL helps keep complex queries understandable.

::::::::::::::::::::::::::::::::::::::::::::::::::
