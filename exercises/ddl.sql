/* DDL (Data Definition Language) Exercises */

-- Create the database with two tables according to the given specifications
CREATE DATABASE extrasolar;

CREATE TABLE stars (
  id serial PRIMARY KEY,
  name varchar(25) UNIQUE NOT NULL,
  distance integer NOT NULL CHECK(distance > 0),
  spectral_type varchar(1),
  companions integer NOT NULL CHECK (companions >= 0) DEFAULT 0
);

CREATE TABLE planets (
  id serial PRIMARY KEY,
  designation char(1),
  mass integer
);

-- Create a star_id column in the plants table which can be used to relate each planet in the planets table to its home star in the stars table (i.e. it is a foreign key). The column must have a value that is present in the stars table as an id.

ALTER TABLE planets 
  ADD COLUMN stars_id integer REFERENCES stars(id);

ALTER TABLE planets 
  ALTER COLUMN stars_id SET NOT NULL;

-- Modify the star name column so it allows names as long as 50 characters

ALTER TABLE stars
  ALTER COLUMN name TYPE varchar(50);

-- Further exploration: note that we can still modify the datatype when data exists within the table, but only within certain specifications. For example, increasing the size of `varchar` is automatic, but decreasing the size will return an error (if there are rows that have values larger than the specified updated size). 

-- Modify the distance column in stars so that it allows fractional light years to any degree of precision required.

ALTER TABLE stars
  ALTER COLUMN distance TYPE numeric;

-- numeric, decimal, real, and double precision are all data types used to store a number that has some kind of decimal or fraction aspect to it (i.e. not an integer). numeric allows for numbers of arbitrary size and precision, while these can be specified, leaving them off means that any precision or scale can be used. real and double precision are mostly reserved for use in applications that perform a lot of mathematical processing.

-- Further exploration: going from the integer type to the numeric type will cause any existing data to change implicitly to te new type (i.e. 1 -> 1.0). However, going the other direction (i.e. more precise to integer) will cause any fractional component of the number to be lost (i.e. 1.2 -> 1). 

-- Add a constraint to the stars table that will enforce the requirement that a row must hold either O B A F G K or M in the spectral_type column. Also make sure that no NULL values are stored here.

ALTER TABLE stars
  ADD CONSTRAINT valid_spectral_type
  CHECK (spectral_type SIMILAR TO '(O|B|A|F|G|K|M)');

ALTER TABLE stars
  ALTER COLUMN spectral_type SET NOT NULL;

-- An _enumerated data type_ is a data type that must have one of a finite set of values. Modify the spectral_type column so it becomes an enumerated type rather than relying on the CHECK constraint.

-- First we have to create out enumerated datatype with CREATE TYPE:

CREATE TYPE spectral_value AS ENUM ('O', 'B', 'A', 'F', 'G', 'K', 'M');

-- Now we can use the type within the table

-- First drop the previous check constraint, then change the column data type. Note that we must add the USING clause, which tells PostgreSQL how to convert any existing values to the new values included in the enumerated type.

ALTER TABLE stars
  DROP CONSTRAINT valid_spectral_type,
  ALTER COLUMN spectral_type TYPE spectral_value
  USING spectral_type::spectral_value;

-- Modify the mass column in the planets table so that it allows fractional masses to any degree of precision required. Also ensure that the mass is not NULL and it is a positive number. Also, make the designation column a required value.

ALTER TABLE planets
  ALTER COLUMN mass TYPE numeric,
  ALTER COLUMN mass SET NOT NULL,
  ADD CONSTRAINT valid_mass CHECK (mass > 0),
  ALTER COLUMN designation SET NOT NULL;

-- Add a semi_major_axis column for the semi-major axis of each planet's orbit; aka the avg distance from the planet's star measured in AU (astonomical units). Use a datatype of nuMeric and ensure that there is a value for each row.

ALTER TABLE planets
  ADD COLUMN semi_major_axis numeric NOT NULL;

-- If we want to add this column once values have already been entered into the table we will have to take the following steps:

-- First, add the column without the NOT NULL constraint. Then update the rows in planets to include the semi_major_axis values. Then add the NOT NULL constraint. You could also specify a default value to be assigned in the place of NULL, although this would have to be updated.

-- Add a moons table with the given structure to the database

CREATE TABLE moons (
  id serial PRIMARY KEY,
  designation integer NOT NULL,
  semi_major_axis numeric CHECK (semi_major_axis > 0),
  mass numeric CHECK (mass > 0),
  planet_id integer NOT NULL REFERENCES planets(id)
);

-- Make a backup and delete your database:
-- pg_dump --inserts extrasolar > extrasolar.dump.sql
-- change to different database and then

DROP DATABASE extrasolar;
