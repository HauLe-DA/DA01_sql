-- Bai tap 1: https://www.hackerrank.com/challenges/average-population-of-each-continent/problem?isFullScreen=true
SELECT t1.Continent,FLOOR(AVG(t2.POPULATION))
FROM COUNTRY as t1
JOIN CITY as t2
ON t1.Code=t2.CountryCode
GROUP BY t1.Continent;
-- Bai tap 2: https://datalemur.com/questions/signup-confirmation-rate
SELECT 
ROUND(1.0*SUM(CASE 
WHEN t2.signup_action='Confirmed' THEN 1 ELSE 0
END)/COUNT(*),2)
FROM emails AS t1
JOIN texts AS t2
ON t1.email_id=t2.email_id	
;
-- Bai tap 3: https://datalemur.com/questions/time-spent-snaps
SELECT t2.age_bucket, 
ROUND(100*SUM(CASE
WHEN t1.activity_type ='send' THEN t1.time_spent
END)/ (SUM(CASE
WHEN t1.activity_type ='open' THEN t1.time_spent
END)+SUM(CASE
WHEN t1.activity_type ='send' THEN t1.time_spent
END)),2) AS send_perc,

ROUND(100*SUM(CASE
WHEN t1.activity_type ='open' THEN t1.time_spent
END)/ (SUM(CASE
WHEN t1.activity_type ='open' THEN t1.time_spent
END)+SUM(CASE
WHEN t1.activity_type ='send' THEN t1.time_spent
END)),2) AS open_perc


FROM activities AS t1
JOIN age_breakdown AS t2
ON t1.user_id	= t2.user_id	
GROUP BY t2.age_bucket
;
-- Bai tap 4: https://datalemur.com/questions/supercloud-customer
SELECT t1.customer_id
FROM customer_contracts AS t1
JOIN products AS t2
ON t1.product_id=t2.product_id
WHERE t2.product_category IN ('Analytics', 'Containers', 'Compute')
GROUP BY t1.customer_id
HAVING COUNT(DISTINCT t2.product_category) = 3;
-- Bai tap 5: https://leetcode.com/problems/the-number-of-employees-which-report-to-each-employee/?envType=study-plan-v2&envId=top-sql-50
SELECT t1.employee_id, t1.name,
COUNT(t2.employee_id) AS reports_count,
ROUND(AVG(t2.age)) AS average_age
FROM Employees AS t1
JOIN Employees AS t2
ON t1.employee_id = t2.reports_to
GROUP BY t1.employee_id, t1.name
ORDER BY t1.employee_id;
-- Bai tap 6: https://leetcode.com/problems/list-the-products-ordered-in-a-period/?envType=study-plan-v2&envId=top-sql-50
SELECT  t2.product_name, SUM(t1.unit) AS unit           
FROM Orders AS t1
JOIN Products AS t2
ON t1.product_id = t2.product_id    
WHERE t1.order_date BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY t1.product_id
HAVING SUM(t1.unit) >=100;
-- Bai tap 7: https://datalemur.com/questions/sql-page-with-no-likes
SELECT t1.page_id
FROM pages AS t1
LEFT JOIN page_likes AS t2
ON t1.page_id = t2.page_id
WHERE t2.page_id IS NULL;
--Mid-course-test:
--Cau 1:
SELECT DISTINCT replacement_cost
FROM film
ORDER BY replacement_cost ASC
LIMIT 1;
-- Cau 2:
SELECT
CASE
WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 'low'
END AS category,
COUNT(*) AS film_count
FROM film
WHERE 
CASE
WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 'low'
END IS NOT NULL
GROUP BY category
;
-- Cau 3:
SELECT t1.length, t3.name 
FROM film AS t1
JOIN film_category AS t2 
ON t1.film_id = t2.film_id
JOIN category AS t3 
ON t2.category_id = t3.category_id
WHERE t3.name IN ('Drama', 'Sports')
ORDER BY t1.length DESC
LIMIT 1;
-- Cau 4:
SELECT t3.name,COUNT(t1.film_id) 
FROM film t1
JOIN film_category AS t2 
ON t1.film_id = t2.film_id
JOIN category t3 
ON t2.category_id = t3.category_id
GROUP BY t3.name
ORDER BY COUNT(t1.film_id) DESC
LIMIT 1;
-- Cau 5:
SELECT 
t1.first_name, 
t1.last_name, 
COUNT(t2.film_id) AS film_count
FROM actor AS t1
JOIN film_actor AS t2 
ON t1.actor_id = t2.actor_id
GROUP BY  t1.first_name, t1.last_name
ORDER BY film_count DESC
LIMIT 1;
-- Cau 6:
SELECT COUNT(*) 
FROM address AS t1
LEFT JOIN customer AS t2 
ON t1.address_id = t2.address_id
WHERE t2.customer_id IS NULL;
-- Cau 7:
SELECT t4.city, SUM(t1.amount) 
FROM payment AS t1
JOIN customer AS t2 
ON t1.customer_id = t2.customer_id
JOIN address AS t3 
ON t2.address_id = t3.address_id
JOIN city AS t4 
ON t3.city_id = t4.city_id
GROUP BY t4.city
ORDER BY SUM(t1.amount) DESC
LIMIT 1;
-- Cau 8:
SELECT CONCAT(t5.country, ', ', t4.city) AS location, SUM(t1.amount) AS revenue
FROM payment AS t1
JOIN customer AS t2 
ON t1.customer_id = t2.customer_id
JOIN address AS t3 
ON t2.address_id = t3.address_id
JOIN city AS t4 
ON t3.city_id = t4.city_id
JOIN country AS t5 
ON t4.country_id = t5.country_id
GROUP BY location
ORDER BY revenue ASC
LIMIT 1;

