# Table Schemas

This document outlines the structure of the tables used in the SQL queries provided in the `queries/` folder. The tables were predesigned by data engineers, and the following information is based on the tables used in the queries.

---

## 1. **Output: `input_table_schema`**


| Column Name       | Data Type    | Description                                    |
|-------------------|--------------|------------------------------------------------|
| `sales_document_number`   | string           | Unique identifier for each sales document       |
| `sales_document_type`   | string | Type of sales document              |
| `sales_document_created_date`         | date  | date of creation sales document |
| `sales_plant`   | string  | Sales Plant     |
| `sales_organization`     | string           | Sales Organization   |
| `customer_name`      | string           | Customers Name    |
| `original_vendor`   | string| Original Vendor                        |
| `shipping_condition`     | string         | Shipping Condition       |
| `payment_terms`     | string         | Payment Terms      |
| `plant_description`   | string  | Plant Description     |
| `delivery_delivery_number`      | string           | delivery document number   |
| `actual_gi_date`   | date           | actual goods issued date        |
| `material`   | string           | material code         |
| `ship_to_customer_country` | varchar(2)          | Foreign Key to gem_supply_chain_clusters.country         |
| `customer purchase_order_number`   | string  |  Customer purchase order number                       |
| `country_name`      | string | Country name                 |
| `cluster`       | string | countries grouped into clusters                         |
| `is_affiliate__ship_to_country`     | string| identifier for affiliate status            |
| `is_european_union`   | string  |  indicator for EU membership                   |
| `franchise`   | string           | Franchise       |
| `sub_franchise_id`      | string           | Sub-Franchise ID   |
| `sub_franchise_description`      | string           | Sub-Franchise Name    |
| `brand` | string   | Brand Name         |
| `primarykey_foresight_` | string   | unique identifier Sales Document + Material          |
| `actual_good_issued_year` | date         | actual goods issued year        |
| `actual_good_issued_weeknum` | date         | actual goods issued weeknum        |