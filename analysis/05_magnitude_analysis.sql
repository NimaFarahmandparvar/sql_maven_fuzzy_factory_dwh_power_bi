/*
===================================================================
Magnitude Analysis
===================================================================
Purpose:
	This query analyzes key measures across product dimensions.

Analysis:
	- To analyze the total sales, quantity sold, cost, returns and 
	  refunds by each product.
===================================================================
*/

-- What is the total sales by products?
select
	p.product_name,
	sum(oi.price_usd) as total_sales
from silver.order_items as oi
join silver.products as p
on p.product_id = oi.product_id
group by p.product_name
order by sum(oi.price_usd) desc

-- How many items are sold by products?
select
	p.product_name,
	count(oi.order_item_id) as total_quantity_sold
from silver.order_items as oi
join silver.products as p
on p.product_id = oi.product_id
group by p.product_name
order by count(oi.order_item_id) desc

-- What is the total cost by products?
select
	p.product_name,
	sum(oi.cogs_usd) as total_cost
from silver.order_items as oi
join silver.products as p
on p.product_id = oi.product_id
group by p.product_name
order by sum(oi.cogs_usd) desc

-- How many items are returned by products?
select
	p.product_name,
	count(oir.order_item_refund_id) as total_returns
from silver.order_items as oi
join silver.products as p
on p.product_id = oi.product_id
join silver.order_item_refunds as oir
on oir.order_item_id = oi.order_item_id
group by p.product_name
order by count(oir.order_item_refund_id) desc

-- What is the total refunds by products?
select
	p.product_name,
	sum(oir.refund_amount_usd) as total_refunds
from silver.order_items as oi
join silver.products as p
on p.product_id = oi.product_id
join silver.order_item_refunds as oir
on oir.order_item_id = oi.order_item_id
group by p.product_name
order by sum(oir.refund_amount_usd) desc
