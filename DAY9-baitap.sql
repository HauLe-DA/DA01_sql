-- BAI TAP 1: https://datalemur.com/questions/laptop-mobile-viewership
SELECT 
    SUM(CASE WHEN device_type = 'laptop' THEN 1 ELSE 0 END) AS laptop_views,
    SUM(CASE WHEN device_type IN ('tablet', 'phone') THEN 1 ELSE 0 END) AS mobile_views
FROM viewership;

-- BAI TAP 2: http://leetcode.com/problems/triangle-judgement/description/?envType=study-plan-v2&envId=top-sql-50
SELECT x, y, z,
       CASE 
           WHEN x + y > z AND x + z > y AND y + z > x THEN 'Yes'
           ELSE 'No'
       END AS triangle
FROM Triangle;

-- BAI TAP 3: https://datalemur.com/questions/uncategorized-calls-percentage
SELECT 
    ROUND(
        100.0 * SUM(CASE WHEN call_category IS NULL OR call_category = 'n/a' THEN 1 ELSE 0 END) 
        / COUNT(*), 1) AS uncategorized_call_pct
FROM callers;

-- BAI TAP 4: https://leetcode.com/problems/find-customer-referee/description/?envType=study-plan-v2&envId=top-sql-50
SELECT name
FROM Customer
WHERE referee_id != 2 OR referee_id IS NULL;

-- BAI TAP 5: https://platform.stratascratch.com/coding/9881-make-a-report-showing-the-number-of-survivors-and-non-survivors-by-passenger-class?code_type=1
SELECT 
    survived,
    SUM(CASE WHEN pclass = 1 THEN 1 ELSE 0 END) AS first_class,
    SUM(CASE WHEN pclass = 2 THEN 1 ELSE 0 END) AS second_class,
    SUM(CASE WHEN pclass = 3 THEN 1 ELSE 0 END) AS third_class
FROM titanic
GROUP BY survived;

