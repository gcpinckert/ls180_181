-- ##### Creating multiple tables #####

-- 3. Encyclopedia: Create an albums table and link it to singers in a one-many relationship
INSERT INTO albums
  (album_name, released, genre, label, singer_id)
  VALUES
    ('Born to Run', 'August 25, 1975', 'Rock and roll', 'Columbia', 1),
    ('Purple Rain', 'June 25, 1984', 'Pop, R&B, Rock', 'Warner Bros', 6),
    ('Born in the USA', 'June 4, 1984', 'Rock and roll, pop', 'Columbia', 1),
    ('Madonna', 'July 27, 1983', 'Dance-pop, post-disco', 'Warner Bros', 5),
    ('True Blue', 'June 30, 1986', 'Dance-pop, Pop', 'Warner Bros', 5),
    ('Elvis', 'October 19, 1956', 'Rock and roll, Rhythm and Blues', 'RCA Victor', 7),
    ('Sign o'' the Times', 'March 30, 1987', 'Pop, R&B, Rock, Funk', 'Paisley Park, Warner Bros', 6),
    ('G.I. Blues', 'October 1, 1960', 'Rock and roll, pop', 'RCA Victor', 7);

-- 4. LS Burger: Normalize the order table
  -- create a customers table to hold customer name data
  -- create an email_addresses table to hold customer email data
  -- they should have a one-to-one relationship, ensuring that if a customer record is deleted so is the email address
  -- populate the tables with the appropriate data from the current orders table

CREATE TABLE customers (
  customer_id serial PRIMARY KEY,
  customer_name varchar(100)
);

CREATE TABLE email_addresses (
  customer_id int,
  email_address varchar(50),
  PRIMARY KEY (customer_id),
  FOREIGN KEY (customer_id)
    REFERENCES customers (customer_id)
    ON DELETE CASCADE
);

INSERT INTO customers (customer_name)
  VALUES
  ('Natasha O''Shea'),
  ('James Bergman'),
  ('Aaron Muller');

INSERT INTO email_addresses (customer_id, email_address)
VALUES
  (1, 'natasha@osheafamily.com'),
  (2, 'james1998@email.com');

-- 5. LS Burger: Make the ording system more flexible
  -- Create a products table and populate it with the given data
  -- Include an auto-incrementing id column for the PRIMARY KEY
  -- product_type column hols a string of up to 20 chars
  -- Other data types should come from previous orders table

CREATE TABLE products (
  id serial PRIMARY KEY,
  product_name varchar(50),
  product_cost decimal(5,2) DEFAULT 0.00,
  product_type varchar(20),
  product_loyalty_points integer DEFAULT 0
);

INSERT INTO products (product_name, product_cost, product_type, product_loyalty_points)
VALUES
  ('LS Burger', 3.00, 'Burger', 10),
  ('LS Cheeseburger', 3.50, 'Burger', 15),
  ('LS Chicken Burger', 4.50, 'Burger', 20),
  ('LS Double Deluxe Burger', 6.00, 'Burger', 30),
  ('Fries', 1.20, 'Side', 3),
  ('Onion Rings', 1.50, 'Side', 5),
  ('Cola', 1.5, 'Drink', 5),
  ('Lemonade', 1.5, 'Drink', 5),
  ('Vanilla Shake', 2, 'Drink', 7),
  ('Chocolate Shake', 2.00, 'Drink', 7),
  ('Strawberry Shake', 2.00, 'Drink', 7);

-- 6. LS Burger: associate customers with products
  -- Alter or replace the orders table so that we can associate a customer with one or more orders
  -- We also want to record an order status in this table
  -- Create an order_items table so that an order can have one or more products associated with it
  -- Populate the tables with the appropriate data

DROP TABLE orders; -- So that we can create a new one that suits our needs

CREATE TABLE orders (
  id serial PRIMARY KEY,
  customer_id integer,
  order_status varchar(20),
  FOREIGN KEY (customer_id)
  REFERENCES customers (customer_id)
  ON DELETE CASCADE
);

