
CREATE DATABASE sql_project_p1;

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

use sql_project_p1;

-- data exploration 

-- how many sales we have ?
select count(*) as total_sales from retail_sales;

-- how many unique customers we have ?
select count( distinct customer_id) as total_sale 
from retail_sales;

select distinct category from retail_sales;

-- data analysis & business key problems and solution
** Q1.  write a sql query to retrieve all column for sales made on '2022-11-05'** 

select count(*)
from retail_sales
where sale_date = '2022-11-05' ;

-- Q2. write a sql query to retrive all transaction where the category is 'clothing' and the quantity  
-- is sold more than 10 in month of nov-2022. 

select *
from retail_sales
where category = 'clothing' and quantiy >= 4
having sale_date between '2022-11-01' and '2022-11-30';


-- Q3. write a sql query to calculate the total sales( total_sales) for each category .

select category ,sum(total_sale) as net_sale ,count(*) as total_sales
from retail_sales
group by category;

-- Q4. write a sql query to find the average age of customers who purchased item from the 'beauty' category.
 
 select round(avg(age),2) as age
 from retail_sales
 where category = 'Beauty';
 
 -- Q5. write a sql query to find all transaction   where the total_sale is greater than 1000.

select *
from retail_sales
where total_sale > 1000;

-- Q6. write a sql query  to find the total number of transaction(transaction_id) made by each gender in each category.

select category , gender,count(transactions_id) 
from retail_sales
group by category, gender;

-- Q7. write a sql query to calculate the average sale  for each month. find out best selling month in each year.

select year , month , avg_sale
from
(select  year(sale_date) as year ,month(sale_date) as month, avg(total_sale) as avg_sale,
        rank() over(partition by year(sale_date) order by avg(total_sale) desc) as rn
from retail_sales
group by year , month ) as t1
where t1.rn = 1;

-- Q8. write a sql query to find the top 5 customers based on the highest total sale.

select customer_id , sum(total_sale) as total_sales
from retail_sales
group by customer_id 
order by total_sales desc limit 5;

-- Q9. write a sql query to find the unique customers who purchased item from each category.

select category, count(distinct customer_id) as no_of_customers
from retail_sales
group by category;

-- Q10. write a sql query to create each shift and number of order(example morning <=12 , afternoon between 12 & 17 , evening  > 17)
with hourly_sale
as(
select *, 
case 
    when hour(sale_time) <12 then 'Morning'
    when hour(sale_time) between 12 and 17 then 'Afternoon'
    when hour(sale_time) >17 then 'evening'
    end as shift
from retail_sales )

select shift , count(*) as total_orders
from hourly_sale
group by shift
