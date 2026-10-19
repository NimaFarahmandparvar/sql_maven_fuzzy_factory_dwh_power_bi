/*
===============================================================================
Performance Analysis
===============================================================================
Purpose:
    - To track monthly sales performance trend.
===============================================================================
*/

with base_query as (
	select
	cast(datetrunc(month, oi.date_time) as date) as month,
	p.product_name,
	sum(price_usd) as current_month_sales
	from silver.order_items as oi
	join silver.products as p
	on p.product_id = oi.product_id
	group by cast(datetrunc(month, oi.date_time) as date), product_name
)
, aggregated_query as (
select
	month,
	product_name,
	current_month_sales,
	lag(current_month_sales) over(partition by product_name order by month) as last_month_sales,
	current_month_sales - lag(current_month_sales) over(partition by product_name order by month) as monthly_sales_difference,
	cast((current_month_sales - lag(current_month_sales) over(partition by product_name order by month)) * 100 / lag(current_month_sales) over(partition by product_name order by month) as decimal(10,2)) as monthly_change_percentage,
	avg(current_month_sales) over(partition by product_name) as monthly_average_sales
from base_query
)

select
	month,
	product_name,
	current_month_sales,
	last_month_sales,
	monthly_sales_difference,
	monthly_change_percentage,

	case when current_month_sales - last_month_sales > 0then 'Increase'
		 when current_month_sales - last_month_sales < 0 then 'Decrease'
		 when current_month_sales - last_month_sales = 0 then 'No Change'
		 else 'NULL'
	end as monthly_sales_change,

	monthly_average_sales,

	case when current_month_sales > monthly_average_sales then 'Above Average'
	     when current_month_sales < monthly_average_sales then 'Below Average'
		 when current_month_sales = monthly_average_sales then 'Above Average'
		 else 'Average'
	end as monthly_average_change
from aggregated_query
