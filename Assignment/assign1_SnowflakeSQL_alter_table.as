/* ASSIGNMENT */

use database DEMO_DATABASE;
CREATE OR REPLACE TABLE SA_SALES_DATA
(order_id VARCHAR(50) ,
order_date DATE,
ship_date DATE,
ship_mode VARCHAR(40),
customer_name VARCHAR(50) PRIMARY KEY, 	
segment VARCHAR(30),	
state VARCHAR(80),	
country VARCHAR(80),	
market VARCHAR(30),
region VARCHAR(80),	
product_id VARCHAR(50),	
category VARCHAR(40),	
sub_category VARCHAR(40),	
product_name VARCHAR(200),	 
sales NUMBER(10,3),	
quantity NUMBER(10,3),	
discount NUMBER(10,3),	 
profit NUMBER(10,3), 	 
shipping_cost NUMBER(10,3), 	
order_priority VARCHAR(30),	
year VARCHAR(20));

-- 1. set primary key 

SELECT*FROM SA_SALES_DATA;

alter table SA_SALES_DATA 
drop PRIMARY KEY;

alter table SA_SALES_DATA
add primary key (order_id);

describe table SA_SALES_DATA;

-- 2. Checking order_date and ship_date type // "Done while creating and updating table" //

-- 3. Extract number after second '-' of order_id 
-- HAVE TO TAKE SUBSTRING

create or replace table SA_SALES_DATA_COPY as
select* from SA_SALES_DATA;

select * from SA_SALES_DATA_COPY;

select order_id, substring(order_id, 9, 10)
from SA_SALES_DATA_COPY;

alter table SA_SALES_DATA_COPY
add column order_id_lastdigit VARCHAR(20);

UPDATE SA_SALES_DATA_COPY
set order_id_lastdigit = substring(order_id, 9, 10);
 
-- 4. flag discount

alter table SA_SALES_DATA_COPY
add column flag_discount VARCHAR(10);

update SA_SALES_DATA_COPY
set flag_discount = 'YES' where discount > 0;

update SA_SALES_DATA_COPY
set flag_discount = 'FALSE' where discount = 0;


-- 5. finding profit // "Given in the table already" //

-- 6. Find date difference of order_date and shipment_date as processing days

select order_date, ship_date, datediff(day, order_date, ship_date) as diff_in_order_ship 
from SA_SALES_DATA_COPY;

alter table SA_SALES_DATA_COPY
add column processing_days varchar(10);
 
DESCRIBE TABLE SA_SALES_DATA_COPY;

update  SA_SALES_DATA_COPY
set processing_days = datediff(day, order_date, ship_date);

-- 7. Flag Processing days

alter table SA_SALES_DATA_COPY
add column flag_processing_days VARCHAR(10);

update SA_SALES_DATA_COPY
set flag_processing_days = '5' where processing_days <= 3;

update SA_SALES_DATA_COPY
set flag_processing_days = '4' where processing_days > 3 and processing_days <= 6;

update SA_SALES_DATA_COPY
set flag_processing_days = '3' where processing_days > 6 and processing_days <= 10;

update SA_SALES_DATA_COPY
set flag_processing_days = '2' where processing_days > 10;