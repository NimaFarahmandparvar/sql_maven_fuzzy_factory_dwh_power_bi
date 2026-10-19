/*
===================================================================
Dimensions Exploration
===================================================================
*/

-- What products are provided?
select
	product_name
from silver.products

-- What are the UTM sources?
select distinct
	utm_source
from silver.website_sessions

-- What are the UTM campaigns?
select distinct
	utm_campaign
from silver.website_sessions

-- What are the UTM contents?
select distinct
	utm_content
from silver.website_sessions

-- What types of devices do visitors use?
select distinct
	device_type
from silver.website_sessions

-- What are the referal URLs?
select distinct
	http_referrer
from silver.website_sessions
