---
title: Aggregating and Grouping Data
teaching: 50
exercises: 10
---

::::::::::::::::::::::::::::::::::::::: objectives

- Apply aggregation functions to group records together.
- Filter and order results of a query based on aggregate functions.
- Employ aliases to assign new names to items in a query.
- Save a query to make a new table.
- Apply filters to find missing values in SQL.

::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::::::::::::::: questions

- How can I summarize my data by aggregating, filtering, or ordering query results?
- How can I make sure column names from my queries make sense and aren't too long?

::::::::::::::::::::::::::::::::::::::::::::::::::

## COUNT and GROUP BY

Aggregation allows us to combine results by grouping records based on value. It is also useful for
calculating combined values in groups.

Let's go to the surveys table and find out how many individuals there are.
Using the wildcard \* counts the number of records (rows):

```sql
SELECT COUNT(*)
FROM digiocean.surveys;
```

We can also find out how much all of those individuals weigh:

```sql
SELECT COUNT(*), SUM(weight)
FROM digiocean.surveys;
```

We can output this value in kilograms (dividing the value by 1000.00), then rounding to 3 decimal places:
(Notice the divisor has numbers after the decimal point, which forces the answer to have a decimal fraction)

```sql
SELECT ROUND(SUM(weight)/1000.00, 3)
FROM digiocean.surveys;
```

There are many other aggregate functions included in SQL, for example:
`MAX`, `MIN`, and `AVG`.

:::::::::::::::::::::::::::::::::::::::  challenge

## Challenge

Write a query that returns: the total weight, average weight, minimum and maximum weights
for all animals caught over the duration of the survey.
Can you modify it so that it outputs these values only for weights between 5 and 10?

:::::::::::::::  solution

## Solution

```sql
-- All animals
SELECT SUM(weight), AVG(weight), MIN(weight), MAX(weight)
FROM digiocean.surveys;

-- Only weights between 5 and 10
SELECT SUM(weight), AVG(weight), MIN(weight), MAX(weight)
FROM digiocean.surveys
WHERE (weight > 5) AND (weight < 10);
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

Now, let's see how many individuals were counted in each species. We do this
using a `GROUP BY` clause

```sql
SELECT species_id, COUNT(*)
FROM digiocean.surveys
GROUP BY species_id;
```

`GROUP BY` tells SQL what field or fields we want to use to aggregate the data.
If we want to group by multiple fields, we give `GROUP BY` a comma separated list.

:::::::::::::::::::::::::::::::::::::::  challenge

## Challenge

Write queries that return:

1. How many individuals were counted in each year in total
2. How many were counted each year, for each different species
3. The average weights of each species in each year

Can you get the answer to both 2 and 3 in a single query?

:::::::::::::::  solution

## Solution of 1

```sql
SELECT year, COUNT(*)
FROM digiocean.surveys
GROUP BY year;
```

:::::::::::::::::::::::::

:::::::::::::::  solution

## Solution of 2 and 3

```sql
SELECT year, species_id, COUNT(*), AVG(weight)
FROM digiocean.surveys
GROUP BY year, species_id;
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

## Ordering Aggregated Results

We can order the results of our aggregation by a specific column, including
the aggregated column.  Let's count the number of individuals of each
species captured, ordered by the count:

```sql
SELECT species_id, COUNT(*)
FROM digiocean.surveys
GROUP BY species_id
ORDER BY COUNT(species_id);
```

## Aliases

As queries get more complex, the expressions we use can get long and unwieldy. To help make things
clearer in the query and in its output, we can use aliases to assign new names to things in the query.

We can use aliases in column names using `AS`:

```sql
SELECT MAX(year) AS last_surveyed_year
FROM digiocean.surveys;
```

The `AS` isn't technically required, so you could do

```sql
SELECT MAX(year) last_surveyed_year
FROM digiocean.surveys;
```

but using `AS` is much clearer so it is good style to include it.

We can not only alias column names, but also table names in the same way:

```sql
SELECT *
FROM digiocean.surveys surv;
```

**Important**: In this case, you cannot use the `AS` keyword, because it is not allowed for table names.

Aliasing table names can be helpful when working with queries that involve multiple tables; you will learn more about this later.

## The `HAVING` keyword

In the previous episode, we have seen the keyword `WHERE`, allowing to
filter the results according to some criteria. SQL offers a mechanism to
filter the results based on **aggregate functions**, through the `HAVING` keyword.

For example, we can request to only return information
about species with a count higher than 10:

```sql
SELECT species_id, COUNT(species_id)
FROM digiocean.surveys
GROUP BY species_id
HAVING COUNT(species_id) > 10;
```

The `HAVING` keyword works exactly like the `WHERE` keyword, but uses
aggregate functions instead of database fields to filter.

:::::::::::::::::::::::::::::::::::::::::  callout

### Using `HAVING` with Aliases

If you are using **Oracle version 23a and later**, the `HAVING` clause can be
simplified by using the alias of the aggregate function.

You can use the `AS` keyword to assign an alias to a column or table, and refer
to that alias in the `HAVING` clause. For example, in the above query, we can call the `COUNT(species_id)` by another name, like `occurrences`. This can be written this way:

