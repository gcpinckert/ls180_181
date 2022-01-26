/* The following file is a times practice run through of the exercises in the SQL Fundamentals M2M Exercises

Run it with the safe-run-sql() command on the CLI for most efficient functioning. */

-- Set up Database:

CREATE TABLE stars (
  id serial PRIMARY KEY,
  name varchar(25) UNIQUE NOT NULL,
  distance integer NOT NULL CHECK (distance > 0),
  spectral_type char(1) CHECK (spectral_type SIMILAR TO 'O|B|A|F|G|K|M'),
  companions integer NOT NULL CHECK (companions > -1)
);

CREATE TABLE planets (
  id serial PRIMARY KEY,
  designation char(1) CHECK (designation SIMILAR TO '[a-z]'),
  mass integer
);

-- Add a star_id column to planets table to be used as foreign key for stars table

ALTER TABLE planets
  ADD COLUMN star_id integer
  NOT NULL REFERENCES stars(id) ON DELETE CASCADE;

-- Increase star name length from 25 to 50

ALTER TABLE stars
  ALTER COLUMN name TYPE varchar(50);

-- Revert the change, add some data, and try to make the same change again

ALTER TABLE stars
  ALTER COLUMN name TYPE varchar(25);

INSERT INTO stars (name, distance, spectral_type, companions)
  VALUES ('Alpha Centauri B', 4, 'K', 3);

ALTER TABLE stars
  ALTER COLUMN name TYPE varchar(50);

-- Change the distance column in stars so that it allows fractional values of any precision

ALTER TABLE stars
  ALTER COLUMN distance TYPE real;

-- Revert the change, add some data, and try to make the same change again

ALTER TABLE stars
  ALTER COLUMN distance TYPE integer;

INSERT INTO stars (name, distance, spectral_type, companions)
  VALUES ('Alpha Orionis', 643, 'M', 9);

ALTER TABLE stars
  ALTER COLUMN distance TYPE real;

-- Add a NOT NULL constraint to spectral type

ALTER TABLE stars
  ALTER COLUMN spectral_type
  SET NOT NULL;

-- Remove the CHECK constraint on stars spectral_type
-- Change spectral type so it becomes an enumerated type that restricts it to the indicated letters

ALTER TABLE stars
  DROP CONSTRAINT "stars_spectral_type_check";

CREATE TYPE spectral AS ENUM ('O', 'B', 'A', 'F', 'G', 'K', 'M');

ALTER TABLE stars
  ALTER COLUMN spectral_type TYPE spectral USING spectral_type::spectral;

-- Change the mass column in planets so that it allows fractional values of any defree of precision
-- Ensure that the mass is required and positive
-- Make designation not null as well

ALTER TABLE planets
  ALTER COLUMN mass TYPE real,
  ALTER COLUMN mass SET NOT NULL,
  ADD CHECK (mass > -1),
  ALTER COLUMN designation SET NOT NULL;

-- Add a column for semi_major_axis in in planets
-- datatype numeric and should not be null

ALTER TABLE planets
  ADD COLUMN semi_major_axis numeric NOT NULL;

-- Add a moons table

CREATE TABLE moons (
  id serial PRIMARY KEY,
  designation integer NOT NULL CHECK (designation > 0),
  semi_major_axis numeric CHECK (semi_major_axis > 0.0),
  mass numeric CHECK (mass > 0.0),
  planet_id integer NOT NULL REFERENCES planets(id) ON DELETE CASCADE
);
