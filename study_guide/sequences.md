# Sequences

A **sequence** is a set of integers that are generated such that each "next" value that is generated produces some kind of unique value that can be used as an identifier or _key_ for individual records in a database.

A sequence is usually defined as part of a relation's _schema_, most commonly with the PostgreSQL datatype `serial`. This allows us to generate a unique value for each row in any particular table, and that unique value can be used as the record's _primary key_. It's typical for us to name the column holding sequence values `id`.

Depending on how a sequence is defined, it can generate integers in either ascending or descending order and at defined intervals. It can also be set up to restart when some sort of `max_value` is reached.

General Syntax:

```sql
CREATE SEQUENCE sequence_name
  START WITH initial_value        -- specifies the value you want the sequence to start at
  INCREMENT BY increment_value    -- specifies what to increment each sequence value by to get the next one
  MINVALUE minimum_value          -- specifies a minimum value (if desired)
  MAXVALUE maximum_value          -- specifies a maximum value (if desired)
  CYCLE/NOCYCLE;                  -- CYCLE will cause the sequence to restart if it reaches a limit
                                  -- NOCYCLE will cause an error to be thrown if the limit is reached
```

For example:

```sql
-- Creates a sequence that starts at 1 and increments by 2
CREATE SEQUENCE odds
  START WITH 1
  INCREMENT BY 2;

-- Creates a sequence that starts at 2 and increments by 2
CREATE SEQUENCE evens
  START WITH 2
  INCREMENT BY 2;
```

We can get the next value of any given sequence with the `nextval()` function.

```sql
SELECT nextval('odds');
/*
 nextval
---------
       1
(1 row) */

-- Once a number is returned by nextval() from a sequence, it isn't returned again

SELECT nextval('odds');
/*
 nextval
---------
       3
(1 row) */
```

"Reset" a sequence back to any number you specify with `ALTER SEQUENCE` in combination with `RESTART WITH`.

```sql
ALTER SEQUENCE odds RESTART WITH 1;

SELECT nextval('odds');
/*
 nextval
---------
       1
(1 row) */

ALTER SEQUENCE evens RESTART WITH 8;

SELECT nextval('evens');
/*
 nextval
---------
       8
(1 row) */
```

Use a general `SELECT` query to get information about a sequence. The `last_val` column will show the last value that was returned by the sequence.

```sql
SELECT * FROM odds;
/*
 last_value | log_cnt | is_called
------------+---------+-----------
          1 |      30 | t
(1 row) */

SELECT * FROM evens;
/*
 last_value | log_cnt | is_called
------------+---------+-----------
          8 |       0 | f
(1 row) */
```

We can use `nextval()` with a sequence to insert data into a table:

```sql
CREATE TABLE rhymes (
  id integer PRIMARY KEY,
  rhyme text
);

INSERT INTO rhymes
  VALUES (nextval('odds'), 'free'), -- The next value in odds is 3
         (nextval('evens'), 'door'), -- The next value in evens is 4
         (nextval('odds'), 'alive'), -- The next value in odds is 5
         (nextval('evens'), 'kicks'); -- The next value in evens is 6
/*
 id | rhyme
----+-------
  3 | free
  4 | door
  5 | alive
  6 | kicks
(4 rows) */
```

The `serial` datatype consists of a sequence that is implicitly created when we assign the datatype. The default value for the column of `serial` datatype then becomes `nextval()` for the created sequence. If we create a table and assign `serial` as datatype for a column, we'll see if we list relations in `psql` that both the table and the sequence pop up.

```sql
CREATE TABLE items (
  id serial PRIMARY KEY,
  description text NOT NULL
);

-- \d database_name now shows:
/*
                    List of relations
 Schema |         Name         |   Type   |   Owner
--------+----------------------+----------+------------
 public | evens                | sequence | gcpinckert
 public | items                | table    | gcpinckert
 public | items_id_seq         | sequence | gcpinckert
 public | odds                 | sequence | gcpinckert
 public | rhymes               | table    | gcpinckert */
```
