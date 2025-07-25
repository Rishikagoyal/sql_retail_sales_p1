drop table if exists retail_data;

create table retail_data(

transaction_id int primary key,
sale_data date,
sale_time time,
customer_id int,
gender varchar(10),
age int,
category varchar(15),
quantity int,
price_per_unit int,
cogs float,
total_sale int



);

select * from retail_data;

INSERT INTO retail_data(
transaction_id, sale_data, sale_time,customer_id,gender,age,category,quantity,price_per_unit,cogs, total_sale
)

Values(180, '2022-11-05', '10:47:00', 117, 'Male', 41, 'Clothing', 3, 300, 129, 900),
(522,	'2022-07-09',	'11:00:00',	52	,'Male',	46	,'Beauty',	3	,500,	145	,1500),
(559,	'2022-12-12',	'10:48:00',	5	,'Female',	40	,'Clothing',	4	,300	,84	,1200),
(1180,	'2022-01-06',	'8:53:00',	85,'Male',	41,	'Clothing',	3	,300,	129,	900),
(1522,	'2022-11-14',	'8:35:00',	48,	'Male',	46,	'Beauty',	3,	500,	235	,1500),
(1559,	'2022-08-20',	'7:40:00',	49,	'Female',	40,	'Clothing',	4,	300,	144,	1200),
(163,	'2022-10-31',	'9:38:00',	144,	'Female',	64,	'Clothing',	3,	50,	23,	150),
(303,	'2022-04-22',	'11:09:00',	54,	'Male',	19,	'Electronics',	3,	30,	14.7,	90),
(421,	'2022-04-08',	'8:43:00',	66,	'Female',	37,	'Clothing',	3,	500,	235,	1500),
(979,	'2022-05-18',	'10:18:00',	6,	'Female',	19,	'Beauty',	1,	25,	10.5,	25),
(1163,	'2022-05-04',	'10:52:00',	120,	'Female',	64,	'Clothing',	3,	50,	27,	150),
(1303,	'2022-03-19',	'8:59:00',	58,	'Male',	19,	'Electronics',	3,	30,	15,	90),
(1421,	'2022-01-17',	'7:07:00',	59,	'Female',	37,	'Clothing',	3,	500,	185,	1500),
(1979,	'2022-08-17',	'11:34:00',	102,	'Female',	19,	'Beauty',	1,	25,	7.75,	25),
(610,	'2022-12-18',	'6:56:00',	137,	'Female',	26,	'Beauty',	2,	300,	93,	600)



select TOP 10 * from retail_data;

-- Data cleaning
-- find the null value columns
select * from retail_data where 
transaction_id is null
or
sale_data is null
or
sale_time is null
or
customer_id is null
or
gender is null
or
age is null
or
category is null
or
quantity is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null

--delete if any null value is there 
delete from retail_data
where
transaction_id is null
or
sale_data is null
or
sale_time is null
or
customer_id is null
or
gender is null
or
age is null
or
category is null
or
quantity is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null
  
select count(*) from retail_data;


-- Data exploration

-- How many sales we have
select count(*) as Total_sales from retail_data;


-- How many customers we have?
select count(distinct customer_id) as Total_customers from retail_data;

-- How many categories we have?
select distinct category as Categories from retail_data;

-- Data Analysis & Business key problems & Answers

-- Retrieve all columns for sales made on "2022-11-05"

select * from retail_data where sale_data ='2022-11-05';

-- Retrieve all transactions where the category is 'clothing' and the quantity sold is more than 2 in the month of Nov-22

select * from retail_data where category ='Clothing' and quantity >2 and sale_data >='2022-11-01'and sale_data<='2022-11-30'; 

-- Calculate the total sales for each category

select category,sum(total_sale) as Total_sales from retail_data group by category;

-- Find average age of customers who purchased items from 'Beauty' category

select avg(age) as Average_age from retail_data where category ='Beauty';

-- Find all transactions where the total_sale is greater than 1000

select * from retail_data where total_sale >1000

-- Find total number of transactions made by each gender in each category

select category, gender, count(transaction_id) as transaction_count from retail_data group by category , gender order by 1;

-- Calculate the avg sale for each month. Find out the best selling month in each year.

select year,month, avg_total_sale from(select Year(sale_data) as year,month(sale_data) as month,avg(total_sale)as avg_total_sale ,rank() over(partition by year(sale_data) order by avg(total_sale) desc) as rank from retail_data group by Year(sale_data), Month(sale_data)) as t1 where rank =1

-- Find the top 5 customers based on the highest total sales

select TOP 5 customer_id, sum(total_sale) as total_sales  from retail_data group by customer_id order by 2 desc;

-- find the number of unique customers who purchased items from each category

select category, count(distinct customer_id) as count_unique_customer from retail_data group by category;

-- Create each shift and number of orders (morning <=12, afternoon between 12 & 17, evening>17)

with hourly_sales as
(select *,
    case 
	 when DATEPART(HOUR,sale_time)<12  then 'Morning'
	 when DATEPART(HOUR,sale_time) between 12 and 17 then 'afternoon'
	 else 'evening'
	end as shift

from retail_data) select shift, count(transaction_id) as total_orders from hourly_sales group by shift

-- end of project 