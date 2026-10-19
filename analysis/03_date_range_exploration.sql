/*
=======================================================================
Date Range Exploration
=======================================================================
Purpose:
	This query explores the date range of 'orders' to identify
	the first and the last order dates.

Analysis:
	-- To identify the date and time of the first and the last orders.
=======================================================================
*/

-- What are the first and the last order dates?
select
	cast(min(date_time) as date) as min_date,
	cast(max(date_time) as date) as max_date,
	cast(datediff(month, min(date_time), max(date_time)) as nvarchar) + ' months' as difference
from silver.orders
