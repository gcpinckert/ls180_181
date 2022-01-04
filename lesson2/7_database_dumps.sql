/* Loading Database Dumps Practice Problems */

/* 1. Load sample_file.sql into a database

  use psql -d encyclopedia < sample_file.sql

  - The file first checks to see if a table called `films` exists, and deletes it (and all associated data) if it does. Becuase no such table yet exists, it moves on to the next SQL statement. 
  - This creates a table called `films` which contains three columns:
    - title, which contains strings of up to 255 characters
    - "year" (which must be put in quotes to differentiate it from the SQL function year pertaining to date datatypes), which contains integers
    - genre, which contains strings of up to 100 characters
  - Next there are three insert clauses
    - The first inserts the values 'Die Hard', 1988, and 'action' into each column respectively
    - The second inserts the values 'Casablanca', 1942, and 'drama' into each column respectively
    - The third inserts the values 'The Conversation`, 1974, and 'thriller' into each column respectively.
  
  - Output:
    NOTICE:  table "films" does not exist, skipping - indicates the given table was not found
    DROP TABLE
    CREATE TABLE - indicates the table has been created
    INSERT 0 1 - indicates that 1 row has been inserted
    INSERT 0 1 - indicates that 1 row has been inserted
    INSERT 0 1 - indicates that 1 row has been inserted */

/* 2. Write an SQL statement that returns all rows in the films table */

SELECT * FROM films;

/* 3. Return all rows in the films table with a title shorter than 12 letters */

SELECT * FROM films
WHERE char_length(title) < 12;

/* 4. Add a 'director' column to hold a director's full name and a 'duration' column to hold the length of the film in minutes */

ALTER TABLE films
ADD COLUMN director varchar(255);

ALTER TABLE films
ADD COLUMN duration integer;

/* 5. Update the existing rows with the given values for the new columns */

UPDATE films -- needs review
  SET director = 'John McTiernan',
      duration = 132
  WHERE title = 'Die Hard';

UPDATE films
  SET director = 'Michael Curtiz',
      duration = 102
  WHERE title = 'Casablanca';

UPDATE films
  SET director = 'Francis Ford Coppola',
      duration = 113
  WHERE title = 'The Conversation';

/* 6. Insert the given data as rows into the films table */

INSERT INTO films (title, "year", genre, director, duration)
  VALUES ('1984', 1956, 'scifi', 'Michael Anderson', 90),
         ('Tinker Tailor Soldier Spy', 2011, 'espionage', 'Tomas Alfredson', 127),
         ('The Birdcage', 1996, 'comedy', 'Mike Nichols', 118);

/* 7. Return the title and age in years of each move, with the newest movies listed first */

SELECT title, (extract(year from current_date) - "year") AS age FROM films
  ORDER BY age;

/* 8. Return the title and duration of each movie londer than two hours, from longest to shortest */

SELECT title, duration FROM films
  WHERE duration >= 120
  ORDER BY duration DESC;

/* 9. Return the title of the longest film */

SELECT title FROM films
  ORDER BY duration DESC
  LIMIT 1;