/*
====================================================================
DDL Script: Creating The Bronze Layer Tables
====================================================================
Purpose:
	This script creates tables in the 'bronze' schema after it 
	ensures there is not the same table and if there is a table, 
	it will drop it.
====================================================================
*/

use MavenFuzzyFactoryDW;
go

--------------------------------------------------------------------
-- Creating 'bronze.website_sessions' table.
--------------------------------------------------------------------
if object_id('bronze.website_sessions', 'U') is not null
drop table bronze.website_sessions;
go

create table bronze.website_sessions (
	website_session_id int,
	created_at nvarchar(50),
	user_id int,
	is_repeat_session int,
	utm_source nvarchar(50),
	utm_campaign nvarchar(50),
	utm_content nvarchar(50),
	device_type nvarchar(50),
	http_referer nvarchar(50)
);
go

--------------------------------------------------------------------
-- Creating 'bronze.website_pageviews' table.
--------------------------------------------------------------------
if object_id('bronze.website_pageviews', 'U') is not null 
drop table bronze.website_pageviews;
go

create table bronze.website_pageviews (
	website_pageview_id int,
	created_at nvarchar(50),
	website_session_id int,
	pageview_url nvarchar(50)
);
go

--------------------------------------------------------------------
-- Creating 'bronze.products' table.
--------------------------------------------------------------------
if object_id('bronze.products', 'U') is not null 
drop table bronze.products;
go

create table bronze.products (
	product_id int,
	created_at nvarchar(50),
	product_name nvarchar(50)
);
go

--------------------------------------------------------------------
-- Creating 'bronze.orders' table.
--------------------------------------------------------------------
if object_id('bronze.orders', 'U') is not null 
drop table bronze.orders;
go

create table bronze.orders (
	order_id int,
	created_at nvarchar(50),
	website_session_id int,
	user_id int,
	primary_product_id int,
	items_purchased int,
	price_usd nvarchar(50),
	cogs_usd nvarchar(50)
);
go

--------------------------------------------------------------------
-- Creating 'bronze.order_items' table.
--------------------------------------------------------------------
if object_id('bronze.order_items', 'U') is not null 
drop table bronze.order_items;
go

create table bronze.order_items (
	order_item_id int,
	created_at nvarchar(50),
	order_id int,
	product_id int,
	is_primary_item int,
	price_usd nvarchar(50),
	cogs_usd nvarchar(50)
);
go

--------------------------------------------------------------------
-- Creating 'bronze.order_item_refunds' table.
--------------------------------------------------------------------
if object_id('bronze.order_item_refunds', 'U') is not null 
drop table bronze.order_item_refunds;
go

create table bronze.order_item_refunds (
	order_item_refund_id int,
	created_at nvarchar(50),
	order_item_id int,
	order_id int,
	refund_amount_usd nvarchar(50)
);
go
