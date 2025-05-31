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
--EX5: https://datalemur.com/questions/user-retention
--EX6: https://leetcode.com/problems/monthly-transactions-i/?envType=study-plan-v2&envId=top-sql-50
--EX7: https://leetcode.com/problems/product-sales-analysis-iii/?envType=study-plan-v2&envId=top-sql-50
--EX8: https://leetcode.com/problems/customers-who-bought-all-products/?envType=study-plan-v2&envId=top-sql-50
--EX9: https://leetcode.com/problems/employees-whose-manager-left-the-company/?envType=study-plan-v2&envId=top-sql-50
--EX10: https://datalemur.com/questions/duplicate-job-listings
--EX11: http://leetcode.com/problems/movie-rating/?envType=study-plan-v2&envId=top-sql-50
--EX12: https://leetcode.com/problems/friend-requests-ii-who-has-the-most-friends/?envType=study-plan-v2&envId=top-sql-50

