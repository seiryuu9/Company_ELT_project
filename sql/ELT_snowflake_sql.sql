CREATE DATABASE IF NOT EXISTS Company_DB;
CREATE SCHEMA IF NOT EXISTS Company_DB.CompanySchema;
USE DATABASE COMPANY_DB;
USE SCHEMA COMPANY_DB.CompanySchema;

-- extract, load
CREATE OR REPLACE TABLE company_index_staging AS
SELECT *
FROM snowflake_public_data_free.public_data_free.company_index;

CREATE OR REPLACE TABLE company_event_transcript_attributes_staging AS
SELECT *
FROM snowflake_public_data_free.public_data_free.company_event_transcript_attributes;

--transform
CREATE OR REPLACE TABLE dim_date (
    date_id INT AUTOINCREMENT PRIMARY KEY,
    date DATE,
    year INT,
    month INT,
    day INT,
    quarter INT,
    weekday INT
);

INSERT INTO dim_date (date, year, month, day, quarter, weekday)
SELECT DISTINCT
    TO_DATE(event_timestamp) AS date,
    YEAR(event_timestamp) AS year,
    MONTH(event_timestamp) AS month,
    DAY(event_timestamp) AS day,
    QUARTER(event_timestamp) AS quarter,
    DAYOFWEEK(event_timestamp) AS weekday
FROM company_event_transcript_attributes_staging;

select * from dim_date limit 10;


CREATE OR REPLACE TABLE dim_time (
    time_id INT AUTOINCREMENT PRIMARY KEY,
    time TIME,
    hour INT,
    minute INT,
    second INT,
    am_pm CHAR(2)
);

INSERT INTO dim_time (time, hour, minute, second, am_pm)
SELECT DISTINCT
    CAST(event_timestamp AS TIME) AS time,
    EXTRACT(HOUR FROM event_timestamp) AS hour,
    EXTRACT(MINUTE FROM event_timestamp) AS minute,
    EXTRACT(SECOND FROM event_timestamp) AS second,
    CASE WHEN EXTRACT(HOUR FROM event_timestamp) < 12 THEN 'AM' ELSE 'PM' END AS am_pm
FROM company_event_transcript_attributes_staging;

select * from dim_time limit 10;


CREATE OR REPLACE TABLE dim_company (
    company_sk INT AUTOINCREMENT PRIMARY KEY,   
    company_id VARCHAR(32),                      
    company_name VARCHAR(1000),
    entity_level VARCHAR(255),
    ein VARCHAR(255),
    cik VARCHAR(255),
    lei array,
    permid_company_id VARCHAR(255)
);

INSERT INTO dim_company (company_id, company_name, entity_level, ein, cik, lei, permid_company_id)
SELECT DISTINCT
    company_id,
    company_name,
    entity_level,
    ein,
    cik,
    lei,
    permid_company_id
FROM company_index_staging;

select * from dim_company limit 10;


CREATE OR REPLACE TABLE dim_event_type (
    event_type_id INT AUTOINCREMENT PRIMARY KEY,
    event_type VARCHAR(255),
    transcript_type VARCHAR(255),
    fiscal_period VARCHAR(255),
    fiscal_year VARCHAR(255)
);

INSERT INTO dim_event_type (event_type, transcript_type, fiscal_period, fiscal_year)
SELECT DISTINCT
    event_type,
    transcript_type,
    fiscal_period,
    fiscal_year
FROM company_event_transcript_attributes_staging;

select * from dim_event_type limit 10;


CREATE OR REPLACE TABLE fact_company_events (
    fact_id INT AUTOINCREMENT PRIMARY KEY,
    company_sk INT,
    event_type_id INT,
    date_id INT,
    time_id INT,
    event_count INT,
    events_per_year INT,
    days_since_prev_event INT
);

INSERT INTO fact_company_events (company_sk, event_type_id, date_id, time_id, event_count, events_per_year, days_since_prev_event)
SELECT
    c.company_sk,
    et.event_type_id,
    d.date_id,
    t.time_id,
    1 AS event_count, 
    
    COUNT(*) OVER (PARTITION BY c.company_sk, et.event_type_id, d.year) AS events_per_year,
    
    DATEDIFF(
        day,
        LAG(e.event_timestamp) OVER (PARTITION BY c.company_sk, et.event_type_id ORDER BY e.event_timestamp),
        e.event_timestamp
    ) AS days_since_prev_event
    
FROM company_event_transcript_attributes_staging e
JOIN dim_company c
    ON e.company_id = c.company_id
JOIN dim_event_type et
    ON e.event_type = et.event_type
   AND e.transcript_type = et.transcript_type
   AND e.fiscal_period = et.fiscal_period
   AND e.fiscal_year = et.fiscal_year
JOIN dim_date d
    ON TO_DATE(e.event_timestamp) = d.date
JOIN dim_time t
    ON CAST(e.event_timestamp AS TIME) = t.time;

select * from fact_company_events limit 10;

DROP TABLE IF EXISTS company_event_transcript_attributes_staging;
DROP TABLE IF EXISTS company_index;

