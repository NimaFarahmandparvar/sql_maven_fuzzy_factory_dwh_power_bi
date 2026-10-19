/*
===================================================================
Ranking Analysis
===================================================================
Purpose:
	To identify and rank the products and the categories by their 
	sales, costs, quantites sold, refunds and returns.
===================================================================
*/

-- Which products are top sellers?
select
	p.product_name,
	sum(oi.price_usd) as total_sales,
	dense_rank() over(order by sum(oi.price_usd) desc) as sales_rank
from silver.order_items as oi
join silver.products as p
on p.product_id = oi.product_id
group by p.product_name
order by sum(oi.price_usd) desc

-- What are the top products in quantity sold?
select
	p.product_name,
	count(oi.order_item_id) as total_quantity_sold,
	dense_rank() over(order by count(oi.order_item_id) desc) as quantity_sold_rank
from silver.order_items as oi
join silver.products as p
on p.product_id = oi.product_id
group by p.product_name
order by count(oi.order_item_id) desc

-- What are the most costly products?
select
	p.product_name,
	sum(oi.cogs_usd) as total_cost,
	dense_rank() over(order by sum(oi.cogs_usd) desc) as costly_rank
from silver.order_items as oi
join silver.products as p
on p.product_id = oi.product_id
group by p.product_name
order by sum(oi.cogs_usd) desc

-- What are the top products in returns?
select
	p.product_name,
	count(oir.order_item_refund_id) as total_returns,
	dense_rank() over(order by count(oir.order_item_refund_id) desc) as returns_rank
from silver.order_items as oi
join silver.products as p
on p.product_id = oi.product_id
join silver.order_item_refunds as oir
on oir.order_item_id = oi.order_item_id
group by p.product_name
order by count(oir.order_item_refund_id) desc

-- What are the top products in refunds?
select
	p.product_name,
	sum(oir.refund_amount_usd) as total_refunds,
	dense_rank() over(order by sum(oir.refund_amount_usd) desc) as refunds_rank
from silver.order_items as oi
join silver.products as p
on p.product_id = oi.product_id
join silver.order_item_refunds as oir
on oir.order_item_id = oi.order_item_id
group by p.product_name
order by sum(oir.refund_amount_usd) desc
