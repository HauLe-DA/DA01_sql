--EX1: https://datalemur.com/questions/duplicate-job-listings
SELECT COUNT(DISTINCT company_id) AS duplicate_companies
FROM (
SELECT company_id, title, description, 
COUNT(job_id) AS job_count
FROM job_listings
GROUP BY company_id, title, description
) AS job_count_cte
WHERE job_count > 1;
--EX2: https://datalemur.com/questions/sql-highest-grossing
WITH total_appliance
AS (
SELECT  category, product, 
SUM(spend	) AS total_spend
FROM product_spend
WHERE category='appliance' AND EXTRACT(YEAR FROM transaction_date) = 2022 
GROUP BY product, category
ORDER BY category, total_spend DESC
LIMIT 2)
,
total_electronics
AS (
SELECT category, product, 
SUM(spend	) AS total_spend
FROM product_spend
WHERE category='electronics' AND EXTRACT(YEAR FROM transaction_date) = 2022 
GROUP BY product, category
ORDER BY category, total_spend DESC
LIMIT 2)
  
SELECT*
FROM total_appliance
UNION ALL 
SELECT * 
FROM total_electronics;
--EX3: https://datalemur.com/questions/frequent-callers

WITH number_policy_holder
AS
(SELECT policy_holder_id,
COUNT(case_id) AS number
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id) >=3)
SELECT
COUNT(number) AS policy_holder_count
FROM number_policy_holder;

--EX4: https://datalemur.com/questions/sql-page-with-no-likes

SELECT page_id
FROM pages
WHERE page_id NOT IN (
SELECT DISTINCT page_id
FROM page_likes
)
ORDER BY page_id DESC;

--EX5: https://datalemur.com/questions/user-retention
WITH june_users AS(
SELECT user_id, 
COUNT( user_id) AS active_users	  
FROM user_actions
WHERE event_type IN ('sign-in','like','comment')
AND EXTRACT(MONTH FROM event_date) =6 
AND EXTRACT(YEAR FROM event_date) = 2022
GROUP BY user_id),
july_users AS(
SELECT user_id, 
COUNT( user_id) AS active_users	  
FROM user_actions
WHERE event_type IN ('sign-in','like','comment')
AND EXTRACT(MONTH FROM event_date) =7 
AND EXTRACT(YEAR FROM event_date) = 2022
GROUP BY user_id)
SELECT
7 AS mth, 
COUNT(*) AS monthly_active_users
FROM july_users AS a 
JOIN june_users AS b 
ON a.user_id=b.user_id;
--Lemur solution:
SELECT 
EXTRACT(MONTH FROM curr_month.event_date) AS mth, 
COUNT(DISTINCT curr_month.user_id) AS monthly_active_users 
FROM user_actions AS curr_month
WHERE EXISTS (
SELECT 1 
FROM user_actions AS last_month
WHERE last_month.user_id = curr_month.user_id
AND EXTRACT(MONTH FROM last_month.event_date) =
EXTRACT(MONTH FROM curr_month.event_date - interval '1 month')
)
  AND EXTRACT(MONTH FROM curr_month.event_date) = 7
  AND EXTRACT(YEAR FROM curr_month.event_date) = 2022
GROUP BY EXTRACT(MONTH FROM curr_month.event_date);
--EX6: https://leetcode.com/problems/monthly-transactions-i/?envType=study-plan-v2&envId=top-sql-50
SELECT
a.month,
a.country,
a.trans_count,
a.approved_count,
a.trans_total_amount,
a.approved_total_amount
FROM (
SELECT
DATE_FORMAT(trans_date, '%Y-%m') AS month,
country,
COUNT(*) AS trans_count,
COUNT(CASE WHEN state = 'approved' THEN 1 END) AS approved_count,
SUM(amount) AS trans_total_amount,
SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY DATE_FORMAT(trans_date, '%Y-%m'), country
) AS a;

--EX7: https://leetcode.com/problems/product-sales-analysis-iii/?envType=study-plan-v2&envId=top-sql-50

