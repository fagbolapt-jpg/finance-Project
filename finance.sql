-- Data cleaning


SELECT COUNT(*)
FROM finance_transaction_staging;

SELECT
 transaction_id,
 COUNT(*) AS duplicate_count
 FROM finance_transaction_staging
 GROUP BY transaction_id
 HAVING COUNT(*) > 1;
 
 SELECT
    COUNT(*) AS total_rows,
    SUM(transaction_id IS NULL) AS missing_transaction_id,
    SUM(transaction_date IS NULL) AS missing_transaction_date,
    SUM(account_id IS NULL) AS missing_account_id,
    SUM(customer_id IS NULL) AS missing_customer_id,
    SUM(transaction_type IS NULL) AS missing_transaction_type,
    SUM(channel IS NULL) AS missing_channel,
    SUM(merchant_category IS NULL) AS missing_merchant_category,
    SUM(amount IS NULL) AS missing_amount,
    SUM(fee_amount IS NULL) AS missing_fee_amount,
    SUM(tax_amount IS NULL) AS missing_tax_amount,
    SUM(currency IS NULL) AS missing_currency,
    SUM(transaction_status IS NULL) AS missing_transaction_status,
    SUM(is_fraud IS NULL) AS missing_is_fraud,
    SUM(risk_score IS NULL) AS missing_risk_score,
    SUM(reference_no IS NULL) AS missing_reference_no
FROM finance_transaction_staging;

SELECT
    COUNT(*) AS total_rows,
    SUM(amount = 0) AS zero_amount,
    SUM(fee_amount = 0) AS zero_fee_amount,
    SUM(tax_amount = 0) AS zero_tax_amount,
    SUM(risk_score = 0) AS zero_risk_score
FROM finance_transaction_staging;


SHOW COLUMNS FROM
finance_transaction_staging
LIKE 'transaction_date';

ALTER TABLE 
finance_transaction_staging
MODIFY COLUMN transaction_date DATE;

SELECT transaction_date
FROM finance_transaction_staging
LIMIT 10;

SELECT DISTINCT transaction_type
FROM finance_transaction_staging
order by transaction_type;

SELECT DISTINCT `channel`
FROM finance_transaction_staging
ORDER BY `channel`;

SELECT DISTINCT merchant_category
FROM finance_transaction_staging
ORDER BY merchant_category;

SELECT DISTINCT currency
FROM finance_transaction_staging
ORDER BY currency;

SELECT DISTINCT transaction_status
FROM finance_transaction_staging
ORDER BY transaction_status;

SELECT DISTINCT is_fraud
FROM finance_transaction_staging
ORDER BY is_fraud;
SELECT DISTINCT
    `channel`,
    TRIM(`channel`) AS cleaned_value
FROM finance_transaction_staging
WHERE transaction_type <> TRIM(`channel`);

SELECT DISTINCT
  merchant_category,
    TRIM(merchant_category) AS cleaned_value
FROM finance_transaction_staging
WHERE transaction_type <> TRIM(merchant_category);

UPDATE finance_transaction_staging
SET `channel` =
UPPER(TRIM(`channel`));

UPDATE finance_transaction_staging
SET merchant_category =
UPPER(TRIM(merchant_category));

SELECT 
 `channel`,
 COUNT(*) AS total
 FROM finance_transaction_staging
 GROUP BY `channel`
 ORDER BY total DESC;
 
 UPDATE finance_transaction_staging
 SET `channel` = 'MOBILE APP'
 WHERE `channel` = 'M@BILE APP';

SELECT *
FROM finance_transaction_staging
WHERE amount < 0
   OR fee_amount < 0
   OR tax_amount < 0
   OR risk_score < 0;
   
   WITH quartiles AS (
    SELECT
        amount,
        NTILE(4) OVER (ORDER BY amount) AS quartile
    FROM finance_transaction_staging
),
iqr_values AS (
    SELECT
        MAX(CASE WHEN quartile = 1 THEN amount END) AS Q1,
        MAX(CASE WHEN quartile = 3 THEN amount END) AS Q3
    FROM quartiles
)
SELECT
    Q1,
    Q3,
    Q3 - Q1 AS IQR,
    Q1 - 1.5 * (Q3 - Q1) AS lower_bound,
    Q3 + 1.5 * (Q3 - Q1) AS upper_bound
FROM iqr_values;
SELECT *
FROM finance_transaction_staging
WHERE amount < -10910.065
   OR amount > 24507.575
ORDER BY amount;

SELECT
    transaction_type,
    transaction_status,
    COUNT(*) AS total
FROM finance_transaction_staging
WHERE amount > 24507.575
GROUP BY transaction_type, transaction_status
ORDER BY total DESC;

SELECT
    transaction_id,
    transaction_type,
    channel,
    amount ,
    transaction_status
FROM finance_transaction_staging
WHERE amount > 24507.575
ORDER BY amount DESC
LIMIT 20;

SELECT 
  transaction_type,
  COUNT(*) AS total_transaction,
  SUM(
        CASE  
        WHEN amount > 24507.575 THEN 1
        ELSE 0 
        END) AS high_outliers
	FROM finance_transaction_staging
    GROUP BY transaction_type
    ORDER BY high_outliers DESC;
    
    WITH quartiles AS (
    SELECT
        fee_amount,
        NTILE(4) OVER (ORDER BY fee_amount) AS quartile
    FROM finance_transaction_staging
),
iqr_values AS (
    SELECT
        MAX(CASE WHEN quartile = 1 THEN fee_amount END) AS Q1,
        MAX(CASE WHEN quartile = 3 THEN fee_amount END) AS Q3
    FROM quartiles
)
SELECT
    Q1,
    Q3,
    Q3 - Q1 AS IQR,
    Q1 - 1.5 * (Q3 - Q1) AS lower_bound,
    Q3 + 1.5 * (Q3 - Q1) AS upper_bound
FROM iqr_values;


SELECT *
FROM finance_transaction_staging
WHERE fee_amount < -21.960
   OR fee_amount > 36.600
ORDER BY fee_amount DESC;

CREATE TABLE 
finance_transaction_cleaned AS
SELECT * 
FROM finance_transaction_staging;

 UPDATE finance_transaction_cleaned
 SET currency = 'INR'
 WHERE currency = 'inr';