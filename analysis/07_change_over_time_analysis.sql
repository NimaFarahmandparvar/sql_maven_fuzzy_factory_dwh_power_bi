/*
===================================================================
Change-over-time Analysis
===================================================================
Purpose:
	This query analyzes key metrics over time in order to track
	trends, growth and changes over time.
===================================================================
*/

-- To analyze yearly sales performance over time.
select
	year(date_time) as year,
	sum(price_usd) as total_sales
from silver.orders
group by year(date_time)

-- To analyze monthly sales performance through years.
select
	cast(datetrunc(month, date_time) as date) as year_month,
	sum(price_usd) as total_sales
from silver.orders
group by cast(datetrunc(month, date_time) as date)
order by cast(datetrunc(month, date_time) as date)

-- To analyze monthly sales performance over time.
select
	month(date_time) as month,
	sum(price_usd) as total_sales
from silver.orders
group by month(date_time)
order by month(date_time)
