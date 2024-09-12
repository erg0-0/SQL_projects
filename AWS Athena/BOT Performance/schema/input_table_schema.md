# Table Schemas

This document outlines the structure of the tables used in the SQL queries provided in the `queries/` folder. The tables were predesigned by data engineers, and the following information is based on the tables used in the queries.

---

## 1. **Table: `adl_business_gem_cf_supply_chain.gem_supply_chain_clusters`**

This table contains country mapping information for GEM region.

| Column Name       | Data Type    | Description                                    |
|-------------------|--------------|------------------------------------------------|
| `country`     | string          | Unique country code ISO-2            |
| `country_name`      | string | Country name                 |
| `cluster`       | string | countries grouped into clusters                         |
| `is_gem_ship_to_country`           | string | identifier of GEM ship to country                |
| `is_affiliate__ship_to_country`     | string| identifier for affiliate status            |

---

## 2. **Table: `adl_enriched_gbl_cf_reference.dim_customer`**

This table tracks information about each customer.

| Column Name        | Data Type     | Description                                  |
|--------------------|---------------|----------------------------------------------|
| `sap_commercial_account`   | string           | Unique identifier for each customer       |
| `sap_commercial_account_name`      | string           | Customers Name    |
| `country` | varchar(2)          | Foreign Key to gem_supply_chain_clusters.country         |


## 3. **Table: `adl_business_gem_cf_supply_chain.apl_gem_bot_performance_metrics`**

This table tracks information from the Foresight.

| Column Name        | Data Type     | Description                                  |
|--------------------|---------------|----------------------------------------------|
| `job_status__c`   | string           | Job Status  in Salesfoce  |
| `casenumber`   | string           | Case Number in Salesforce    |
| `case_owner_name_ac__c`   | string           | Case Owner name   |
| `status`   | string           | Status |
| `sap_id_ac__c`   | string           | SAP ID     |
| `apl_gem_country_update_c`   | string           | country name  |
| `apl_gem_country__c`   | string           | country name     |
| `apl_gem_sub_sub_area__c`   | string           | sub-area     |
| `apl_picked_by_bot_date_time__c`   | datetime           | time of picking the posting by bot     |
| `apl_order_placed_date_time__c`   | datetime           | time of posting by bot  |
| `apl_pending_from_csr_date_time__c`   | datetime           | time of pending status  |
| `date_time_opened_ac__c`   | datetime           | time of opening |
| `lastmodifieddate`   | datetime           | last modification datetime  |
| `sub-area_ac__c`   | string           | status of case  |
| `apl_waiting_for_bot_date_time_c`   | datetime           | waiting_time |
| `subject`   | string           | case subject |
| `sap_id_ac__c`   | string           | sap_id_ac__c_normalised     |


## 4. **Table: `"adl_enriched_gbl_cf_sapbods"."dim_material"`**

This table tracks information about each material.

| Column Name        | Data Type     | Description                                  |
|--------------------|---------------|----------------------------------------------|
| `material_code` | string   | Foreign Key to Material     |
| `product_level2_description`   | string           | Franchise       |
| `sub_franchise_id`      | string           | Sub-Franchise ID   |
| `sub_franchise_description`      | string           | Sub-Franchise Name    |
| `product_level5_description` | string   | Brand Name         |


---

## 5. **Table: `"adl_enriched_gbl_cf_sapbods"."fact_sales_oti"`**

This table contains information about the sales documents.

| Column Name        | Data Type     | Description                                  |
|--------------------|---------------|----------------------------------------------|
| `sales_document_number`     | string           | Unique identifier for each sales document         |
| `service_order_number` | string | Service Order Number |
| `sales_document_item`     | string           | Sales Document Item         |
| `material_code`         | string  | Material Code    |
| `ship_to_customer_nbr`         | string |unique identifier to Ship to Customer Number     |
| `created_date`         | date  | date of creation sales document |
| `created_time`         | date  | date of creation sales document |
| `created_by`         | date  | date of creation sales document |
| `header_created_by`         | date  | date of creation sales document |
| `sales_document_type`   | string | Type of sales document              |
| `reason_rejection`         | string  | Reason Rejection    |
| `sales_organization`     | string           | Sales Organization   |
| `original_vendor`   | string| Original Vendor                        |
| `shipping_condition`     | string         | Shipping Condition       |
| `plant`   | string  | Sales Plant     |
| `customer_purchase_order_number`   | string  | Customer purchase order number                       |
| `item_category_id`     | string           | Item Category ID      |
| `item_category_description`         | string | Item Category Description     |
| `payment_terms`     | string         | Payment Terms      |
| `order_type`     | string           | Item Category ID      |
| `distribution_channel`         | string | Distribution Channel     |

*Notes:
`created_by` is correct only until 2023-04-30, after this date the `header_created_by` provides correct assignment
