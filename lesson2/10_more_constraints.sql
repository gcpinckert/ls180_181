/* MORE CONSTRAINTS */

/* 1. Import films.sql into a database with:
      $ psql -d sql_course < films.sql */

/* 2. Make all columns have a NOT NULL constraint */

ALTER TABLE films
  ALTER COLUMN title SET NOT NULL;
ALTER TABLE films
  ALTER COLUMN year SET NOT NULL;
ALTER TABLE films
  ALTER COLUMN genre SET NOT NULL;
ALTER TABLE films
  ALTER COLUMN director SET NOT NULL;
ALTER TABLE films
  ALTER COLUMN duration SET NOT NULL;

/* 3. When we set a column to NOT NULL, this is shown in the table's schema description (pulled up with `\d`). In this case, we can see 'not null' displayed in the "Nullable" column. */

/* 4. Add a constraint to ensure that all film titles are unique */

ALTER TABLE films
  ADD CONSTRAINT unique_title UNIQUE (title);

/* 5. The above constraint is displayed by `\d` as an "index", i.e. as a named constraint at the bottom of the schema display table. */

/* 6. Remove the UNIQUE constraint added in #4 */

ALTER TABLE films
  DROP CONSTRAINT unique_title;

/* 7. Add a constraint to films that requires title be a value at least 1 character long */

ALTER TABLE films
  ADD CONSTRAINT title_length CHECK(length(title) > 0);

/* 8. The following statement now generates an error: */

INSERT INTO films VALUES ('', 1999, 'a', 'b', 300);

/* Raises:

ERROR:  new row for relation "films" violates check constraint "title_length"
DETAIL:  Failing row contains (, 1999, a, b, 300). */

/* 9. The constraint added in #7 is shown as a named check constraint at the bottom of the table shown by `\d` along with the conditional clause */

/* 10. Remove the constraint set in #7 */

ALTER TABLE films DROP CONSTRAINT title_length;

/* 11. Add a constraint to ensure that all films have a date between 1900 and 2100 */

ALTER TABLE films
  ADD CONSTRAINT release_year 
  CHECK (year > 1899 AND year < 2101);

/* 12. The constraint added in #11 is shown as a named check constraint at the bottom of the schema table displayed by `\d` along with the conditonal clause */

/* 13. Add a constraint that requires all rows to have a value for director that is at least 3 characters long and contains one space */

ALTER TABLE films
  ADD CONSTRAINT director_length
  CHECK (length(director) > 2 AND position(' ' in director) > 0);

/* 14. The constraint added in #13 is shown as a named check constraint at the bottom of the schema table displayed by `\d` along with the conditonal clause */

/* 15. Try to update the directory for "Die Hard" to "Johnny" */

UPDATE films SET director = 'Johnny'
  WHERE title = 'Die Hard';

/* This raises an error due to the check constraint:
ERROR:  new row for relation "films" violates check constraint "director_length"
DETAIL:  Failing row contains (Die Hard, 1988, action, Johnny, 132). */

/* 16. How can schema be used to restrict values stored in a column?

- We can use UNIQUE constraints to ensure that all values within a column are unique (i.e. there are no duplicate values)
- We can use a NOT NULL constraint to ensure NULL values are not added to a given column
- We can use a CHECK constraint to set specific conditionals for a given column, for examples that it contains strings of a certain length.
- Data types themselves can also act as constraints, for example by specifiying whole number integers instead of decimals */

/* 17. You cannot define a default value for a column that will be considered invalud by any already existing constraints. If you try to do so, an error will be thrown when you try to add some values with that default value */

/* 18. Use \d table_name in order to view all constraints in a table */