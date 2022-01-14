/* SUBQUERIES AND MORE EXERCISES */

/* System Notes:
  - This set of excersies will focus on an auction.
  - The database will have three relations: bidders, items, and bids
  - It will rely on the three .csv files to import necessary data
*/

CREATE DATABASE auction;

-- /c auction to connect to database

CREATE TABLE bidders (
  id serial PRIMARY KEY,
  name text NOT NULL
);

CREATE TABLE items (
  id serial PRIMARY KEY,
  name text NOT NULL,
  initial_price numeric(6, 2) NOT NULL,
  sales_price numeric(6, 2)
);

CREATE TABLE bids (
  id serial PRIMARY KEY,
  bidder_id integer NOT NULL REFERENCES bidders(id) ON DELETE CASCADE,
  item_id integer NOT NULL REFERENCES items(id) ON DELETE CASCADE,
  amount numeric(6, 2) NOT NULL
);

CREATE INDEX ON bids (bidder_id, item_id);

/* Copy data from csv files to each table

\copy bidders FROM './exercises/bidders.csv' WITH HEADER CSV;
\copy items FROM './exercises/items.csv' WITH HEADER CSV;
\copy bids FROM './exercises/bids.csv' WITH HEADER CSV;

Note that the relative path from root ls180_181 folder is used */

/* Condtional Subqueries: IN
  - Return all the items that have bids put on them
*/

SELECT name AS "Bid on Items" FROM items WHERE id IN
  (SELECT DISTINCT item_id FROM bids);

/* Conditional Subqueries: NOT IN
  - Return a list of all items that have not had bids put on them
*/

SELECT name AS "Not Bid On" FROM items WHERE id NOT IN
  (SELECT DISTINCT item_id FROM bids);

/* Conditional Subqueries: EXISTS
  - Return a list of names of everyone who has bid in the auction
*/

SELECT name FROM bidders WHERE EXISTS
  (SELECT DISTINCT bidder_id FROM bids WHERE bids.bidder_id = bidders.id);

-- Use a JOIN clause to get the same output

SELECT DISTINCT p.name FROM bidders AS p
  INNER JOIN bids AS b ON p.id = b.bidder_id;

/* Query from a Virtual Table
  - Build the WHERE clause filtering into a virtual table we will query
  - Return the largest number of bids from an individual bidder
  - First, use a subquery to generate a result table
  - Next, query that table for the largest number of bids
*/

SELECT max(count) FROM
  (SELECT count(id) FROM bids
   GROUP BY bidder_id) AS "number of bids";

-- First we use a subquery to generate a count of all the times a bidder row has bid
-- Second we use the aggregate function max to dind the maximum value from the bid counts column

/* Scalar Subqueries
  - Use a scalar subquery to determine the number of bids on each item
  - Return a table that has the name of each item along with the number of bids
*/

SELECT name, 
  (SELECT count(item_id) FROM bids WHERE bids.item_id = items.id)
FROM ITEMS;

-- First the subquery counts the number of bids on a particular item where the item_id is equal to the current items.id.
-- For each item in the outer SELECT, items.id will equal the current id value from that outer SELECT
-- Basically, we are querying another table and associating that tables data with another table based on a foreign key

-- Get the same results with a LEFT OUTER JOIN

SELECT i.name, count(b.item_id) FROM items AS i
  LEFT OUTER JOIN bids AS b ON b.item_id = i.id
  GROUP BY i.name;

/* Row Comparison
  - Display the id for the item that matches all the given data
  - Do not use the AND keyword
*/

SELECT id FROM items
  WHERE row(name, initial_price, sales_price) = row('Painting', 100.00, 250.00);

-- First, we use the keyword ROW to construct two virtual rows: one that contains the given data and the other that represents data for each row in the table.
-- Virtual rows are copares using the = operator
-- When the condition is met, we return the associated id with that record

/* EXPLAIN
  - Check the efficiency of the query statement we used that utilizes EXISTS
  - First, just use EXPLAIN
  - Next, include the ANALYZE option as well
  - List the output you get back by each statement
*/

EXPLAIN SELECT name FROM bidders WHERE EXISTS
  (SELECT DISTINCT bidder_id FROM bids WHERE bids.bidder_id = bidders.id);
/*
                                QUERY PLAN
--------------------------------------------------------------------------
 Hash Join  (cost=33.38..66.47 rows=635 width=32)
   Hash Cond: (bidders.id = bids.bidder_id)
   ->  Seq Scan on bidders  (cost=0.00..22.70 rows=1270 width=36)
   ->  Hash  (cost=30.88..30.88 rows=200 width=4)
         ->  HashAggregate  (cost=28.88..30.88 rows=200 width=4)
               Group Key: bids.bidder_id
               ->  Seq Scan on bids  (cost=0.00..25.10 rows=1510 width=4)
(7 rows)
*/
/*
  - The above output shows us a total of four nodes
  - The first node consists of a Hash Join and will have a total cost of 66.47, with an expected output of 635 rows
  - The second node consists of a sequential scan on bidders, with a total cost of 22.7 and an expected output of 1270 rows
  - The third node consists of a Hash with a total cost of 30.88 and an expected output of 200 rows
  - The fourth node consists of a Hash aggregate with a total cost of 30.88 and an expected output of 300 rows
  - The fifth node consists of another sequential scan on bids with a total cost of 25.1 and an expected output of 1510 rows
*/

EXPLAIN ANALYZE SELECT name FROM bidders WHERE EXISTS
  (SELECT DISTINCT bidder_id FROM bids WHERE bids.bidder_id = bidders.id);
