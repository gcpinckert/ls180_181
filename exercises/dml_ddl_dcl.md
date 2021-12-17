# DML, DDL, and DCL

## 1

SQL consists of three different sub-languages:

**DCL** or **Data Control Language** is used to control access to a database, aka to define the rights and roles granted to individual users. Common SQL DCL statements include:

```sql
GRANT
REVOKE
```

**DDL** or **Data Definition Language** is used to define and modify the _schema_ of a database, aka to define or modify the rules around how data values within a database are structured. This includes things like changing table and column rules, such as defining a new datatype for a particular column, or adding/removing constraints.

Common SQL DDL statements include:

```sql
CREATE
DROP
ADD
ALTER
```

**DML** or **Data Manipulation Language** is used to interact with and manipulate data values that exist within a database. This might mean inserting data into a table, selecting and returning certain data, or updating and deleting data within a database.

Common SQL DML statements include:

```sql
INSERT
SELECT
UPDATE
DELETE
```

## 2

```sql
SELECT column_name FROM my_table;
```

The above code snippet is an example of DML (Data Manipulation Language), since `SELECT` only retrieves _data_.

## 3

```sql
CREATE TABLE things (
  id serial PRIMARY KEY,
  item text NOT NULL UNIQUE,
  material text NOT NULL
);
```

The above code uses the DDL (Data Definition Language) component of SQL, because `CREATE TABLE` defines the _structure_ or _schema_, rather than dealing with any actual data values themselves.

## 4

```sql
ALTER TABLE things
DROP CONSTRAINT things_item_key;
```

The above code uses the DDL component of SQL, because the `ALTER TABLE` deals with the rules around data stored within a column, rather than the data values themselves.

## 5

```sql
INSERT INTO things VALUES (3, 'Scissors', 'Metal');
```

The above code uses the DML component of SQL, because it inserts actual data values into a table, rather than dealing with the structure of that data.

## 6

```sql
UPDATE things
SET material = 'plastic'
WHERE item = 'Cup';
```

The above code uses the DML component of SQL, because it is updating the actual data values stored within a table, rather than dealing with the structure of that data.

## 7

```sql
\d things
```

The above is not an SQL statement. It is a meta-command used to interact with the `psql` console. `\d` will display the schema for the table given, in this case, `things`.

## 8

```sql
DELETE FROM things WHERE item = 'Cup';
```

The above uses the DML component of SQL. We are deleting a specific row of data values from a table, rather than manipulating the structure of that table.

## 9

```sql
DROP DATABASE xyzzy;
```

The above uses the DDL component of SQL. Here we are deleting an entire database. A database provides structure to data, and the fact that it deletes all data within is more of a side effect.

## 10

```sql
CREATE SEQUENCE part_number_sequence;
```

The above uses the DDL component of SQL. This is because `CREATE` is used to provide structure to data, rather than manipulate any actual data values themselves.

`CREATE SEQUENCE` statements are used to modify that characteristics and attributes of a database by adding a sequence object to the database _structure_, they do not actually manipulate any data.
