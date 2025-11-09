-- ============================================================================
-- SQL Server Graph Database Sample - Converted to DuckDB with DuckPGQ
-- ============================================================================
-- This script demonstrates how to create a graph database in DuckDB using
-- the DuckPGQ community extension (v1.4.1)
-- 
-- Based on: https://learn.microsoft.com/en-us/sql/relational-databases/graphs/sql-graph-sample

-- ============================================================================
-- Step 1: Install and Load DuckPGQ Extension
-- ============================================================================
INSTALL duckpgq FROM community;
LOAD duckpgq;

-- Start DuckDB UI from the terminal by launching the DuckDB CLI client with the -ui argument:
duckdb -ui

-- Load DuckDB UI from DuckDB CLI
CALL start_ui();
-- ============================================================================
-- Step 2: Create Regular Tables (Vertex and Edge Tables)
-- ============================================================================

-- Create vertex tables (nodes)
CREATE TABLE Person (
    ID INTEGER PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE Restaurant (
    ID INTEGER PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(100)
);

CREATE TABLE City (
    ID INTEGER PRIMARY KEY,
    name VARCHAR(100),
    stateName VARCHAR(100)
);

-- Create edge tables (relationships)
CREATE TABLE likes (
    personId INTEGER,
    restaurantId INTEGER,
    rating INTEGER
);

CREATE TABLE friendOf (
    person1Id INTEGER,
    person2Id INTEGER
);

CREATE TABLE livesIn (
    personId INTEGER,
    cityId INTEGER
);

CREATE TABLE locatedIn (
    restaurantId INTEGER,
    cityId INTEGER
);

-- ============================================================================
-- Step 3: Insert Data into Vertex Tables
-- ============================================================================

INSERT INTO Person (ID, name)
VALUES (1, 'John'),
       (2, 'Mary'),
       (3, 'Alice'),
       (4, 'Jacob'),
       (5, 'Julie');

INSERT INTO Restaurant (ID, name, city)
VALUES (1, 'Taco Dell', 'Bellevue'),
       (2, 'Ginger and Spice', 'Seattle'),
       (3, 'Noodle Land', 'Redmond');

INSERT INTO City (ID, name, stateName)
VALUES (1, 'Bellevue', 'WA'),
       (2, 'Seattle', 'WA'),
       (3, 'Redmond', 'WA');

-- ============================================================================
-- Step 4: Insert Data into Edge Tables
-- ============================================================================

-- Insert which restaurants each person likes
INSERT INTO likes (personId, restaurantId, rating)
VALUES (1, 1, 9),
       (2, 2, 9),
       (3, 3, 9),
       (4, 3, 9),
       (5, 3, 9);

-- Associate in which city each person lives
INSERT INTO livesIn (personId, cityId)
VALUES (1, 1),
       (2, 2),
       (3, 3),
       (4, 3),
       (5, 1);

-- Insert data where the restaurants are located
INSERT INTO locatedIn (restaurantId, cityId)
VALUES (1, 1),
       (2, 2),
       (3, 3);

-- Insert data into the friendOf edge
INSERT INTO friendOf (person1Id, person2Id)
VALUES (1, 2),
       (2, 3),
       (3, 1),
       (4, 2),
       (5, 4);

-- ============================================================================
-- Step 5: Create Property Graph
-- ============================================================================

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
        LABEL FriendOf,
    livesIn 
        SOURCE KEY (personId) REFERENCES Person (ID)
        DESTINATION KEY (cityId) REFERENCES City (ID)
        LABEL LivesIn,
    locatedIn 
        SOURCE KEY (restaurantId) REFERENCES Restaurant (ID)
        DESTINATION KEY (cityId) REFERENCES City (ID)
        LABEL LocatedIn
);

-- ============================================================================
-- Step 6: Query Examples Using Graph Pattern Matching
-- ============================================================================

