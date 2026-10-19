/*
===============================================================================
Part-to-whole Analysis
===============================================================================
Purpose:
    - To analyze the contribution of each product to total sales and quantity.
===============================================================================
*/

with base_query as (
select
    p.product_name,
    oi.product_id,
    price_usd,
    cogs_usd
from silver.order_items as oi
join silver.products as p
on p.product_id = oi.product_id
)

, aggregated_query as (
select
    product_name,
    count(product_id) as total_quantity_sold,
    sum(count(product_id)) over() as all_products_quantity_sold,
    sum(price_usd) as total_sales,
    sum(sum(price_usd)) over() as all_products_sales,
    sum(cogs_usd) as total_costs,
    sum(sum(cogs_usd)) over() as all_products_costs
from base_query
group by product_name
)

select
    product_name,
    total_quantity_sold,
    all_products_quantity_sold,
    cast(cast(total_quantity_sold as decimal(10,2)) * 100/ all_products_quantity_sold as decimal(10,2)) as quantity_percentage,
    total_sales,
    all_products_sales,
    cast(cast(total_sales as decimal(10,2)) * 100/ all_products_sales as decimal(10,2)) as sales_percentage,
    total_costs,
    all_products_costs,
    cast(cast(total_costs as decimal(10,2)) * 100/ all_products_costs as decimal(10,2)) as costs_percentage
from aggregated_query
order by total_sales desc
