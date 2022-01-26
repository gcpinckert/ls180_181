/* The following file is a times practice run through of the exercises in the SQL Fundamentals M2M Exercises

Run it with the safe-run-sql() command on the CLI for most efficient functioning. */

-- Set up Database:

CREATE TABLE devices (
  id serial PRIMARY KEY,
  name text NOT NULL,
  created_at timestamp NOT NULL DEFAULT now()
);

CREATE TABLE parts (
  id serial PRIMARY KEY,
  part_number integer UNIQUE NOT NULL,
  device_id integer REFERENCES devices(id) 
);

-- Add data

INSERT INTO devices (name)
  VALUES ('Accelerometer'), ('Gyroscope');

INSERT INTO parts (part_number, device_id)
  VALUES (10, 1),
         (11, 1),
         (12, 1),
         (20, 2),
         (21, 2),
         (22, 2),
         (23, 2),
         (24, 2),
         (30, NULL),
         (31, NULL),
         (32, NULL);

-- Display all devices along with the parts that make them up.
-- Show only device name and part number

SELECT d.name, p.part_number FROM devices AS d
  JOIN parts AS p ON p.device_id = d.id
  ORDER BY d.name;

-- Return all parts that have a part number that starts with 3

SELECT * FROM parts
  WHERE part_number::text LIKE '3%';

-- Return a table that contains the name of each device along with the number of parts

SELECT d.name, count(p.id) FROM devices AS d
  LEFT OUTER JOIN parts AS p ON p.device_id = d.id
  GROUP BY d.name;

-- Note that a left outer join is required here so that we make sure we get all devices

-- Change the above query so that we list devices in descending alphabetical order

SELECT d.name, count(p.id) FROM devices AS d
  LEFT OUTER JOIN parts AS p ON p.device_id = d.id
  GROUP BY d.name
  ORDER BY d.name DESC;

-- Generate a list of parts that currently belong to a device

SELECT part_number, device_id FROM parts
  WHERE device_id IS NOT NULL
  ORDER BY device_id;

-- Generate a list of parts that do not belong to a device

SELECT part_number, device_id FROM parts
  WHERE device_id IS NULL;

-- Insert more data

INSERT INTO devices (name)
  VALUES ('Magnetometer');

INSERT INTO parts (part_number, device_id)
  VALUES (42, 3);

-- Return the name of the oldest device from the devices table

SELECT name AS "oldest" FROM devices
  ORDER BY created_at
  LIMIT 1;

-- Associate the last two parts from gyroscope with accelerometer

UPDATE parts
  SET device_id = 1 
  WHERE id = 8 OR id = 7;

-- Associate the part with the smallest part number with Gyroscope

UPDATE parts
  SET device_id = 2
  WHERE part_number = (SELECT min(part_number) FROM parts);

-- Delete any data related to 'Accelerometer'

-- First add, remove foreign key constraint from device id column

ALTER TABLE parts
  DROP CONSTRAINT "parts_device_id_fkey";

-- Add a new foriegn key constraint with ON DELETE CASCADE

ALTER TABLE parts
  ADD CONSTRAINT "parts_device_id_fkey"
  FOREIGN KEY (device_id) REFERENCES devices(id) ON DELETE CASCADE;

-- Now we can delete the device without errors

DELETE FROM devices
  WHERE name = 'Accelerometer';
