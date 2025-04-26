--EX1: http://datalemur.com/questions/sql-histogram-tweets
SELECT count(distinct user_id) as users_num, 
tweet_bucket
FROM(
  SELECT
  count(distinct tweet_id) as tweet_bucket,
  user_id
  FROM tweets
  where EXTRACT(year from tweet_date )=2022 
  group by user_id
  ) as aggregate
group by tweet_bucket
;
--EX2: http://datalemur.com/questions/duplicate-job-listings
select count(duplicate_companies) as duplicate_companies
from(
  select
  count(company_id) as duplicate_companies
  from job_listings
  group by title, company_id
  having count(title)>1 and count(company_id)>1
  ) as aggregate
;
-- EX3:https://www.hackerrank.com/challenges/weather-observation-station-19/problem?isFullScreen=true
/*
 - Carefully read the problem to identify the goal (e.g., retrieve data, calculate a value, filter records): calculate Euclidean Distance: d(p,q)=sqrt(sqr(q1-p1)+sqr(q2-p2))
   - Identify the key components:
     Input data: What tables and columns are involved?
     STATION, LAT_N, LONG_W
     Output requirements: What should the query return?
      Euclidean Distance
     Constraints: Are there filters or conditions?
    min, max, round
*/
select
round(sqrt(power(min(LAT_N)-max(LAT_N),2)+power(min(LONG_W)-max(LONG_W),2)),4) as euclidean_distance
from STATION
-- power(a,x): a lũy thừa x
-- sqrt: căng bậc 2
