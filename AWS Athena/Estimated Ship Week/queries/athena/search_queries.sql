--check latest file uploads from other flow
select distinct osl_file_date from "adl_business_gem_cf_supply_chain"."weekly_cesw" osl order by osl_file_date desc


--check whether long leadtime is missing?
with franchise as (
		SELECT 
        SUBSTRING(material_code,10,9) as "material_code"
        , product_level2_description as "franchise"
        ,sub_franchise_id
        , sub_franchise_description as "sub-franchise"
        ,product_level5_description as "brand"
        ,case sub_franchise_id 
        		when 'DIA' then 'Long Leadtime'
        		when 'SGS' then 'Long Leadtime' 
        		when 'OTC' then 'Long Leadtime'
        		when 'CLC' then 'Long Leadtime' 
        		else 'Short Leadtime' end as "Leadtime"
        FROM "adl_enriched_gbl_cf_sapbods"."dim_material")

select * from "adl_business_gem_cf_supply_chain"."weekly_cesw" osl
left join franchise on osl.material = franchise.material_code
where cast(osl_file_date as varchar) = '2024-06-13'
and franchise."Leadtime" = 'Long Leadtime'
order by osl_file_date desc