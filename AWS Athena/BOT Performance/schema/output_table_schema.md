# Table Schemas


This document outlines the structure of the tables that are OUTPUT of the SQL queries provided in the `queries/` folder. 

---

## 1. **Output: `input_table_schema`**

This table contains country mapping information for GEM region.

| Column Name       | Data Type    | Description                                    |
|-------------------|--------------|------------------------------------------------|
| `job_status__c`   | string           | Job Status  in Salesfoce  |
| `casenumber`   | string           | Case Number in Salesforce    |
| `case_owner_name_ac__c`   | string           | Case Owner name   |
| `customer_id`   | string           | SAP ID     |
| `apl_gem_sub_sub_area__c`   | string           | sub-area     |
| `apl_picked_by_bot_date_time__c`   | datetime           | time of picking the posting by bot     |
| `apl_order_placed_date_time__c`   | datetime           | time of posting by bot  |
| `apl_pending_from_csr_date_time__c`   | datetime           | time of pending status  |
| `date_time_opened_ac__c`   | datetime           | time of opening |
| `lastmodifieddate`   | datetime           | last modification datetime  |
| `sub-area_ac__c`   | string           | status of case  |
| `apl_waiting_for_bot_date_time_c`   | datetime           | waiting_time |
| `subject`   | string           | case subject |
| `customer_name`      | string           | Customers Name    |
| `country_code`     | string          | Unique country code ISO-2            |
| `country_name`      | string | Country name                 |
| `cluster`       | string | countries grouped into clusters                         |
| `is_gem_ship_to_country`           | string | identifier of GEM ship to country                |
| `is_affiliate__ship_to_country`     | string| identifier for affiliate status            |
| `service_order_number` | string | Service Order Number |
| `sales_document_number`     | string           | Unique identifier for each sales document         |
| `sales_document_item`     | string           | Sales Document Item         |
| `material_code` | string   | Foreign Key to Material     |
| `ship_to_customer_nbr`         | string |unique identifier to Ship to Customer Number     |
| `created_by`         | date  | date of creation sales document |
| `header_created_by`         | date  | date of creation sales document |
| `created_date`         | date  | date of creation sales document |
| `created_time`         | time  | date of creation sales document |
| `created_date_year`         | int  | year of creation sales document |
| `created_date_month`         | int  | month of creation sales document |
| `created_timestamp`         | datetime  | timestamp of creation sales document |
| `item_category_id`     | string           | Item Category ID      |
| `item_category_description`         | string | Item Category Description     |
| `sales_document_type`   | string | Type of sales document              |
| `reason_rejection`         | string  | Reason Rejection    |
| `sales_organization`     | string           | Sales Organization   |
| `shipping_condition`     | string         | Shipping Condition       |
| `original_vendor`   | string| Original Vendor                        |
| `plant`   | string  | Sales Plant     |
| `customer_purchase_order_number`   | string  | Customer purchase order number                       |
| `created_by_corrected`   | string  | corrected header created by                    |
| `franchise`   | string           | Franchise       |
| `sub_franchise_id`      | string           | Sub-Franchise ID   |
| `sub-franchise`      | string           | Sub-Franchise Name    |
| `brand` | string   | Brand Name         |