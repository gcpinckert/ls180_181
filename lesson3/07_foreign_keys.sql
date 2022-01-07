/* USING FOREIGN KEYS */

/* 2. Update the orders table so that the referential integrity will be preserved between orders and products. */

ALTER TABLE orders
ADD CONSTRAINT orders_product_id_fkey
FOREIGN kEY (product_id) REFERENCES products(id);

/* 3. Insert the given data into the database */

INSERT INTO products (name)
  VALUES ('small bolt'),
         ('large bolt');
INSERT INTO orders (product_id, quantity)
  VALUES (1, 10),
         (1, 25),
         (2, 15);

/* 4. Return the quantity ordered and product name for inserted data */

SELECT o.quantity, p.name FROM orders AS o
  INNER JOIN products AS p ON o.product_id = p.id;

/* 5. Insert a row into `orders` without a product id */

INSERT INTO orders (quantity) VALUES (12);

/* 6. Prevent NULL values from being stored in orders.product_id. */

-- First we have to get rid of the already existing null value to avoid an error
DELETE FROM orders WHERE product_id IS NULL;

-- Now we can add the NOT NULL constraint
ALTER TABLE orders ALTER COLUMN product_id SET NOT NULL;

/* 8. Create a new table called reviews to store the given data. It should include a primary key and a reference to products */

CREATE TABLE reviews (
  id serial PRIMARY KEY,
  product_id integer REFERENCES products(id) NOT NULL,
  review text
);

/* 9. Insert the given data */

INSERT INTO reviews (product_id, review)
  VALUES (1, 'a little small'),
         (2, 'very round!'),
         (2, 'could have been smaller');

/* 10. A foreign key constraint ALLOWS for NULL values in foreign key columns. If you wish to prevent NULL values in a foreign key column, you must also add a NOT NULL constraint */