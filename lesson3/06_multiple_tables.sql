/* WORKING WITH MULTIPLE TABLES */

/* 2. Determine how many tickets have been sold */

SELECT count(id) FROM tickets;

/* 3. Determine how many different customer purchased tickets to at least one event */

SELECT count(DISTINCT customer_id) FROM tickets;

/* 4. Determine what percentage of the customers have purchased a ticket to one or more of the events */

SELECT round((count(DISTINCT t.customer_id) / count(DISTINCT c.id)::decimal) * 100, 2) AS percent 
  FROM customers AS c LEFT OUTER JOIN tickets AS t
  ON t.customer_id = c.id;

/* 5. Return the name of each event and how many tickets were sold for it, in order from most to least popular */

SELECT e.name, count(t.id) AS popularity
  FROM tickets AS t INNER JOIN events AS e ON t.event_id = e.id 
  GROUP BY e.id 
  ORDER BY popularity DESC;

/* 6. Return the user id, email, and number of events for all customers that have purchased tickets to three events */

SELECT c.id, c.email, count(DISTINCT t.event_id) FROM customers AS c
  LEFT OUTER JOIN tickets AS t ON t.customer_id = c.id
  GROUP BY c.id
  HAVING count(DISTINCT t.event_id) = 3;

/* Note that normally GROUP BY has a requirement that all columns are specified when using an aggregate function such as count. However, this requirement can be ignored as long as the GROUP BY clause is applied to the table's primary key */

/* 7. Return a report of all tickets purchased by the customer with the email address gennaro.rath@mcdermott.co. This should include the vent name and the time the event starts as well as the seat's section name, row and seat number. */

SELECT e.name AS event, e.starts_at, sc.name AS section, st.row, st.number AS seat
  FROM tickets AS t
  INNER JOIN events AS e ON t.event_id = e.id
  INNER JOIN seats AS st ON t.seat_id = st.id
  INNER JOIN sections AS sc ON st.section_id = sc.id
  INNER JOIN customers AS c ON t.customer_id = c.id
  WHERE c.email = 'gennaro.rath@mcdermott.co';