-- Query 1: Find restaurants that John likes
SELECT Restaurant_name
FROM GRAPH_TABLE (social_network
    MATCH (p:Person)-[l:Likes]->(r:Restaurant)
    WHERE p.name = 'John'
    COLUMNS (r.name AS Restaurant_name)
);

-- Query 2: Find restaurants that John's friends like
SELECT Restaurant_name
FROM GRAPH_TABLE (social_network
    MATCH (p1:Person)-[f:FriendOf]->(p2:Person)-[l:Likes]->(r:Restaurant)
    WHERE p1.name = 'John'
    COLUMNS (r.name AS Restaurant_name)
);

-- Query 3: Find people who like a restaurant in the same city they live in
SELECT Person_name
FROM GRAPH_TABLE (social_network
    MATCH 
        (p:Person)-[l:Likes]->(r:Restaurant)-[loc:LocatedIn]->(c:City),
        (p:Person)-[liv:LivesIn]->(c:City)
    COLUMNS (p.name AS Person_name)
);

-- Query 4: Find friends-of-friends-of-friends (3 hops)
-- Excluding cases where the relationship "loops back"
SELECT Person1_name, Person2_name, Person3_name, Person4_name
FROM GRAPH_TABLE (social_network
    MATCH 
        (p1:Person)-[f1:FriendOf]->(p2:Person)
        -[f2:FriendOf]->(p3:Person)
        -[f3:FriendOf]->(p4:Person)
    WHERE 
        p1.ID != p2.ID 
        AND p2.ID != p3.ID 
        AND p3.ID != p4.ID 
        AND p1.ID != p4.ID
    COLUMNS (
        p1.name AS Person1_name,
        p2.name AS Person2_name,
        p3.name AS Person3_name,
        p4.name AS Person4_name
    )
);

-- ============================================================================
-- Advanced Query Examples
-- ============================================================================

-- Query 5: Find all paths of friends (variable length path)
-- Find any shortest path between John and all other people
SELECT Person1_name, Person2_name, path_length
FROM GRAPH_TABLE (social_network
    MATCH p = ANY SHORTEST (p1:Person)-[f:FriendOf]->+(p2:Person)
    WHERE p1.name = 'John' AND p1.ID != p2.ID
    COLUMNS (
        p1.name AS Person1_name,
        p2.name AS Person2_name,
        path_length(p) AS path_length
    )
)
ORDER BY path_length, Person2_name;

-- Query 6: Find all restaurants liked by friends within 2 hops
SELECT DISTINCT Person_name, Restaurant_name
FROM GRAPH_TABLE (social_network
    MATCH (p1:Person)-[f:FriendOf]->{1,2}(p2:Person)-[l:Likes]->(r:Restaurant)
    WHERE p1.name = 'John'
    COLUMNS (
        p1.name AS Person_name,
        r.name AS Restaurant_name
    )
)
ORDER BY Restaurant_name;

-- Query 7: Find people who live in the same city as restaurants they like
SELECT Person_name, 
       Restaurant_name, 
       City_name,
       Rating
FROM GRAPH_TABLE (social_network
    MATCH 
        (p:Person)-[l:Likes]->(r:Restaurant)-[loc:LocatedIn]->(c:City),
        (p:Person)-[liv:LivesIn]->(c:City)
    COLUMNS (
        p.name AS Person_name,
        r.name AS Restaurant_name,
        c.name AS City_name,
        l.rating AS Rating
    )
);

-- ============================================================================
-- Cleanup
-- ============================================================================

-- Drop the property graph
-- DROP PROPERTY GRAPH social_network;

-- Drop tables
-- DROP TABLE IF EXISTS likes;
-- DROP TABLE IF EXISTS friendOf;
-- DROP TABLE IF EXISTS livesIn;
-- DROP TABLE IF EXISTS locatedIn;
-- DROP TABLE IF EXISTS Person;
-- DROP TABLE IF EXISTS Restaurant;
-- DROP TABLE IF EXISTS City;