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
SELECT user_id,
tweet_date,
ROUND(AVG(tweet_count) OVER(PARTITION BY user_id ORDER BY tweet_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS rolling_avg_3d 
FROM tweets 
;
ex6: datalemur-repeated-payments: https://datalemur.com/questions/repeated-payments 
WITH LAGGED AS
(SELECT 
transaction_id,
merchant_id,
credit_card_id,
amount,
transaction_timestamp,
LAG(transaction_timestamp) 
OVER(PARTITION BY merchant_id, credit_card_id, amount ORDER BY transaction_timestamp) AS prev_timestamp
FROM transactions)
SELECT
COUNT(merchant_id) AS payment_count
FROM LAGGED
WHERE prev_timestamp IS NOT NULL
AND EXTRACT(EPOCH FROM (transaction_timestamp-prev_timestamp))/60<=10
; 
ex7: datalemur-highest-grossing: https://datalemur.com/questions/sql-highest-grossing 
WITH total_spend 
AS(
SELECT category,
product,
SUM(spend) AS total_spend
FROM product_spend
WHERE EXTRACT(YEAR FROM transaction_date)='2022'
GROUP BY category, product),
rank AS(
SELECT category,
product,
RANK() OVER(PARTITION BY category ORDER BY total_spend DESC) AS rank,
total_spend
FROM total_spend)
SELECT category,
product,
total_spend
FROM rank
WHERE rank<=2
;
ex8: datalemur-top-fans-rank: https://datalemur.com/questions/top-fans-rank
WITH top_10_cte AS(
SELECT a.artist_name, 
DENSE_RANK() OVER(ORDER BY COUNT(c.song_id) DESC) AS artist_rank 
FROM artists AS a
INNER JOIN songs AS b ON a.artist_id=b.artist_id
INNER JOIN global_song_rank AS c ON b.song_id=c.song_id
WHERE c.rank<=10
GROUP BY a.artist_name)
SELECT artist_name, artist_rank
FROM top_10_cte
WHERE artist_rank <= 5;
