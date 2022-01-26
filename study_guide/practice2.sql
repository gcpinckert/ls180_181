/* The following file is a times practice run through of the exercises in the SQL Fundamentals M2M Exercises

Run it with the safe-run-sql() command on the CLI for most efficient functioning. */

-- Set up Database:

CREATE TABLE bidders (
  id serial PRIMARY KEY,
  name text NOT NULl
);

CREATE TABLE items (
  id serial PRIMARY KEY,
  name text NOT NULL,
  initial_price numeric(6, 2) NOT NULL CHECK (initial_price BETWEEN 0.0 AND 1000.0),
  sales_price numeric(6, 2) CHECK (initial_price BETWEEN 0.00 AND 1000.0)
);

CREATE TABLE bids (
  id serial PRIMARY KEY,
  bidder_id integer NOT NULL REFERENCES bidders(id) ON DELETE CASCADE,
  item_id integer NOT NULL REFERENCES items(id) ON DELETE CASCADE,
  amount numeric(6, 2) NOT NULL CHECK (amount BETWEEN 0.0 AND 1000.0)
);

CREATE INDEX ON bids (bidder_id, item_id);

-- Copy data from csv files to each table

\copy bidders FROM '../exercises/bidders.csv' WITH HEADER CSV;
\copy items FROM '../exercises/items.csv' WITH HEADER CSV;
\copy bids FROM '../exercises/bids.csv' WITH HEADER CSV;

-- Note that the relative path from root ls180_181/study_guide folder is used

-- Use the logical IN operator to write return all items that have bids placed on them.

SELECT items.name AS "Bid on Items" FROM items WHERE items.id IN
  (SELECT bids.item_id FROM bids);

-- Use the logical NOT IN operator to show items that have not been bid on

SELECT items.name AS "Not Bid On" FROM items WHERE items.id NOT IN
  (SELECT bids.item_id FROM bids);

-- Return the names of everyone who has bid in the auction. First use a Join clause, then get the same results by using EXISTS

SELECT DISTINCT b.name FROM bidders AS b
  INNER JOIN bids AS bd ON bd.bidder_id = b.id;

SELECT DISTINCT bidders.name FROM bidders WHERE EXISTS
  (SELECT bids.bidder_id FROM bids WHERE bids.bidder_id = bidders.id);

-- Find the largest number of bids from an individual bidder

-- With a subquery

SELECT max(count) FROM
  (SELECT b.name, count(bd.bidder_id) FROM bidders AS b
    JOIN bids AS bd ON bd.bidder_id = b.id
    GROUP BY b.name) AS "Number of Bids";

-- With a join clause:

SELECT b.name, count(bd.bidder_id) AS "max" FROM bidders AS b
  JOIN bids AS bd ON bd.bidder_id = b.id
  GROUP BY b.name
  ORDER BY count(bd.bidder_id) DESC
  LIMIT 1;

-- Use a scalar subquery to determine the number of bids on each item
-- Return a table with the name of each item along with the number of bids

SELECT items.name,
  (SELECT count(bids.item_id) FROM bids WHERE items.id = bids.item_id)
FROM items;

-- Use a row constructor to find the id for the item that matches all the given data:
-- 'Painting', 100.00, 250.00

SELECT id FROM items WHERE
  (name, initial_price, sales_price) = ('Painting', 100.00, 250.00);
