/* MANY TO MANY RELATIONSHIPS PRACTICE PROBLEMS */

-- 1. Add NOT NULL and ON DELETE CASCADE constraints to the foriegn keys

ALTER TABLE books_categories
  ALTER COLUMN book_id SET NOT NULL,
  ALTER COLUMN category_id SET NOT NULL;

  -- To add ON DELETE CASCADE you have to drop the existing foreign key constraint and add it back

ALTER TABLE books_categories
  DROP CONSTRAINT books_categories_book_id_fkey,
  ADD CONSTRAINT books_categories_book_id_fkey 
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE;

ALTER TABLE books_categories
  DROP CONSTRAINT books_categories_category_id_fkey,
  ADD CONSTRAINT books_categories_category_id_fkey 
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE;

-- 2. Return a list containing each author and thier categories

SELECT b.id, b.author, string_agg(c.name, ', ') AS categories
  FROM books AS b
    INNER JOIN books_categories AS bc ON b.id = bc.book_id
    INNER JOIN categories AS c ON c.id = bc.category_id
  GROUP BY b.id
  ORDER BY b.id;

--3. Insert the given books into the database. What must be done to ensure this data fits in the database?

  -- We have to find the correct category id numbers to associate the categories with the correct books.
  -- Certain categories will have to be added so they can be associated with a book.

  -- First insert new categories
INSERT INTO categories (name)
  VALUES ('Space Exploration'),
         ('Cookbook'),
         ('South Asia');
  
  -- Update books schema to accept longer values
ALTER TABLE books
  ALTER COLUMN title TYPE varchar(50),
  ALTER COLUMN author TYPE varchar(50);

  -- Next insert books
INSERT INTO books (author, title)
  VALUES ('Lynn Sherr', 'Sally Ride: America''s First Woman in Space'),
         ('Charlotte Brontë', 'Jane Eyre'),
         ('Meeru Dhalwala and Vikram Vij', 'Vij''s: Elegant and Inspired Indian Cuisine');
  
  -- Get the primary keys for books and categories, and insert each into the join table
INSERT INTO books_categories (book_id, category_id)
  VALUES (4, 5),
         (4, 1),
         (4, 7),
         (5, 2),
         (5, 4),
         (6, 8),
         (6, 1),
         (6, 9);

-- 4. Add a uniqueness constraint to the combination of columns book_id and category_id of books_categories. This should be a table constraint that checks for uniqueness on the combination of book_id and category_id across all rows of the table.

CREATE UNIQUE INDEX unique_book_category_combo ON books_categories (book_id, category_id);

-- 5. Return a list of category names, the count of each book per category, and the titles of the books.

SELECT c.name, count(b.id) AS book_count, string_agg(b.title, ', ') AS book_titles 
  FROM categories AS c
    INNER JOIN books_categories AS bc ON c.id = bc.category_id
    INNER JOIN books AS b ON b.id = bc.book_id
  GROUP BY c.name
  ORDER BY c.name;