CREATE DATABASE Bakery_Sales;

# Inserted the data with the Table Data Import Wizard

SELECT * FROM Bakery_Sales.bakery_sales_revised;

SELECT distinct period_day FROM bakery_sales_revised;
SELECT distinct weekday_weekend FROM bakery_sales_revised;

ALTER TABLE bakery_sales_revised
ADD COLUMN date DATE,
ADD COLUMN time TIME;
UPDATE bakery_sales_revised
SET
	date = STR_TO_DATE(SUBSTRING_INDEX(date_time, ' ', 1), '%m/%d/%Y'),
    time = STR_TO_DATE(SUBSTRING_INDEX(date_time, ' ', -1), '%H:%i');

CREATE TABLE transactions (
	transaction_id INT PRIMARY KEY, 
    transaction_date DATE,
    transaction_time TIME,
    period_day VARCHAR(30),
    weekday_weekend VARCHAR(30)
);

INSERT INTO transactions (transaction_id, transaction_date, transaction_time, period_day, weekday_weekend)
SELECT DISTINCT Transaction, date, time, period_day, weekday_weekend FROM bakery_sales_revised;

CREATE TABLE items (
	item_id INT auto_increment primary key,
    item_name VARCHAR(50)
);

INSERT INTO items (item_name)
SELECT DISTinct Item FROM bakery_sales_revised;

CREATE TABLE sales (
	sale_id INT auto_increment primary key,
    transaction_id INT,
    item_id INT,
    FOREign KEY (transaction_id) REFERENCES transactions(transaction_id),
    FOREIGN KEY (item_id) REFERENCES items(item_id)
    );
    
INSERT INTO sales (transaction_id, item_id)
SELECT t.transaction_id, i.item_id
FROM bakery_sales_revised bs
JOIN items i ON bs.Item = i.item_name
JOIN transactions t ON bs.Transaction = t.transaction_id;