SELECT product_id, year AS first_year, quantity, price 
FROM Sales
WHERE (product_id, year) IN (
SELECT product_id, MIN(year)
FROM Sales
GROUP BY product_id
);

--EX8: https://leetcode.com/problems/customers-who-bought-all-products/?envType=study-plan-v2&envId=top-sql-50
SELECT 
customer_id
FROM Customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(*) FROM Product);

--EX9: https://leetcode.com/problems/employees-whose-manager-left-the-company/?envType=study-plan-v2&envId=top-sql-50
SELECT 
e.employee_id
FROM Employees AS e
WHERE e.manager_id IS NOT NULL
AND NOT EXISTS (
SELECT 1
FROM Employees AS m
WHERE m.employee_id = e.manager_id
)
AND e.salary < 30000
ORDER BY e.employee_id;

--EX10: https://datalemur.com/questions/duplicate-job-listings
WITH duplicates AS (
SELECT
company_id
FROM job_listings
GROUP BY
company_id, title, description
HAVING COUNT(*) > 1)

SELECT
COUNT(DISTINCT company_id) AS duplicate_companies
FROM duplicates;

--EX11: http://leetcode.com/problems/movie-rating/?envType=study-plan-v2&envId=top-sql-50

(
SELECT
u.name AS results
FROM MovieRating AS mr
JOIN Users AS u
ON mr.user_id = u.user_id
GROUP BY u.name
ORDER BY COUNT(mr.rating) DESC, u.name
LIMIT 1
)

UNION ALL
(
SELECT
m.title AS results
FROM MovieRating AS mr2
JOIN Movies AS m
ON mr2.movie_id = m.movie_id
WHERE DATE_FORMAT(mr2.created_at, '%Y-%m') = '2020-02'
GROUP BY m.title
ORDER BY AVG(mr2.rating) DESC, m.title
LIMIT 1
);
-- ANOTHER METHOD:
WITH
twt_avg_rating AS -- find the avg rating for each movie
(SELECT movie_id, AVG(rating) AS avg_rating              
FROM MovieRating
WHERE EXTRACT(YEAR FROM created_at)='2020' AND 
EXTRACT(MONTH FROM created_at)='02'
GROUP BY movie_id
),
twt_result_movie AS-- find the movie name with the highest average rating in February 2020
(
SELECT A.title AS results
FROM Movies A
JOIN twt_avg_rating B
ON A.movie_id=B.movie_id
ORDER BY B.avg_rating DESC, A.title
LIMIT 1
),
users_rate AS-- count the number of movies that each user has rated
(SELECT user_id, COUNT(movie_id) AS no_rating_movies    
FROM MovieRating 
GROUP BY user_id
),
twt_result_user AS-- find the name of the user who has rated the greatest number of movies
(
SELECT C.name AS results
FROM Users C
JOIN users_rate D
ON C.user_id=D.user_id     
ORDER BY D.no_rating_movies DESC, C.name
LIMIT 1)
  -- union all 
SELECT results
FROM  twt_result_user
UNION ALL
SELECT results
FROM  twt_result_movie 
--EX12: https://leetcode.com/problems/friend-requests-ii-who-has-the-most-friends/?envType=study-plan-v2&envId=top-sql-50
WITH AllIds AS (
SELECT requester_id AS id
FROM RequestAccepted
UNION ALL
SELECT accepter_id
FROM RequestAccepted
)
SELECT id,
COUNT(*) AS num
FROM AllIds
GROUP BY id
ORDER BY num DESC
LIMIT 1;
-- CÁCH 2:
WITH twt_RequestAccepted AS(
SELECT 
requester_id AS id, COUNT(accepter_id ) AS num
FROM RequestAccepted  
GROUP BY requester_id
UNION ALL
SELECT 
accepter_id AS id, COUNT(requester_id)  AS num
FROM RequestAccepted
GROUP BY accepter_id)
SELECT id,SUM(num) AS num
FROM twt_RequestAccepted
GROUP BY id
ORDER BY SUM(num) DESC 
LIMIT 1

