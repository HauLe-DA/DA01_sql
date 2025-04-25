-- BAI TAP 1: https://www.hackerrank.com/challenges/more-than-75-marks/problem?isFullScreen=true
SELECT  
Name
FROM STUDENTS
WHERE Marks >75  
ORDER BY RIGHT(Name,3), ID
-- BAI TAP 2: https://leetcode.com/problems/fix-names-in-a-table/?envType=study-plan-v2&envId=top-sql-50
SELECT user_id,
CONCAT(UPPER(SUBSTRING(name FROM 1 FOR 1)), LOWER(SUBSTRING(name FROM 2 FOR LENGTH(name)-1))) AS name
FROM Users
ORDER BY user_id;
-- BAI TAP 3: https://datalemur.com/questions/total-drugs-sales
SELECT manufacturer, 
'$'||round(sum(total_sales)/1000000) || ' million' as total_sale
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY sum(total_sales) desc ;
-- BAI TAP 4: https://datalemur.com/questions/sql-avg-review-ratings

SELECT   
extract(month from submit_date) as mth,
product_id,
ROUND(AVG(stars),2) as avg_stars
FROM reviews
GROUP BY product_id, mth
ORDER BY mth, product_id ;
-- BAI TAP 5: https://datalemur.com/questions/teams-power-users
SELECT sender_id,
count(content) as count_message
FROM messages
where extract(month from sent_date)=8 
and extract(year from sent_date)=2022--sent_date between '08/01/2022'and '09/01/2022'
group by sender_id
order by count_message DESC
limit 2;
-- BAI TAP 6: https://leetcode.com/problems/invalid-tweets/?envType=study-plan-v2&envId=top-sql-50
select tweet_id
from Tweets
where length(content)>15;
-- BAI TAP 7: https://leetcode.com/problems/user-activity-for-the-past-30-days-i/description/?envType=study-plan-v2&envId=top-sql-50
select distinct 
activity_date as day,
count(distinct user_id) as active_users
from Activity
where activity_date between '2019-06-28' and'2019-07-27'
group by activity_date 
having count(distinct user_id)>=1
; 
-- BAI TAP 8: https://platform.stratascratch.com/coding/2151-number-of-hires-during-specific-time-period?code_type=1
select 
count(id) as number_of_employee
from employees
where extract(month from joining_date ) between 1 and 7
and extract(year from joining_date) =2022
--where joining_date between '01=01-2022' and '07-31-2022';
-- BAI TAP 9: https://platform.stratascratch.com/coding/9829-positions-of-letter-a?code_type=1
select 
position('a' in first_name) as position
from worker
where first_name='Amitah';
-- BAI TAP 10: https://platform.stratascratch.com/coding/10039-macedonian-vintages?code_type=1
select title,
substring(title from length(winery)+1 for 5) :: int as year
from winemag_p2
where country ='Macedonia' ;
