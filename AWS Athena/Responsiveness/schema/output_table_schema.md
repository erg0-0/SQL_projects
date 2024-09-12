# Table Schemas

This document outlines the structure of the tables that are OUTPUT of the SQL queries provided in the `queries/` folder. 

---

## 1. **Output: `input_table_schema`**

This table contains responsiveness information about the supply process for GEM region for current and previous year. The output is used as a datasource for Tableau dashboard.

| Column Name       | Data Type    | Description                                    |
|-------------------|--------------|------------------------------------------------|
| `sales_document_number`       | string           | Unique identifier for each product           |
| `sales_document_type`   | string | Type of sales document              |
| `sales_document_created_date`         | date  | date of creation sales document |
| `sold_to_customer_nbr`         | string |unique identifier to Sold to Customer Number     |
| `plant`   | string  | Sales Plant                       |
| `sales_organization`   | string           | sales organization        |
| `original_vendor`   | string| Original Vendor                        |
| `shipping_point`         | string | Shipping Point      |
| `SO2`       | string           | sales document number used in the intercompany transactions           |
| `PO2`         | string | Purchase Order Number used in the intercompany transactions    |
| `shipping_condition`     | string         | Shipping Condition       |
| `payment_terms`     | string         | Payment Terms      |
| `payment_terms_text`      | string           | Payment Terms description |
| `PO1_customer_order_number`   | string  | Customer purchase order number on the external Purchase Order Documents                   |
| `PO1_customer_purchase_order_date`   | string | Customer Purchase Order Date  on the external Purchase Order Documents    |
| `plant_description`         | string  | Plant Description     |
| `delivery_delivery_number`     | string           | Delivery number |      
| `delivery_created_on`   | date           | Date created delivery        |
| `delivery_actual_gi_date`   | date           | actual goods issued date        |
|`material` | string | Material Code |
| `billing_document_number`     | string  | Name of the product                          |
| `country`     | string          | Unique country code ISO-2            |
| `country_name`      | string | Country name                 |
| `cluster`       | string | countries grouped into clusters                         |
| `is_gem_ship_to_country`           | string | identifier of GEM ship to country                |
| `is_european_union`     | string         | identifier for EU membership              |
| `is_distributor__ship_to_country`   | string         | identifier for distributor status|
| `is_affiliate__ship_to_country`     | string| identifier for affiliate status            |
| `sap_commercial_account`   | string           | Unique identifier for each customer       |
| `sap_commercial_account_name`      | string           | Customers Name    |
| `country` | varchar(2)          | Foreign Key to gem_supply_chain_clusters.country         |
| `GTS_date`         | date  | billing date or GTS document date|
| `GTS_document_number`         | string  | billing document |
| `Customer Name`| string | Ship to Customer Name |
| `Sold To Customer Name`| string | Sold to Customer Name |
| `ship_to_customer_country`| varchar(2) | Ship to customer country code ISO-2 |
| `sold_to_customer_country`| varchar(2) | Sold to customer country code ISO-2 |
| `country_name` | string        | country_name       |
| `cluster` | string        | cluster       |
| `is_gem_ship_to_country`           | string | identifier of GEM ship to country                |
| `is_european_union`     | string         | identifier for EU membership              |
| `is_affiliate__ship_to_country`     | string| identifier for affiliate status            |
| `is_virtual`     | string| identifier for plant type             |
| `apl_plant`     | string| plant name         |
| `franchise`   | string           | Franchise       |
| `sub-franchise`      | string           | Sub-Franchise description   |
| `sub_franchise_id`      | string           | Sub-Franchise ID    |
| `brand` | string   | Brand Name         |
| `actual_good_issued_year` | int   | actual good issued year     |
| `actual_good_issued_weeknum` | int   | actual good issued weeknumber     |
