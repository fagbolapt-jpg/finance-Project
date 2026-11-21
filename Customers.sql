SELECT
 customer_id,
 COUNT(*) AS duplicate_count
 FROM customer_stagging
 GROUP BY customer_id
 HAVING COUNT(*) > 1;
 
 SELECT *
 FROM customer_stagging
 WHERE first_name OR second_name is NULL;
 
 SELECT *
 FROM customer_stagging
 WHERE customer_id IS NULL;
 
 SELECT distinct
   gender
   FROM customer_stagging;
   
   SELECT DISTINCT 
     city
	FROM customer_stagging;
    
    SELECT DISTINCT 
    state
    FROM customer_stagging;
    
    SELECT DISTINCT
    occupation
    FROM customer_stagging;
    
    SELECT DISTINCT 
     customer_segment
	FROM customer_stagging;
    
    SELECT *
    FROM customer_stagging
    LIMIT 10;
    
    SELECT 
    STR_TO_DATE ( date_of_birth,'%d-%m-%Y') AS date_of_birth,
    STR_TO_DATE ( join_date,'%d-%m-%Y') AS join_date
    FROM customer_stagging;
    
  

DESCRIBE customer_stagging;

CREATE TABLE customer_cleaned AS
 SELECT * FROM customer_stagging;
