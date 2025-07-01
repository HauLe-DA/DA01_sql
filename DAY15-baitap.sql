ex1: datalemur-yoy-growth-rate: https://datalemur.com/questions/yoy-growth-rate 
WITH curr_year_transactions AS(
SELECT 
EXTRACT(YEAR FROM transaction_date) AS year,
product_id,
SUM(spend) OVER(PARTITION BY product_id, EXTRACT(YEAR FROM transaction_date)) AS curr_year_spend
FROM user_transactions)
SELECT year,
product_id,
curr_year_spend,
LAG(curr_year_spend) OVER(PARTITION BY product_id) AS prev_year_spend,
ROUND(((curr_year_spend/LAG(curr_year_spend) OVER(PARTITION BY product_id))-1)*100.0,2) AS yoy_rate
FROM curr_year_transactions
;
ex2: datalemur-card-launch-success: https://datalemur.com/questions/card-launch-success 
ex3: datalemur-third-transaction: https://datalemur.com/questions/sql-third-transaction 
ex4: datalemur-histogram-users-purchases: https://datalemur.com/questions/histogram-users-purchases 
ex5: datalemur-rolling-average-tweets: https://datalemur.com/questions/rolling-average-tweets 
ex6: datalemur-repeated-payments: https://datalemur.com/questions/repeated-payments 
ex7: datalemur-highest-grossing: https://datalemur.com/questions/sql-highest-grossing 
ex8: datalemur-top-fans-rank: https://datalemur.com/questions/top-fans-rank