```sql
SELECT species_id, COUNT(species_id) AS occurrences
FROM digiocean.surveys
GROUP BY species_id
HAVING occurrences > 10;
```

In this workshop, we are using **Oracle version 21**, so you will need to use the full expression. In the example above, you would need to use `HAVING COUNT(species_id) > 10` instead of `HAVING occurrences > 10`.

::::::::::::::::::::::::::::::::::::::::::::::::::

Note that in both queries, `HAVING` comes *after* `GROUP BY`. One way to
think about this is: the data are retrieved (`SELECT`), which can be filtered
(`WHERE`), then joined in groups (`GROUP BY`); finally, we can filter again based on some
of these groups (`HAVING`).

:::::::::::::::::::::::::::::::::::::::  challenge

## Challenge

Write a query that returns, from the `species` table, the number of
`species` in each `taxa`, only for the `taxa` with more than 10 `species`.

:::::::::::::::  solution

## Solution

```sql
SELECT taxa, COUNT(*) AS n
FROM digiocean.species
GROUP BY taxa
HAVING COUNT(*) > 10;
```

:::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::

## Saving Queries for Future Use

It is not uncommon to repeat the same operation more than once—for example,
for monitoring or reporting purposes. SQL provides a powerful mechanism for this
by allowing you to create *views*. Views are saved queries that can be stored in the database,
and can be used to inspect, filter, and sometimes even update data.

You can think of a view as a virtual table: it presents a set of results derived
from one or more real tables, potentially using aggregation or filtering.

To create a view from a query, prepend the query with `CREATE VIEW viewname AS`.
For example, suppose our project focuses only on data collected during the
summer months (May to September) of the year 2000. That query would look like this:

```sql
SELECT *
FROM digiocean.surveys
WHERE year = 2000 AND (month > 4 AND month < 10);
```
Rather than writing this every time, we can define a view to store this subset:

```sql
CREATE VIEW summer_2000 AS
SELECT *
FROM digiocean.surveys
WHERE year = 2000 AND (month > 4 AND month < 10);
```

Once the view is created, you can see it as a *new table* in the database on the left side bar. We can query it just like a regular table, using a shorter and more intuitive expression:

```sql
SELECT *
FROM summer_2000
WHERE species_id = 'PE';
```

:::::::::::::::::::::::::::::::::::::::::  callout

### Notes for Oracle Users

- Oracle fully supports `CREATE VIEW`.
- Views created using this syntax are **read-only by default** if they contain `JOIN`s, aggregation functions, or certain filters. However, simple views over a single table can be *updatable*.
- If you attempt to recreate a view that already exists, Oracle will return an error. You must first drop the existing view with:

```sql
DROP VIEW summer_2000;
```

::::::::::::::::::::::::::::::::::::::::::::::::::

## What About NULL?

From the last example, there should only be five records.  If you look at the `weight` column, it's
easy to see what the average weight would be. If we use SQL to find the
average weight, SQL behaves like we would hope, ignoring the NULL values:

```sql
SELECT AVG(weight)
FROM summer_2000
WHERE species_id = 'PE';
```

But if we try to be extra clever, and find the average ourselves,
we might get tripped up:

```sql
SELECT SUM(weight), COUNT(weight), SUM(weight)/COUNT(*)
FROM summer_2000
WHERE species_id = 'PE';
```

Here the `COUNT` function includes all five records (even those with NULL
values), but the `SUM` only includes the three records with data in the
`weight` field, giving us an incorrect average. However,
our strategy *will* work if we modify the `COUNT` function slightly:

```sql
SELECT SUM(weight), COUNT(weight), SUM(weight)/COUNT(weight)
FROM summer_2000
WHERE species_id = 'PE';
```

When we count the weight field specifically, SQL ignores the records with data
missing in that field.  So here is one example where NULLs can be tricky:
`COUNT(*)` and `COUNT(field)` can return different values.

Another case is when we use a "negative" query.  Let's count all the
non-female animals:

```sql
SELECT COUNT(*)
FROM summer_2000
WHERE sex != 'F';
```

Now let's count all the non-male animals:

```sql
SELECT COUNT(*)
FROM summer_2000
WHERE sex != 'M';
```

But if we compare those two numbers with the total:

```sql
SELECT COUNT(*)
FROM summer_2000;
```

We'll see that they don't add up to the total! That's because SQL
doesn't automatically include NULL values in a negative conditional
statement.  So if we are querying "not x", then SQL divides our data
into three categories: 'x', 'not NULL, not x' and NULL; then,
returns the 'not NULL, not x' group. Sometimes this may be what we want -
but sometimes we may want the missing values included as well! In that
case, we'd need to change our query to:

```sql
SELECT COUNT(*)
FROM summer_2000
WHERE sex != 'M' OR sex IS NULL;
```

:::::::::::::::::::::::::::::::::::::::: keypoints

- Use the `GROUP BY` keyword to aggregate data.
- Functions like `MIN`, `MAX`, `AVG`, `SUM`, `COUNT`, etc. operate on aggregated data.
- Aliases can help shorten long queries. To write clear and readable queries, use the `AS` keyword when creating aliases.
- Use the `HAVING` keyword to filter on aggregate properties.
- Use a `VIEW` to access the result of a query as though it was a new table.

::::::::::::::::::::::::::::::::::::::::::::::::::
