/* NOT NULL AND DEFAULT VALUES */

/* 1. The result of using an operator (any operator) on a NUL value is NULL. This makes NULL results hard to predict when used in operations like sorting and comparison. It can also effect the complixity of other systems, who now must check for the "absense of value". */

/* 2. Set the default value of the 'department' column to 'unassigned'. Set the value of the 'department' column to 'unassigned' for any rows which have a NULL value. Add a NOT NULL constraint to the department column. */

ALTER TABLE employees
  ALTER COLUMN department
  SET DEFAULT 'unassigned';

UPDATE employees
  SET department = 'unassigned'
  WHERE department IS NULL;

ALTER TABLE employees
  ALTER COLUMN department
  SET NOT NULL;

/* 3. Create a table called temparatures to hold the given data. All the rows in the table should always contain all three values. */

CREATE TABLE temperatures (
  date date NOT NULL DEFAULT current_date,
  low integer NOT NULL,
  high integer NOT NULL
);

/* 4. Insert the given data into temperatures */

INSERT INTO temperatures (date, low, high)
  VALUES ('2016-03-01', 34, 43),
         ('2016-03-02', 32, 44),
         ('2016-03-03', 31, 47),
         ('2016-03-04', 33, 42),
         ('2016-03-05', 39, 46),
         ('2016-03-06', 32, 43),
         ('2016-03-07', 29, 32),
         ('2016-03-08', 23, 31),
         ('2016-03-09', 17, 28);

/* 5. Determine the avg temperature for each day from 3/2 - 3/8. Round the result to one decimal place */

SELECT date, round(((low + high) / 2.0), 1) AS average FROM temperatures
  WHERE extract(day from date) > 1 AND extract(day from date) < 9;

/* Note that we could also use the date comparison predicate BETWEEN in the WHERE clause */

SELECT date, round(((low + high) / 2.0), 1) AS average FROM temperatures
  WHERE date BETWEEN '2016-03-02' AND '2016-03-08';

/* 6. Add 'rainfall' as a new column to 'temperatures' to store millimeters of rainfall as integers with a default value of 0. */

ALTER TABLE temperatures
  ADD COLUMN rainfall integer NOT NULL DEFAULT 0;

/* 7. Update the data in the temperatures table according to the following formula:
  Each day it rains 1 mm per degree the average temperature is above 35 */

UPDATE temperatures
  SET rainfall = ((low + high) / 2) - 35
  WHERE (((low + high) / 2) - 35) > 0;

/* 8. Modify the rainfall column so that data is stored in inches */

ALTER TABLE temperatures
  ALTER COLUMN rainfall TYPE decimal(4, 2);

UPDATE temperatures
  SET rainfall = rainfall / 25.4;

/* 9. Rename the temperatures table to weather */

ALTER TABLE temperatures
  RENAME TO weather;

/* 10. \d weather metacommand will show the structure of the weather table */

/* 11. You can use
  $ pg_dump -d sql-course -t weather --inserts > dump.sql
  to create an SQL file that contains the SQL commands needed to recreate the current structure and data of the weather table */
  