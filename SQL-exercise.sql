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
