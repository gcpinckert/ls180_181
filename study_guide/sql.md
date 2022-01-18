# SQL Facts

## General Characteristics

SQL is a **special purpose language** used to interact with a relational database management system. It has three main functions, each of which is carried out by a certain _sublanguage_:

  1. to define or change structure or rules that apply to database
  2. to manipulate data within a database with CRUD operations
  3. to manipulate rules surrounding users of a database and their permissions

In order to talk about these different responsibilities, we use the terms **data** and **schema**. **Data** refers to the actual values that are stored within a database, i.e. the _contents_ of a table. **Schema** refers to the structure of the database rather than its contents, i.e. what names identify columns and tables, what kinds of data are allowed in certain columns, and any rules that may be applied to the database (whether to a specific column or an entire table).

SQL is a **declarative language** which means that it states what needs to be done, but abstracts away any details about how this action will be accomplished. These implementation details will vary depending on a number of factors, and an approach is ultimately decided by the RDBMS in use at the time. If a user ever needs to "peek" behind the abstraction and look at a so-called "execution plan" for any given SQL statement they can do so with `EXPLAIN` (which shows the plan along with estimated performance cost) or `EXPLAIN ANALYZE` (which actually executes the plan and shows real performance cost).

## Syntax

SQL consists of **statements** which are themselves made up of **clauses**. All SQL statements must end in a `;`, or they will not be executed (the SQL server will not consider the statement to be complete).

Statements and clauses are made up of a rotating cast of parts: **identifiers**, **key words**, and **expressions**.

- _Identifiers_: Words that signify a table or column within any particular database. By convention, these are represented in lowercase.
- _Key Words_: Specific commands within the SQL language that tell the SQL server to do something. This includes things like `SELECT`. By convention, key words are always capitalized.
- _Expressions_: Expressions consist of things to be evaluated. This can include arbitrary values (such as a string or integer), identifiers, operators, and functions. For example, `count(user_id)` is an expression that utilizes the function `count()` along with a column identifier `user_id`.

Something to be aware of, there are certain key words in SQL that are _reserved_, which means that in order to use them as an identifier they must be placed in double quotes.

## Sublanguages

SQL has three separate sublanguages.

For the following discussion of sublanguages, we'll utilize an example database that is an inventory for various items being stored in storage units. We have one table representing the storage units, and another table representing the items being stored. We'll use a foreign key in the items table to specify which storage unit any given item is stored in.

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

### DDL

**DDL** or **Data Definition Language** is concerned with schema. It's job is to define, change, or otherwise manipulate the _structure_ of a database as well as define, change or manipulate any rules we need to apply to values being stored within that structure. Actions such as creating tables, changing table attributes, deleting structures, and adding constraints are all carried out with DDL.

Some example DDL statements include:

```sql
-- creating structure within a database
CREATE TABLE items (
  id serial PRIMARY KEY,
  description text,
  storage_id REFERENCES storage_units(id)
);

-- altering the structure, identifier, or rules for a table
ALTER TABLE items RENAME TO things;

ALTER TABLE things 
  ALTER COLUMN description SET NOT NULL;

ALTER TABLE things
  ADD COLUMN date_packed date NOT NULL;

-- deleting any part of a database structure
ALTER TABLE things
  DROP COLUMN date_packed;

DROP TABLE things;
```

### DML

**DML** or **Data Manipulation Language** is concerned with data. It's job is to perform all the CRUD (Create, Read, Update, Delete) operations on the actual values stored within a database. Actions such as adding data values to a table, selecting values from a table, changing values within a table, or deleting values from a table are all carried out with DML.

Some example DML statements include:

```sql
-- adding data to a database
INSERT INTO items (description, storage_id)
  VALUES ('box of dishes', 2),
         ('dining room chair', 2),
         ('photo album', 3),
         ('wedding dress', 2),
         ('skis', NULL);

-- selecting certain values from a database
SELECT description AS "Items in Unit B515" FROM items
  WHERE storage_id = 2;

/* Items in Unit B515
--------------------
 box of dishes
 dining room chair
 wedding dress
(3 rows) */

SELECT u.unit_number, count(i.id) AS number_of_items FROM items AS i
  INNER JOIN storage_units AS u ON u.id = i.storage_id
  GROUP BY u.unit_number
  ORDER BY number_of_items;
/*
  unit_number | number_of_items
-------------+-----------------
 C203        |               1
 B515        |               3
(2 rows)
*/

-- Update data within a table
UPDATE items SET storage_id = 1
  WHERE description = 'skis';

-- Delete data within a table
DELETE FROM items
  WHERE description = 'skis';
```

### DCL

**DCL** or **Data Control Language** is primarily concerned with the rules surrounding _users_ of a particular database, i.e. user permissions, or who is allowed to do what. Actions like ensuring certain users only have access for _reading_ data, as opposed to adding, updating, or deleting it are carried out by DCL. DCL uses keywords like `GRANT` AND `REVOKE`.
