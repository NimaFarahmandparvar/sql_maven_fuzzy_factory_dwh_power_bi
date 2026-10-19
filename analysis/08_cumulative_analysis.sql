/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running total for sales and costs.
    - To track performance over time cumulatively.
===============================================================================
*/

-- Calculating running total for sales and costs per month.

select
month,
total_sales,
sum(total_sales) over(order by month rows between unbounded preceding and current row) as running_total_sales,
total_costs,
sum(total_costs) over(order by month rows between unbounded preceding and current row) as running_total_costs
from (
    select
        cast(datetrunc(month, date_time) as date) as month,
        sum(price_usd) as total_sales,
        sum(cogs_usd) as total_costs
    from silver.orders
    group by cast(datetrunc(month, date_time) as date)
) t 
order by month
