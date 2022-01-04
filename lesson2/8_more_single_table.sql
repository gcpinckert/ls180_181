/* More Single Table Queries */

/* 1. Create a new residents database from the cli
      $ createdb residents */

/* 2. Load the sample file into residents
      $ psql -d residents < residents_with_data.sql */

/* 3. List the ten states with the most rows in the people table in descending order */

SELECT state, count(id) AS number_of_people FROM people
  GROUP BY state
  ORDER BY number_of_people DESC
  LIMIT 10;

/* 4. List all the domains used in an email address in the 'people' table along with how many people in the database have an email address containing that domain. Go in order from most to least popular. */

SELECT regexp_match(email, '@.*\..*') AS domain, count(id) FROM people
  GROUP BY domain
  ORDER BY count DESC;

/* 5. Delete the person with ID 3399 from the people table */

SELECT * FROM people WHERE id = 3399;

DELETE FROM people WHERE id = 3399;

/* 6. Delete all users that are located in the state of CA */

SELECT id, username, state FROM people
  WHERE state LIKE 'CA';

DELETE FROM people WHERE state = 'CA';

/* 7. Update the given_name values to be all uppercase for users that have an email address containing `teleworm.us` */

UPDATE people
SET given_name = upper(given_name)
WHERE email LIKE '%teleworm.us';

/* 8. Delete all rows from the people table */

DELETE FROM people;
