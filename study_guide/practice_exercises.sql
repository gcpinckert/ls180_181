/* The following file is a times practice run through of the exercises in the SQL Fundamentals M2M Exercises

Run it with the safe-run-sql() command on the CLI for most efficient functioning. */

/* Database set up 

-- Data for the customers table

id | name          | payment_token
--------------------------------
1  | Pat Johnson   | XHGOAHEQ
2  | Nancy Monreal | JKWQPJKL
3  | Lynn Blake    | KLZXWEEE
4  | Chen Ke-Hua   | KWETYCVX
5  | Scott Lakso   | UUEAPQPS
6  | Jim Pornot    | XKJEYAZA

-- Data for the services table

id | description         | price
---------------------------------
1  | Unix Hosting        | 5.95
2  | DNS                 | 4.95
3  | Whois Registration  | 1.95
4  | High Bandwidth      | 15.00
5  | Business Support    | 250.00
6  | Dedicated Hosting   | 50.00
7  | Bulk Email          | 250.00
8  | One-to-one Training | 999.00 

-- customers table
  - id primary key
  - name text cannot be null
  - payment_token 8 chars only uppercase alphanumeric must be unique cannot be null

-- services
  - id primary key
  - description text cannot be null
  - price numeric(10,2) cannot be null must be >= 0 */

-- Create the customers and services table
CREATE TABLE customers (
  id serial PRIMARY KEY,
  name text NOT NULL,
  payment_token char(8) UNIQUE NOT NULL CHECK (payment_token SIMILAR TO '[A-Z]{8}')
);

CREATE TABLE services (
  id serial PRIMARY KEY,
  description text NOT NULL,
  price numeric(10,2) NOT NULL CHECK (price >= 0.0)
);

-- Insert data for customers

INSERT INTO customers (name, payment_token)
  VALUES ('Pat Johnson', 'XHGOAHEQ'),
         ('Nancy Monreal', 'JKWQPJKL'),
         ('Lynn Blake', 'KLZXWEEE'),
         ('Chen Ke-Hua', 'KWETYCVX'),
         ('Scott Lakso', 'UUEAPQPS'),
         ('Jim Pornot', 'XKJEYAZA');

-- Insert data for services

INSERT INTO services (description, price)
  VALUES ('Unix Hosting', 5.95),
         ('DNS', 4.95),
         ('Whois Registration', 1.95),
         ('High Bandwidth', 15),
         ('Business Support', 250),
         ('Dedicated Hosting', 50),
         ('Bulk Email', 250),
         ('One-to-one Training', 999);

-- Create a join table to associate customers with services
-- Ensure that deleting a customer record also deletes corresponding records here
-- This should not be in effect for service records

CREATE TABLE customers_services (
  id serial PRIMARY KEY,
  customer_id integer NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  services_id integer NOT NULL REFERENCES services(id),
  UNIQUE (customer_id, services_id)
);

-- Enter data into join table

INSERT INTO customers_services (customer_id, services_id)
  VALUES (1, 1),
         (1, 2),
         (1, 3),
         (3, 2),
         (3, 1),
         (3, 3),
         (3, 4),
         (3, 5),
         (4, 1),
         (4, 4),
         (5, 1),
         (5, 2),
         (5, 6),
         (6, 1),
         (6, 6),
         (6, 7);

-- Retrieve the customer data for every customer who subscribes to at least one service

SELECT DISTINCT customers.* FROM customers
  INNER JOIN customers_services ON customers_services.customer_id = customers.id;

SELECT customers.* FROM customers
  INNER JOIN customers_services ON customers_services.customer_id = customers.id
  GROUP BY customers.id;

-- Retrieve the customer data for customer that do NOT subscribe to any services

SELECT customers.* FROM customers
  WHERE customers.id NOT IN (SELECT customers_services.customer_id FROM customers_services);

-- Retrieve all customers with no services and all services with no customers

SELECT c.*, s.* FROM customers AS c
  FULL OUTER JOIN customers_services AS cs ON cs.customer_id = c.id
  FULL OUTER JOIN services AS s ON cs.services_id = s.id
  WHERE cs.customer_id IS NULL OR cs.services_id IS NULL;

-- Display a list of all services not currently in use:

SELECT description FROM services
  WHERE id NOT IN (SELECT services_id FROM customers_services);

-- Do the same thing with a right outer join

SELECT s.description FROM customers_services AS cs
  RIGHT OUTER JOIN services AS s ON cs.services_id = s.id
  WHERE cs.customer_id IS NULL;

-- Display all customer names togehter with a comma separated list of services they use

SELECT c.name, string_agg(s.description, ', ') FROM customers AS c
  LEFT OUTER JOIN customers_services AS cs ON cs.customer_id = c.id
  LEFT OUTER JOIN services AS s ON cs.services_id = s.id
  GROUP BY c.name;

-- Display the description for every service that is subscribed to by at least 3 customers, and include the customer count

SELECT s.description, count(c.id) FROM services AS s
  JOIN customers_services AS cs ON cs.services_id = s.id
  JOIN customers AS c ON cs.customer_id = c.id
  GROUP BY s.id HAVING count(c.id) > 2;

-- Compute the total gross income we expect to recieve

SELECT sum(s.price) AS "gross" FROM services AS s
  JOIN customers_services AS cs ON cs.services_id = s.id;

-- Add the new customer and his relevant data to the database

INSERT INTO customers (name, payment_token)
  VALUES ('John Doe', 'EYODHLCN');

INSERT INTO customers_services (customer_id, services_id)
  VALUES (7, 1), (7, 2), (7, 3);

-- Report the current expected income level of all services that cost more than 100

SELECT sum(s.price) FROM services AS s
  JOIN customers_services AS cs ON cs.services_id = s.id
  WHERE s.price > 100;

-- Report the hypothetical maximum income level if all customers purchased all services that cost more than 100

SELECT sum(s.price) FROM services AS s
  CROSS JOIN customers
  WHERE s.price > 100;

-- Delete Bulk Email service and Chen Ke-Hua

DELETE FROM customers WHERE name = 'Chen Ke-Hua';

ALTER TABLE customers_services
  DROP CONSTRAINT "customers_services_services_id_fkey";

ALTER TABLE customers_services
  ADD CONSTRAINT "customers_services_services_id_fkey"
  FOREIGN KEY (services_id) REFERENCES services(id) ON DELETE CASCADE;

DELETE FROM services WHERE description = 'Bulk Email';