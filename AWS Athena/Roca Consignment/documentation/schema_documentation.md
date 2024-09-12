# Table Schemas

This document outlines the structure of the tables used in the SQL queries provided in the `queries/` folder. The tables were predesigned by data engineers, and the following information is based on the tables used in the queries.

---

## 1. **Table: `gem_iol_consignment`**

This table contains the transactional data for supply chain in area of IOL.

| Column Name       | Data Type    | Description                                    |
|-------------------|--------------|------------------------------------------------|
| `region`          | string       | region                                         |
| `cluster   `      | string       | cluster                                        |
| `country`         | string       | country name                                   |
| `date `           | date         | date of the transaction                        |
| `sold_to_party`   | string       | Sold To Party                                  |
| `sold_to_party_name`   | string         | Name of the sold to party|
| `sold_to_party_customer_group_description`     | string| Name of the customer group          |
| `ship_to_party` | string | Ship to party |
|`ship_to_party_group`|  string | Name of the ship to party group |
|`sales_rep_concat` | string | sales representative name |
|`product_level4_description` | string | Organizational Hierarchy level 4|
|`product_level5_description`| string | Organizational Hierarchy level 5 |
| `product_level6_description`| string | Organizational Hierarchy level 6 |
| `product_level7_description`| string | Organizational Hierarchy level 7|
| `iol_diopter`| string | Diopter of IOL products|
| `iol_latest_status`| string | IOL latest status|
| `inventory`| bigint | Inventory|
| `avg_price_usd`| float | Average price in USD|
| `sales_last_6_months`| string | Sales last 6 months|
| `idle_exclusion`| boolean | Idle exclusion|
| `batch_exp_date`| date | batch expiration date|
| `expiry` | varchar(6) | expiry|
|`data_set`| varchar(10) | data set|
| `type`| varchar(11) |type|
| `quantity`| decimal(38,5) | quantity|
| `billed_sales_usd`| double | Billed Sales in USD|
| `billed_sales_lc`| decimal (38,5) | Billed sales in Local Currency|
| `latest_transaction_ts`| string | Lates transaction ts|
| `exp_projection_date`| date | Expiration projection date|
| `expiry_bucket`| varchar(6) | Expiry bucket |
| `exp_inventory`| bigint | Expiry inventory |


