/*
=============================================================
DDL Script: Creating Silver Tables
=============================================================
Script Purpose:
	This script creates tables in the 'silver' schema after 
	it ensures there is not the same table and if there is 
	a table, it will drop it.
=============================================================
*/

--------------------------------------------------------------------
-- Creating 'silver.website_sessions' table.
--------------------------------------------------------------------
if object_id('silver.website_sessions', 'U') is not null
drop table silver.website_sessions;
go

create table silver.website_sessions (
	website_session_id int,
	date_time datetime2(0),
	user_id int,
	is_repeat_session int,
	utm_source nvarchar(50),
	utm_campaign nvarchar(50),
	utm_content nvarchar(50),
	device_type nvarchar(50),
	http_referrer nvarchar(50)
);
go

--------------------------------------------------------------------
-- Creating 'silver.website_pageviews' table.
--------------------------------------------------------------------
if object_id('silver.website_pageviews', 'U') is not null 
drop table silver.website_pageviews;
go

create table silver.website_pageviews (
	website_pageview_id int,
	date_time datetime2(0),
	website_session_id int,
	pageview_url nvarchar(50)
);
go

--------------------------------------------------------------------
-- Creating 'silver.products' table.
--------------------------------------------------------------------
if object_id('silver.products', 'U') is not null 
drop table silver.products;
go

create table silver.products (
	product_id int,
	date_time datetime2(0),
	product_name nvarchar(50)
);
go

--------------------------------------------------------------------
-- Creating 'silver.orders' table.
--------------------------------------------------------------------
if object_id('silver.orders', 'U') is not null 
drop table silver.orders;
go

create table silver.orders (
	order_id int,
	date_time datetime2(0),
	website_session_id int,
	user_id int,
	primary_product_id int,
	items_purchased int,
	price_usd decimal(10, 2),
	cogs_usd decimal(10, 2)
);
go

--------------------------------------------------------------------
-- Creating 'silver.order_items' table.
--------------------------------------------------------------------
if object_id('silver.order_items', 'U') is not null 
drop table silver.order_items;
go

create table silver.order_items (
	order_item_id int,
	date_time datetime2(0),
	order_id int,
	product_id int,
	is_primary_item int,
	price_usd decimal(10, 2),
	cogs_usd decimal(10, 2)
);
go


--------------------------------------------------------------------
-- Creating 'silver.order_item_refunds' table.
--------------------------------------------------------------------
if object_id('silver.order_item_refunds', 'U') is not null 
drop table silver.order_item_refunds;
go

create table silver.order_item_refunds (
	order_item_refund_id int,
	date_time datetime2(0),
	order_item_id int,
	order_id int,
	refund_amount_usd decimal(10, 2)
);
go
