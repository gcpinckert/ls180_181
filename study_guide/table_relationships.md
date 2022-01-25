# Table Relationships

## Normalization and Database Design

We can help reduce redundancy and improve data integrity in our databases by using **normalization**, which is implemented by arranging data into multiple tables and defining relationships between those tables.

First, we define _entities_, which are abstractions that represent a real world object. Each of these objects will consist of a set of data to be stored as a table in the database. For example, if the system to be modeled is that of an employee management system, we might have tables for employees, projects, departments, etc.

Once each entity is defined, we can plan the tables to store data for each entity. In our example, we might store the name and contact information for each employee in a table called `employees`, information regarding the dealines, budget, and who is involved with each project in `projects`, and the name and workers in each `department`.

As you can see, there are areas of each table that relate to other tables. We can use the relationships between entities (such as "an employee is a member of a department") to model the relationships between tables, including any specific rules that pertain to how those relationships work.

We can use an _Entity Relationship Diagram_ or _ERD_ to graphically represent the system as a whole and the relationsips within it.

Relationships between entities are implemented in a database through the use of primary and foreign keys. All tables have a primary key column that can uniquely identify a record on that table. We can use a foreign key column in another table to reference values in the primary key column of the first table, and this representing a relationship between the two records.

## One to One

In a one to one relationship between entities, there can be only one instance of each entity on either side of the relationship. These are a bit rare in the real world, but imagine something like a social security number. A person can only have one social security number, and a social security number can only be associated with a single person.

A one-to-one relationship is implemented by associating two _primary key_ columns. Because a primary key must be unique, this constraint ensures that more than one entity instance is not assigned to an entity instance on either side of the relationship. Basically, we use the values from the primary key column of one entity in a column that assigned as _both_ the foreign key and primary key column of another table.

Note that one-to-one relationships are rare, and usually running into a one-to-one relationship means that those entities should be stored in the same table or "folded into each other". For example, here, we might include `social security number` as a column in a table called `persons`.

## One to Many

A one-to-many relationship is one in which a record in one table can be associated with multiple records in another table, but the second record can only accept one association each. For example, a storage unit may contain many items, but an item can only be stored in one storage unit.

We implement a one-to-many relationship by assigning a foreign key column in the "many" entity table set to reference the primary key column of the "one" entity table. This way, we can associate as many records as we want on the "many" side with individual records on the "one" side, but not vice versa.

## Many to Many

A many-to-many relationship describes one in which for each record being associated in one table, there may be multiple records linked to it in the other table and vice versa.

To implement a many-to-many relationship, we need to define a third and separate cross referencing table. Records in this table represent instances of each _relationship_ between the other entities being associated. It usually contains a primary key (which uniquely identities each record of a relationship), and two foreign keys, one to reference a primary key in each table that is being linked.

Additional columns in the cross-referencing table might add additional context to the relationship between the two related entities, but not to either entity itself.
