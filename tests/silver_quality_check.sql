/*
==========================================================
-- Silver Tables Quality Checks
==========================================================
*/

-- Checking Tables Rows

with bronze_layer as (
	select	
		'website_sessions' as bronze_tables_name,
		count(*) as bronze_total_rows
	from bronze.website_sessions

	union all

	select
		'website_pageviews',
		count(*)
	from bronze.website_pageviews

	union all

	select
		'products',
		count(*)
	from bronze.products

	union all

	select
	'orders',
	count(*)
	from bronze.orders

	union all

	select
	'order_items',
	count(*)
	from bronze.order_items

	union all

	select
	'order_item_refunds',
	count(*)
	from bronze.order_item_refunds
),

silver_layer as (
	select	
		'website_sessions' as silver_tables_name,
		count(*) as silver_total_rows
	from silver.website_sessions

	union all

	select
		'website_pageviews',
		count(*)
	from silver.website_pageviews

	union all

	select
		'products',
		count(*)
	from silver.products

	union all

	select
	'orders',
	count(*)
	from silver.orders

	union all

	select
	'order_items',
	count(*)
	from silver.order_items

	union all

	select
	'order_item_refunds',
	count(*)
	from silver.order_item_refunds
)

select
	b.bronze_tables_name,
	b.bronze_total_rows,
	s.silver_tables_name,
	s.silver_total_rows,
	b.bronze_total_rows - s.silver_total_rows as rows_difference,
	case
		when b.bronze_total_rows = s.silver_total_rows then 'passed'
		else 'check'
	end as quality_check
from bronze_layer as b
join silver_layer as s
on b.bronze_total_rows = s.silver_total_rows
order by bronze_tables_name desc;
go

----------------------------------------------------------
-- Checking Unwanted Spaces
-- Expectation: No Results
select
	utm_source,
	utm_campaign,
	utm_content,
	device_type,
	http_referrer
from silver.website_sessions
where trim(utm_source) != utm_source
   or trim(utm_campaign) != utm_campaign
   or trim(utm_content) != utm_content
   or trim(replace(replace(replace(replace(http_referrer, char(9), ''), char(10), ''), char(13), ''), char(160), '')) != http_referrer
   or http_referrer like '%' + char(9) + '%'
   or http_referrer like '%' + char(10) + '%'
   or http_referrer like '%' + char(13) + '%'
   or http_referrer like '%' + char(160) + '%';
go

select
	pageview_url
from silver.website_pageviews
where trim(replace(replace(replace(replace(pageview_url, char(9), ''), char(10), ''), char(13), ''), char(160), '')) != pageview_url
	or pageview_url like '%' + char(9) + '%'
    or pageview_url like '%' + char(10) + '%'
    or pageview_url like '%' + char(13) + '%'
    or pageview_url like '%' + char(160) + '%';
go

select
	product_name
from silver.products
where trim(replace(replace(replace(replace(product_name, char(9), ''), char(10), ''), char(13), ''), char(160), '')) != product_name
	or product_name like '%' + char(9) + '%'
    or product_name like '%' + char(10) + '%'
    or product_name like '%' + char(13) + '%'
    or product_name like '%' + char(160) + '%';
go

select
	cogs_usd
from silver.orders
where replace(replace(replace(replace(cogs_usd, char(9), ''), char(10), ''), char(13), ''), char(160), '') != cogs_usd
	or cogs_usd like '%' + char(9) + '%'
    or cogs_usd like '%' + char(10) + '%'
    or cogs_usd like '%' + char(13) + '%'
    or cogs_usd like '%' + char(160) + '%';
go

select
	cogs_usd
from silver.order_items
where replace(replace(replace(replace(cogs_usd, char(9), ''), char(10), ''), char(13), ''), char(160), '') != cogs_usd
	or cogs_usd like '%' + char(9) + '%'
    or cogs_usd like '%' + char(10) + '%'
    or cogs_usd like '%' + char(13) + '%'
    or cogs_usd like '%' + char(160) + '%';
go

select
	refund_amount_usd
from silver.order_item_refunds
where replace(replace(replace(replace(refund_amount_usd, char(9), ''), char(10), ''), char(13), ''), char(160), '') != refund_amount_usd
	or refund_amount_usd like '%' + char(9) + '%'
    or refund_amount_usd like '%' + char(10) + '%'
    or refund_amount_usd like '%' + char(13) + '%'
    or refund_amount_usd like '%' + char(160) + '%';
go

