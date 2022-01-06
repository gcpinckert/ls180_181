/* USING KEYS */

/* 1. Create a new sequence called 'counter' */

CREATE SEQUENCE counter;

/* 2. Retrieve the next value from the counter sequnce */

SELECT nextval('counter');

/* 3. Remove the sequence 'counter' */

DROP SEQUENCE counter;

/* 4. Create a sequence that returns only even numbers */

CREATE SEQUENCE evens INCREMENT 2
  START 2;

/* 5. What is the name of the sequence create by the following command? */

CREATE TABLE regions (id serial PRIMARY KEY, name text, area integer);
-- 'regions_id_seq'

/* 6. Add an auto-incrementing integer primary key column to the films table */

ALTER TABLE films
ADD COLUMN id serial PRIMARY KEY;

/* 7. What error is shown when you try to add a row with an already used value for id? */

/* ERROR:  duplicate key value violates unique constraint "films_pkey"
DETAIL:  Key (id)=(1) already exists. */

/* 8. What error is raised if you add another primary key column to the films table? */

/* ERROR:  multiple primary keys for table "films" are not allowed */

/* 9. Modify the film table such that it has no Primary Key but preserve the id column and its values */

ALTER TABLE films DROP CONSTRAINT films_pkey;
