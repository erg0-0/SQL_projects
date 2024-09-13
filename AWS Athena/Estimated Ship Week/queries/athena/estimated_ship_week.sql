SELECT * FROM (
WITH manual_country_info as
                ( 
                SELECT 
                country
                ,country_name
                ,cluster
                ,is_gem_ship_to_country
                ,is_european_union
                ,is_affiliate__ship_to_county
                FROM adl_business_gem_cf_supply_chain.GEM_supply_chain_clusters
                WHERE is_gem_ship_to_country = 'true'
                AND cluster <> 'Latin America')
, cust as 
    	    (select distinct --1,936,646
    	    cust.sap_commercial_account_id
    	    ,cust.sap_commercial_account_name 
    	    ,cust.country
    	   from "adl_enriched_gbl_cf_reference"."dim_customer" cust
    	   )
, billing_data as ( 
            SELECT 
            b.sales_document_number
           ,b.billing_document_number
           ,b.bill_date
           ,b.ship_to_customer_nbr
           ,b.billing_type
           ,b.material_code
           ,b.item_category_id
           ,b.item_category_description
           FROM "adl_enriched_gbl_cf_sapbods"."fact_sales_billing" b
           WHERE 1>0 
           and billing_type = 'Z8C1' 
           AND item_category_id NOT IN ('Z8GG', 'Y8FR','Y8CU','Y8FT','Y8ES','Y8C6')
           AND YEAR(b.bill_date) >= YEAR (current_date)-1
           and sales_document_number IS NOT NULL
           )
, delivery as (
        SELECT 
        d.refer_doc_number as "delivery_sales_document"
        ,d.delivery "delivery_delivery_number"
        ,d.actual_gi_date "delivery_actual_goods_issue_date"
        ,d.material
        FROM  "adl_enriched_gbl_cf_sapbods"."fact_delivery_item" d 
        WHERE d.actual_gi_date IS NOT NULL
        AND YEAR(d.actual_gi_date) =YEAR(current_date)
        and d.refer_doc_number is not null
        )
, sales as
        (
          SELECT 
          s.sales_document_number
          , s.sales_document_type
          , s.created_date as "sales_document_created_date"
          ,s.order_type as "sales_document_order_type"
          ,s.plant "sales_plant"
          ,s.sales_organization 
          ,s.original_vendor
          ,s.purchase_order_number
          ,s.shipping_condition
          ,s.payment_terms
          ,s.customer_purchase_order_number
          ,s.plant_description
          ,s.material_code
         FROM "adl_enriched_gbl_cf_sapbods"."fact_sales_oti" s
    	  WHERE 
    	    s.sales_document_type IN ('Z8FA', 'Z8C1')
    	    and s.sales_organization IN ('CH10', 'PA10')
    	    and s.distribution_channel = 'TR' 
    	    and YEAR(s.created_date) >= YEAR(current_date)-1
            AND reason_rejection IS NULL
    	  )   
,brand as ( 
    SELECT 
    brand.product_level2_description as "franchise"
    ,brand.sub_franchise_id
    ,brand.sub_franchise_description as "sub-franchise"
    ,brand.product_level5_description as "brand"
    ,brand.material_code
    FROM "adl_enriched_gbl_cf_sapbods"."dim_material" brand 
    WHERE brand.sub_franchise_description is not null AND brand.product_level5_description is not null
    )
,base as (
SELECT 
distinct
s.sales_document_number
, s.sales_document_type
, s."sales_document_created_date"
,s."sales_plant"
,s.sales_organization 
,s.original_vendor
,s.shipping_condition
,s.payment_terms
,s.plant_description
,s.customer_purchase_order_number
,d.delivery_delivery_number  
,d.delivery_actual_goods_issue_date
,d.material
,year(d.delivery_actual_goods_issue_date) as "actual_good_issued_year"
,Extract(week from d.delivery_actual_goods_issue_date) as "actual_goods_issued_weeknum"
,b.billing_document_number
,cust.sap_commercial_account_name "Customer Name"
,cust.country as "ship_to_customer_country"
,m.country_name
,m.cluster
,m.is_gem_ship_to_country
,m.is_european_union
,m.is_affiliate__ship_to_county
,brand."franchise"
,brand.sub_franchise_id
,brand."sub-franchise"
,brand."brand"
FROM manual_country_info m
INNER JOIN cust ON m."country" = cust.country
INNER JOIN billing_data b on b.ship_to_customer_nbr = cust.sap_commercial_account_id
INNER JOIN sales s on s.sales_document_number = b.sales_document_number  and s.material_code = b.material_code 
INNER JOIN delivery d on s.sales_document_number = d.delivery_sales_document and s.material_code = d.material 
LEFT JOIN brand  on brand.material_code = s.material_code
WHERE d.delivery_actual_goods_issue_date IS NOT NULL
)
, median as (
SELECT distinct
country_name as "country_name_median"
, brand as "brand_median"
, 'Lag0' as "assign_lag"
FROM "adl_business_gem_cf_supply_chain"."responsiveness"
GROUP by
country_name
, brand
HAVING approx_percentile(date_diff('day',CAST(sales_document_created_date as DATE), CAST(delivery_actual_goods_issue_date as DATE)), 0.5 ) <10
order by 1,2
)
,
osl AS
(
WITH correction_osl_date AS (
        SELECT 
        CONCAT(sales_order_no, LPAD(material,18,'0')) as "primarykey_osl"
        ,delivery_number
        ,sales_order_no
        ,propose_estimated_ship_week__date_format
        ,YEAR(propose_estimated_ship_week__date_format) as "propose_estimated_ship_week__date_yr"
        ,CAST( propose_estimated_ship_week as int) "propose_estimated_ship_week"
        ,estimated_ship_week_date_format_cs
        ,YEAR(estimated_ship_week_date_format_cs) as "estimated_ship_year"
        ,Extract(week from estimated_ship_week_date_format_cs) as "estimated_ship_weeknum"
        ,osl_file_date as "osl_file_date_original"
        , CASE Extract(dow from osl_file_date)
            WHEN 1 THEN 'Monday'
            WHEN 2 THEN 'Tuesday'
            WHEN 3 THEN 'Wednesday'
            WHEN 4 THEN 'Thursday'
            WHEN 5 THEN 'Friday'
            WHEN 6 THEN 'Saturday'
            WHEN 7 THEN 'Sunday' END as "osl_file_date_original_weekdayname"
        , Extract(dow from osl_file_date) as "osl_file_original_weekdaynum"
        ,CASE Extract(dow from osl_file_date) 
        WHEN 4 then osl_file_date
        WHEN 1 then osl_file_date
        WHEN 2 then date_add('day', -1, osl_file_date)
        WHEN 3 then date_add('day', -2, osl_file_date)
        WHEN 5 then date_add('day', -1, osl_file_date)
        WHEN 6 then date_add('day', -2, osl_file_date)
        WHEN 7 then date_add('day', -3, osl_file_date)
         END as "osl_file_date"
        FROM "adl_business_gem_cf_supply_chain"."weekly_cesw"
        )
SELECT 
c.*
,YEAR(c.osl_file_date) as "osl_file_date_yr"
,Extract(week from c.osl_file_date) as "osl_file_date_weeknum"
,CASE Extract(dow from c.osl_file_date) 
    WHEN 1 THEN 'Monday'
    WHEN 2 THEN 'Tuesday'
    WHEN 3 THEN 'Wednesday'
    WHEN 4 THEN 'Thursday'
    WHEN 5 THEN 'Friday'
    WHEN 6 THEN 'Saturday'
    WHEN 7 THEN 'Sunday' END as "osl_file_date_weekday"
FROM correction_osl_date c
)
, osl_leadtime as ( --392,382
SELECT distinct * FROM osl where "osl_file_date_weekday"  = 'Thursday' ORDER BY 1
    )
, osl_lag0 as ( --394,383
    SELECT distinct * FROM osl where "osl_file_date_weekday"  = 'Monday' ORDER BY 1
    )
, foresight AS ( -- 489286 
SELECT 
base.sales_document_number
, base.sales_document_type
, base."sales_document_created_date"
,base."sales_plant"
,base.sales_organization 
,base.customer_purchase_order_number
,base.original_vendor
,base.shipping_condition
,base.payment_terms
,base.plant_description
,base.delivery_delivery_number  
,base.delivery_actual_goods_issue_date
,base.material
,base.billing_document_number
,base."Customer Name"
,base."ship_to_customer_country"
,base.country_name
,base.cluster
,base.is_gem_ship_to_country
,base.is_european_union
,base.is_affiliate__ship_to_county
,base."franchise"
,base.sub_franchise_id
,base."sub-franchise"
,base."brand"
,CONCAT(base.sales_document_number, material) as "primarykey_foresight"
,year(base.delivery_actual_goods_issue_date) as "actual_good_issued_year"
,Extract(week from base.delivery_actual_goods_issue_date) as "actual_goods_issued_weeknum"
,date_add('week', -1, base.delivery_actual_goods_issue_date) as "fc-1_date"
,YEAR(date_add('week', -1, base.delivery_actual_goods_issue_date) ) as "fc-1_yr"
,Extract(week from date_add('week', -1, base.delivery_actual_goods_issue_date) ) as "fc-1_weeknum"
,date_add('week', -4, base.delivery_actual_goods_issue_date) as "fc-4_date"
,YEAR(date_add('week', -4, base.delivery_actual_goods_issue_date) ) as "fc-4_yr"
,Extract(week from date_add('week', -4, base.delivery_actual_goods_issue_date) ) as "fc-4_weeknum"
, median.*
, CASE
    WHEN base."sub-franchise" = 'Contact Lens Care' AND base."sales_plant" = 'CH75' THEN 'ShortLT' 
    WHEN base."sub-franchise" = 'Over The Counter' AND base."sales_plant" = 'CH75' THEN 'ShortLT'
    WHEN base."sub-franchise" ='Diagnostics' THEN 'LongLT'
    WHEN base."sub-franchise" = 'Surgical Solutions' THEN 'LongLT' 
    WHEN base."sub-franchise" = 'Contact Lens Care' THEN 'LongLT'
    WHEN base."sub-franchise" ='Over The Counter' THEN 'LongLT'
    ELSE 
    (CASE WHEN median.assign_lag = 'Lag0' THEN 'Lag0'  
        ELSE 'ShortLT' END)
        END "leadtime"                
FROM base
LEFT JOIN median on median.country_name_median = base.country_name and median.brand_median = base.brand
)
,osl_joined AS (
SELECT 
foresight.*
, osl_lag0.primarykey_osl
,osl_lag0.delivery_number
,osl_lag0.sales_order_no
,osl_lag0.osl_file_date
,osl_lag0.osl_file_date_yr
,osl_lag0.osl_file_date_weeknum
,osl_lag0.propose_estimated_ship_week__date_format
,osl_lag0.propose_estimated_ship_week__date_yr
,osl_lag0.propose_estimated_ship_week
,osl_lag0.estimated_ship_week_date_format_cs
,osl_lag0.estimated_ship_year
,osl_lag0.estimated_ship_weeknum
FROM foresight 
LEFT JOIN osl_lag0 on foresight.primarykey_foresight = osl_lag0.primarykey_osl 
                      and foresight.actual_good_issued_year=osl_file_date_yr 
                      and foresight.actual_goods_issued_weeknum = osl_lag0.osl_file_date_weeknum
WHERE foresight.leadtime = 'Lag0'
UNION
SELECT 
foresight.*
, osl_leadtime.primarykey_osl
,osl_leadtime.delivery_number
,osl_leadtime.sales_order_no
,osl_leadtime.osl_file_date
,osl_leadtime.osl_file_date_yr
,osl_leadtime.osl_file_date_weeknum
,osl_leadtime.propose_estimated_ship_week__date_format
,osl_leadtime.propose_estimated_ship_week__date_yr
,osl_leadtime.propose_estimated_ship_week
,osl_leadtime.estimated_ship_week_date_format_cs
,osl_leadtime.estimated_ship_year
,osl_leadtime.estimated_ship_weeknum
FROM foresight 
LEFT JOIN  osl_leadtime ON foresight.primarykey_foresight = osl_leadtime.primarykey_osl 
                            and foresight."fc-1_yr"=osl_leadtime.osl_file_date_yr 
                            and foresight."fc-1_weeknum" = osl_leadtime.osl_file_date_weeknum
WHERE  foresight.leadtime = 'ShortLT'
UNION  
SELECT 
foresight.*
, osl_leadtime.primarykey_osl
,osl_leadtime.delivery_number
,osl_leadtime.sales_order_no
,osl_leadtime.osl_file_date
,osl_leadtime.osl_file_date_yr
,osl_leadtime.osl_file_date_weeknum
,osl_leadtime.propose_estimated_ship_week__date_format
,osl_leadtime.propose_estimated_ship_week__date_yr
,osl_leadtime.propose_estimated_ship_week
,osl_leadtime.estimated_ship_week_date_format_cs
,osl_leadtime.estimated_ship_year
,osl_leadtime.estimated_ship_weeknum
FROM foresight 
LEFT JOIN  osl_leadtime ON foresight.primarykey_foresight = osl_leadtime.primarykey_osl 
                            and foresight."fc-4_yr"=osl_leadtime.osl_file_date_yr 
                            and foresight."fc-4_weeknum" = osl_leadtime.osl_file_date_weeknum
WHERE  foresight.leadtime = 'LongLT'
)
SELECT 
sales_document_number
,sales_document_type
,sales_document_created_date
,sales_plant
,sales_organization
,"Customer Name"
,original_vendor
,shipping_condition
,payment_terms
,plant_description
,delivery_delivery_number
,delivery_actual_goods_issue_date
,material
,ship_to_customer_country
,customer_purchase_order_number
,country_name
,cluster
,is_european_union
,is_affiliate__ship_to_county
,franchise
,sub_franchise_id
,"sub-franchise"
,brand
,primarykey_foresight
,actual_good_issued_year
,actual_goods_issued_weeknum
,"fc-1_date"
,"fc-1_yr"
,"fc-1_weeknum"
,"fc-4_date"
,"fc-4_yr"
,"fc-4_weeknum"
,"country_name_median"
,"brand_median"
, "assign_lag"
,"leadtime"
,"primarykey_osl"
,"osl_file_date"
,"osl_file_date_yr"
,"osl_file_date_weeknum"
,"propose_estimated_ship_week__date_format"
,"propose_estimated_ship_week__date_yr"
,"propose_estimated_ship_week"
,"estimated_ship_week_date_format_cs"
,"estimated_ship_year"
,"estimated_ship_weeknum"
FROM osl_joined
)