SELECT * FROM (
WITH manual_country_info as( 
                SELECT 
                country
                ,country_name
                ,cluster
                ,is_gem_ship_to_country
                ,is_european_union
                ,is_affiliate__ship_to_county
                FROM adl_business_gem_cf_supply_chain.GEM_supply_chain_clusters
                WHERE is_gem_ship_to_country = 'true')
, cust as 
    	    (select distinct 
    	    cust.sap_commercial_account_id
    	    ,cust.sap_commercial_account_name 
    	    ,cust.country
    	   from "adl_enriched_gbl_cf_reference"."dim_customer" cust
    	   )
,billing_invoice as 
    (   SELECT 
        base.sales_document_number
        ,base.billing_document_number
        ,base.bill_date
        ,base.sales_organization
        ,base.ship_to_customer_nbr
        ,base.billing_type
        ,base.billing_type_description
        ,base.material_code
        ,base.item_category_id
        ,base.item_category_description
        ,base.reference_document
         FROM ( SELECT 
            sales_document_number
           ,billing_document_number
           ,bill_date
           ,sales_organization
           ,ship_to_customer_nbr
           ,billing_type
           ,billing_type_description
           ,material_code
           ,item_category_id
           ,item_category_description
           ,reference_document
           ,row_number() over (partition by sales_document_number, material_code 
           order by billing_document_number asc) as rn
           FROM "adl_enriched_gbl_cf_sapbods"."fact_sales_billing"
           WHERE 1>0
           AND sales_organization IN ('CH10', 'PA10')
           AND billing_type = 'Z8C1' --invoice
           AND item_category_id NOT IN ('Z8GG', 'Y8FR','Y8CU','Y8FT','Y8ES')
           and YEAR(bill_date)>=Year(current_date)-1
           and sales_document_number IS NOT NULL
    ) base
    WHERE base.rn = 1
    and base.sales_document_number IS NOT NULL
) 
, billing_GTS_proforma as 
    (SELECT 
        *
        FROM "adl_enriched_gbl_cf_sapbods"."fact_sales_billing"
        WHERE 1>0
           AND sales_organization IN ('CH10', 'PA10')
           AND item_category_id NOT IN ('Z8GG', 'Y8FR','Y8CU','Y8FT','Y8ES')
           AND billing_type = 'Z8CG' -- Alcon GTS Proforma
           AND YEAR(bill_date)>=Year(current_date)-1
    )
, billing_data as (     
    SELECT 
    inv.sales_document_number
    ,inv.billing_document_number
    ,inv.bill_date
    , inv.sales_organization
    ,inv.ship_to_customer_nbr
    ,inv.billing_type
    ,inv.billing_type_description
    ,inv.material_code
    ,inv.item_category_id
    ,inv.item_category_description
    ,gts.billing_document_number as "GTS_document_number"
    ,gts.bill_date as "GTS_date"
From billing_invoice inv
LEFT JOIN billing_GTS_proforma gts on inv.sales_document_number = gts.sales_document_number and inv.material_code = gts.material_code and inv.reference_document = gts.reference_document
)
, first_delivery as
    (SELECT --276,285
    base.delivery_sales_document
    ,base.delivery_delivery_number
    ,base."delivery_shipping_date"
    ,base.delivery_actual_goods_issue_date
    ,base.delivery_created_on
    ,base.material
        FROM 
        ( SELECT -- (9,374,735)
        d.refer_doc_number as "delivery_sales_document"
        ,d.delivery "delivery_delivery_number"
        ,d.created_on "delivery_created_on"
        ,d.shipping_date "delivery_shipping_date"
        ,d.actual_gi_date "delivery_actual_goods_issue_date"
        ,d.material
        ,row_number() over (partition by d.refer_doc_number, d.material 

        order by d.created_on asc) as rn 
        FROM  "adl_enriched_gbl_cf_sapbods"."fact_delivery_item" d 
        WHERE YEAR(d.created_on) >= YEAR(current_date)-1
        and d.sales_org IN ('CH10', 'PA10')
        ) base
    WHERE
    base.rn = 1 
    and base.delivery_actual_goods_issue_date IS NOT NULL
    )
, sales as 
        (
          SELECT 
          s.sales_document_number
          , s.sales_document_type
          , s.created_date as "sales_document_created_date"
          ,s.order_type as "sales_document_order_type"
          ,s.plant "sales_plant"
          ,s.sold_to_customer_nbr
          ,s.sales_organization 
          ,s.original_vendor
          ,s.purchase_order_number
          ,s.shipping_condition
          ,s.payment_terms
          ,s.customer_purchase_order_number
          ,s.customer_purchase_order_date
          ,s.plant_description
          ,s.material_code
          ,s.shipping_point
         FROM "adl_enriched_gbl_cf_sapbods"."fact_sales_oti" s
    	  WHERE 
    	    s.sales_document_type IN ('Z8FA', 'Z8C1')
    	    and s.sales_organization IN ('CH10', 'PA10')
    	    and s.distribution_channel = 'TR' 
    	    and YEAR(s.created_date) >= YEAR(current_date)-1
                  AND reason_rejection IS NULL
    	  )
, so_delivery_frachise_material_brand as (
            SELECT
            product_level2_description as "franchise"
            ,sub_franchise_description as "sub-franchise"
            ,product_level5_description as "brand"
            ,sub_franchise_id
            ,material_code
            FROM "adl_enriched_gbl_cf_sapbods"."dim_material" brand
            )
,sales2 as 
        (
          SELECT 
          distinct s.sales_document_number
          ,s.sales_organization 
          ,s.original_vendor
          ,s.purchase_order_number
          ,s.customer_purchase_order_number
          ,s.customer_purchase_order_date
         FROM "adl_enriched_gbl_cf_sapbods"."fact_sales_oti" s
         WHERE YEAR(s.created_date) >= YEAR(current_date)-1
    	  )
, pmt_text AS 
    (select distinct pmnttrms, txtmd as "payment_terms_text" from "adl_enriched_gbl_cf_sapbods"."payment_terms_desc" 
    where pmnttrms IS NOT NULL and txtmd is not null)
SELECT 
distinct
s.sales_document_number
, s.sales_document_type
, s."sales_document_created_date"
, s.sold_to_customer_nbr
,s."sales_plant"
,s.sales_organization 
,s.original_vendor
,s.shipping_point
--,s.purchase_order_number as "PO1"
,sales2.sales_document_number as "SO2_number"
,sales2.customer_purchase_order_number "PO2_number"
,CAST(date_format( date_parse( sales2.customer_purchase_order_date, '%Y.%m.%d'), '%Y-%m-%d')as date) as  "PO2_date" 
,s.shipping_condition
,s.payment_terms
,pmt_text."payment_terms_text"
,s.customer_purchase_order_number "PO1_customer_order_number"
,CAST(date_format( date_parse( s.customer_purchase_order_date, '%Y.%m.%d'), '%Y-%m-%d')as date) as  "PO1_customer_order_date" 
,s.plant_description
,d.delivery_delivery_number  
,d.delivery_created_on
,d.delivery_actual_goods_issue_date
,d.material
,b.billing_document_number
,b."GTS_document_number"
,b."GTS_date"
,cust.sap_commercial_account_name "Customer Name"
,cust2.sap_commercial_account_name "Sold To Customer Name"
,cust.country as "ship_to_customer_country"
,cust2.country as "sold_to_customer_country"
,m.country_name
,m.cluster
,m.is_gem_ship_to_country
,m.is_european_union
,m.is_affiliate__ship_to_county
,v.is_virtual
,v.apl_plant
,sdf."franchise"
,sdf."sub-franchise"
,sdf."sub_franchise_id"
,sdf."brand"
,year(d.delivery_actual_goods_issue_date) as "actual_good_issued_year"
,Extract(week from d.delivery_actual_goods_issue_date) as "actual_goods_issued_weeknum"
FROM manual_country_info m
INNER JOIN cust ON m."country" = cust.country
INNER JOIN billing_data b on b.ship_to_customer_nbr = cust.sap_commercial_account_id
INNER JOIN sales s on s.sales_document_number = b.sales_document_number  and s.material_code = b.material_code 
INNER JOIN first_delivery d on s.sales_document_number = d.delivery_sales_document and s.material_code = d.material 
LEFT JOIN cust cust2 on s.sold_to_customer_nbr = cust2.sap_commercial_account_id
LEFT JOIN "adl_business_gem_cf_supply_chain"."virtual_plants" as v on v.plant = s.sales_plant
LEFT JOIN so_delivery_frachise_material_brand sdf on sdf.material_code = s.material_code
LEFT JOIN  sales2 on SUBSTR(s.purchase_order_number, LENGTH(s.purchase_order_number)-9, 10)= sales2.customer_purchase_order_number
LEFT JOIN pmt_text on s.payment_terms = pmt_text.pmnttrms
)