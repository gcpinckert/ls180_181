# PostgreSQL Examples

## How does PostgreSQL process a query

There is a certain order that the PostgreSQL server will take when executing a the steps of a query. Below is an example of what this looks like with `SELECT`.

1. **Create a virtual table** - The server takes _all_ the data from all the tables listen in the `FROM` clause, including data in any tables that are `JOIN`ed and creates an ephemeral "virtual" table.
2. **Filtering data** - Any conditions that are specified with a `WHERE` clause are used to remove rows from the virtual tables that do not meet the specified condition(s)
3. **Grouping data** - Records that pass the condition are "grouped" according to any categories specified in a `GROUP BY` clause.
4. **Filtering groups of data** - Any conditions that are specified in a `HAVING` clause are used to remove groups (instead of individual rows) that do not meet the specified condition.
5. **Evaluate Select List** - All identifiers and expressions (including functions) specified in the `SELECT` list are evaluated. The resulting values are associated with either the name of a column, function, or custom name otherwise specified with _aliasing_.
6. **Sorting** - If an `ORDER BY` clause is included, the resulting records are sorted according to the given criteria.
7. **Limiting** - Any `LIMIT` or `OFFSET` clauses determine which rows from the result set are returned.

## Make an autoincrementing column

To make an auto-incrementing column we have to use the PostgreSQL datatype `serial`. `serial` implicitly creates a [sequence](./sequences.md) and the assigns a default value of `nextval()` to the column in question.

For example, let's say we are creating a table `users` that keeps track of usernames. As per convention, we'd want to ensure that we have a **primary key** column for this table called `id`. `id` should always utilize a datatype that automatically generates a unique identifier for the default value, such as `serial`. Therefore we can create the table like this:

```sql
CREATE TABLE users (
  id serial PRIMARY KEY,
  name text NOT NULL
);
```

What `serial` does behind the scenes is effectively this:

```sql
CREATE SEQUENCE users_id_sequence;

CREATE TABLE users (
  id integer NOT NULL DEFAULT nextval('users_id_sequence'),
  name text NOT NULL
);
```

This is why when we look at all the relations in a database after creating a table with a column of datatype `serial`, we will see a new sequence represented too:

```
study_guide=# \d
                   List of relations
 Schema |         Name         |   Type   |   Owner
--------+----------------------+----------+------------
 public | users                | table    | gcpinckert
 public | users_id_seq         | sequence | gcpinckert
(2 rows)
```

Note that above we specify the `PRIMARY KEY` constraint with the `id` column even though the `serial` datatype has an implicit `NOT NULL` requirement, because it signals our intention to use the column as a unique identifier for the table's records.

## Define a default value for a column

To define a default value for a column we use the keyword `DEFAULT`. Doing so allows us to protect data from `NULL` values creeping in, which can cause issues with sorting, calculations, and any operations involving conditional operators. It's usually better to assign some kind of _value to represent nothing_ (such as `0`) rather than rely on utilizing a `NULL` value itself.

One thing to be aware of is that if you already have data within a table, you cannot set any column to `NOT NULL` that already has a `NULL` value stored in it. Therefore, it is usually a good idea to set up any `DEFAULT` value implementation during the table creation phase, so this does not occur.

Whenever you set a `NOT NULL` constraint on a column, you should specify a `DEFAULT` value to prevent errors from occurring. Also, ensure that any default values you set are not in conflict with an existing constraint, such as a `CHECK`. If you set a constraint that checks to see if some value must be greater than `0`, you cannot set a default value of `0` for that column, as this will raise an error.

There are a few ways to set a `DEFAULT` value:

```sql
-- During table creation
CREATE TABLE users (
  id serial PRIMARY KEY,
  name text NOT NULL DEFAULT 'Jane Doe'
);

-- Assign a column constraint
ALTER TABLE users
  ALTER COLUMN name SET DEFAULT 'Jane Doe';
/*
                            Table "public.users"
 Column |  Type   | Collation | Nullable |              Default
--------+---------+-----------+----------+-----------------------------------
 id     | integer |           | not null | nextval('users_id_seq'::regclass)
 name   | text    |           | not null | 'Jane Doe'::text
Indexes:
    "users_pkey" PRIMARY KEY, btree (id) */
```

## Foreign Key Constraints

The term **foreign key** can reference two different things depending on context. It can be either a _constraint_ or a _column_. Logically, we typically apply a _foreign key constraint_ to a _foreign key column_.

A **foreign key column** represents a _relationship_ between records in two different tables. By storing a primary key value that uniquely identifies a record in another table, it links the record in its table with the record specified by the primary key.

A **foreign key constraint** enforces the rules that make a foreign key relationship have logical sense. For example, it ensures that any value stored in a foreign key column is actually represented as a primary key in the table specified on the other side of the relationship.

In order to create a foreign key column, all we have to do is ensure that the column has the same datatype as the primary key column we want to reference. In order to make sure that the integrity of this relationship stays in place, we need to apply the foreign key constraint with a `REFERENCES` clause. Like all constraints, this can be done during either during table creation or after a table already exists.

Let's say we have some data pertaining to items that are being stored in different storage units. We might define a foreign key column within the `items` table to link specific item records to the different storage units they are stored in.

```sql
-- First create the table you are going to reference with the foreign key
CREATE TABLE storage_units (
  id serial PRIMARY KEY,
  unit_number char(4) NOT NULL
);

-- Then create the table with the foreign key column + constraint
CREATE TABLE items (
  id serial PRIMARY KEY,
  description text NOT NULL,
  unit_id integer REFERENCES storage_units(id)
);

-- You can also add the constraint after the table already exists
ALTER TABLE items
  ADD CONSTRAINT items_unit_id_fkey
  FOREIGN KEY (unit_id) REFERENCES storage_units(id);
```

To remove foreign key constraints, we have to use `DROP CONSTRAINT` along with the name of the constraint.

```sql
ALTER TABLE items
  DROP CONSTRAINT items_unit_id_fkey;
```

This does not get rid of the column itself, but it _does_ get rid of the constraint. For example, we now have the ability to add values that are not represented in the primary key column of the `storage_units` table to the `units_id` column of the `items` table.
