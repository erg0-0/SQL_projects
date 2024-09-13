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
| `is_european_union`   | string  |  indicator for EU membership                   |

---

## 2. **Table: `adl_enriched_gbl_cf_reference.dim_customer`**

This table tracks information about each customer.

| Column Name        | Data Type     | Description                                  |
|--------------------|---------------|----------------------------------------------|
| `sap_commercial_account`   | string           | Unique identifier for each customer       |
| `sap_commercial_account_name`      | string           | Customers Name    |
| `country` | varchar(2)          | Foreign Key to gem_supply_chain_clusters.country         |


## 3. **Table: `"adl_enriched_gbl_cf_sapbods"."fact_sales_billing"`**

This table tracks information about each customer.

| Column Name        | Data Type     | Description                                  |
|--------------------|---------------|----------------------------------------------|
| `sales_document_number`   | string           | Unique identifier for each sales document       |
| `billing_document_number`      | string           | billing document number   |
| `bill_date` | date         | billing date        |
| `ship_to_customer_nbr` | string         | Ship To customer Number       |
| `billing_type` | string          | Billing Type         |
| `material_code` | string       | Material Code       |
| `item_category_id` | string         | Item Category ID         |
| `item_category_description` | string      | Item Category Description       |

## 4. **Table: `"adl_enriched_gbl_cf_sapbods"."fact_delivery_item"`**

This table tracks information about each customer.

| Column Name        | Data Type     | Description                                  |
|--------------------|---------------|----------------------------------------------|
| `refer_doc_number`   | string           | sales document  number Foreign Key     |
| `delivery`      | string           | delivery document number   |
| `actual_gi_date` | date         | actual goods issued date        |
| `material` | string       | Material Code       |



## 5. **Table: `"adl_enriched_gbl_cf_sapbods"."dim_material"`**

This table tracks information about each material.

| Column Name        | Data Type     | Description                                  |
|--------------------|---------------|----------------------------------------------|
| `material_code` | string   | Foreign Key to Material     |
| `product_level2_description`   | string           | Franchise       |
| `sub_franchise_id`      | string           | Sub-Franchise ID   |
| `sub_franchise_description`      | string           | Sub-Franchise Name    |
| `product_level5_description` | string   | Brand Name         |


---

## 6. **Table: `"adl_enriched_gbl_cf_sapbods"."fact_sales_oti"`**

This table contains information about the sales documents.

| Column Name        | Data Type     | Description                                  |
|--------------------|---------------|----------------------------------------------|
| `sales_document_number`     | string           | Unique identifier for each sales document         |
| `sales_document_type`   | string | Type of sales document              |
| `created_date`         | date  | date of creation sales document |
| `order_type`     | string           | Item Category ID      |
| `sales_plant`   | string  | Sales Plant     |
| `plant_description`   | string  | Plant Description     |
| `sales_organization`     | string           | Sales Organization   |
| `original_vendor`   | string| Original Vendor                        |
| `purchase_order_number`   | string  |  purchase order number                       |
| `shipping_condition`     | string         | Shipping Condition       |
| `payment_terms`     | string         | Payment Terms      |
| `customer purchase_order_number`   | string  |  Customer purchase order number                       |
| `material_code`         | string  | Material Code    |
| `sales_document_item`     | string           | Sales Document Item         |
| `ship_to_customer_nbr`         | string |unique identifier to Ship to Customer Number     |
| `distribution_channel`         | string | Distribution Channel     |

## 7. **Table: `"adl_business_gem_cf_supply_chain"."weekly_cesw"`**

This table contains information about the OSLs.

| Column Name        | Data Type     | Description                                  |
|--------------------|---------------|----------------------------------------------|
| `sales_order_no`     | string           | Unique identifier for each sales document         |
| `material`   | string | material code             |
| `delivery_number`         | date  | date of delivery |
| `propose_estimated_ship_week__date_format`     | date           | Proposed estimated ship week     |
| `estimated_ship_week_date_format_cs`     | date           | Estimated Ship Week   |
| `osl_file_date`   | date| Load Date of the OSL file                      |


## 8. **Table: `adl_enriched_gbl_cf_sapbods.fact_delivery_item`**

This table tracks the deliveries.

| Column Name        | Data Type     | Description                                  |
|--------------------|---------------|----------------------------------------------|
| `refer_doc_number`       | string           | Foreign key referring to `product_catalog`   |
| `delivery`     | string           | Delivery number               |
| `actual_gi_date`   | date           | actual goods issued date        |
| `material`   | string           | material code         |



