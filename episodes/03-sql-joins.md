---
title: Combining Data With Joins
teaching: 15
exercises: 10
---

::::::::::::::::::::::::::::::::::::::: objectives

- Employ joins to combine data from two tables.
- Apply functions to manipulate individual values.
- Employ aliases to assign new names to tables and columns in a query.

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- How do I bring data together from separate tables?

::::::::::::::::::::::::::::::::::::::::::::::::::

## Joins

To combine data from two tables we use an SQL `JOIN` clause, which comes after
the `FROM` clause.

Database tables are used to organise and group data by common characteristics or principles.
Often, we need to combine elements from separate tables into a single table or queries for analysis and visualisation.
A `JOIN` is a way to combine columns from multiple tables using values common to each. The `JOIN` keyword, combined with `ON`, is used to bring together fields from different tables.

A `JOIN` clause on its own will produce a **Cartesian product**, where each row in
the first table is paired with every row in the second table. This is usually **not**
what we want when combining two related datasets.

For that, we need to tell the computer which columns provide the link between the two
tables using the word `ON`.  What we want is to join the data with the same
species id.

```sql
SELECT *
FROM surveys
JOIN species
ON surveys.species_id = species.species_id;
```

`ON` is like `WHERE`. It filters things out according to a test condition.  We use
the `table.colname` format to tell the manager what column in which table we are
referring to.

The output from using the `JOIN` clause will have columns from the first table plus the
columns from the second table. For the above statement, the output will be a table
that has the following column names:

| record\_id | month                                                                           | day | year      | plot\_id  | species\_id | sex | hindfoot\_length | weight | species\_id | genus     | species  | taxa   |
| --------- | ------------------------------------------------------------------------------- | --- | --------- | -------- | ---------- | --- | --------------- | ------ | ---------- | --------- | -------- | ------ |
| ...       |                                                                                 |     |           |          |            |     |                 |        |            |           |          |        |
| 96        | 8                                                                               | 20  | 1997      | 12       | **DM**           | M   | 36              | 41     | **DM**           | Dipodomys | merriami | Rodent |
| ...       |                                                                                 |     |           |          |            |     |                 |        |            |           |          |        |


You can see that `species_id` appears twice—once from the `surveys` table and once from the `species` table—because both tables include a column with the same name.

Alternatively, we can use the word `USING`, as a short-hand. `USING` only
works on columns which share the same name. In this case we are
telling the manager that we want to combine `surveys` with `species` and that
the common column is `species_id`.

```sql
SELECT *
FROM surveys
JOIN species
USING (species_id);
```

The output will only have one **species\_id** column

| record\_id | month                                                                           | day | year      | plot\_id  | species\_id | sex | hindfoot\_length | weight | genus      | species   | taxa     |
| --------- | ------------------------------------------------------------------------------- | --- | --------- | -------- | ---------- | --- | --------------- | ------ | ---------- | --------- | -------- |
| ...       |                                                                                 |     |           |          |            |     |                 |        |            |           |          |
| 96        | 8                                                                               | 20  | 1997      | 12       | DM         | M   | 36              | 41     | Dipodomys  | merriami  | Rodent   |
| ...       |                                                                                 |     |           |          |            |     |                 |        |            |           |          |

We often won't want all of the fields from both tables, so anywhere we would
have used a field name in a non-join query, we can use `table.colname`.

For example, what if we wanted information on when individuals of each
species were captured, but instead of their species ID we wanted their
actual species names.

```sql
SELECT surveys.year, surveys.month, surveys.day, species.genus, species.species
FROM surveys
JOIN species
ON surveys.species_id = species.species_id;
```

| year      | month                                                                           | day | genus     | species  |
| --------- | ------------------------------------------------------------------------------- | --- | --------- | -------- |
| ...       |                                                                                 |     |           |          |
| 1977      | 7                                                                               | 16  | Neotoma   | albigula |
| 1977      | 7                                                                               | 16  | Dipodomys | merriami |
| ...       |                                                                                 |     |           |          |

Many databases, including **Oracle**, also support a join through the `WHERE` clause of a query.
For example, you may see the query above written without an explicit JOIN.

