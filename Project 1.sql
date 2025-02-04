
-- CREATE DATABASE sql project p1;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

-- Data cleaning

SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;




select *
from retail_sales;

 -- Q.1 write a sql querry to retrieve all columns for sales made on '2022-11-05'
 select *
 from retail_Sales 
 where sale_date = '2022-11-05'


 -- Q.2 write a sql querry to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of november
 select * 
from retail_sales
where category = 'Clothing'
	and 
	to_char(sale_date, 'yyyy-mm')='2022-11'
	and
	quantity >=4


-- Q.3 write a sql querry to calculate the total sales (total_sale) for each category
select 
	category,
	sum (total_sale) as net_sale,
	count (*) as total_orders
from retail_sales
group by 1


 -- Q.4 write a sql querry to find the average age of customers who purchased items from 'Beauty' category
select 
	round(avg (age), 2) as average_age
from retail_sales
where category = 'Beauty'


-- Q.5 write a sql querry to find all transactions where the total_sale is greater than 1000
select *
from retail_sales
where total_sale > 1000


-- Q.6 write a sql querry to find the total number of transactions (transactions_id) made by each gender in each category
select
	category,
	gender,
	count (*) as total_transactions
from retail_sales
group by 
	category,
	gender
group by 1


-- Q.7  write a sql querry to calculate the average sale for each month find out the best selling month in each year
select
	year,
	month,
	avg_sale
from 
(
	select 
		extract(year from sale_date) as year,
		extract(month from sale_date) as month,
		avg(total_sale) as avg_sale,
		rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
	from retail_sales
	group by 1, 2
) as t1 
where rank =1


-- Q.8  write a sql querry to find the top  customers based on the highest total sales
select 
	customer_id,
	sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc 
limit 5


-- Q.9 write a sql querry to find the number of unique ustomers who purchased items from each caategory
select 
	count(distinct customer_id) as unique_customers,
	category
from retail_sales
group by 2


--Q.10 write a sql querry to create shift and number of orders (Example Morning <=12, Afternoon 12 & 17, Evening >17)
with hourly_sale --ditambahkan with guna agar nanti 'shift' bisa digunakan untuk order by dan bisa di select
as
(
select *,
	case 
		when extract(hour from sale_time) <12 then 'Morning' 
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift
from retail_sales
)
select 
	shift,
	count (*) as total_orders
	from hourly_sale
	group by shift


--END OF THIS PART
