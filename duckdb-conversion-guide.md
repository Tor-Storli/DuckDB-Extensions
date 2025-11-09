# Converting SQL Server Graph Database to DuckDB with DuckPGQ

This guide explains how to convert SQL Server graph database examples to DuckDB using the DuckPGQ community extension (v1.4.1).

## Overview

The DuckPGQ extension brings SQL/PGQ (Property Graph Queries) syntax from the SQL:2023 standard to DuckDB, enabling powerful graph analysis directly within your database without needing specialized graph database systems.

------------------------------------------------------------------------

## Main Differences from SQL Server

### 1. **Table Creation**

**SQL Server:**

``` sql
CREATE TABLE Person (
    ID INTEGER PRIMARY KEY,
    name VARCHAR(100)
) AS NODE;

CREATE TABLE likes (rating INTEGER) AS EDGE;
```

**DuckDB:**

``` sql
-- Create regular tables first
CREATE TABLE Person (
    ID INTEGER PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE likes (
    personId INTEGER,
    restaurantId INTEGER,
    rating INTEGER
);
```

In DuckDB, you create regular relational tables instead of using `AS NODE` or `AS EDGE` syntax. The graph layer is added separately through the property graph definition.

### 2. **Property Graph Creation**

After creating regular tables, you define the property graph structure:

``` sql
CREATE PROPERTY GRAPH social_network
VERTEX TABLES (
    Person,
    Restaurant,
    City
)
EDGE TABLES (
    likes 
        SOURCE KEY (personId) REFERENCES Person (ID)
        DESTINATION KEY (restaurantId) REFERENCES Restaurant (ID)
        LABEL Likes,
    friendOf 
        SOURCE KEY (person1Id) REFERENCES Person (ID)
        DESTINATION KEY (person2Id) REFERENCES Person (ID)
        LABEL FriendOf
);
```

This creates a logical graph layer on top of your existing tables, specifying: - Which tables represent vertices (nodes) - Which tables represent edges (relationships) - How edges connect to vertices through foreign keys - Meaningful labels for relationships (e.g., `Likes`, `FriendOf`)

### 3. **Edge Table Structure**

**SQL Server:**

``` sql
INSERT INTO likes
VALUES (
    (SELECT $node_id FROM Person WHERE ID = 1),
    (SELECT $node_id FROM Restaurant WHERE ID = 1),
    9
);
```

**DuckDB:**

``` sql
INSERT INTO likes (personId, restaurantId, rating)
VALUES (1, 1, 9);
```

Instead of using special `$node_id`, `$from_id`, and `$to_id` columns, DuckDB uses explicit foreign key columns that you define when creating the property graph. This makes the data more accessible and easier to work with using standard SQL.

### 4. **Query Syntax**

**SQL Server:**

``` sql
SELECT Restaurant.name
FROM Person, likes, Restaurant
WHERE MATCH (Person-(likes)->Restaurant)
AND Person.name = 'John';
```

**DuckDB with DuckPGQ:**

``` sql
SELECT Restaurant_name
FROM GRAPH_TABLE (social_network
    MATCH (p:Person)-[l:Likes]->(r:Restaurant)
    WHERE p.name = 'John'
    COLUMNS (r.name AS Restaurant_name)
);
```

The DuckDB approach uses: - `GRAPH_TABLE()` function to query the property graph - Visual pattern syntax: `(node)-[edge]->(node)` - Labels with colons: `(p:Person)` means "a Person node aliased as p" - A `COLUMNS` clause to specify what to return (similar to SELECT)

------------------------------------------------------------------------

## Key Features Demonstrated

### Pattern Matching

Find simple patterns in your graph:

``` sql
-- Find restaurants that John likes
MATCH (p:Person)-[l:Likes]->(r:Restaurant)
WHERE p.name = 'John'
```

The pattern `(p:Person)-[l:Likes]->(r:Restaurant)` visually represents: - A Person node (aliased as `p`) - Connected by a Likes edge (aliased as `l`) - To a Restaurant node (aliased as `r`)

### Multi-hop Queries

Find relationships through intermediate nodes:

``` sql
-- Find restaurants that John's friends like
MATCH (p1:Person)-[f:FriendOf]->(p2:Person)-[l:Likes]->(r:Restaurant)
WHERE p1.name = 'John'
```

This traverses two edges: from John to his friends, then from friends to restaurants they like.

### Variable Length Paths

