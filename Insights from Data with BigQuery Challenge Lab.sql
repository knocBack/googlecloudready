--TASK-1
--/*
SELECT SUM(cumulative_confirmed) AS total_cases_worldwide
FROM `bigquery-public-data.covid19_open_data.covid19_open_data` 
  WHERE date='2020-06-15'
--*/

--TASK-2
--/*
SELECT count(t1.Count) AS count_of_states 
FROM (SELECT subregion1_name,SUM(cumulative_deceased) AS dsum, COUNT(subregion1_name) AS count
FROM `bigquery-public-data.covid19_open_data.covid19_open_data` 
  WHERE date='2020-04-10'
    AND country_name='United States of America' 
    AND subregion1_name IS NOT NULL 
  GROUP BY subregion1_name 
  HAVING dsum>=200
  ORDER BY dsum DESC)
AS t1
--*/

--TASK-3
--/*
SELECT subregion1_name AS state, SUM(cumulative_confirmed) AS total_confirmed_cases FROM `bigquery-public-data.covid19_open_data.covid19_open_data` 
WHERE subregion1_name IS NOT NULL
  AND country_name='United States of America'
  AND date='2020-04-10'
GROUP BY subregion1_name
HAVING total_confirmed_cases>2000
ORDER BY total_confirmed_cases DESC
--*/

--TASK-4
--/*
SELECT SUM(cumulative_confirmed) AS total_confirmed_cases, SUM(cumulative_deceased) AS total_deaths, ((SUM(cumulative_deceased)/SUM(cumulative_confirmed))*100) AS case_fatality_ratio
FROM `bigquery-public-data.covid19_open_data.covid19_open_data`
WHERE country_name = 'Italy'
AND date >= '2020-04-01' AND date <= '2020-04-30'
GROUP BY country_name
--*/

--TASK-5
--/*
SELECT date
FROM `bigquery-public-data.covid19_open_data.covid19_open_data`
WHERE country_name='Italy'
AND cumulative_deceased>12000
GROUP BY Date
ORDER BY Date
LIMIT 1
--*/

--!!!!!
-- NEEDS TO LEARN 
-- LAG function
--!!!!!

--TASK-6
--/*
WITH india_cases_by_date AS (
  SELECT
    date,
    SUM(cumulative_confirmed) AS cases
  FROM
    `bigquery-public-data.covid19_open_data.covid19_open_data`
  WHERE
    country_name="India"
    AND date between '2020-02-21' and '2020-03-14'
  GROUP BY
    date
  ORDER BY
    date ASC
 )
, india_previous_day_comparison AS
(SELECT
  date,
  cases,
  LAG(cases) OVER(ORDER BY date) AS previous_day,
  cases - LAG(cases) OVER(ORDER BY date) AS net_new_cases
FROM india_cases_by_date
)
SELECT COUNT(*) FROM india_previous_day_comparison
WHERE net_new_cases=0
--*/

--TASK-7
--/*
WITH us_cases_by_date AS (
  SELECT
    date,
    SUM(cumulative_confirmed) AS cases
  FROM
    `bigquery-public-data.covid19_open_data.covid19_open_data`
  WHERE
    country_name='United States of America'
    AND date between '2020-03-22' and '2020-04-20'
  GROUP BY
    date
  ORDER BY
    date ASC
 )
, us_previous_day_comparison AS
(SELECT
  date,
  cases,
  LAG(cases) OVER(ORDER BY date) AS previous_day,
  cases - LAG(cases) OVER(ORDER BY date) AS net_new_cases,
FROM us_cases_by_date
)
SELECT date AS Date, 
cases AS Confirmed_Cases_On_Day, 
previous_day AS Confirmed_Cases_Previous_Day, 
((net_new_cases/previous_day)*100) AS Percentage_Increase_In_Cases
FROM us_previous_day_comparison
WHERE ((net_new_cases/previous_day)*100)>10
ORDER BY Date
--*/

--TASK-8
--/*
SELECT
  country_name AS country,
  SUM(cumulative_recovered) AS recovered_cases,
  SUM(cumulative_confirmed) AS confirmed_cases,
  (SUM(cumulative_recovered)/SUM(cumulative_confirmed)) AS recovery_rate
FROM
  `bigquery-public-data.covid19_open_data.covid19_open_data`
WHERE date = '2020-05-10'
GROUP BY country_name
HAVING confirmed_cases > 50000
ORDER BY recovery_rate DESC
LIMIT 10
--*/

--!!!!!
-- NEEDS TO LEARN 
-- LEAD function
--!!!!!
--TASK-9
--/*
WITH
  france_cases AS (
  SELECT
    date,
    SUM(cumulative_confirmed) AS total_cases
  FROM
    `bigquery-public-data.covid19_open_data.covid19_open_data`
  WHERE
    country_name="France"
    AND date IN ('2020-01-24',
      '2020-04-20')
  GROUP BY
    date
  ORDER BY
    date)
, summary as (
SELECT
  total_cases AS first_day_cases,
  LEAD(france_cases.total_cases) OVER(ORDER BY france_cases.total_cases) AS last_day_cases,
  DATE_DIFF(LEAD(date) OVER(ORDER BY date),date, day) AS days_diff
FROM
  france_cases
LIMIT 1
)
select first_day_cases, last_day_cases, days_diff, POW((last_day_cases/first_day_cases),(1/days_diff))-1 as cdgr
from summary
--*/

--TASK-10
--/*
SELECT
  date,
  SUM(cumulative_confirmed) AS Number_of_Confirmed_Cases,
  SUM(cumulative_deceased) AS Number_of_Deaths
FROM
  `bigquery-public-data.covid19_open_data.covid19_open_data`
WHERE
  country_name="United States of America"
  AND date between '2020-03-29' and '2020-04-19'
GROUP BY
  date
ORDER BY
  date
--*/
