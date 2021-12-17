# Assignment 2 Practice Problems

## What kind of programming language is SQL?

SQL is a **declarative language**, meaning that instead of describing how to do something it states _what_ must be done. For example, an SQL statement might tell us that we are "selecting" or "inserting" something, but the mechanisms by which the data is selected and returned, or inserted into the database, is abstracted away within the SQL engine.

SQL is also a **special purpose** language, meaning that it is reserved for a particular purpose, unlike more general purposed programming languages like Ruby, C, or JavaScript, which can be used to accomplish many different kinds of things. SQL is reserved for _manipulating and interacting with data inside of a relational database_.

## What are the three sub-languages of SQL?

The three sub-languages of SQL are:

- **DDL** or **Data Definition Language** which is used to define the _schema_ or the rules defining the structure (i.e. tables and columns) of data within a relational database.
- **DML** or **Data Manipulation Language** which is used to manipulate and interact with the _data_ or the specific values being stored within a relational database.
- **DCL** of **Data Control Language** which is used to change permissions around the different users who might need to interact with a relational database.

## Write the following values as quoted string values that could be used in an SQL query:

```
canoe
a long road
weren't
"No way!"
```

```sql
'canoe'
'a long road'
'weren''t'
'"No Way!"'
```

## What operator is used to concatenate strings?

SQL uses double pipes `||` for string concatenation.

For example:

```sql
'Hello' || ' World'
-- returns 'Hello World'
```

## What function returns a lowercased version of a string?

We use the function `lower(str)` to convert a string to lowercase.

For example:

```sql
lower('HELLO')
-- returns 'hello'

SELECT lower('PLEASE QUIET DOWN');
/*        lower
  -------------------
  please quiet down
  (1 row) */
```

## How does the psql console display true and false values?

The `psql` console will display true and false values as an abbreviation, `t` for true and `f` for false. For example:

```sql
-- given a table with column 'enabled' that contains either true or false values

SELECT enabled FROM my_table;

/* enabled
  ---------
  t
  f
  t
  f
  t
  t
  (6 rows) */
```

## Spheres

The surface area of a sphere is calculated using the formula `A = 4π r2`, where `A` is the surface area and `r` is the radius of the sphere.

Use SQL to compute the surface area of a sphere with a radius of 26.3cm, truncated to return an integer.

