-- Graf 1: Počet udalostí podľa typu udalosti
SELECT et.event_type, COUNT(f.fact_id) AS total_events
FROM fact_company_events f
JOIN dim_event_type et ON f.event_type_id = et.event_type_id
GROUP BY et.event_type
ORDER BY total_events DESC;

-- Graf 2: Počet udalostí podľa roku
SELECT d.year, COUNT(f.fact_id) AS total_events
FROM fact_company_events f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.year
ORDER BY d.year;

-- Graf 3: Počet udalostí podľa spoločnosti
SELECT c.company_name, COUNT(f.fact_id) AS total_events
FROM fact_company_events f
JOIN dim_company c ON f.company_sk = c.company_sk
GROUP BY c.company_name
ORDER BY total_events DESC
LIMIT 10;

-- Graf 4: Priemerný počet dní medzi udalosťami
SELECT et.event_type, ROUND(AVG(f.days_since_prev_event), 0) AS avg_days_between_events
FROM fact_company_events f 
JOIN dim_event_type et ON f.event_type_id = et.event_type_id
WHERE f.days_since_prev_event IS NOT NULL
GROUP BY et.event_type
HAVING COUNT(f.event_type_id) >= 2
ORDER BY avg_days_between_events;

-- Graf 5: Rozdelenie udalostí podľa hodiny dňa
SELECT t.hour, COUNT(f.fact_id) AS total_events
FROM fact_company_events f
JOIN dim_time t ON f.time_id = t.time_id
GROUP BY t.hour
ORDER BY t.hour;

-- Graf 6: Počet udalostí podľa typu a fiškálneho roka
SELECT et.event_type, et.fiscal_year, COUNT(f.fact_id) AS total_events
FROM fact_company_events f
JOIN dim_event_type et ON f.event_type_id = et.event_type_id
WHERE et.fiscal_year != 'None'
GROUP BY et.event_type, et.fiscal_year
ORDER BY et.fiscal_year, total_events DESC;