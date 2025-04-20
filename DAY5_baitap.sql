--- BAI TAP 1
-- Solution 1
SELECT DISTINCT CITY 
FROM STATION
WHERE ID % 2 =0
;
-- Solution 2
SELECT DISTINCT CITY 
FROM STATION
WHERE MOD(ID,2)=0 -- MOD()- calculate the remainder of a division operation.
;
--- BAI TAP 2
SELECT 
COUNT(CITY)-COUNT(DISTINCT(CITY)) AS DIFFERENCE
FROM STATION
;
--- BAI TAP 3
SELECT DISTINCT (SELECT AVG(SALARY) FROM EMPLOYEES)- (SELECT AVG(SALARY) FROM EMPLOYEES WHERE NOT SALARY LIKE '%0%')
FROM EMPLOYEES
;
--- BAI TAP 4
SELECT 
ROUND(CAST(SUM(item_count*order_occurrences)/SUM(order_occurrences) AS DECIMAL), 1)
FROM items_per_order;
--- BAI TAP 5
SELECT candidate_id 
FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT( skill) = 3
ORDER BY candidate_id;
--- BAI TAP 6
-- Solution 1
SELECT user_id,  
EXTRACT(DAY FROM MAX(post_date)- MIN(post_date) ) as days_between
FROM posts
WHERE post_date BETWEEN '2021-01-01' AND '2022-01-01'
GROUP BY user_id
HAVING count(user_id)>=2 
;
-- Solution 2
SELECT user_id,  
DATE(MAX(post_date))- DATE(MIN(post_date)) as days_between
FROM posts
WHERE post_date BETWEEN '2021-01-01' AND '2022-01-01'
GROUP BY user_id
HAVING count(user_id)>=2 
;
--- BAI TAP 7
SELECT 
card_name,
MAX(issued_amount)-MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY MAX(issued_amount)-MIN(issued_amount) DESC
;
--- BAI TAP 8
SELECT
manufacturer, 
COUNT(*) AS drug_count,
SUM (losses) AS total_loss

FROM( --Subquery 
SELECT
manufacturer,
COUNT(drug), 
ABS(total_sales-cogs) AS losses
FROM pharmacy_sales
GROUP BY manufacturer, total_sales-cogs
HAVING total_sales-cogs<0
) AS aggregated_data -- Subquery 

GROUP BY manufacturer
ORDER BY SUM (losses) DESC
;
--- BAI TAP 9
SELECT *
FROM Cinema
WHERE NOT (MOD(ID,2) = 0 
OR description ='boring')
ORDER BY rating DESC
;
--- BAI TAP 10
SELECT teacher_id,
COUNT(DISTINCT(subject_id)) AS cnt
FROM Teacher
GROUP BY teacher_id
;
--- BAI TAP 11
select user_id, 
count(follower_id) as followers_count 
from Followers 
group by user_id 
order by user_id;
--- BAI TAP 12
SELECT class
FROM Courses
GROUP BY class
HAVING COUNT(class) >=5
;
