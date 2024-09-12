WITH manual_country_info as
                ( 
                SELECT --110
                country
                ,country_name
                ,cluster
                ,is_gem_ship_to_country
                ,is_affiliate__ship_to_county
                FROM adl_business_gem_cf_supply_chain.GEM_supply_chain_clusters
                WHERE
                (is_gem_ship_to_country = 'true' OR country IN ('CN', 'JP', 'UY') )
                 AND country NOT IN ('IR', 'SY', 'SD' )
                 )
, cust AS  --ADDING CUSTOMER MASTER DATA
    	    (select distinct --1,936,646
    	    cust.sap_commercial_account_id
    	    ,cust.sap_commercial_account_name 
    	    ,cust.country
    	   from "adl_enriched_gbl_cf_reference"."dim_customer" cust
    	   )
,brand as 
	    --ADDING BRAND AND SUBFRANCHISE INFORMATION
	   ( SELECT 
        material_code
        , product_level2_description as "franchise"
        ,sub_franchise_id
        , sub_franchise_description as "sub-franchise"
        ,product_level5_description as "brand"
        FROM "adl_enriched_gbl_cf_sapbods"."dim_material")
, sales AS (
        SELECT 
         sales_document_number
         ,sales_document_item
         ,material_code
         ,ship_to_customer_nbr
         ,created_by
         ,created_date
         ,header_created_by          --,EXTRACT (year from created_date) as "created_date_year"          --,EXTRACT ( month from created_date ) as "created_date_month"
         ,date_parse( CONCAT(cast(created_date as varchar),' ', created_time), '%Y-%m-%d %H:%i:%s') as created_timestamp
         ,item_category_id          --,item_category_description
         ,sales_document_type          --,sold_to_customer_nbr          --,reason_rejection
         ,sales_organization
         ,original_vendor
         ,plant
         ,shipping_condition
         ,customer_purchase_order_number
         ,requested_delivery_date_in_item_level
         ,net_value_ast_lc3
         ,payment_terms  
         ,delivery_date 
         ,CASE WHEN CAST(created_date as DATE) >= CAST('2023-04-30' as date) 
               THEN header_created_by 
               ELSE created_by END "created_by_corrected"
        FROM adl_enriched_gbl_cf_sapbods.fact_sales_oti 
        WHERE 
        calendar_year >= year(current_date)-1
        and reason_rejection is NULL
        AND sales_document_type IN ('Z8FA')--, 'Z8C1', 'Z8F2')
        AND  sales_organization IN ('CH10', 'PA10') --company code Only Alcon Pharmaceuticals LTD & Alcon Panama
        and plant NOT IN ('CH06')  --plant NOT IN ('CH10','PA01', 'CH06') 
        AND order_type <> 'WEB' 
        AND distribution_channel = 'TR'
)
, pmt_text AS 
    (select distinct pmnttrms, txtmd as "payment_terms_text" from "adl_enriched_gbl_cf_sapbods"."payment_terms_desc" 
    where pmnttrms IS NOT NULL and txtmd is not null)
, output AS (
    SELECT 
    CONCAT(s.sales_document_number,s.material_code ) as "primarykey_foresight_so_mat"
    ,s.sales_document_number
    , s.sales_document_item --
    , s.material_code --    , s."created_date_year", --    , s."created_date_month"
    ,s.created_timestamp
    ,s.sales_organization --    ,s.reason_rejection
    ,s.original_vendor
    ,s.plant
    ,s.shipping_condition
    ,s.requested_delivery_date_in_item_level
    ,s.payment_terms     
    ,s.header_created_by     
    ,s.created_by     --
    ,s."created_by_corrected"     --
    , CASE s."created_by_corrected"     
      WHEN 'BOT_APL_001' THEN 'BOT'     
      WHEN 'BOT_APL_002' THEN 'BOT'     
      ELSE 'CSR'  END "created_by_bot_csr"
    ,pmt_text."payment_terms_text"
    ,cust.country as "ship_to_customer_country"
    ,cust.sap_commercial_account_name as "customer_name"--,cust2.sap_commercial_account_name "sold_to_customer_name"
    ,m.cluster
    ,m.country_name
    ,m.is_affiliate__ship_to_county
    ,brand."franchise"
    ,brand."sub-franchise"
    ,brand.sub_franchise_id
    ,brand."brand"
    ,s.customer_purchase_order_number
    ,s.net_value_ast_lc3
    ,s.delivery_date 
    FROM sales   s
    LEFT JOIN cust ON s.ship_to_customer_nbr = cust.sap_commercial_account_id --adding customer_name     --LEFT JOIN cust cust2 ON s.sold_to_customer_nbr = cust2.sap_commercial_account_id --adding customer_name
    INNER JOIN manual_country_info m on cust.country = m.country
    LEFT JOIN brand on s.material_code = brand.material_code  
    LEFT JOIN pmt_text on s.payment_terms = pmt_text.pmnttrms
    WHERE brand."franchise" IN ('Surgical Business','Vision Care Business')     --AND  "created_by_corrected" NOT IN ('BATCH-CET', 'BATCH-USER')
)
SELECT *
from output 