/*
                                                     QUERY PLAN
---------------------------------------------------------------------------------------------------------------------
 Hash Join  (cost=33.38..66.47 rows=635 width=32) (actual time=0.038..0.041 rows=6 loops=1)
   Hash Cond: (bidders.id = bids.bidder_id)
   ->  Seq Scan on bidders  (cost=0.00..22.70 rows=1270 width=36) (actual time=0.012..0.013 rows=7 loops=1)
   ->  Hash  (cost=30.88..30.88 rows=200 width=4) (actual time=0.021..0.021 rows=6 loops=1)
         Buckets: 1024  Batches: 1  Memory Usage: 9kB
         ->  HashAggregate  (cost=28.88..30.88 rows=200 width=4) (actual time=0.018..0.020 rows=6 loops=1)
               Group Key: bids.bidder_id
               ->  Seq Scan on bids  (cost=0.00..25.10 rows=1510 width=4) (actual time=0.005..0.007 rows=26 loops=1)
 Planning Time: 0.136 ms
 Execution Time: 0.102 ms
(10 rows)

-- The above query plan consists of the same data from the EXPLAIN expression above alongside with the data pertaining to the actual performance to the proposed plan. It also contains the total planning time and total execution time.

/* Comparing SQL Statements
  - Use EXPLAIN ANALYZE to compare the efficiency of two SQL statements
*/

-- Statement 1: with subqueries
EXPLAIN ANALYZE SELECT MAX(bid_counts.count) FROM
  (SELECT COUNT(bidder_id) FROM bids GROUP BY bidder_id) AS bid_counts;
/*
                                                  QUERY PLAN
---------------------------------------------------------------------------------------------------------------
 Aggregate  (cost=37.15..37.16 rows=1 width=8) (actual time=0.030..0.031 rows=1 loops=1)
   ->  HashAggregate  (cost=32.65..34.65 rows=200 width=12) (actual time=0.026..0.028 rows=6 loops=1)
         Group Key: bids.bidder_id
         ->  Seq Scan on bids  (cost=0.00..25.10 rows=1510 width=4) (actual time=0.010..0.012 rows=26 loops=1)
 Planning Time: 0.090 ms
 Execution Time: 0.069 ms
(6 rows)
*/
-- Statement 2: without subqueries
EXPLAIN ANALYZE SELECT COUNT(bidder_id) AS max_bid FROM bids
  GROUP BY bidder_id
  ORDER BY max_bid DESC
  LIMIT 1;
/*                                                      QUERY PLAN
---------------------------------------------------------------------------------------------------------------------
 Limit  (cost=35.65..35.65 rows=1 width=12) (actual time=0.034..0.036 rows=1 loops=1)
   ->  Sort  (cost=35.65..36.15 rows=200 width=12) (actual time=0.033..0.034 rows=1 loops=1)
         Sort Key: (count(bidder_id)) DESC
         Sort Method: top-N heapsort  Memory: 25kB
         ->  HashAggregate  (cost=32.65..34.65 rows=200 width=12) (actual time=0.019..0.020 rows=6 loops=1)
               Group Key: bidder_id
               ->  Seq Scan on bids  (cost=0.00..25.10 rows=1510 width=4) (actual time=0.006..0.007 rows=26 loops=1)
 Planning Time: 0.104 ms
 Execution Time: 0.066 ms
(9 rows)
*/

-- From the two query plans above, we can see that statement 1 is more efficient than statement 2
-- It contains less nodes (3 compared to 4)
-- It also has less demand on CPU and memory as no sort operatins are performed


-- Compare the scalar subquery with an equivalent join clause
EXPLAIN ANALYZE SELECT name,
  (SELECT COUNT(item_id) FROM bids WHERE item_id = items.id)
FROM items;
/*
                                                 QUERY PLAN
-------------------------------------------------------------------------------------------------------------
 Seq Scan on items  (cost=0.00..25455.20 rows=880 width=40) (actual time=0.023..0.037 rows=6 loops=1)
   SubPlan 1
     ->  Aggregate  (cost=28.89..28.91 rows=1 width=8) (actual time=0.004..0.004 rows=1 loops=6)
           ->  Seq Scan on bids  (cost=0.00..28.88 rows=8 width=4) (actual time=0.002..0.003 rows=4 loops=6)
                 Filter: (item_id = items.id)
                 Rows Removed by Filter: 22
 Planning Time: 0.100 ms
 Execution Time: 0.067 ms
(8 rows)
*/
EXPLAIN ANALYZE SELECT i.name, count(b.item_id) FROM items AS i
  LEFT OUTER JOIN bids AS b ON b.item_id = i.id
  GROUP BY i.name;
/*
                                                      QUERY PLAN
-----------------------------------------------------------------------------------------------------------------------
 HashAggregate  (cost=66.44..68.44 rows=200 width=40) (actual time=0.045..0.048 rows=6 loops=1)
   Group Key: i.name
   ->  Hash Right Join  (cost=29.80..58.89 rows=1510 width=36) (actual time=0.027..0.036 rows=27 loops=1)
         Hash Cond: (b.item_id = i.id)
         ->  Seq Scan on bids b  (cost=0.00..25.10 rows=1510 width=4) (actual time=0.003..0.005 rows=26 loops=1)
         ->  Hash  (cost=18.80..18.80 rows=880 width=36) (actual time=0.019..0.019 rows=6 loops=1)
               Buckets: 1024  Batches: 1  Memory Usage: 9kB
               ->  Seq Scan on items i  (cost=0.00..18.80 rows=880 width=36) (actual time=0.014..0.015 rows=6 loops=1)
 Planning Time: 0.166 ms
 Execution Time: 0.089 ms
(10 rows)
*/
