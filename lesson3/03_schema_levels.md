# Database Diagrams: Levels of Schema

Practice Problems

1. In order of decreasing levels of abstraction (i.e. increasing levels of implementation details) the three levels of schema are conceptual, logical, and physical.

2. Conceptual schema is _a high-level design focused on identifying entities and their relationships_. It's concerned with bigger objects and higher-level concepts. It focuses purely on entities and how they relate, and does not concern itself with data or how this data will be stored.

3. A physical schema is _a low-level database specific design that is focused on the implementation of a conceptual schema_. It typically consists of descriptions of the actual tables within the database that we will use to represent the system. Some information that is usually included is the collective name of the entity, the column names (attributes for the entity in question), the column datatypes, as well as any specific constraints for column values such as primary key, foreign key, or NOT NULL. It may also show a line connecting two columns that consist of a relationship between tables.

4. Three types of relationships can be shown in a database diagram: one-to-one, one-to-many, and many-to-many.
