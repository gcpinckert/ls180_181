/* GROUP BY AND AGGREGATE FUNCTIONS */

/* 2. Insert the given data into the database */

INSERT INTO films (title, year, genre, director, duration)
VALUES ('Wayne''s World', 1992, 'comedy', 'Penelope Spheeris', 95),
       ('Bourne Identity', 2002, 'espionage', 'Doug Liman', 118);

/* 3. List all the genres for which there is a movie */

SELECT DISTINCT genre FROM films;

/* 4. List all the genres without using DISTINCT */

SELECT genre FROM films GROUP BY genre;

/* 5. Determine the average duration across all movies, and round it to the nearest minute */

SELECT round(avg(duration)) AS average_duration_mins FROM films;

/* 6. Determine the average duration for each genre, rounded to the nearest minute */

SELECT genre, round(avg(duration)) AS average_duration_mins FROM films
  GROUP BY genre;

/* 7. Determine the average duration for each decade of movies, rounded to the nearest minute and listed in chronological order */

SELECT year / 10 * 10 AS decade, round(avg(duration)) AS average_duration_mins FROM films
  GROUP BY decade
  ORDER BY decade;

/* 8. Find all films whose director has the first name John */

SELECT title, director FROM films
  WHERE director LIKE 'John%';

/* 9. Return a list of genres with the number of movies of that genre */

SELECT genre, count(id) FROM films
  GROUP BY genre
  ORDER BY count(id) DESC;

/* 10. Return a list of films per genre per decade */

SELECT round(year, -1) AS decade, genre, string_agg(title, ', ') AS films FROM films
  GROUP BY decade, genre
  ORDER BY decade, genre;

/* 11. Return a list of the sum of all the durations in each genre */

SELECT genre, sum(duration) AS total_duration FROM films
  GROUP BY genre
  ORDER BY total_duration, genre;