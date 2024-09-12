SELECT
     i.*
   , (
        SELECT 
        CAST(
        CONCAT(CAST(YEAR(MAX(date)) AS varchar),'-', CAST(MONTH(MAX(date)) AS varchar), '-', CAST(DAY(MAX(date)) AS varchar) )
        AS date)
        FROM "adl_business_gem_cf_supply_chain"."gem_iol_consignment"
        WHERE (data_set = 'stock')
    ) max_stock_date
   FROM
     "adl_business_gem_cf_supply_chain"."gem_iol_consignment" i
   WHERE (NOT (sold_to_party IN ('0100586778', '0100242072', '0100240863')))