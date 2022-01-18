# SQL Joins

## What are SQL Joins

A `JOIN` clause in SQL is a way to link together data stored in two different tables. We achieve this by providing four pieces of information after declaring which data we want returned in a `SELECT` statement:

  1. The name of the first table to "join" (considered the "left" table)
  2. The type of 'JOIN' to use, which will be `INNER` by default if nothing is specified
  3. The name of the second table to "join" (considered the "right" table)
  4. The _join condition_, which determines how records in two separate tables are to be linked together. This usually relies on the columns that define the relationship between two tables, i.e. primary and foreign key columns.

General `JOIN` syntax looks something like this:

  ```sql
  SELECT table_name1.column_name1, table_name1.column_name2, table_name2.column_name1 -- ... etc
    FROM table_name1
    JOIN_TYPE JOIN table_name2 ON table_name1.primary_key = table_name2.foreign_key;
    -- Note that what follows "on" is the "join condition"
  ```

We can think of the second part the above SQL statement acting first, (i.e. the `JOIN` clause), which creates a _virtual table_ that contains all the columns from `table_name1` and all the columns from `table_name2`. Individual records will be "joined" wherever the join condition is met, that is, wherever the value in the `primary_key` column of `table_name1` matches the value of the `foreign_key` column of `table_name2`. Then, the SQL engine will use the `SELECT` clause to return only the columns we've specified from that virtual table.

To join three or more tables together, we can use multiple join statements. This is most useful when dealing with the three tables that represent a many-to-many relationship, in which we have two tables that represent each entity in the relationship and a third table that represents the relationship itself.

  ```sql
  SELECT table_a.column_name, table_b.column_name, table_c.column_name -- ... etc
    FROM table_a
    JOIN_TYPE JOIN table_c ON table_a.primary_key = table_c.foreign_key_table_a
    JOIN_TYPE JOIN table_b ON table_b.primary_key = table_c.foreign_key_table_b;
  ```

## Aliasing

Because join statements can get rather lengthy, as we must include both the table and column name for each specified field, it's usually a good idea to use _table aliasing_ in order to simplify or shorten the statement.

**Table aliasing** is when we use the `AS` keyword in our SQL statement to specify an abbreviated version of the table name. We can then utilize this throughout the rest of our statement. This is generally expected in `JOIN` statements.

```sql
SELECT a.column_name, b.column_name, c.column_name -- ... etc
  FROM table_a AS a
  JOIN_TYPE JOIN table_c AS c
    ON a.primary_key = c.foreign_key_table_a
  JOIN_TYPE JOIN table_b AS b
    ON b.primary_key = c.foreign_key_table_b;
```

