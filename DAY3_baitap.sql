-- BAI TAP 1
SELECT NAME FROM CITY
WHERE POPULATION > 120000
AND COUNTRYCODE ='USA'
;
--BAI TAP 2
SELECT * FROM CITY
WHERE COUNTRYCODE ='JPN'
;
-- BAI TAP 3
SELECT CITY, STATE FROM STATION
;
--BAI TAP 4
SELECT DISTINCT CITY FROM STATION
WHERE CITY LIKE 'A%' 
OR CITY LIKE 'E%'
OR CITY LIKE 'I%'
OR CITY LIKE 'O%'
OR CITY LIKE 'U%'
;
-- BAI TAP 5
SELECT DISTINCT CITY FROM STATION
WHERE CITY LIKE '%A' 
OR CITY LIKE '%E'
OR CITY LIKE '%I'
OR CITY LIKE '%O'
OR CITY LIKE '%U'
;
-- BAI TAP 6
SELECT DISTINCT CITY FROM STATION
WHERE NOT (CITY LIKE 'A%' 
OR CITY LIKE 'E%'
OR CITY LIKE 'I%'
OR CITY LIKE 'O%'
OR CITY LIKE 'U%')
;
-- BAI TAP 7
SELECT name FROM Employee
ORDER BY name 
;
-- BAI TAP 8
SELECT name FROM Employee
WHERE salary >2000
AND months <10
ORDER BY employee_id
;
-- BAI TAP 9
SELECT product_id FROM Products
WHERE low_fats ='Y' 
AND recyclable ='Y'
;
-- BAI TAP 10
SELECT name FROM Customer
WHERE referee_id <> 2 
OR referee_id IS NULL
;
-- BAI TAP 11
SELECT name, population, area FROM World
WHERE area>= 3000000 OR population >= 25000000
;
-- BAI TAP 12: Write a solution to find all the authors that viewed at least one of their own articles.
SELECT DISTINCT author_id AS id FROM Views
WHERE author_id = viewer_id -- indicate the same person, that means the author has viewed their own articles 
ORDER BY  id 
;
-- BAI TAP 13
SELECT part, assembly_step FROM parts_assembly
WHERE finish_date IS NULL
;
-- BAI TAP 14
SELECT * FROM lyft_drivers 
WHERE yearly_salary <= 30000 
OR yearly_salary >= 70000
;
-- BAI TAP 15
SELECT advertising_channel FROM uber_advertising
WHERE  money_spent > 100000 AND  year = 2019
;
