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
| `is_european_union`     | string         | identifier for EU membership              |
| `is_affiliate__ship_to_country`     | string| identifier for affiliate status            |

---

## 2. **Table: `adl_enriched_gbl_cf_reference.dim_customer`**

This table tracks information about each customer.

| Column Name        | Data Type     | Description                                  |
|--------------------|---------------|----------------------------------------------|
| `sap_commercial_account`   | string           | Unique identifier for each customer       |
| `sap_commercial_account_name`      | string           | Customers Name    |
| `country` | varchar(2)          | Foreign Key to gem_supply_chain_clusters.country         |


---

## 3. **Table: `adl_enriched_gbl_cf_sapbods.fact_sales_billing`**

This table contains information about the billing of sale.

| Column Name        | Data Type     | Description                                  |
|--------------------|---------------|----------------------------------------------|
| `sales_document_number`       | string           | Unique identifier for each product           |
| `billing_document_number`     | string  | Name of the product                          |
| `bill_date`         | date  | Product category (e.g., Electronics, Apparel)|
| `sales_organization`            | string | Unit price of the product                    |
| `ship_to_customer_nbr`| string | Ship to Customer Number |
| `billing_type`| string | Billing type |
| `billing_type_description`| string | Billing Type description |
|`material_code` | string | Material Code |
|`item_category_id` | string | Item Category ID |
| `item_category_description` | string | Item Category description |
| `reference_document` | string | Reference Document Foreign Key: Sales document number |

---

## 4. **Table: `adl_enriched_gbl_cf_sapbods.fact_delivery_item`**

This table tracks the deliveries.

| Column Name        | Data Type     | Description                                  |
|--------------------|---------------|----------------------------------------------|
| `refer_doc_number`       | string           | Foreign key referring to `product_catalog`   |
| `delivery`     | string           | Delivery number               |
| `created_on`   | date           | Date created delivery        |
| `shipping_date`   | date           | shipping date      |
| `actual_gi_date`   | date           | actual goods issued date        |
| `material`   | string           | material code         |
| `sales_org`   | string           | sales organization        |


---

## 5. **Table: `"adl_enriched_gbl_cf_sapbods"."fact_sales_oti"`**

This table contains information about the sales documents.

| Column Name        | Data Type     | Description                                  |
|--------------------|---------------|----------------------------------------------|
| `sales_document_number`     | string           | Unique identifier for each sales document         |
| `sales_document_type`   | string | Type of sales document              |
| `created_date`         | date  | date of creation sales document |
| `order_type`     | string           | Order type or Data source in BI      |
| `plant`   | string  | Sales Plant                       |
| `sold_to_customer_nbr`         | string |unique identifier to Sold to Customer Number     |
| `sales_organization`     | string           | Sales Organization   |
| `original_vendor`   | string| Original Vendor                        |
| `purchase_order_number`         | string | Purchase Order Number      |
| `payment_terms`     | string         | Payment Terms      |
| `shipping_condition`     | string         | Shipping Condition       |
| `customer_purchase_order_number`   | string  | Customer purchase order number                       |
| `customer_purchase_order_date`   | string | Customer Purchase Order Date   |
| `plant_description`         | string  | Plant Description     |
| `material_code`         | string  | Material Code    |
| `shipping_point`         | string | Shipping Point      |
| `distribution_channel`         | string | Distribution Channel     |
| `reason_rejection`         | string  | Reason Rejection    |


## 6. **Table: `"adl_enriched_gbl_cf_sapbods"."dim_material"`**

This table tracks information about each material.

| Column Name        | Data Type     | Description                                  |
|--------------------|---------------|----------------------------------------------|
| `product_level2_description`   | string           | Franchise       |
| `sub_franchise_id`      | string           | Sub-Franchise ID   |
| `sub_franchise_description`      | string           | Sub-Franchise Name    |
| `product_level5_description` | string   | Brand Name         |
| `material_code` | string   | Foreign Key to Material     |

## 7. **Table: `"adl_enriched_gbl_cf_sapbods"."payment_terms_desc" `**

This table contains information about the payment terms description as enrichment.

| Column Name        | Data Type     | Description                                  |
|--------------------|---------------|----------------------------------------------|
| `pmnttrms`   | string           | Foreign Key Payment Terms code        |
| `txtmd`      | string           | Payment Terms description |

