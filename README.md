# Database Foundations

How to think about data in a relational way, and how to interact with relational databases using SQL.

## Study Guide

### SQL

- [SQL Facts](./study_guide/sql.md)
  - [General Characteristics](./study_guide/sql.md#general-characteristics)
  - [Syntax](./study_guide/sql.md#syntax)
  - [Sublanguages](./study_guide/sql.md#sublanguages)
    - [DDL](./study_guide/sql.md#ddl)
    - [DML](./study_guide/sql.md#dml)
    - [DCL](./study_guide/sql.md#dcl)
- [Example SQL Statements](./study_guide/sql_statements.md)
  - [CREATE](./study_guide/sql_statements.md#create)
  - [ALTER](./study_guide/sql_statements.md#alter)
    - [Adding and Removing Constraints](./study_guide/sql_statements.md#adding-and-removing-constraints)
  - [DROP](./study_guide/sql_statements.md#drop)
  - [INSERT](./study_guide/sql_statements.md#insert)
  - [SELECT](./study_guide/sql_statements.md#select)
    - [WHERE](./study_guide/sql_statements.md#where)
    - [GROUP BY](./study_guide/sql_statements.md#group-by)
    - [HAVING](./study_guide/sql_statements.md#having)
    - [ORDER BY](./study_guide/sql_statements.md#order-by)
    - [LIMIT and OFFSET](./study_guide/sql_statements.md#limit-and-offset)
  - [UPDATE](./study_guide/sql_statements.md#update)
  - [DELETE](./study_guide/sql_statements.md#delete)
- [JOINs](./study_guide/joins.md)
  - [What are JOINs?](./study_guide/joins.md#what-are-sql-joins)
  - [Aliasing](./study_guide/joins.md#aliasing)
  - [Types of JOINs](./study_guide/joins.md#types-of-joins)
    - [Inner Joins](./study_guide/joins.md#inner-joins)
    - [Left Outer Joins](./study_guide/joins.md#left-outer-joins)
    - [Right Outer Joins](./study_guide/joins.md#right-outer-joins)
    - [Full Joins](./study_guide/joins.md#full-joins)
    - [Cross Joins](./study_guide/joins.md)
- [Subqueries](./study_guide/subqueries.md)
  - [What are subqueries?](./study_guide/subqueries.md#what-are-subqueries)
  - [General Syntax](./study_guide/subqueries.md#general-syntax)
  - [Subquery Expressions](./study_guide/subqueries.md#subquery-expression-examples)
    - [IN](./study_guide/subqueries.md#in)
    - [NOT IN](./study_guide/subqueries.md#not-in)
    - [ANY and SOME](./study_guide/subqueries.md#any-and-some)
    - [ALL](./study_guide/subqueries.md#all)
    - [EXISTS](./study_guide/subqueries.md#exists)

To Do:

### PostgreSQL

- [ ] Describe what a sequence is and what they are used for
- [ ] Create an auto-incrementing column
- [ ] Define a default value for a column
- [ ] Be able to describe what primary, foreign, natural and surrogate keys are
- [ ] Create and remove `CHECK` constraints from a column
- [ ] Create and remove foreign key constraints from a column

### Database Diagrams

- [ ] Talk about the different levels of schema
- [ ] Define cardinality and modality
- [ ] Be able to draw database diagrams using crow's foot notation
