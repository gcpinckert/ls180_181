-- 1. Create a new database called `animals`

-- From cli: createdb animals

CREATE DATABASE animals;

/* 2. Create a table called 'birds' with the following columns:
  - id (primary key)
  - name (string of up to 25 chars)
  - age (int)
  - species (string of up to 15 chars) */

CREATE TABLE birds (
  id serial PRIMARY KEY,
  name varchar(25),
  age integer,
  species varchar(15)
);

-- 3. Add data to the birds table

INSERT INTO birds (name, age, species)
           VALUES ('Charlie', 3, 'Finch'),
                  ('Allie', 5, 'Owl'),
                  ('Jennifer', 3, 'Magpie'),
                  ('Jamie', 4, 'Owl'),
                  ('Roy', 8, 'Crow');

-- 4. query all the data currently in the birds table

SELECT * FROM birds;

-- 5. query records for birds under the age of 5

SELECT * FROM birds
  WHERE age < 5;

-- 6. Update the 'birds' table so that a row with a species of crow reads 'Raven'

-- First perform a SELECT query so you know you are selecting the right data
SELECT * FROM birds
  WHERE species = 'Crow';

-- Then update the value
UPDATE birds
  SET species = 'Raven'
  WHERE species = 'Crow';

-- Further exploration, change Jamie's species from Hawk to Owl

-- Perform a SELECT query to check
SELECT * FROM birds
  WHERE name = 'Jamie';

-- Update the species value
UPDATE birds 
  SET species = 'Hawk'
  WHERE name = 'Jamie';

-- 7. Delete the record that describes a 3 year old finch

-- First perform select to check
SELECT * FROM birds
  WHERE age = 3 AND species = 'Finch';

-- Then delete the record
DELETE FROM birds
  WHERE age = 3 AND species = 'Finch';

-- 8. Add a constraint that limits age to positive numbers, then check it to make sure it works

ALTER TABLE birds
  ADD CONSTRAINT check_age CHECK (age >= 0);

INSERT INTO birds (name, age)
  VALUES ('Jo', -3);

-- 9. Delete the birds table from the animals database
DROP TABLE birds;

-- 10. Delete the animals database

-- From the CLI: dropdb animals
