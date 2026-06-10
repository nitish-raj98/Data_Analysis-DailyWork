select * from superstore_data;

ALTER TABLE  superstore_data
DROP column order_date;

alter table superstore_data
drop column ship_date;


SELECT category, SUM(sales) FROM superstore_data GROUP BY category;

select segment , sum(sales) from superstore_data group by segment;

select category, sales
from superstore_data
where discount_flag = "yes-discount" and sales >= (select avg(sales) from superstore_data);

SELECT sub_category, round(AVG(profit)) AS "Average_of_profit"
FROM superstore_data
GROUP BY sub_category
ORDER BY AVG(profit) DESC
LIMIT 5;

select * from superstore_data;

select ship_mode, avg(sales) from superstore_data where ship_mode in ("First Class","Second Class") group by ship_mode;

SELECT ship_mode, AVG(sales) AS "Average_Sales"
FROM superstore_data
GROUP BY ship_mode
ORDER BY AVG(sales) DESC;

select distinct(segment) from superstore_data;

select city, 
round(sum(sales),0) 
from superstore_data 
group by city 
order by sum(sales) desc 
limit 5;

WITH city_sales AS (
    SELECT city, ROUND(SUM(sales),0) AS Total_Sales
    FROM superstore_data
    GROUP BY city
)
SELECT city, Total_Sales
FROM city_sales
WHERE Total_Sales > 5000;

select * from superstore_data;

with item_counts as (
select category, sub_category,
count(product_id) as total_orders,
ROW_NUMBER() OVER (partition by category order by count(product_id) desc) as item_rank
from superstore_data
group by category, sub_category)
select category, sub_category, item_rank
from item_counts
where item_rank <= 3;

SELECT category, sub_category, item_rank
FROM (
    SELECT category, sub_category,
    ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT(product_id) DESC) AS item_rank
    FROM superstore_data
    GROUP BY category, sub_category
) AS ranked
WHERE item_rank <= 20;

select product_name, 
count(customer_name) as repeat_team
from superstore_data
where quantity > 10
group by product_name
order by repeat_team desc;

SELECT city,
round(sum(sales)) as total_cost
from superstore_data
group by city
order by total_cost desc
limit 5;


WITH avg_profit AS (
    SELECT AVG(profit) AS avg_val
    FROM superstore_data
)
SELECT customer_name, profit
FROM superstore_data, avg_profit
WHERE profit > avg_val;

select * from superstore_data;

with 
city_sales AS(
    select city, sum(sales) as total_sales
    from superstore_data
    group by city
),
state_sales As(
     select state, avg(sales) as avg_sales
     from  superstore_data
     group by state
)
select c.city, s.state 
from city_sales c
join state_sales s  on c.city =  s.state;

WITH
city_sales AS (
    SELECT city, state, SUM(sales) AS total_sales
    FROM superstore_data
    GROUP BY city, state         
),
state_sales AS (
    SELECT state, AVG(sales) AS avg_sales
    FROM superstore_data
    GROUP BY state
)
SELECT c.city, c.state, c.total_sales, s.avg_sales
FROM city_sales c
JOIN state_sales s ON c.state = s.state;


SELECT customer_name, sales,
row_number() OVER (ORDER BY sales DESC) AS rnk
FROM superstore_data;

SELECT customer_name, sales,
DENSE_RANK() OVER (ORDER BY sales DESC) AS dense_rnk
FROM superstore_data;

SELECT city, sales,
SUM(sales) OVER(PARTITION BY city) AS city_total_sales
FROM superstore_data;

SELECT category, product_name,
ROW_NUMBER() OVER (ORDER BY category asc) AS row_num,
COUNT(*) OVER (PARTITION BY category) AS category_count
FROM superstore_data;
