/*
===================================================================
Measures Exploration
===================================================================
Purpose:
	This query explores 'products' dimension and 'fact' tables to 
	identify the overall trends using aggregated metrics.
===================================================================
*/

-- How many products are offered?
select 
	count(distinct product_name) as total_products
from silver.products

-- How many users have visited the website?
select 
	count(distinct user_id) as total_website_visitors
from silver.website_sessions

-- How many website sessions are recorded?
select 
	count(website_session_id) as total_website_sessions
from silver.website_sessions

-- How many UTM sources do visitors come from?
select 
	count(distinct utm_source) as total_sources
from silver.website_sessions
where utm_source not in ('n/a')

-- How many UTM campaigns are set?
select 
	count(distinct utm_campaign) as total_campaigns
from silver.website_sessions
where utm_campaign not in ('n/a')

-- How many UTM contents are set?
select 
	count(distinct utm_content) as total_contents
from silver.website_sessions
where utm_content not in ('n/a')

-- What is the total orders?
select
	count(order_id) as total_orders
from silver.orders

-- What is the total sales?
select
	sum(price_usd) as total_sales
from silver.orders

-- What is the total costs?
select
	sum(cogs_usd) as total_costs
from silver.orders

-- What is the total products sold?
select
	sum(items_purchased) as total_products_sold
from silver.orders

-- What is the total products returns?
select
	count(order_item_refund_id) as total_products_returns
from silver.order_item_refunds

-- What is the total refunds?
select
	sum(refund_amount_usd) as total_refunds
from silver.order_item_refunds
