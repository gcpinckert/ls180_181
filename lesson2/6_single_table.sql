/* Working with a Single Table Practice Problems */

/* Write an SQL statement that will create the following table, then insert the data shown

name	    \ age	\ occupation
----------------------------
Abby	    \ 34	\ biologist
Mu'nisah	\ 26	\ NULL
Mirabelle	\ 40	\ contractor */

CREATE TABLE people (
  name varchar(20) NOT NULL,
  age integer,
  occupation varchar(20)
);

INSERT INTO people (name, age, occupation)
VALUES             ('Abby', 34, 'biologist'),
                   ('Mu''nisah', 26, NULL),
                   ('Mirabelle', 40, contractor);

/* Write 3 queries that can be used to retireve the second row of the table */

SELECT * FROM people
  LIMIT 1 OFFSET 1;

SELECT * FROM people
  WHERE name = 'Mu''nisah';

SELECT * FROM people
  WHERE occupation IS NULL;

/* Create the following table called birds, then insert the data shown:

name	            \ length  \ wingspan \ family	       \ extinct
-----------------------------------------------------------------
Spotted Towhee	  \ 21.6	  \ 26.7	   \ Emberizidae	 \ f
American Robin	  \ 25.5	  \ 36.0	   \ Turdidae	     \ f
Greater Koa Finch	\ 19.0	  \ 24.0	   \ Fringillidae	 \ t
Carolina Parakeet	\ 33.0	  \ 55.8	   \ Psittacidae	 \ t
Common Kestrel	  \ 35.5	  \ 73.5	   \ Falconidae	   \ f        */

CREATE TABLE birds (
  name varchar(50) NOT NULL,
  length decimal(3, 1),
  wingspan decimal(3, 1),
  family varchar(50),
  extinct boolean
);

INSERT INTO birds (name, length, wingspan, family, extinct)
VALUES            ('Spotted Towhee', 21.6, 26.7, 'Emberizidae', false),
                  ('American Robin', 25.5, 36.0, 'Turdidae', false),
                  ('Greater Koa Finch', 19, 24, 'Fringillidea', true),
                  ('Carolina Parakeet', 33, 55.8, 'Psittacidae', true),
                  ('Common Kestrel', 35.5, 73.5, 'Falconidae', false);

/* Find the name and families for all birds that are not extinct, in order from longest to shortest length */

SELECT name, family FROM birds
  WHERE extinct = false
  ORDER BY length DESC;

/* Determine the average, minimum, and maximum wingspan for the birds in the table */

SELECT avg(wingspan) FROM birds; -- 43.2

SELECT min(wingspan) FROM birds; -- 24.0

SELECT max(wingspan) FROM birds; -- 73.5

/* Create the given table as menu_items and then insert the data shown:

   item   \ prep_time \ ingredient_cost \ sales \ menu_price
----------+-----------+-----------------+-------+------------
 omelette \        10 \            1.50 \   182 \       7.99
 tacos    \         5 \            2.00 \   254 \       8.99
 oatmeal  \         1 \            0.50 \    79 \       5.99  */

CREATE TABLE menu_items (
    item varchar(50),
    prep_time integer,
    ingredient_cost numeric(3,2),
    sales integer,
    menu_price numeric(3,2)
);

INSERT INTO menu_items 
  VALUES    ('omelette', 10, 1.50, 182, 7.99),
            ('tacos', 5, 2.00, 254, 8.99),
            ('oatmeal', 1, 0.50, 79, 5.99);

/* Determine which menu item is the most profitable based on the cost of its ingrediants, and return the name of the item and its profit */

SELECT item, (menu_price - ingredient_cost) AS profit FROM menu_items
  ORDER BY profit DESC
  LIMIT 1;

/*  item  | profit
  -------+--------
  tacos |   6.99   */

/* Determine how profitable each item on the menu is based on the amount of time it takes to prepare one item. 
  - Assume whoever is preparing the food gets $13/hour
  - List the most profitable items first
  - `prep_time` is represented in minutes
  - `ingrediant_cost` and `menu_price` are in dollars and cents */

SELECT item, menu_price, ingredient_cost,
       round(prep_time/60.0 * 13.0, 2) AS labor,
       menu_price - ingredient_cost - round(prep_time/60.0 * 13.0, 2) AS profit
  FROM menu_items
  ORDER BY profit DESC;

--  item   | menu_price | ingredient_cost | labor | profit
-- ----------+------------+-----------------+-------+--------
--  tacos    |       8.99 |            2.00 |  1.08 |   5.91
--  oatmeal  |       5.99 |            0.50 |  0.22 |   5.27
--  omelette |       7.99 |            1.50 |  2.17 |   4.32
