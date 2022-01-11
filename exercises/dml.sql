/* Data Manipulation Language Exercises */

-- Set up the database

CREATE DATABASE workshop;

-- Set up the tables

CREATE TABLE devices (
  id serial PRIMARY KEY,
  name text NOT NULL,
  created_at timestamp DEFAULT now()
);

CREATE TABLE parts (
  id serial PRIMARY KEY,
  part_number integer UNIQUE NOT NULL,
  device_id integer REFERENCES devices(id) NOT NULL
);

-- Add in device data

INSERT INTO devices (name)
  VALUES ('Accelerometer'),
         ('Gyroscope');

-- Remove NOT NULL constraint from device_id so we can add parts that do not have a device

ALTER TABLE parts
  ALTER COLUMN device_id DROP NOT NULL;

-- Add in parts data

INSERT INTO parts (part_number, device_id)
  VALUES (10, 1),
         (11, 1),
         (12, 1),
         (13, 2),
         (14, 2),
         (15, 2),
         (16, 2),
         (17, 2),
         (18, NULL),
         (19, NULL),
         (20, NULL);

-- Display all the devices along with the parts that make them up. Only display the name of the device and the part number.

SELECT d.name, p.part_number FROM devices AS d
  INNER JOIN parts AS p ON p.device_id = d.id;

-- Return all parts that have a part number that starts with 3. Show all the attributes of the parts table.

SELECT * FROM parts WHERE part_number::text LIKE '3%';

-- Casting the integer value in part_number to a string datatype allows us to use pattern matching to see what value start with 3. We can't determine this automatically, since the numbers may be between 1-10000.

-- Return a result table with the name of each device together with the number of parts for that device.

SELECT d.name, count(p.id) AS number_of_parts FROM devices AS d
  LEFT OUTER JOIN parts AS p ON p.device_id = d.id
  GROUP BY d.name;

-- Note that a left outer join is needed here in case there are devices which have no parts.

-- Return the same as above, but devices should be listed in descending alphabetical order.

SELECT d.name, count(p.id) AS number_of_parts FROM devices AS d
  LEFT OUTER JOIN parts AS p ON p.device_id = d.id
  GROUP BY d.name
  ORDER BY d.name DESC;

-- Write two SQL queries, one which gives a list of parts that belong to a device and one which gives a list of parts that do not belong to a device. Do not use the parts.id column.

SELECT part_number, device_id FROM parts WHERE device_id IS NOT NULL;
SELECT part_number, device_id FROM parts WHERE device_id IS NULL;

-- Insert another device into the devices table

INSERT INTO devices (name)
  VALUES ('Magnetometer');
INSERT INTO parts (part_number, device_id)
  VALUES (30, 3);

-- Return the name of the oldest device from devices

SELECT name AS oldest FROM devices
  ORDER BY age(created_at) DESC
  LIMIT 1;

-- Associate the last two parts associated with Gryoscope with Accelermoneter instead

-- Find ids for the parts:
SELECT d.name, p.id FROM devices AS d
  INNER JOIN parts AS p ON p.device_id = d.id;

-- Update the relavant parts (id #s 7, 8)
UPDATE parts SET device_id = 1 
  WHERE id = 7 or part_number = 8;

-- Delete any data related to Accelerometer, including any parts associated with it

-- First delete any parts associate with accerometer (otherwise, we have parts referencing a non-existant device which goes againsr the foreign key constraint)
DELETE FROM parts WHERE device_id = 1;

-- Now we can delete associated device
DELETE FROM devices WHERE name = 'Accelerometer';
