-- ============================================
-- Bank Customer Churn Analysis
-- Author: Ehtesham Ali Khan
-- Date: 19 March 2026
-- Dataset: e-commerce-operation-analysis.bank_customer_churn.bank
-- Tool: Google BigQuery
-- ============================================




SELECT * FROM `e-commerce-operation-analysis.bank_customer_churn.bank` LIMIT 1000;

--Query1 - Overall  churn Rate
-- Result: 20.37% of customers have churned
SELECT
  COUNTIF(churn = 1) AS churned_customers,
  COUNT(*) AS total_customers,
  ROUND(COUNTIF(churn = 1) / COUNT(*) * 100, 2) AS churn_rate_pct
FROM `e-commerce-operation-analysis.bank_customer_churn.bank`;

--Query 2 - churn rate by country
-- Result: Germany 32.44%, Spain 16.67%, France 16.15%
SELECT
  country,
  COUNT(*) AS total,
  COUNTIF(churn = 1) AS churned,
  ROUND(COUNTIF(churn = 1) / COUNT(*) * 100, 2) AS churn_rate_pct
FROM `e-commerce-operation-analysis.bank_customer_churn.bank`
GROUP BY country
ORDER BY churn_rate_pct DESC;

--Query 3 - churn by Age group
-- Result: Age 46-60 highest at 51.12%
SELECT
  CASE
    WHEN age < 30 THEN 'Under 30'
    WHEN age BETWEEN 30 AND 45 THEN '30-45'
    WHEN age BETWEEN 46 AND 60 THEN '46-60'
    ELSE 'Over 60'
  END AS age_group,
  COUNT(*) AS total,
  COUNTIF(churn = 1) AS churned,
  ROUND(COUNTIF(churn = 1) / COUNT(*) * 100, 2) AS churn_rate_pct
FROM `e-commerce-operation-analysis.bank_customer_churn.bank`
GROUP BY age_group
ORDER BY churn_rate_pct DESC;

--Query 4 Churn by no of products
-- Result: 4-product customers = 100% churn, 2-product = 7.58% (sweet spot)
SELECT
  products_number,
  COUNT(*) AS total,
  COUNTIF(churn = 1) AS churned,
  ROUND(COUNTIF(churn = 1) / COUNT(*) * 100, 2) AS churn_rate_pct
FROM `e-commerce-operation-analysis.bank_customer_churn.bank`
GROUP BY products_number
ORDER BY products_number;

--Query 5 - Average profile churned vs Retained
-- Result: Churned customers hold £18k more on average
SELECT
  CASE WHEN churn = 1 THEN 'Churned' ELSE 'Retained' END AS status,
  ROUND(AVG(balance), 2) AS avg_balance,
  ROUND(AVG(credit_score), 2) AS avg_credit_score,
  ROUND(AVG(age), 1) AS avg_age,
  ROUND(AVG(tenure), 1) AS avg_tenure
FROM `e-commerce-operation-analysis.bank_customer_churn.bank`
GROUP BY status;

--Query 6 - High risk lost customers 
-- Result: Top 20 losses = £3.8M+ in deposits, all inactive
SELECT
  customer_id,
  age,
  country,
  balance,
  products_number,
  active_member,
  credit_score,
  churn
FROM `e-commerce-operation-analysis.bank_customer_churn.bank`
WHERE
  age BETWEEN 40 AND 60
  AND balance > 100000
  AND active_member = 0
  AND churn = 1
ORDER BY balance DESC
LIMIT 20;

--Query 7 Active vs Inactive churn rate 
-- Result: Inactive churn 26.85% vs Active 14.27% (nearly 2x)
SELECT
  active_member,
  COUNT(*) AS total,
  COUNTIF(churn = 1) AS churned,
  ROUND(COUNTIF(churn = 1) / COUNT(*) * 100, 2) AS churn_rate_pct
FROM `e-commerce-operation-analysis.bank_customer_churn.bank`
GROUP BY active_member;