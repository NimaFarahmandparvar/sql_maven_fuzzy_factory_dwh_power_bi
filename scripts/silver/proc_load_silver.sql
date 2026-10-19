/*
====================================================================
Stored Procedure: Loading The Silver Layer
====================================================================
Purpose:
	This script creates a stored procedure to insert data from 
	'bronze' tables into the 'silver' tables. Additionally, it 
	calculates the loading duration of each table and also the 
	loading duration of the whole silver layer.

Parameters and Variables:
	- No pararmeters.
	- four variables are used to calculate the loading duration of 
	  each table (@start_time, @end_time) and the whole silver layer
	  (@batch_start_time, @batch_end_time).

Usage:
	exec proc_load_silver
====================================================================
*/
create or alter procedure proc_load_silver as
begin
	declare @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime;
		begin try
		set @batch_start_time = getdate();
		set @start_time = getdate();
		print '=============================================================';
		print '>> Loading The Silver Layer';
		print '=============================================================';

		print '-------------------------------------------------------------';
		print '>> Truncating Tables';
		print '-------------------------------------------------------------';

		truncate table silver.website_sessions;
		truncate table silver.website_pageviews;
		truncate table silver.products;
		truncate table silver.orders;
		truncate table silver.order_items;
		truncate table silver.order_item_refunds;

		set @end_time = getdate();
		print '-- Truncating Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';


		set @start_time = getdate();
		print '-------------------------------------------------------------';
		print '>> Loading silver.website_sessions Table';
		print '-------------------------------------------------------------';
		insert into silver.website_sessions (
			website_session_id,
			date_time, 
			user_id,
			is_repeat_session,
			utm_source,
			utm_campaign,
			utm_content,
			device_type,
			http_referrer
		)
		select
			website_session_id,
			cast(created_at as datetime2(0)) as date_time,
			user_id,
			is_repeat_session,

			case
				when replace(lower(coalesce(trim(utm_source), 'n/a')), 'null', 'n/a') = 'gsearch' then 'google'
				when replace(lower(coalesce(trim(utm_source), 'n/a')), 'null', 'n/a') = 'bsearch' then 'bing'
				when replace(lower(coalesce(trim(utm_source), 'n/a')), 'null', 'n/a') = 'socialbook' then 'facebook'
				else replace(lower(coalesce(trim(utm_source), 'n/a')), 'null', 'n/a')
			end as utm_source,

			replace(lower(coalesce(trim(utm_campaign), 'n/a')), 'null', 'n/a') as utm_campaign,

			case
				when replace(lower(coalesce(trim(utm_content), 'n/a')), 'null', 'n/a') = 'b_ad_1' then 'bing_advertisement_1'
				when replace(lower(coalesce(trim(utm_content), 'n/a')), 'null', 'n/a') = 'b_ad_2' then 'bing_advertisement_2'
				when replace(lower(coalesce(trim(utm_content), 'n/a')), 'null', 'n/a') = 'g_ad_1' then 'google_advertisement_1'
				when replace(lower(coalesce(trim(utm_content), 'n/a')), 'null', 'n/a') = 'g_ad_2' then 'google_advertisement_2'
				when replace(lower(coalesce(trim(utm_content), 'n/a')), 'null', 'n/a') = 'social_ad_1' then 'facebook_advertisement_1'
				when replace(lower(coalesce(trim(utm_content), 'n/a')), 'null', 'n/a') = 'social_ad_2' then 'facebook_advertisement_2'
				else replace(lower(coalesce(trim(utm_content), 'n/a')), 'null', 'n/a')
			end as utm_content,

			replace(lower(coalesce(trim(device_type), 'n/a')), 'null', 'n/a') as device_type,

			case
				when replace(
							 lower(
								  coalesce(
										   trim(
												replace(replace(replace(replace(http_referer, char(9), ''), char(10), ''), char(13), ''), char(160), '')
												)
											, 'n/a')
								  )
							 , 'null', 'n/a') like '%gsearch%' then 'https://www.google.com'
				when replace(
							 lower(
								  coalesce(
										   trim(
												replace(replace(replace(replace(http_referer, char(9), ''), char(10), ''), char(13), ''), char(160), '')
												)
											, 'n/a')
								  )
							 , 'null', 'n/a') like '%bsearch%' then 'https://www.bing.com'
				when replace(
							 lower(
								  coalesce(
										   trim(
												replace(replace(replace(replace(http_referer, char(9), ''), char(10), ''), char(13), ''), char(160), '')
												)
											, 'n/a')
								  )
							 , 'null', 'n/a') like '%socialbook%' then 'https://www.facebook.com'
				else replace(
							 lower(
								  coalesce(
										   trim(
												replace(replace(replace(replace(http_referer, char(9), ''), char(10), ''), char(13), ''), char(160), '')
												)
											, 'n/a')
								  )
							, 'null', 'n/a')
				end as http_referrer
		from bronze.website_sessions;
		set @end_time = getdate();
		print '-- Loading Duration : ' + cast(datediff(second,@start_time, @end_time) as nvarchar) + ' seconds';
	

		set @start_time = getdate();
		print '-------------------------------------------------------------';
		print '>> Loading silver.website_pageviews Table';
		print '-------------------------------------------------------------';
		insert into silver.website_pageviews (
			website_pageview_id,
			date_time,
			website_session_id,
			pageview_url
		)
		select
			website_pageview_id,
			cast(created_at as datetime2(0)) as date_time,
			website_session_id,
			replace(
				    replace(
					        lower(
								  coalesce(
											trim(
										 		 replace(replace(replace(replace(pageview_url, char(9), ''), char(10), ''), char(13), ''), char(160), '')
												 )
										   , 'n/a')
								  )
							, 'null', 'n/a')
					 , '/', '') as pageview_url
		from bronze.website_pageviews;
		set @end_time = getdate();
		print '-- Loading Duration : ' + cast(datediff(second,@start_time, @end_time) as nvarchar) + ' seconds';


		set @start_time = getdate();
		print '-------------------------------------------------------------';
		print '>> Loading silver.products Table';
		print '-------------------------------------------------------------';
		insert into silver.products (
			product_id,
			date_time,
			product_name
		)
		select
			product_id,
			cast(created_at as datetime2(0)) as date_time,
			replace(
					lower(
						  coalesce(
								   trim(
										replace(replace(replace(replace(product_name, char(9), ''), char(10), ''), char(13), ''), char(160), '')
										)
									, 'n/a')
						  )
					, 'null', 'n/a') as product_name
		from bronze.products;
		set @end_time = getdate();
		print '-- Loading Duration : ' + cast(datediff(second,@start_time, @end_time) as nvarchar) + ' seconds';
	

		set @start_time = getdate();
		print '-------------------------------------------------------------';
		print '>> Loading silver.orders Table';
		print '-------------------------------------------------------------';
		insert into silver.orders (
			order_id,
			date_time,
			website_session_id,
			user_id,
			primary_product_id,
			items_purchased,
			price_usd,
			cogs_usd
		)
		select
			order_id,
			cast(created_at as datetime2(0)) as date_time,
			website_session_id,
			user_id,
			primary_product_id,
			items_purchased,
			cast(trim(price_usd) as decimal(10, 2)) as price_usd,
			cast(
				 trim(
					  replace(replace(replace(replace(cogs_usd, char(9), ''), char(10), ''), char(13), ''), char(160), '')
					  ) 
				 as decimal(10, 2)) as cogs_usd
		from bronze.orders;
		set @end_time = getdate();
		print '-- Loading Duration : ' + cast(datediff(second,@start_time, @end_time) as nvarchar) + ' seconds';
	

		set @start_time = getdate();
		print '-------------------------------------------------------------';
		print '>> Loading silver.order_items Table';
		print '-------------------------------------------------------------';
		insert into silver.order_items (
			order_item_id,
			date_time,
			order_id,
			product_id,
			is_primary_item,
			price_usd,
			cogs_usd
		)
		select
			order_item_id,
			cast(created_at as datetime2(0)) as date_time,
			order_id,
			product_id,
			is_primary_item,
			cast(trim(price_usd) as decimal(10, 2)) as price_usd,
			cast(
				 trim(
					  replace(replace(replace(replace(cogs_usd, char(9), ''), char(10), ''), char(13), ''), char(160), '')
					  ) 
				 as decimal(10, 2)) as cogs_usd
		from bronze.order_items;
		set @end_time = getdate();
		print '-- Loading Duration : ' + cast(datediff(second,@start_time, @end_time) as nvarchar) + ' seconds';
	

		set @start_time = getdate();
		print '-------------------------------------------------------------';
		print '>> Loading silver.order_item_refunds Table';
		print '-------------------------------------------------------------';
		insert into silver.order_item_refunds (
			order_item_refund_id,
			date_time,
			order_item_id,
			order_id,
			refund_amount_usd
		)
		select
			order_item_refund_id,
			cast(created_at as datetime2(0)) as date_time,
			order_item_id,
			order_id,
			cast(
				 trim(
					  replace(replace(replace(replace(refund_amount_usd, char(9), ''), char(10), ''), char(13), ''), char(160), '')
					  ) 
				 as decimal(10, 2)) as refund_amount_usd
		from bronze.order_item_refunds;
		set @end_time = getdate();
		print '-- Loading Duration : ' + cast(datediff(second,@start_time, @end_time) as nvarchar) + ' seconds';
		set @batch_end_time = getdate();
		print '=============================================================';
		print 'Loading The Silver Layer Is Completed';
		print '-- Loading The Silver Layer Duration is : ' + cast(datediff(second, @batch_start_time, @batch_end_time) as nvarchar) + ' seconds';
		print '=============================================================';
	end try

	begin catch
		print '=============================================================';
		print 'An Error Has Occured During Loading The Silver Layer';
		print 'Error Message : ' + error_message();
		print 'Error Number : ' + cast(error_number() as nvarchar);
		print 'Error State : ' + cast(error_state() as nvarchar);
		print '=============================================================';
	end catch
end

