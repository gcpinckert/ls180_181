# Levels of Schema

It's a good idea to be aware of what level of abstraction you are working with at any given point in a database diagram. There are three levels of _schema_ that help us drill down into different levels of abstraction.

- **Conceptual** - high level
- **Logical** - middle level
- **Physical** - low level

## Conceptual Schema

**Conceptual Schema** has a high level of abstraction. It is concerned with entities and their relationships, abstracting away all the lower level details of the data sets associated with each entity. A diagram that represents only the entities involved in a system and their relationships (such as an ERD) is a conceptual schema.

For example:

```
employees                             projects
+---------------+           +---------------+
|               |<----+--+->|               |
|               |           |               |
| employees     |           | projects      |
|               |           |               |
|               |<-+        |               |
+---------------+  |        +---------------+
                   |
+---------------+  |
| departments   |<-+
|               |
+---------------+
```

## Physical Schema

**Physical Schema** has a lower level of abstraction. It focuses on database specific design elements that consist of the conceptual schema's implementation. A physical schema will include details about the data sets associated with each entity in the system, such as column names, data types, and where primary key, foreign key, and not null constraints are placed.

While in a conceptual schema we are just concerned with how entities relate, in a physical schema, we want to make sure that the link between relations is shown in a way that demonstrates which columns represent that relationship.

For example:

```
employees                             projects
+---------------+---------+           +---------------+---------+
| id            | int     |<----+  +->| id            | int     |
| first_name    | varchar |     |  |  | title         | varchar |
| last_name     | varchar |     |  |  | start_date    | date    |
| salary        | int     |     |  |  | end_date      | date    |
| department_id | int     |--+  |  |  | budget        | int     |
+---------------+---------+  |  |  |  +---------------+---------+
                             |  |  |
departments                  |  |  |  employees_projects
+---------------+---------+  |  |  |  +---------------+---------+
| id            | int     |<-+  |  +--| project_id    | int     |
| name          | varchar |     +-----| employee_id   | int     |
+---------------+---------+           +---------------+---------+
```

Above, we have four tables, `employees`, `projects`, `departments`, and the join table `employees_projects`. We can see the column name and data type for each table.

Based on the diagram, we can see that there is a one-to-many relationship between `departments` and `employees` which is represented by the link between `employees.department_id` and `departments.id`. We can also see that there is a many-to-many relationship between `employees` and `projects`, which is represented by the join table `employees_projects`. The join table consists of two foreign key columns that link back to the primary key columns of both `employees` and `projects`.