```sql
SELECT surveys.year, surveys.month, surveys.day, species.genus, species.species
FROM surveys, species
WHERE surveys.species_id = species.species_id;
```

For the remainder of this lesson, we'll stick with the explicit use of the `JOIN` keyword for
joining tables in SQL.

:::::::::::::::::::::::::::::::::::::::  challenge

## Challenge:

- Write a query that returns the genus, the species name, and the weight
  of every individual captured at the site

:::::::::::::::  solution

## Solution

```sql
SELECT species.genus, species.species, surveys.weight
FROM surveys
JOIN species
ON surveys.species_id = species.species_id;
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

### Different join types

We can count the number of records returned by our original join query.

```sql
SELECT COUNT(*)
FROM surveys
JOIN species
USING (species_id);
```

Notice that this number is smaller than the number of records present in the
survey data.

```sql
SELECT COUNT(*) FROM surveys;
```

This is because, by default, SQL only returns records where the joining value is present in the joined columns of both tables (i.e. it takes the *intersection* of the two join columns). This joining behaviour is known as an `INNER JOIN`. In fact, the `JOIN` keyword is shorthand for `INNER JOIN` in Oracle, and the two terms can be used interchangeably as they will produce the same result.

We can also tell the computer that we wish to keep all the records in the first
table by using a `LEFT OUTER JOIN` clause, or `LEFT JOIN` for short. Additionally, Oracle also supports `RIGHT OUTER JOIN` (or simply `RIGHT JOIN`), which works in a similar manner but keeps all records from the right table (`species`). And you also have `FULL OUTER JOIN`, which keeps all records from both tables. The difference
between the JOINs can be visualised like so:

![
Diagrams representing JOINs in Oracle
](fig/sql-joins.png){
alt='Diagrams representing JOINs in Oracle'
}

:::::::::::::::::::::::::::::::::::::::  challenge

## Challenge:

- Re-write the original query to keep all the entries present in the `surveys`
  table. How many records are returned by this query?

:::::::::::::::  solution

## Solution

```sql
SELECT * FROM surveys
LEFT JOIN species
USING (species_id);
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::  challenge

## Challenge:

- Count the number of records in the `surveys` table that have a `NULL` value
  in the `species_id` column.

:::::::::::::::  solution

## Solution

```sql
SELECT COUNT(*)
FROM surveys
WHERE species_id IS NULL;
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

**Important Note:** In SQL, a `NULL` value in one table can never be joined to a `NULL` value in another table because `NULL` is not equal to anything, not even itself.

### Combining joins with sorting and aggregation

Joins can be combined with sorting, filtering, and aggregation. So, if we
wanted average mass of the individuals on each different type of treatment, we
could do something like

```sql
SELECT plots.plot_type, AVG(surveys.weight)
FROM surveys
JOIN plots
ON surveys.plot_id = plots.plot_id
GROUP BY plots.plot_type;
```

:::::::::::::::::::::::::::::::::::::::  challenge

## Challenge:

- Write a query that returns the number of animals caught of each genus in each plot.
  Order the results by plot number (ascending) and by descending number of individuals in each plot.

:::::::::::::::  solution

## Solution

```sql
-- select the plot id, genus and count of individuals
SELECT surveys.plot_id, species.genus, COUNT(*) AS number_indiv
-- from table surveys
FROM surveys
-- join with table species
JOIN species
-- on the species id
ON surveys.species_id = species.species_id
-- group the results by genus and plot id
GROUP BY species.genus, surveys.plot_id
-- order the results by plot id and number of individuals
ORDER BY surveys.plot_id ASC, number_indiv DESC;
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::  challenge

## Challenge:

- Write a query that finds the average weight of each rodent species (i.e., only include species with Rodent in the taxa field).

:::::::::::::::  solution

## Solution

