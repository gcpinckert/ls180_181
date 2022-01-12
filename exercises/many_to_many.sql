/* MANY TO MANY EXERCISES */

/* System Notes: 
  - The database is the billing database for a company that provides web hosting.
  - Contains information about customers and the services each customer uses.
  - A customer can have any number of services (0 - infinity)
  - A service can have any number of customers (0 - infinity) */

CREATE DATABASE billing;

-- connect to billing database

CREATE TABLE customers (
  id serial PRIMARY KEY,
  name text NOT NULL,
  payment_token char(8) UNIQUE NOT NULL CHECK (payment_token SIMILAR TO '[A-Z]{8}')
);

CREATE TABLE services (
  id serial PRIMARY KEY,
  description text NOT NULL,
  price numeric(10,2) NOT NULL CHECK (price >= 0.00)
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

-- Create join table that associates customers with services and vice versa, including an id primary key for the relation

CREATE TABLE customers_services (
  id serial PRIMARY KEY,
  customer_id integer REFERENCES customers(id) ON DELETE CASCADE NOT NULL,
  service_id integer REFERENCES services(id) NOT NULL,
  UNIQUE(customer_id, service_id)
);

-- Enter data into join table

INSERT INTO customers_services (customer_id, service_id)
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

-- Retrieve the customer data for every customer who currently subscribes to at least one service

SELECT DISTINCT c.name, c.payment_token FROM customers AS C 
  INNER JOIN customers_services AS cs ON c.id = cs.customer_id;

-- Retrieve the customer data for every customer who does _not_ currently subscribe to any services

SELECT DISTINCT c.* FROM customers AS c
  LEFT OUTER JOIN customers_services AS cs ON c.id = cs.customer_id
  WHERE cs.service_id IS NULL;

-- Display all customers with no services and all services that have no customers

SELECT DISTINCT c.*, s.* FROM customers AS c
  FULL JOIN customers_services AS cs ON c.id = cs.customer_id
  FULL JOIN services AS s ON s.id = cs.service_id
  WHERE cs.service_id IS NULL OR cs.customer_id IS NULL;

-- Display a list of all services that are not currently in use. Use a RIGHT OUTER JOIN.

SELECT s.description FROM customers_services AS cs
  RIGHT OUTER JOIN services AS s ON cs.service_id = s.id
  WHERE cs.customer_id IS NULL;

-- Display a list of all customer names together with a comma-separated list of the services they use.

SELECT c.name, string_agg(s.description, ', ') AS services FROM customers AS c
  LEFT OUTER JOIN customers_services AS cs ON c.id = cs.customer_id
  LEFT OUTER JOIN services AS s ON s.id = cs.service_id
  GROUP BY c.name;

-- Display the description for every service that is subscribed to by at least 3 customers. Include the customer count.

SELECT s.description, count(cs.customer_id) FROM services AS s
  INNER JOIN customers_services AS cs ON s.id = cs.service_id
  GROUP BY s.id HAVING count(cs.customer_id) > 2;

-- Compute the total gross income we expect to recieve

SELECT sum(s.price) AS gross FROM services AS s
  INNER JOIN customers_services AS cs ON s.id = cs.service_id;

-- Add a new customer to the database

INSERT INTO customers (name, payment_token)
  VALUES ('John Doe', 'EYODHLCN');

SELECT * FROM customers WHERE name = 'John Doe';

INSERT INTO customers_services (customer_id, service_id)
  VALUES (7, 1),
         (7, 2),
         (7, 3);

-- Report the current expected income level for all services that cost more than $100

SELECT sum(s.price) FROM services AS s
  INNER JOIN customers_services AS cs ON s.id = cs.service_id
  WHERE s.price > 100;

-- Report the hypothetical maximum income if all customers subsribed to services that cost more than $100

SELECT sum(s.price) FROM customers
  CROSS JOIN services AS s
  WHERE s.price > 100;

-- Delete the bulk email service and the customer Chen Ke-Hua from the database

DELETE FROM customers_services WHERE service_id = 7;
DELETE FROM services WHERE description = 'Bulk Email';

DELETE FROM customers WHERE name = 'Chen Ke-Hua';
