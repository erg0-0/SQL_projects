with  manual_country_info as
	( 
	SELECT 
	country
	,country_name
	,cluster
	,is_gem_ship_to_country
	,is_affiliate__ship_to_county
	FROM adl_business_gem_cf_supply_chain.GEM_supply_chain_clusters
	)
,cust AS  (select distinct 
    	    cust.sap_commercial_account_id
    	    ,cust.sap_commercial_account_name 
    	    ,cust.country
    	   from "adl_enriched_gbl_cf_reference"."dim_customer" cust
    	   )
,salesforce as (
	select * 
	,LPAD(bot.sap_id_ac__c,10,'0') as sap_id_ac__c_normalised
	,LPAD(bot.casenumber , 24,'0') as casenumber_normalized_24
	from adl_business_gem_cf_supply_chain.apl_gem_bot_performance_metrics bot
	)
,brand as 
	(SELECT 
      material_code
      , product_level2_description as "franchise"
      ,sub_franchise_id
      , sub_franchise_description as "sub-franchise"
      ,product_level5_description as "brand"
      FROM "adl_enriched_gbl_cf_sapbods"."dim_material"
      )
,sales_base as 
	(SELECT 
	service_order_number 
	,sales_document_number
	,sales_document_item 
	,material_code
	,ship_to_customer_nbr
	,created_by
	,created_date
	,header_created_by
	,EXTRACT (year from created_date) as "created_date_year"
	,EXTRACT ( month from created_date ) as "created_date_month"
	,date_parse( CONCAT(cast(created_date as varchar),' ', created_time), '%Y-%m-%d %H:%i:%s') as created_timestamp
	,item_category_id
	,item_category_description
	,sales_document_type
	,reason_rejection
	,sales_organization
	,shipping_condition
	,original_vendor
	,plant
	,customer_purchase_order_number
	,CASE WHEN CAST(created_date as DATE) >= CAST('2023-04-30' as date) THEN header_created_by ELSE created_by END "created_by_corrected"
	FROM adl_enriched_gbl_cf_sapbods.fact_sales_oti 
	WHERE 
	calendar_year >= year(current_date)-2
	AND sales_document_type IN ('Z8FA', 'Z8C1', 'Z8F2')
	AND  sales_organization IN ('CH10', 'PA10') 
	and plant NOT IN ('CH06') 
	AND order_type <> 'WEB' 
	AND distribution_channel = 'TR' 
	)
,sales as 
	(SELECT 
	s.*
	FROM sales_base s
	where 
	s."created_by_corrected" like '%BOT%'
    )
select 
bot.job_status__c 
,bot.casenumber 
,bot.case_owner_name_ac__c 
,bot.status
,bot.sap_id_ac__c_normalised as "customer_id"
,bot.apl_gem_sub_sub_area__c 
,bot.apl_picked_by_bot_date_time__c 
,bot.apl_order_placed_date_time__c 
,bot.apl_pending_from_csr_date_time__c 
,bot.date_time_opened_ac__c 
,bot.lastmodifieddate 
,bot.sub_area_ac__c 
,bot.apl_waiting_for_bot_date_time__c 
,bot.subject 
,cust.sap_commercial_account_name as "customer_name"
,cust.country as "country_code"
,m.country_name
,m.cluster
,m.is_gem_ship_to_country
,m.is_affiliate__ship_to_county
,sales.*
,brand.*
from salesforce bot
left join sales on bot.casenumber_normalized_24 = sales.service_order_number 
left join cust on cust.sap_commercial_account_id = sales.ship_to_customer_nbr --bot.sap_id_ac__c_normalised
INNER JOIN manual_country_info m on cust.country = m.country
left join brand on sales.material_code = brand.material_code