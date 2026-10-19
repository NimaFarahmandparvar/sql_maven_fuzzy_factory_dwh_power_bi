/*
====================================================================
Stored Procedure: Loading The Bronze Layer
====================================================================
Purpose:
	This script creates a stored procedure to insert data from CSV
	files into the 'bronze' tables. Additionally, it calculates
	the loading duration of each table and also the loading duration
	of the whole bronze layer.

Parameters and Variables:
	- No pararmeters.
	- four variables are used to calculate the loading duration of 
	  each table (@start_time, @end_time) and the whole bronze layer
	  (@batch_start_time, @batch_end_time).

Usage:
	exec proc_load_bronze
====================================================================
*/

create or alter procedure proc_load_bronze as
begin
	declare @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime;
		begin try
		set @batch_start_time = getdate();
		print '=============================================================';
		print '>> Loading The Bronze Layer';
		print '=============================================================';
		print '-------------------------------------------------------------';
		print '>> Loading bronze.website_sessions Table';
		print '-------------------------------------------------------------';


		set @start_time = getdate();
		print '>> Truncating bronze.website_sessions Table';
		truncate table bronze.website_sessions;
		print '>> Inserting Data Into bronze.website_sessions Table';
		bulk insert bronze.website_sessions
		from 'D:\Projects\maven_fuzzy_factory\dataset\website_sessions.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			rowterminator = '0x0a',
			tablock
		);
		set @end_time = getdate();
		print'>> Loading Duration : ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';


		set @start_time = getdate();
		print '-------------------------------------------------------------';
		print '>> Loading bronze.website_pageviews Table';
		print '-------------------------------------------------------------';
		print '>> Truncating bronze.website_pageviews Table';
		truncate table bronze.website_pageviews;
		print '>> Inserting Data Into bronze.website_pageviews Table';
		bulk insert bronze.website_pageviews
		from 'D:\Projects\maven_fuzzy_factory\dataset\website_pageviews.csv'
		with (
			format = 'CSV',
			firstrow = 2,
			fieldterminator = ',',
			rowterminator = '0x0a',
			tablock
		);
		set @end_time = getdate();
		print'>> Loading Duration : ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';


		set @start_time = getdate();
		print '-------------------------------------------------------------';
		print '>> Loading bronze.products Table';
		print '-------------------------------------------------------------';
		print '>> Truncating bronze.products Table';
		truncate table bronze.products;
		print '>> Inserting Data Into bronze.products Table';
		bulk insert bronze.products
		from 'D:\Projects\maven_fuzzy_factory\dataset\products.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			rowterminator = '0x0a',
			tablock
		);
		set @end_time = getdate();
		print'>> Loading Duration : ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';


		set @start_time = getdate();
		print '-------------------------------------------------------------';
		print '>> Loading bronze.orders Table';
		print '-------------------------------------------------------------';
		print '>> Truncating bronze.orders Table';
		truncate table bronze.orders;
		print '>> Inserting Data Into bronze.orders Table';
		bulk insert bronze.orders
		from 'D:\Projects\maven_fuzzy_factory\dataset\orders.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			rowterminator = '0x0a',
			tablock
		);
		set @end_time = getdate();
		print'>> Loading Duration : ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';


		set @start_time = getdate();
		print '-------------------------------------------------------------';
		print '>> Loading bronze.order_items Table';
		print '-------------------------------------------------------------';
		print '>> Truncating bronze.order_items Table';
		truncate table bronze.order_items;
		print '>> Inserting Data Into bronze.order_items Table';
		bulk insert bronze.order_items
		from 'D:\Projects\maven_fuzzy_factory\dataset\order_items.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			rowterminator = '0x0a',
			tablock
		);
		set @end_time = getdate();
		print'>> Loading Duration : ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';


		set @start_time = getdate();
		print '-------------------------------------------------------------';
		print '>> Loading bronze.order_item_refunds Table';
		print '-------------------------------------------------------------';
		print '>> Truncating bronze.order_item_refunds Table';
		truncate table bronze.order_item_refunds;
		print '>> Inserting Data Into bronze.order_item_refunds Table';
		bulk insert bronze.order_item_refunds
		from 'D:\Projects\maven_fuzzy_factory\dataset\order_item_refunds.csv'
		with (
			firstrow = 2,
			fieldterminator = ',',
			rowterminator = '0x0a',
			tablock
		);
		set @end_time = getdate();
		print'>> Loading Duration : ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';
		set @batch_end_time = getdate();


		print '=============================================================';
		print '>> Loading The Bronze Layer Is Completed';
		print '>> Loading The Bronze Layer Duration is : ' + cast(datediff(second, @batch_start_time, @batch_end_time) as nvarchar) + ' seconds';
		print '=============================================================';
		print'>> Loading Duration : ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';
	end try


	begin catch
		print '=============================================================';
		print 'An Error Has Occured During Loading The Bronze Layer';
		print 'Error Message : ' + error_message();
		print 'Error Number : ' + cast(error_number() as nvarchar);
		print 'Error State : ' + cast(error_state() as nvarchar);
		print '=============================================================';
	end catch
end
