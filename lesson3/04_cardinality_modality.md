# Database Diagrams: Cardinality and Modality

Practice Problems

1. **Cardinality** is the number of objects on each side of a relationship, i.e. it determines if entities have a one-to-one, one-to-many, or many-to-many relationship.

2. **Modality** determines if the relationship is optional or required. For example, A review _must_ (required) have a book but a book does not necessarily need (optional) a review. Often, modality is indicated with a single number, `1` for required or `0` for optional.

3. If one side of a relationship has a modality of 1, it must have at least one instance of an entity on that side of a relationship.

4. A common type of notation for describing cardinality and modality is _crow's foot notation_. In crow's foot notation, a straight line represents a one side of a relationship, and a forked 'crows foot' represents a many side of a relationship. On the line between entities either a circle (0, optional) or line (1, required) will represent the modality of that side of the relationship.
