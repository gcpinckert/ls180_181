# Cardinality and Modality

Table relationships exhibit two different traits: **cardinality** and **modality**.

**Cardinality** refers to the _number of entity instances_ on each side of a relationships. It tells us if a relationship is one-to-one, one-to-many, or many-to-many.

**Modality** refers to whether or not the relationship is mandatory or optional. If a relationship is required, there has to be at least one instance of that entity on that side of the relationship, so this is indicated with a modality of `1`. If a relationship is optional, there may be no instances of that entity on that side of the relationship, so this is indicated with a modality of `0`. For example, a book may exist without having any associated reviews (modality of `0`), but it does not make sense for a review to exist without an associated book (modality of `1`).

Understanding the _cardinality and modality_ of a relationship allows us to define the rules of how a database is going to operate. For example, a relation that has a modality of `1` might utilize a `NOT NULL` constraint in it's foreign key column in order to enforce that modality.

## Crows Foot Notation

We can graphically represent both cardinality and modality of a relationship using **Crow's Foot Notation**.

Cardinality is represented by drawing a line between entity objects, and whether or not that line ends in a single line (one) or a "crows foot" (many) indicates the cardinality on either side of a relationship.

![cardinality in crow's foot notation](./study_guide/crows_foot_1.jpg)

Modality is represented by either a line perpendicular to the connecting line (modality of 1, mandatory), or a circle through the connecting line (modality of 0, optional). Putting this all together we get:

![Cardinality and Modality in crow's foot notation](./study_guide/crows_foot_2.jpg)
