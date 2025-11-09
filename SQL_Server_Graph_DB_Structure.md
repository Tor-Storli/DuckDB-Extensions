# SQL Server Graph Tables: Multi-Column Nodes and Relationships


## Graph Table Structure in SQL Server

In SQL Server, graph tables consist of **nodes** and **edges**. Each node table has a system-generated `$node_id` column, and edge tables have `$from_id` and `$to_id` columns to represent relationships between nodes.

## Example: Multi-Column Node Table

Here's an example of a **node table** with additional columns:

| $node_id | Name     | Type         | CreatedDate |
|----------|----------|--------------|-------------|
| 1        | Alice    | Person       | 2025-01-01  |
| 2        | Bob      | Person       | 2025-02-15  |
| 3        | CompanyX | Organization | 2025-03-10  |

### Column Descriptions

- **$node_id**: System-generated unique identifier for each node.
- **Name**: Custom column for the node's name.
- **Type**: Custom column to classify the node (e.g., Person, Organization).
- **CreatedDate**: Custom column for metadata.

## Example: Edge Table (Simplified View)

An edge table connects nodes and includes `$from_id` and `$to_id`:

| $edge_id | $from_id | $to_id | RelationshipType |
|----------|----------|--------|------------------|
| 1        | 1        | 3      | WorksAt          |
| 2        | 2        | 3      | WorksAt          |

### Column Descriptions

- **\$edge_id**: System-generated unique identifier for each edge.
- **\$from_id**: References the `$node_id` of the source node.
- **\$to_id**: References the `$node_id` of the target node.
- **RelationshipType**: Custom column to describe the relationship.

## Example: Edge Table (Realistic with JSON Node IDs)

In SQL Server graph tables, the `$from_id` and `$to_id` columns actually store JSON strings that contain both the schema, table name, and the node's unique identifier. Here's a more realistic representation:

| $edge_id | $from_id | $to_id | RelationshipType |
|----------|----------|--------|------------------|
| {"type":"edge","schema":"dbo","table":"WorksAt","id":0} | {"type":"node","schema":"dbo","table":"Person","id":0} | {"type":"node","schema":"dbo","table":"Person","id":2} | WorksAt |
| {"type":"edge","schema":"dbo","table":"WorksAt","id":1} | {"type":"node","schema":"dbo","table":"Person","id":1} | {"type":"node","schema":"dbo","table":"Person","id":2} | WorksAt |

### Understanding the JSON Structure

The `$node_id`, `$from_id`, and `$to_id` columns in SQL Server graph tables are actually **nvarchar** columns containing JSON with the following structure:

```json
{
  "type": "node",
  "schema": "dbo",
  "table": "Person",
  "id": 0
}
```

- **type**: Indicates whether this is a "node" or "edge"
- **schema**: The database schema name
- **table**: The table name where this node/edge exists
- **id**: The internal numeric identifier within that table

## SQL Script to Create Graph Tables

```sql
-- Create a node table
CREATE TABLE Person (
    Name NVARCHAR(100),
    Type NVARCHAR(50),
    CreatedDate DATE
) AS NODE;

-- Create an edge table
CREATE TABLE WorksAt (
    RelationshipType NVARCHAR(50)
) AS EDGE;
```

**Note**: The `$node_id`, `$edge_id`, `$from_id`, and `$to_id` columns are automatically created by SQL Server when you use the `AS NODE` or `AS EDGE` syntax.