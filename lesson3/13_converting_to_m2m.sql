/* CONVERTING 1:M to M:M PRACTICE PROBLEMS */

-- 2. Create a join table such that a fi;m can have multiple directors and directors can have multiple films. Include an id column in this table and add foreign key constraints to the other columns.

CREATE TABLE directors_films (
  id serial PRIMARY KEY,
  film_id integer REFERENCES films(id),
  director_id integer REFERENCES directors(id)
);

  -- Note that we follow SQL convetion and use alphabetical order for both words in the join table name (i.e. Directors then Films)

-- 3. Insert data into the new join table that represents the existing one-to-many relationships

  -- First get the primary key for each entitiy
SELECT * FROM films FULL JOIN directors ON films.director_id = directors.id;

  -- Then insert the correct id values
INSERT INTO directors_films (film_id, director_id)
  VALUES (1, 1),
         (2, 2),
         (3, 3),
         (4, 4),
         (5, 5),
         (6, 6),
         (7, 3),
         (8, 7),
         (9, 8),
         (10, 4);

-- 4. Remove any unneeded columns from films
  -- We can drop the director_id column, as this relationship is now represented by the directors_films table

ALTER TABLE films
  DROP COLUMN director_id;

-- 5. Return a list of movie titles along with the name of their director

SELECT f.title, d.name FROM films AS f
  LEFT OUTER JOIN directors_films AS df ON f.id = df.film_id
  LEFT OUTER JOIN directors AS d ON d.id = df.director_id
  ORDER BY f.title;

-- 6. Insert the new data into the database

  -- First create the film records:
INSERT INTO films (title, "year", genre, duration)
  VALUES ('Fargo', 1996, 'comedy', 98),
         ('No Country for Old Men', 2007, 'western', 122),
         ('Sin City', 2005, 'crime', 124),
         ('Spy Kids', 2001, 'scifi', 88);
  
  -- Next create the director records
INSERT INTO directors (name)
  VALUES ('Joel Coen'),
         ('Ethan Coen'),
         ('Frank Miller'),
         ('Robert Rodriguez');
  
  -- Now get the id values so you can input them into the join table
SELECT id, name FROM directors ORDER BY id DESC LIMIT 4; -- directors
SELECT id, title FROM films ORDER BY id DESC LIMIT 4; -- films

  -- Insert the primary key values into the foriegn key columns of the join table
INSERT INTO directors_films (film_id, director_id)
  VALUES (11, 9),
         (12, 9),
         (12, 10),
         (13, 11),
         (13, 12),
         (14, 12);
  
  -- Verify
SELECT f.title, d.name FROM films AS f
  LEFT OUTER JOIN directors_films AS df ON f.id = df.film_id
  LEFT OUTER JOIN directors AS d ON d.id = df.director_id
  ORDER BY f.title;

-- 7. Determine how many films each director in the database has directed. Sort results by number of films from highest to lowest, and then by name in alphabetical order.

SELECT d.name AS director, count(f.id) AS number_of_films FROM directors AS d
  INNER JOIN directors_films AS df ON d.id = df.director_id
  INNER JOIN films AS f ON f.id = df.film_id
  GROUP BY d.name
  ORDER BY number_of_films DESC, d.name;
  