/* ONE TO MANY RELATIONSHIPS */

/* 1. Add the given data */

-- First find the contact id for the person called:
SELECT id FROM contacts WHERE first_name = 'William' AND last_name = 'Swift';

-- Use the id to insert the correct information
INSERT INTO calls ("when", duration, contact_id)
  VALUES ('2016-01-18 14:47:00', 632, 6);

/* 2. Return all the call times, duration, and first names for calls not made to William Swift */

SELECT ca."when", ca.duration, co.first_name FROM calls AS ca
  INNER JOIN contacts AS co ON ca.contact_id = co.id
  WHERE contact_id <> 6;

/* 3. Add the given data to the database */

-- First add the new contacts
INSERT INTO contacts (first_name, last_name, number)
  VALUES ('Merve', 'Elk', '6343511126'),
         ('Sawa', 'Fyodorov', '6125594874');

-- Then find the contact id (26 & 27 respectively)

-- Insert the call data into the calls table
INSERT INTO calls ("when", duration, contact_id)
  VALUES ('2016-01-17 11:52:00', 175, 26),
         ('2016-01-18 21:22:00', 79, 27);

/* 4. Add a constraint to contacts that prevents a duplicate value being added in the number column */

ALTER TABLE contacts
ADD CONSTRAINT unique_number
UNIQUE (number);

/* 5. Try to insert a dpulicate number and determine what error is shown */

INSERT INTO contacts (first_name, last_name, number)
  VALUES ('John', 'Johnson', '6125594874');

/* ERROR:  duplicate key value violates unique constraint "unique_number"
DETAIL:  Key (number)=(6125594874) already exists. */

/* 6. We need to put "when" in quotes because it represents an SQL keyword. Because the distinguishing of capital vs lowercase is only a convention and in fact SQL is case insensitive, the database has no way of knowing if we mean a column name or the keyword name. Putting when into quotes tells the psql engine that we specifically mean the name of a column. */