Use special syntax for paths of variable length:

``` sql
-- Find any shortest path between John and other people
MATCH p = ANY SHORTEST (p1:Person)-[f:FriendOf]->+(p2:Person)
WHERE p1.name = 'John'
```

-   `->+` means "one or more hops" (no upper limit)
-   `->{1,2}` means "between 1 and 2 hops"
-   `ANY SHORTEST` finds the shortest path among multiple possibilities

### Path Functions

Extract information about matched paths:

``` sql
COLUMNS (
    path_length(p) AS path_length,
    p1.name AS start_person,
    p2.name AS end_person
)
```

The `path_length()` function returns the number of edges in a matched path.

### Complex Patterns

Combine multiple patterns in a single query:

``` sql
-- Find people who like restaurants in the same city they live in
MATCH 
    (p:Person)-[l:Likes]->(r:Restaurant)-[loc:LocatedIn]->(c:City),
    (p:Person)-[liv:LivesIn]->(c:City)
```

The comma separates multiple patterns that must all match, with shared variables (`p` and `c`) ensuring they connect properly.

------------------------------------------------------------------------

## Advantages of DuckPGQ Approach

1.  **Standard SQL Foundation**: Your data remains in regular tables, accessible via standard SQL
2.  **No Data Duplication**: The property graph is a logical layer, not a physical copy
3.  **Visual Syntax**: The SQL/PGQ pattern matching is more intuitive than complex JOINs
4.  **Performance**: Runs on DuckDB's high-performance vectorized engine
5.  **SQL:2023 Standard**: Using an official SQL standard, not proprietary syntax
6.  **Flexibility**: Switch between graph queries and relational queries as needed

------------------------------------------------------------------------

## Example Use Cases

-   **Social Networks**: Friend recommendations, influence analysis
-   **Fraud Detection**: Transaction chains, ownership cycles
-   **Knowledge Graphs**: Entity relationships, concept hierarchies
-   **Supply Chains**: Dependencies, routing optimization
-   **Network Analysis**: Connectivity, bottleneck identification

------------------------------------------------------------------------

## Getting Started

``` sql
-- Install and load the extension
INSTALL duckpgq FROM community;
LOAD duckpgq;

-- Create your tables
CREATE TABLE Person (...);
CREATE TABLE friendOf (...);

-- Define the property graph
CREATE PROPERTY GRAPH my_graph
VERTEX TABLES (Person)
EDGE TABLES (friendOf 
    SOURCE KEY (...) REFERENCES Person (...)
    DESTINATION KEY (...) REFERENCES Person (...)
    LABEL FriendOf
);

-- Query the graph
SELECT * FROM GRAPH_TABLE (my_graph
    MATCH (p1:Person)-[f:FriendOf]->(p2:Person)
    COLUMNS (p1.name, p2.name)
);
```

------------------------------------------------------------------------

## Resources

-   **DuckPGQ Documentation**: [duckpgq.org](https://duckpgq.org)
-   **DuckDB Community Extensions**: [duckdb.org/community_extensions](https://duckdb.org/community_extensions)
-   **SQL/PGQ Standard**: Part of SQL:2023
-   **Original SQL Server Example**: [Microsoft Learn](https://learn.microsoft.com/en-us/sql/relational-databases/graphs/sql-graph-sample)

------------------------------------------------------------------------

## Summary

Converting from SQL Server graph syntax to DuckDB with DuckPGQ involves:

1.  Creating regular tables instead of `AS NODE` / `AS EDGE`
2.  Defining a property graph layer with `CREATE PROPERTY GRAPH`
3.  Using `GRAPH_TABLE()` with visual pattern matching syntax
4.  Leveraging powerful features like variable-length paths and path functions

The result is a more flexible, standard-based approach to graph querying that integrates seamlessly with your existing relational data.

### **Reference-Assistance:**

-   **Create a graph database and run some pattern matching queries using T-SQL**<br> <https://learn.microsoft.com/en-us/sql/relational-databases/graphs/sql-graph-sample?view=sql-server-ver17>

-   **Uncovering Financial Crime with DuckDB and Graph Queries**<br> <https://duckdb.org/2025/10/22/duckdb-graph-queries-duckpgq>

-   <span style="color: #0000FF;"><i>
**Anthropic. (2025, November 7). Introduction to Graph Databases. <br>Generated by Claude Sonnet 4.5.**  
</i></span>