-- Create an order_items table to create a many-to-many relationship between orders and products
CREATE TABLE order_items (
  id serial PRIMARY KEY,
  order_id integer NOT NULL,
  product_id integer NOT NULL,
  FOREIGN KEY (order_id)
  REFERENCES orders (id)
  ON DELETE CASCADE,
  FOREIGN KEY (product_id)
  REFERENCES products (id)
  ON DELETE CASCADE
);

-- Add data

INSERT INTO orders (customer_id, order_status)
VALUES (1, 'In Progress'),
(2, 'Placed'),
(2, 'Complete'),
(3, 'Placed');

INSERT INTO order_items (order_id, product_id)
VALUES
  (1, 3),
  (1, 5),
  (1, 6),
  (1, 8),
  (2, 2),
  (2, 5),
  (2, 7),
  (3, 4),
  (3, 2),
  (3, 5),
  (3, 5),
  (3, 6),
  (3, 10),
  (3, 9),
  (4, 1),
  (4, 5);

-- ##### SQL JOINS #####

-- 1. Encyclopedia: return all country names along with their appropriate continents.

SELECT countries.name, continents.continent_name
FROM countries
JOIN continents
ON countries.continent_id = continents.id;

-- 2. Return all the names and capitals of the European countries

SELECT countries.name, countries.capital
FROM countries JOIN continents
ON countries.continent_id = continents.id
WHERE continents.continent_name = 'Europe';

-- 3. Return the first name of any singer who had an album released under the Warner Bros label

SELECT singers.first_name
FROM singers JOIN albums
ON singers.id = albumbs.singer_id
WHERE albums.label = 'Warner Bros';

-- Note you can also use DISTINCT to ensure that names aren't repeated in the results,
-- and pattern matching to ensure you capture all relevant strings

SELECT DISTINCT singers.first_name
FROM singers JOIN albums
ON singers.id = albums.singer_id
WHERE albums.label LIKE '%Warner Bros%';

-- 4. Return the first name and last name of any singer who released an album in the 80s and is still living
-- along with the names of the album and the release date. Order the results by singer's age (youngest - oldest)

SELECT singers.first_name, singers.last_name, albums.album_name, albums.released
FROM singers JOIN albums
ON singers.id = albums.singer_id
WHERE date_part('year', albums.released) < 1990 AND date_part('year', albums.released) > 1979 AND singers.deceased = false
ORDER BY age(singers.date_of_birth);

-- 5. Write a query to return the first name and last name of any singer without an associated album entry

SELECT singers.first_name, singers.last_name
FROM singers LEFT JOIN albums
ON singers.id = albums.singer_id
WHERE albums.id IS NULL;

-- 6. Return the same as above but with a subquery

SELECT singers.first_name, singers.last_name FROM singers
WHERE singers.id NOT IN (
  SELECT albums.singer_id FROM albums
);

-- 7. LS Burger: Return a list of all orders and their associated product items

SELECT orders.*, products.*
FROM orders JOIN order_items
ON orders.id = order_items.order_id
JOIN products
ON order_items.product_id = products.id;

-- 8. Return the id of any order that includes Fries, and use table aliasing

SELECT DISTINCT c.customer_name AS "Customers who like Fries"
  FROM orders o JOIN order_items i
    ON o.id = i.order_id
  JOIN products p
    ON i.product_id = p.id
  JOIN customers c
    ON o.customer_id = c.customer_id
  WHERE p.product_name = 'Fries';

-- 9. Return the total cost of Natasha O' Shea's orders

SELECT sum(p.product_cost) AS "Total Order Cost"
  FROM orders o JOIN order_items i
    ON o.id = i.order_id
  JOIN products p
    ON i.product_id = p.id
  JOIN customers c
    ON o.customer_id = c.customer_id
  WHERE c.customer_name = 'Natasha O''Shea';

  -- 11. Write a query to return the name of every product included in an order alongside the number of times it has been ordered
  -- sort the results by product name ascending

SELECT p.product_name, count(p.id) 
  FROM orders o JOIN order_items i
    ON o.id = i.order_id
  JOIN products p
    ON i.product_id = p.id
  GROUP BY p.product_name
  ORDER BY p.product_name;