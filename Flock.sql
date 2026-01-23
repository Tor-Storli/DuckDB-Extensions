
INSTALL flock FROM community;
LOAD flock;

CREATE SECRET (
    TYPE OLLAMA,
    API_URL '127.0.0.1:11434'
);

SELECT * FROM duckdb_secrets();

GET MODELS;

SELECT * FROM duckdb_secrets();

CREATE MODEL(
   'deepseek',
   'deepseek-r1:latest',
   'ollama',
   {"tuple_format": "json", "batch_size": 32, "model_parameters": {"temperature": 0.7}}
);


DELETE MODEL 'sqlcoder';


CREATE GLOBAL MODEL(
   'sqlcoder',
   'sqlcoder:15b',
   'ollama',
   {"tuple_format": "json", "batch_size": 32, "model_parameters": {"temperature": 0.7}}
);

GET MODELS;

SELECT llm_complete(
    {'model_name': 'deepseek'},
    {'prompt': 'What is the currency of Vietnam?'}
) AS sample_purpose;


show tables;


desc financial_ratios;

FROM financial_ratios LIMIT 15;


SELECT llm_complete(
    {'model_name': 'sqlcoder'},
    {'prompt': '### Task
Generate a SQL query to retrieve liquidity and profitability ratios from the financial_ratios table.
The table financial_ratios in DuckDB has the following structure:
- category (VARCHAR)
- account_number (INTEGER)
- account (VARCHAR)
- ratio (DOUBLE)
Write a DuckDB SQL query that:
1. Retrieves all rows where the category is either ''Liquidity'' or ''Profitability Ratios''
2. Returns all columns: category, account_number, account, and ratio
3. Orders the results by category and then by account_number'}
) AS generated_query;


SELECT * FROM financial_ratios WHERE category in ('Liquidity', 'Profitability Ratios') ORDER BY category, account_number asc;

-----------------------------------------  END OF SCRIPT --------------------------------------------------------------------
