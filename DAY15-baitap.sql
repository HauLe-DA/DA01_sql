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
LAG(curr_year_spend) OVER(PARTITION BY product_id ORDER BY year ) AS prev_year_spend,
ROUND(((curr_year_spend/LAG(curr_year_spend) OVER(PARTITION BY product_id ORDER BY year))-1)*100.0,2) AS yoy_rate
FROM curr_year_transactions
;
ex2: datalemur-card-launch-success: https://datalemur.com/questions/card-launch-success 
SELECT
a.card_name,
a.issued_amount
FROM 
(SELECT 
card_name,
issued_amount,
issue_year,
issue_month,
ROW_NUMBER()OVER(PARTITION BY card_name ORDER BY issue_year,issue_month) AS rank
FROM monthly_cards_issued) AS a
WHERE rank=1 
ORDER BY a.issued_amount DESC ;
ex3: datalemur-third-transaction: https://datalemur.com/questions/sql-third-transaction 
SELECT
user_id,
spend,
transaction_date
FROM(SELECT 
user_id,
spend,
ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date, user_id) AS RANK,
transaction_date
FROM transactions) A
WHERE RANK =3;
ex4: datalemur-histogram-users-purchases: https://datalemur.com/questions/histogram-users-purchases
  --cte+ JOIN:
  WITH recent_transaction 
AS(SELECT MAX(transaction_date) AS transaction_date,
user_id
FROM user_transactions
GROUP BY user_id 
ORDER BY transaction_date ASC)
SELECT A.transaction_date,
A.user_id,
COUNT(B.product_id) AS purchase_count
FROM recent_transaction A 
LEFT JOIN user_transactions B
ON A.user_id=B.user_id AND A.transaction_date=B.transaction_date
GROUP BY A.transaction_date, A.user_id;
-- WINDOW FUNCTION
SELECT
A.transaction_date,
A.user_id,
A.purchase_count
FROM (SELECT 
user_id,
transaction_date,
COUNT(product_id) OVER(PARTITION BY user_id, transaction_date) AS purchase_count,
ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date DESC) AS RANK
FROM user_transactions) A
WHERE A.RANK=1
ORDER BY A.transaction_date ;
ex5: datalemur-rolling-average-tweets: https://datalemur.com/questions/rolling-average-tweets 
ex6: datalemur-repeated-payments: https://datalemur.com/questions/repeated-payments 
ex7: datalemur-highest-grossing: https://datalemur.com/questions/sql-highest-grossing 
ex8: datalemur-top-fans-rank: https://datalemur.com/questions/top-fans-rank