```sql
SELECT surveys.species_id, AVG(surveys.weight)
FROM surveys
JOIN species
ON surveys.species_id = species.species_id
WHERE species.taxa = 'Rodent'
GROUP BY surveys.species_id;
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

## Functions `COALESCE` and `NULLIF` and more

SQL includes numerous functions for manipulating data. You've already seen some
of these being used for aggregation (`SUM` and `COUNT`) but there are functions
that operate on individual values as well. Probably the most important of these
are `COALESCE` and `NULLIF`. `COALESCE` allows us to specify a value to use in
place of `NULL`.

We can represent unknown sexes with `'U'` instead of `NULL`:

```sql
SELECT species_id, sex, COALESCE(sex, 'U') AS sex_cleaned
FROM surveys;
```

The lone "sex" column is only included in the query above to illustrate where
`COALESCE` has changed values; this isn't a usage requirement.

:::::::::::::::::::::::::::::::::::::::  challenge

## Challenge:

- Write a query that returns 30 instead of `NULL` for values in the
  `hindfoot_length` column.

:::::::::::::::  solution

## Solution

```sql
SELECT hindfoot_length, COALESCE(hindfoot_length, 30)
FROM surveys;
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::  challenge

## Challenge:

- Write a query that calculates the average hind-foot length of each species,
  assuming that unknown lengths are 30 (as above).

:::::::::::::::  solution

## Solution

```sql
SELECT species_id, AVG(COALESCE(hindfoot_length, 30))
FROM surveys
GROUP BY species_id;
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

`COALESCE` can be particularly useful in `JOIN`. When joining the `species` and
`surveys` tables earlier, some results were excluded because the `species_id`
was `NULL` in the surveys table. We can use `COALESCE` to include them again, re-writing the `NULL` to
a valid joining value:

```sql
SELECT surveys.year, surveys.month, surveys.day, species.genus, species.species
FROM surveys
JOIN species
ON COALESCE(surveys.species_id, 'AB') = species.species_id;
```

:::::::::::::::::::::::::::::::::::::::  challenge

## Challenge:

- Write a query that returns the number of animals caught of each genus in each
  plot, assuming that unknown species are all of the genus "Rodent".

:::::::::::::::  solution

## Solution

```sql
SELECT plot_id, COALESCE(genus, 'Rodent') AS genus2, COUNT(*)
FROM surveys
LEFT JOIN species
ON surveys.species_id=species.species_id
-- because we are using Oracle version 21, we need to write the full COALESCE
-- instead of the alias genus2
GROUP BY plot_id, COALESCE(genus, 'Rodent');
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

The inverse of `COALESCE` is `NULLIF`. This returns `NULL` if the first argument
is equal to the second argument. If the two are not equal, the first argument
is returned. This is useful for "nulling out" specific values.

We can "null out" plot 7:

```sql
SELECT species_id, plot_id, NULLIF(plot_id, 7) AS plot_id_nullified
FROM surveys;
```

Some more functions which are common to SQL databases are listed in the table
below:

| Function                      | Description                                                                 |
|------------------------------|-----------------------------------------------------------------------------|
| `ABS(n)`                     | Returns the absolute (positive) value of the numeric expression *n*         |
| `COALESCE(x1, ..., xN)`      | Returns the first of its arguments that is not `NULL`                       |
| `LENGTH(s)`                  | Returns the number of characters in the string *s*                          |
| `LOWER(s)`                   | Returns the string *s* in lowercase                                         |
| `NULLIF(x, y)`               | Returns `NULL` if *x* = *y*, otherwise returns *x*                          |
| `ROUND(n)` or `ROUND(n, x)`  | Rounds *n* to *x* decimal places (default is 0)                             |
| `TRIM(s)`                    | Removes leading and trailing whitespace from the string *s*                |
| `UPPER(s)`                   | Returns the string *s* in uppercase                                         |

Finally, some useful functions which are particular to Oracle are listed in the
table below:

| Function                       | Description                                                                 |
|---------------------------------|-----------------------------------------------------------------------------|
| `TO_NUMBER(s)`                  | Converts a string *s* to a numeric value. If the string is not a valid number, it returns an error. |
| `TO_CHAR(d)`                    | Converts a date or number to a string in a specified format. E.g., `TO_CHAR(SYSDATE, 'YYYY-MM-DD')`. |
| `TO_DATE(s, format)`            | Converts a string *s* to a date, using the specified format. |
| `CURRENT_DATE`                  | Returns the current date in the session's time zone. |
| `EXTRACT(field FROM date)`      | Extracts a specific part (e.g., year, month, day) from a date or timestamp. |