----------------------------------------------------------
-- Checking For Duplicates And Nulls
-- Expectation: No Results
select
	website_session_id,
	date_time,
	user_id,
	is_repeat_session,
	utm_source,
	utm_campaign,
	utm_content,
	device_type,
	http_referrer,
	count(website_session_id) as total_website_session_id
from silver.website_sessions
group by website_session_id, 
		 date_time,
		 user_id,
		 is_repeat_session,
		 utm_source,
		 utm_campaign,
		 utm_content,
		 device_type,
		 http_referrer
having count(website_session_id) > 1
    or website_session_id is null
	or date_time is null
	or user_id is null
	or is_repeat_session is null
	or utm_source is null
	or utm_campaign is null
	or utm_content is null
	or device_type is null
	or http_referrer is null;
go

select
	website_pageview_id,
	date_time,
	website_session_id,
	pageview_url,
	count(website_pageview_id) as total_website_pageview_id
from silver.website_pageviews
group by website_pageview_id,
		 date_time,
		 website_session_id,
		 pageview_url
having count(website_pageview_id) > 1
    or website_pageview_id is null
	or date_time is null
	or website_session_id is null
	or pageview_url is null;
go

select
	product_id,
	date_time,
	product_name,
	count(product_id) as total_product_id
from silver.products
group by product_id,
		 date_time,
		 product_name
having count(product_id) > 1
	or product_id is null
	or date_time is null
	or product_name is null;
go

select
	order_id,
	date_time,
	website_session_id,
	user_id,
	primary_product_id,
	items_purchased,
	price_usd,
	cogs_usd,
	count(order_id) as total_order_id
from silver.orders
group by order_id,
		 date_time,
		 website_session_id,
		 user_id,
		 primary_product_id,
		 items_purchased,
		 price_usd,
		 cogs_usd
having count(order_id) > 1
    or order_id is null
	or date_time is null
	or website_session_id is null
	or user_id is null
	or primary_product_id is null
	or items_purchased is null
	or price_usd is null
	or cogs_usd is null;
go

select
	order_item_id,
	date_time,
	order_id,
	product_id,
	is_primary_item,
	price_usd,
	cogs_usd,
	count(order_item_id) as total_order_item_id
from silver.order_items
group by order_item_id,
		 date_time,
		 order_id,
		 product_id,
		 is_primary_item,
		 price_usd,
		 cogs_usd
having count(order_item_id) > 1
	or order_item_id is null
	or date_time is null
	or order_id is null
	or product_id is null
	or is_primary_item is null
	or price_usd is null
	or cogs_usd is null;
go

select
	order_item_refund_id,
	date_time,
	order_item_id,
	order_id,
	refund_amount_usd,
	count(order_item_refund_id) as total_order_item_refund_id
from silver.order_item_refunds
group by order_item_refund_id,
		 date_time,
		 order_item_id,
		 order_id,
		 refund_amount_usd
having count(order_item_refund_id) > 1
	or order_item_refund_id is null
	or date_time is null
	or order_item_id is null
	or order_id is null
	or refund_amount_usd is null;
go

----------------------------------------------------------
-- Checking Numeric Values
-- Expectation: No Results
select
*
from silver.website_sessions
where website_session_id < 0
   or user_id < 0
   or is_repeat_session < 0;
go

select
	*
from silver.website_pageviews
where website_pageview_id < 0
   or website_session_id < 0;
go

select
	*
from silver.products
where product_id < 0;
go

select
	*
from silver.orders
where order_id < 0
   or website_session_id < 0
   or user_id < 0
   or primary_product_id < 0
   or items_purchased < 0
   or price_usd < 0
   or cogs_usd < 0;
go

select
	*
from silver.order_items
where order_item_id < 0
   or order_id < 0
   or product_id < 0
   or is_primary_item < 0
   or price_usd < 0
   or cogs_usd < 0;
go

select
	*
from silver.order_item_refunds
where order_item_refund_id < 0
   or order_item_id < 0
   or order_id < 0
   or refund_amount_usd < 0;
go

----------------------------------------------------------
-- Data Standardization and Normalization
-- Expectation: No Results
select
	utm_source,
	utm_content,
	http_referrer
from silver.website_sessions
where utm_source like '%gsearch%'
   or utm_source like '%bsearch%'
   or utm_source like '%socialbook%'
   or utm_content like '%b_ad_1%'
   or utm_content like '%b_ad_2%'
   or utm_content like '%g_ad_1%'
   or utm_content like '%g_ad_2%'
   or utm_content like '%social_ad_1%'
   or utm_content like '%social_ad_2%'
   or http_referrer like '%gsearch%'
   or http_referrer like '%bsearch%'
   or http_referrer like '%socialbook%'

