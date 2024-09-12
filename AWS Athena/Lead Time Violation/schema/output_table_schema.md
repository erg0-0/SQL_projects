# Table Schemas

This document outlines the structure of the tables used in the SQL queries provided in the `queries/` folder. The tables were predesigned by data engineers, and the following information is based on the tables used in the queries.

---

## 1. **Output: `input_table_schema`**


| Column Name       | Data Type    | Description                                    |
|-------------------|--------------|------------------------------------------------|
| `primarykey_foresight_so_mat`     | string          | Unique key Sales Document and Material |
| `sales_document_number`     | string           | Unique identifier for each sales document         |
| `sales_document_item`     | string           | Sales Document Item         |
| `material_code`         | string  | Material Code    |
| `created_timestamp`         | datetime  | timestamp of creation sales document |
| `sales_organization`     | string           | Sales Organization   |
| `original_vendor`   | string| Original Vendor                        |
| `shipping_condition`     | string         | Shipping Condition       |
| `plant`   | string  | Sales Plant     |
| `requested_delivery_date_in_item_level`         | string | requested delivery date in item level      |
| `ship_to_customer_country` | varchar(2)          | Foreign Key to gem_supply_chain_clusters.country         |
| `payment_terms`     | string         | Payment Terms      |
| `header_created_by`         | date  | header created by |
| `created_by`         | string  | created by |
| `created_by_corrected`         | string  | header created by |
| `created_by_bot_csr`         | string  | header created by |
| `payment_terms_text`      | string           | Payment Terms description |
| `customer_name`      | string           | Customers Name    |
| `cluster`       | string | countries grouped into clusters                         |
| `country_name`      | string | Country name                 |
| `is_affiliate__ship_to_country`     | string| identifier for affiliate status            |
| `franchise`   | string           | Franchise       |
| `sub_franchise_id`      | string           | Sub-Franchise ID   |
| `sub_franchise_description`      | string           | Sub-Franchise Name    |
| `brand` | string   | Brand Name         |
| `customer_purchase_order_number`   | string  | Customer purchase order number                       |
| `net_value_ast_lc3`         | string | requested delivery date in item level      |
| `delivery_date`     | date         | Delivery Date  |