:::::::::::::::::::::::::::::::::::::::  challenge

## Challenge:

Write a query that returns genus names (no repeats), sorted from longest genus name down
to shortest.

:::::::::::::::  solution

## Solution

```sql
SELECT DISTINCT genus
FROM species
ORDER BY LENGTH(genus) DESC;
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

As we saw before, aliases make things clearer, and are especially useful when joining tables.

```sql
SELECT surv.year AS yr, surv.month AS mo, surv.day AS day,
       sp.genus AS gen, sp.species AS sp
FROM surveys surv
JOIN species sp
ON surv.species_id = sp.species_id;
```

To practice we have some optional challenges for you.

:::::::::::::::::::::::::::::::::::::::  challenge

## Challenge (optional):

SQL queries help us *ask* specific *questions* which we want to answer about our data. The real skill with SQL is to know how to translate our scientific questions into a sensible SQL query (and subsequently visualise and interpret our results).

Have a look at the following questions; these questions are written in plain English. Can you translate them to *SQL queries* and give a suitable answer?

1. How many plots from each type are there?

2. How many specimens are of each sex are there for each year, including those whose sex is unknown?

3. How many specimens of each species were captured in each type of plot, excluding specimens of unknown species?

4. What is the average weight of each taxa?

5. What are the minimum, maximum and average weight for each species of Rodent?

6. What is the average hindfoot length for male and female rodent of each species? Is there a Male / Female difference?

7. What is the average weight of each rodent species over the course of the years? Is there any noticeable trend for any of the species?

:::::::::::::::  solution

## Proposed solutions:

1. Solution:

  ```sql
  SELECT plot_type, COUNT(*) AS num_plots
  FROM plots
  GROUP BY plot_type;
  ```

2. Solution:

  ```sql
  SELECT year, sex, COUNT(*) AS num_animal
  FROM surveys
  GROUP BY sex, year;
  ```

3. Solution:

  ```sql
  SELECT species_id, plot_type, COUNT(*)
  FROM surveys
  JOIN plots USING(plot_id)
  WHERE species_id IS NOT NULL
  GROUP BY species_id, plot_type;
  ```

4. Solution:

  ```sql
  SELECT taxa, AVG(weight)
  FROM surveys
  JOIN species ON species.species_id = surveys.species_id
  GROUP BY taxa;
  ```

5. Solution:

  ```sql
  SELECT surveys.species_id, MIN(weight), MAX(weight), AVG(weight) FROM surveys
  JOIN species ON surveys.species_id = species.species_id
  WHERE taxa = 'Rodent'
  GROUP BY surveys.species_id;
  ```

6. Solution:

  ```sql
  SELECT surveys.species_id, sex, AVG(hindfoot_length)
  FROM surveys JOIN species ON surveys.species_id = species.species_id
  WHERE (taxa = 'Rodent') AND (sex IS NOT NULL)
  GROUP BY surveys.species_id, sex;
  ```

7. Solution:

  ```sql
  SELECT surveys.species_id, year, AVG(weight) as mean_weight
  FROM surveys
  JOIN species ON surveys.species_id = species.species_id
  WHERE taxa = 'Rodent' GROUP BY surveys.species_id, year;
  ```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: keypoints

- Use a `JOIN` clause to combine data from two tables---the `ON` or `USING` keywords specify which columns link the tables.
- Regular `JOIN` returns only matching rows. Other join clauses provide different behavior, e.g., `LEFT JOIN` retains all rows of the table on the left side of the clause.
- `COALESCE` allows you to specify a value to use in place of `NULL`, which can help in joins
- `NULLIF` can be used to replace certain values with `NULL` in results
- Many other functions like `COALESCE` and `NULLIF` can operate on individual values.

::::::::::::::::::::::::::::::::::::::::::::::::::
