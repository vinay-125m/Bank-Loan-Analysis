USE Project_db;
SET GLOBAL local_infile = 1;
SELECT @@local_infile;

TRUNCATE TABLE financial_loan;

LOAD DATA LOCAL INFILE '/Users/mutyalavinay/Downloads/financial_loan.csv'
INTO TABLE financial_loan
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select count(*) from financial_loan;

Select * from financial_loan;

DESCRIBE financial_loan;

Alter table financial_loan
  ADD COLUMN issue_date_new DATE,
  ADD COLUMN last_credit_pull_date_new DATE,
  ADD COLUMN last_payment_date_new DATE,
  ADD COLUMN next_payment_date_new DATE;

SET SQL_SAFE_UPDATES = 0;

UPDATE financial_loan
SET issue_date_new            = STR_TO_DATE(NULLIF(TRIM(issue_date), ''), '%d-%m-%Y'),
    last_credit_pull_date_new = STR_TO_DATE(NULLIF(TRIM(last_credit_pull_date), ''), '%d-%m-%Y'),
    last_payment_date_new     = STR_TO_DATE(NULLIF(TRIM(last_payment_date), ''), '%d-%m-%Y'),
    next_payment_date_new     = STR_TO_DATE(NULLIF(TRIM(next_payment_date), ''), '%d-%m-%Y');

SET SQL_SAFE_UPDATES = 1;

SELECT COUNT(*) FROM financial_loan
WHERE issue_date IS NOT NULL AND issue_date <> '' AND issue_date_new IS NULL;

SELECT issue_date, issue_date_new FROM financial_loan LIMIT 10;

ALTER TABLE financial_loan
  DROP COLUMN issue_date,
  DROP COLUMN last_credit_pull_date,
  DROP COLUMN last_payment_date,
  DROP COLUMN next_payment_date;

ALTER TABLE financial_loan
  RENAME COLUMN issue_date_new TO issue_date,
  RENAME COLUMN last_credit_pull_date_new TO last_credit_pull_date,
  RENAME COLUMN last_payment_date_new TO last_payment_date,
  RENAME COLUMN next_payment_date_new TO next_payment_date;
  
  Describe financial_loan;

select count(id) as total_loan_applications 
from financial_loan;

select count(id) as MTD_total_applications 
from financial_loan
where month(issue_date) = 12 and year(issue_date) = 2021;

select count(id) as PMTD_total_applications 
from financial_loan
where month(issue_date) = 11 and year(issue_date) = 2021;

select sum(loan_amount) as Total_funded_amount from financial_loan;

select sum(loan_amount) as MTD_Total_funded_amount from financial_loan
where month(issue_date)= 12 and year(issue_date)=2021;

select sum(loan_amount) as PMTD_Total_funded_amount from financial_loan
where month(issue_date)= 11 and year(issue_date)=2021;

select sum(total_payment) as Total_amount_received from financial_loan;

select sum(total_payment) as MTD_Total_amount_received from financial_loan
where month(issue_date)= 12 and year(issue_date)=2021;

select sum(total_payment) as PMTD_Total_amount_received from financial_loan
where month(issue_date)= 11 and year(issue_date)=2021;

select round(avg(int_rate)*100,2) as average_interest from financial_loan;

select round(avg(int_rate)*100,2) as MTD_average_interest from financial_loan
where month(issue_date)= 12 and year(issue_date)=2021;

select round(avg(int_rate)*100,2) as PMTD_average_interest from financial_loan
where month(issue_date)= 11 and year(issue_date)=2021;

select round(avg(dti)*100,2) as Avg_DTI from financial_loan;

select round(avg(dti)*100,2) as MTD_Avg_DTI from financial_loan
where month(issue_date)= 12 and year(issue_date)=2021;

select round(avg(dti)*100,2) as PMTD_Avg_DTI from financial_loan
where month(issue_date)= 11 and year(issue_date)=2021;

Select round((count(case when loan_status='Fully Paid' or loan_status = 'Current' then id else Null end)/count(id))*100,2) as Good_loan_percentage
from financial_loan;

select count(id) as Good_loan_Applications from financial_loan
where loan_status = 'Fully Paid' or loan_status = 'Current';

select sum(loan_amount) as Good_loan_Funded_amount from financial_loan
where loan_status = 'Fully Paid' or loan_status = 'Current';

select sum(total_payment) as Good_loan_received_amount from financial_loan
where loan_status = 'Fully Paid' or loan_status = 'Current';

Select round((count(case when loan_status='Charged Off' then id else Null end)/count(id))*100,2) as Bad_loan_percentage
from financial_loan;

select count(id) as Bad_loan_Applications from financial_loan
where loan_status = 'Charged Off';

select sum(loan_amount) as Bad_loan_Funded_amount from financial_loan
where loan_status = 'Charged Off';

select sum(total_payment) as Bad_loan_received_amount from financial_loan
where loan_status = 'Charged Off';

select 
    loan_status,
    count(id) as Total_loan_applications,
    sum(loan_amount) as Total_funded_amount,
    sum(total_payment) as Total_received_amount,
    round(avg(int_rate)*100,2) as Avg_interest_rate,
    round(avg(dti)*100,2) as Avg_DTI
from financial_loan
group by loan_status;

select
    loan_status,
    sum(loan_amount) as MTD_Total_funded_amount,
    sum(total_payment) as MTD_Total_received_amount
from financial_loan
where month(issue_date)=12 and year(issue_date)= 2021
group by loan_status;

select 
    MONTH(issue_date) as Mon,
	MONTHNAME(issue_date) as Month_name,
    count(id) as Total_applications,
    sum(loan_amount) as total_funded_amount,
    sum(total_payment) as total_received_amount
from financial_loan
group by Mon, Month_name
order by Mon;

select 
    address_state,
    count(id) as Total_applications,
    sum(loan_amount) as total_funded_amount,
    sum(total_payment) as total_received_amount
from financial_loan
group by address_state
order by total_funded_amount desc;

select 
    term,
    count(id) as Total_applications,
    sum(loan_amount) as total_funded_amount,
    sum(total_payment) as total_received_amount
from financial_loan
group by term
order by term;

select 
    emp_length,
    count(id) as Total_applications,
    sum(loan_amount) as total_funded_amount,
    sum(total_payment) as total_received_amount
from financial_loan
group by emp_length
order by emp_length;

select 
    purpose,
    count(id) as Total_applications,
    sum(loan_amount) as total_funded_amount,
    sum(total_payment) as total_received_amount
from financial_loan
group by purpose
order by Total_applications desc;

select 
    home_ownership,
    count(id) as Total_applications,
    sum(loan_amount) as total_funded_amount,
    sum(total_payment) as total_received_amount
from financial_loan
group by home_ownership
order by Total_applications desc;

