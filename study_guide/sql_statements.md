# Example SQL Statements

## Table of Contents

- [CREATE](#create)
- [ALTER](#alter)
- [DROP](#drop)
- [INSERT](#insert)
- [SELECT](#select)
  - [WHERE](#where)
  - [GROUP BY](#group-by)
  - [HAVING](#having)
  - [ORDER BY](#order-by)
  - [LIMIT and OFFSET](#limit-and-offset)
- [UPDATE](#update)
- [DELETE](#delete)

## Example Data

For the following discussion of SQL statements, we'll utilize an example database that is an inventory for various items being stored in storage units. We have one table representing the storage units, and another table representing the items being stored. We'll use a foreign key in the items table to specify which storage unit any given item is stored in.

`items`

| id | description | storage_id |
|----|-------------|------------|
| 1  | box of dishes | 2 |
| 2  | dinning room chair | 2 |
| 3  | photo album | 3 |
| 4  | wedding dress | 2 |
| 5  | skis | 1 |

`storage_units`

| id | unit_number |
|----|-------------|
| 1  | B307        |
| 2  | B515        |
| 3  | C203        |

## CREATE

General syntax:

```sql
CREATE TABLE table_name (
  column_name1 datatype CONSTRAINTS,
  column_name2 datatype CONSTRAINTS,
  ... etc
  TABLE CONSTRAINTS
);
```

Some things to take note of here:

- Including a name and datatype for each column is mandatory.
- Any constraints are optional. These can be defined either at the column level or for the table as a whole.
- Each column definition must be separated with a comma (`,`)

There are a few common types of data we can use to restrict the kind of data being added to any given column

- `serial`: generates an auto-incrementing integer that can be used as a unique identifier for records in a table. It's generally a good idea to include an `id serial` column for all tables. This usually serves as a primary key.
- `char(n)` and `varchar(n)`: both store strings of up to a certain length, `n`. `char(n)` will fill in spaces for any string that is less than `n` in length, while `varchar(n)` will not.
- `boolean`: stored boolean values that are represented as `t` or `f`
- `decimal(precision, scale)`: stores decimals with a set level of precision, the first argument specifies the total number of digits allowed and the second specifies the number of digits that come after the decimal point.
- `timestamp` and `date`: stores either a date and time (`timestamp`) or a date value without a time (`date`)

Create the two tables for our example database. Make sure that each have an auto-incrementing `id` column that can serve as a primary key.

```sql
CREATE TABLE storage_units (
  id serial PRIMARY KEY,
  unit_number text
);

CREATE TABLE items (
  id serial PRIMARY KEY,
  description text,
  storage_id integer REFERENCES storage_units(id)
);
```

Note that we have to create the `storage_units` table first, as `items` contains a column that will serve as foreign key and reference the `id` column of `storage_units`.

## ALTER

General syntax:

```sql
ALTER TABLE table_name
  ADD/DROP/ALTER/RENAME COLUMN --or
  ADD/DROP CONSTRAINT
  additional_arguments_if_needed;
```

Add a column to the `items` table that tracks the date an item was packed and put into storage. Make sure that data stored in this column cannot be `NULL` and set a default value to be assigned to the current date.

```sql
ALTER TABLE items
  ADD COLUMN date_packed date NOT NULL DEFAULT current_date;
```

Change the `description` column in `items` so that it cannot hold a `NULL` value. Change the `unit_number` column in the `storage_units` table so that it always holds strings of 4 characters long. This column should also not hold any `NULL` or duplicated values. There should be some kind of constraint in place to ensure that the `unit_number` has the following format: capitalized alphanumeric character followed by three digits.

```sql
ALTER TABLE items
  ALTER COLUMN description SET NOT NULL;

ALTER TABLE storage_units
  ALTER COLUMN unit_number TYPE char(4),
  ALTER COLUMN unit_number SET NOT NULL;

ALTER TABLE storage_units
  ADD UNIQUE (unit_number);

ALTER TABLE storage_units
  ADD CONSTRAINT check_unit_number_format
  CHECK (unit_number SIMILAR TO '[A-Z][0-9]{3}');
```

### Adding and Removing Constraints

Note the difference in how the `CHECK`, `UNIQUE` and `NOT NULL` constraints are added above. This is because table constraints (as in the case of `CHECK`) and column constraints (as in the case of `NOT NULL`) have different forms of the `ALTER TABLE` command. For the most part, if you are adding constraints to an existing table, anything other than `NOT NULL` will have to be added as a table constraint, although the `CHECK` constraint above _could_ have been added as a column constraint in the `CREATE TABLE` statement.

Here are some examples of how to add and remove different kinds of constraints:

```sql
-- Add NOT NULL
ALTER TABLE table_name
  ALTER COLUMN column_name SET NOT NULL;

-- Remove NOT NULL
ALTER TABLE table_name
  ALTER COLUMN column_name DROP NOT NULL;

-- Add a UNIQUE constraint for a given column
ALTER TABLE table_name
  ADD UNIQUE (column_name);
-- A constraint name will be automatically generated if not provided

-- Add a CHECK constraint for a given column
ALTER TABLE table_name
  ADD CHECK (conditional_expression_include_column_name);

-- Remove a table constraint (such as UNIQUE or CHECK)
ALTER TABLE table_name
  DROP CONSTRAINT constraint_name;
-- If you didn't provide a name, you can look up what was generated with \d table_name in psql
```

To remove or add foreign key constraints:

```sql
-- Remove a foreign key constraint with the constraint name
ALTER TABLE parts
  DROP CONSTRAINT "parts_device_id_fkey";

-- Add a constraint as a table constraint
ALTER TABLE parts
  ADD CONSTRAINT "parts_device_id_fkey"
  FOREIGN KEY (device_id) REFERENCES devices(id) ON DELETE CASCADE;
```

## DROP

Using `DROP TABLE` or `DROP COLUMN` completely removes an entire column or an entire table from the database, including any data that may be stored there. This is irreversible and has no warning (i.e., the SQL server will not ask "are you sure?"), so it's a good idea to be _very careful_ about using `DROP`. In general, it's good practice to perform a `SELECT` query first to get a sense of the kind of data you stand to lose.

```sql
-- delete an entire column
ALTER TABLE table_name
  DROP COLUMN column_name;

-- delete an entire table
DROP TABLE table_name;
```

We can also use `DROP` to remove a constraint. Just as with adding a constraint, there are two different forms for removing either table or column constraints. This is not _quite_ as dangerous as removing a column or table, as no data will be lost, but it could affect data integrity.

```sql
-- remove a table constraint, such as the check constraint set above
ALTER TABLE storage_units
  DROP CONSTRAINT check_unit_number_format;

-- remove a column constraint, such as NOT NULL
ALTER TABLE items
  ALTER COLUMN date_packed DROP NOT NULL;
```

## INSERT

To insert data values into a table need to specify:

  1. The table name into which we want to insert data
  2. The names of the columns we are adding data to
  3. The actual values we want to store in those columns (make sure to match the order of what is specified in step 2 above).

General syntax:

```sql
INSERT INTO table_name (column1, column2, column4)
  VALUES (data_col1, data_col2, data_col4),
         (data_col1, data_col2, data_col4),
         ...etc
         (data_col1, data_col2, data_col4);
```

Note that you don't always have to specify all the columns. For any columns not specified, for example, either whatever value is set as default or a `NULL` value will be added for that column. In the case of columns like `id`, which have an auto-incrementing unique value. we can trust that to be added for each record we insert even if the `id` column is never specified in the `INSERT` statement.

Add the given values into the tables creates above:

```sql
-- note that we don't have to specify the 'date_packed' column here, the default value of current_date will be added
INSERT INTO items (description, storage_id)
  VALUES ('box of dishes', 2),
         ('dining room chair', 2),
         ('photo album', 3),
         ('wedding dress', 2),
         ('skis', 1);

INSERT INTO storage_units (unit_number)
  VALUES ('B307'), ('B515'), ('C203');
```

If you try to insert data that violates any of the tables _schema_, i.e. if it doesn't meet a certain constraint or is the wrong datatype, an error will be thrown.

```sql
-- The following data violates the check_unit_number_format constraint
INSERT INTO storage_units (unit_number)
  VALUES ('ab00');
/*
ERROR:  new row for relation "storage_units" violates check constraint "check_unit_number_format"
DETAIL:  Failing row contains (4, ab00).
*/
```

## SELECT

`SELECT` statements are a special kind of statement in SQL known as _queries_. They allow us to pull up and view various data stored in the database, varying from records stored as is to utilizing more complex expressions to return more nuanced information about data values. `SELECT` statements rely on certain key pieces of information:

  1. The column name(s) for which you want to return or utilize data in some expression (mandatory)
  2. The table name(s) that contain the specified columns (mandatory)
  3. Some kind of condition clause that determines whether or not data should be included in the return set, usually specified by either `WHERE` or `HAVING` (optional)
  4. If aggregate functions are used, the attribute on which to "group" data values should be specified by a `GROUP BY` clause (optional)
  5. If a specific order for the returned dataset is requited, this should be specified by an `ORDER BY` clause
  6. If only a certain number of records need to appear in the result set, this can be restricted with included a `LIMIT` or `OFFSET BY` clause

General syntax:

```sql
SELECT column_name1, column_name2, ...etc
FROM table_name
  WHERE condition
  GROUP BY grouping_element
  HAVING condition
  ORDER BY expression ASC/DESC
  LIMIT count
  OFFSET start;
```

A very simple select query might use the `*` wildcard to select all rows and all columns from a single table:

```sql
SELECT * FROM table_name;
```

We can select all the values from within a single column by specifying that column.

```sql
-- select all description values from items
SELECT description FROM items;
/*
    description
-------------------
 box of dishes
 dining room chair
 photo album
 wedding dress
 skis
(5 rows)
*/
```

### WHERE

We can specify a condition that must be met for records to be returned as part of the result set with a `WHERE` clause.

```sql
-- select only those item descriptions which appear in the storage unit with an id of 2
SELECT description FROM items
  WHERE storage_id = 2;
/*
    description
-------------------
 box of dishes
 dining room chair
 wedding dress
(3 rows)
*/
```

The condition specified with `WHERE` is usually an expression containing some kind of conditional operator or function. For example, let's say that we add a column to `items` called `weight`. It contains a decimal representing the number of pounds each item weighs.

```sql
ALTER TABLE items
  ADD COLUMN weight decimal(4, 1) CHECK (weight > 0.0);
-- note that this adds a column of all NULL values

-- we update the NULL values per row with a WHERE clause
UPDATE items
  SET weight = 25.2 WHERE description = 'box of dishes';
UPDATE items
  SET weight = 18.4 WHERE description = 'dining room chair';
UPDATE items
  SET weight = 4.7 WHERE description = 'photo album';
UPDATE items
  SET weight = 8.1 WHERE description = 'wedding dress';
UPDATE items
  SET weight = 9.3 WHERE description = 'skis';
```

Now we can use a `WHERE` clause to specify a condition that must be met in order to filter our resulting set of data.

```sql
-- return the description and weight of those items that weigh less than 10 pound
SELECT description, weight FROM items
  WHERE weight < 10;
/*
  description  | weight
---------------+--------
 photo album   |    4.7
 wedding dress |    8.1
 skis          |    9.3
(3 rows) */

-- we don't need to include the column used in the WHERE clause with SELECT if we don't want
SELECT description AS "Lightweight Items" FROM items
  WHERE weight < 10;
/*
 Lightweight Items
-------------------
 photo album
 wedding dress
 skis
(3 rows) */
```

We can use multiple conditions in a `WHERE` clause by combining expressions with the logical operators `AND` or `OR`.

```sql
-- return the description of all items that weight less than 10 pounds in the storage unit
SELECT description AS "Light items in unit #B515" FROM items
  WHERE weight < 10 AND storage_id = 2;
/*
 Light items in unit #B515
---------------------------
 wedding dress
(1 row) */

-- we can get the same results just using the name of the storage unit by using a join table
SELECT i.description AS "Light items in unit #B515"
FROM items AS i
  INNER JOIN storage_units AS u ON u.id = i.storage_id
  WHERE i.weight < 10 AND u.unit_number = 'B515';
/*
 Light items in unit #B515
---------------------------
 wedding dress
(1 row) */
```

### GROUP BY

`GROUP BY` is a key word that we generally use in combination with _aggregate functions_, and it allows us to "group" values stored in a table according to certain categories.

For example, let's say we want to return a list of storage unit numbers along with a count of how many items are in each. To do so, we'll first join our two tables into a virtual table that contains both sets of data, then we'll "group" items in terms of unit number, and utilize the aggregate function `count()` to see how many items are represented for each unit.

```sql
SELECT u.unit_number, count(i.id) FROM items AS i
  INNER JOIN storage_units AS u ON u.id = i.storage_id
  GROUP BY u.unit_number;
/*
 unit_number | count
-------------+-------
 B515        |     3
 B307        |     1
 C203        |     1
(3 rows)  */
```

Note that any columns included in the list to select with whatever aggregate function we are using must _also_ be represented in the `GROUP BY` clause, or else we will get an error.

```sql
SELECT u.unit_number, count(i.id), weight FROM items AS i
  INNER JOIN storage_units AS u ON u.id = i.storage_id
  GROUP BY u.unit_number;
/*
ERROR:  column "i.weight" must appear in the GROUP BY clause or be used in an aggregate function
LINE 1: SELECT u.unit_number, count(i.id), weight FROM items AS i
*/
```

In the above case, while we _could_ include `items.weight` in the `GROUP BY` clause, it doesn't really give us any useful results, since each item has a distinct and individual weight. We _could_, however, utilize this value in an aggregate function, say `sum()`, which would give us the total weight for all items in each storage unit.

```sql
SELECT u.unit_number, count(i.id), sum(weight) AS total_weight 
FROM items AS i
  INNER JOIN storage_units AS u ON u.id = i.storage_id
  GROUP BY u.unit_number;
/*
 unit_number | count | total_weight
-------------+-------+--------------
 B515        |     3 |         51.7
 B307        |     1 |          9.3
 C203        |     1 |          4.7
(3 rows) */
```

### HAVING

In order to filter rows that are grouped with `GROUP BY` we need to use a `HAVING` clause rather than a `WHERE` clause, since we are targeting aggregate rows instead of a single row at a time.

General syntax:

```sql
SELECT col_1, aggregate_function(col_2) FROM table_name
  GROUP BY col_1 HAVING conditional_expression;
```

For example, let's say that we want to return a count of items in each storage unit, but we only want to include storage units that have an item count of more than 1 in our results set. To do this, we need to use `HAVING`.

```sql
SELECT u.unit_number, count(i.id) FROM items AS i
  INNER JOIN storage_units AS u ON u.id = i.storage_id
  GROUP BY u.unit_number HAVING count(i.id) > 1;
/*
 unit_number | count
-------------+-------
 B515        |     3
(1 row) */
```

### ORDER BY

If we want to display a result set in a certain order, rather than the arbitrary order in which records are stored in the database, we can do so with an `ORDER BY` clause. When specifying an order, we use the keywords `ASC` or `DESC` to declare whether we want the items sorted in _ascending_ or _descending_ order.

```sql
-- return the item description and weight in order from lightest to heaviest
SELECT description, weight FROM items
  ORDER BY weight ASC;
/*
    description    | weight
-------------------+--------
 photo album       |    4.7
 wedding dress     |    8.1
 skis              |    9.3
 dining room chair |   18.4
 box of dishes     |   25.2
(5 rows) */

-- return the item description and weight in order from heaviest to lightest
SELECT description, weight FROM items
  ORDER BY weight DESC;
/*
    description    | weight
-------------------+--------
 box of dishes     |   25.2
 dining room chair |   18.4
 skis              |    9.3
 wedding dress     |    8.1
 photo album       |    4.7
(5 rows) */
```

We can include more than one expressions in the `ORDER BY` clause, in which case the results will be ordered first by the first specified expression, and then for any records who share the same value for that particular attribute, these will be ordered by the second specified expression.

For example, the following statement returns a set of data including the storage unit number, total number of items per unit, and the total weight for those items. Two of the storage units have the same number of items, so we want to make sure that we put those records in order from heaviest to least heavy. To do we need to include an additional expression in the `ORDER BY` clause.

```sql
SELECT u.unit_number, count(i.id) AS item_count, sum(i.weight) AS total_weight
FROM items AS i
  INNER JOIN storage_units AS u ON u.id = i.storage_id
  GROUP BY u.unit_number
  ORDER BY item_count DESC, total_weight DESC;
/* 
 unit_number | item_count | total_weight
-------------+------------+--------------
 B515        |          3 |         51.7
 B307        |          1 |          9.3
 C203        |          1 |          4.7
(3 rows) */
```

### LIMIT and OFFSET

If we want to work with a specific _number_ of records we can use `LIMIT` and `OFFSET` clauses to do so. These filter records to include in the result set not based on whether or not they meet some conditional expression (as with `WHERE` and `HAVING`), but rather by setting a "start" number and maximum number of records to return. This can be useful when used in combination with `ORDER BY`.

For example, using `LIMIT` we can actually find our heaviest item in storage. We simply select all items, order them by weight from heaviest to lightest, and limit the results set to 1.

```sql
SELECT description AS "Heaviest Item" FROM items
  ORDER BY weight DESC
  LIMIT 1;
/*
 Heaviest Item
---------------
 box of dishes
(1 row) */

-- Changing the number used with LIMIT changes the number of records returned
SELECT description AS "Heaviest Item" FROM items
  ORDER BY weight DESC
  LIMIT 2;
/*
   Heaviest Item
-------------------
 box of dishes
 dining room chair
(2 rows) */
```

`OFFSET` allows us to set a "start" position for which records we want to include in a result set. For example, we can exclude the first record by setting an offset of 1.

```sql
-- returns all items except the heaviest one
SELECT description FROM items
  ORDER BY weight DESC
  OFFSET 1;
/*
    description
-------------------
 dining room chair
 skis
 wedding dress
 photo album
(4 rows) */

-- increasing the "start" position leaves off more items
SELECT description FROM items
  ORDER BY weight DESC
  OFFSET 3;
/*
  description
---------------
 wedding dress
 photo album
(2 rows) */
```

We can combine offset with limit to return a result set that consists of X records starting at position Y in the results table.

```sql
-- returns the second to most heavy item:
SELECT description FROM items AS "Second heaviest item"
  ORDER BY weight DESC
  LIMIT 1 OFFSET 1;
/*
    description
-------------------
 dining room chair
(1 row) */
```

## UPDATE

To update data that already exists in a table we need to use an `UPDATE` statement.

General syntax:

```sql
UPDATE table_name
  SET column_name = value, ... etc
  WHERE conditional_expression;
```

Although the `WHERE` clause is not mandatory, it is used to target the specific record which you want to update, so its usually a good idea to include it. Otherwise, every value in the specified column for _all_ records in the table will be updated.

```sql
-- changes the date_packed for ALL records in items
UPDATE items
  SET date_packed = '12-22-2021';

-- changes the date_packed for only those items that meet the WHERE condition
UPDATE items
  SET date_packed = '12-22-2021'
  WHERE description = 'skis';
```

Typically we want to make sure our conditional expression is specific enough to target a single record. For this reason, it's a good idea to use something like a primary key as a condition when updating values.

## DELETE

`DELETE` statements permanently delete any data within a table where a given condition is met. If no condition is given, all the data within a table will be deleted. Note that when using `DELETE` only _entire records_ can be deleted, and not individual values from specific columns within those records. In order to "delete" a specific column's value within an individual record, we must use `UPDATE` and set that value to `NULL` (assuming no constraint prevents us from doing so).

General syntax:

```sql
DELETE FROM table_name
  WHERE conditional_expression;
```

For example, let's say we want to remove the `'skis'` item in our items table (we are taking them out to go skiing). In practice, it's good to first "test" the conditional expression within a `SELECT` clause so that you can ensure you are selecting the correct data. Then we can remove the record with `DELETE`.

```sql
-- test the WHERE clause
SELECT * FROM items
  WHERE description = 'skis';
/*
 id | description | storage_id | date_packed | weight
----+-------------+------------+-------------+--------
  5 | skis        |          1 | 2022-01-18  |    9.3
(1 row) */

-- now we can delete
DELETE FROM items
  WHERE description = 'skis';

-- to be extra careful, we can also include the primary key value, to ensure that no other items with the same description get deleted
DELETE FROM items
  WHERE description = 'skis' AND id = 5;
  ```