While it's not necessary to specify the `AS` keyword explicitly, it's usually a good idea to do so to make your intentions clear (see [The SQL style guide](https://docs.telemetry.mozilla.org/concepts/sql_style.html#aliasing)).

## Types of Joins

For the following discussion of join types, we'll utilize an example database that is an inventory for various items being stored in storage units. We might have one table representing the storage units, and another table representing the items being stored. We'll use a foreign key in the items table to specify which storage unit it is stored in.

`items`

| id | description | storage_id |
|----|-------------|------------|
| 1  | box of dishes | 2 |
| 2  | dinning room chair | 2 |
| 3  | photo album | 3 |
| 4  | wedding dress | 2 |
| 5  | skis | |

`storage_units`

| id | unit_number |
|----|-------------|
| 1  | B307        |
| 2  | B515        |
| 3  | C203        |

### INNER JOINs

Inner joins are the default kind of join that SQL will use if no `JOIN` type is specified. An **inner join** will only combine those rows from each of the two specified tables for which the join condition returns true. If there are any rows in the first table specified that do not meet the condition, these records will be left out of the result table, as is the case for any rows that do not meet the condition in the second table that's specified.

We want to return a table that consists of the item description along with the unit number of the storage unit it is in. To do so, we'll use a join statement. Specifying an `INNER JOIN` will not return any items that do not have a storage unit, nor will it return any storage units that do not have items.

```sql
SELECT i.description, u.unit_number FROM items AS i
  INNER JOIN storage_units AS u 
  ON i.storage_id = u.id;
```

Returns:

```
    description    | unit_number
-------------------+-------------
 box of dishes     | B515
 dining room chair | B515
 photo album       | C203
 wedding dress     | B515
(4 rows)
```

As you can see, the results of our `INNER JOIN` do not contain the item `skis`, as that item is not currently assigned to a storage unit. The join condition is therefore not met, and SQL leaves the record out of the results. Similarly storage unit `B307` does not contain any items, and therefore we do not see it represented in the results of the `INNER JOIN`.

### LEFT OUTER JOINs

A **left outer join** combines the rows from each of the specified tables for which the join condition is met, but will _also_ include any rows from the "left" table (i.e. the table that is specified first) that do _not_ meet the join condition. For those records from the left table that do not have a corresponding match in the other specified table, `NULL` will be used to represent any missing values from the second table.

For example, in the case of our storage inventory, if we specify `items` as the "left" table, we will see all the records returned by an inner join along with the record for `skis`, with a `NULL` value in the `unit_number` column:

```sql
SELECT i.description, u.unit_number FROM items AS i
  LEFT OUTER JOIN storage_units AS u
  ON i.storage_id = u.id;
```

Returns:

```
    description    | unit_number
-------------------+-------------
 box of dishes     | B515
 dining room chair | B515
 photo album       | C203
 wedding dress     | B515
 skis              |
(5 rows)
```

### RIGHT OUTER JOINs

A **right outer join** is similar to a left join; it will combine all rows for which the join condition is met, but it will include any rows from the "right" table (i.e. the table specified second) that do not meet the condition as well.

In this case, we will get all the values returned by the original `INNER JOIN` along with a record for the storage unit `B307`, even though this is not represented by any corresponding records in the `items` table. Notice how because this is a _right_ outer join, `skis` is still omitted from the resulting table.

```sql
SELECT i.description, u.unit_number FROM items AS i
  RIGHT OUTER JOIN storage_units AS u
  ON i.storage_id = u.id;
```

Returns:

```
    description    | unit_number
-------------------+-------------
 box of dishes     | B515
 dining room chair | B515
 photo album       | C203
 wedding dress     | B515
                   | B307
(5 rows)
```

### FULL JOINs

A **full join** works like a combination of a left and right outer join, that is, it will contain all records from both specified tables, regardless of whether or not those records meet the join condition. It will, however, like the previous joins described, still match up records from each specified table according to the condition, leaving those records not represented on the other specified table will `NULL` values in columns being drawn from the other table.

For example, unlike our left or right outer join, which contained either `skis` from `items` or unit `B307` from `storage_units`, a full join will return a row for each of these records in its result table.

```sql
SELECT i.description, u.unit_number FROM items AS I
  FULL JOIN storage_units AS u
  ON i.storage_id = u.id;
```

Returns:

```
    description    | unit_number
-------------------+-------------
 box of dishes     | B515
 dining room chair | B515
 photo album       | C203
 wedding dress     | B515
 skis              |
                   | B307
(6 rows)
```

### CROSS JOINs

A **cross join** is a special type of join that does _not_ require a join condition. This is because a cross join will return all possible combinations of rows from both tables, i.e. each row from the first table matched with each row from the second table. This is also known as a _Cartesian Join_, and is relatively rare in the wild.

```SQL
SELECT i.description, u.unit_number FROM items AS i
  CROSS JOIN storage_units AS u;
```

```
    description    | unit_number
-------------------+-------------
 box of dishes     | B307
 dining room chair | B307
 photo album       | B307
 wedding dress     | B307
 skis              | B307
 box of dishes     | B515
 dining room chair | B515
 photo album       | B515
 wedding dress     | B515
 skis              | B515
 box of dishes     | C203
 dining room chair | C203
 photo album       | C203
 wedding dress     | C203
 skis              | C203
(15 rows)
```

As you can see from the above result, a `CROSS JOIN` will take all the items in our items table, and match them each with the first record in the `storage_units` table (unit `B307`). Next, it will take all the items from the items table _again_ and match them each with the second record in the `storage_units` table. This process repeats until all combinations of both types of record have been matched.
