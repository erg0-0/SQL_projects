# Table Schemas

This document outlines the structure of the tables used in the SQL queries provided in the `queries/` folder. The tables were predesigned by data engineers, and the following information is based on the tables used in the queries.

---

## 1. **Table: `customer_data`**

This table contains demographic and transactional data for customers.

| Column Name       | Data Type    | Description                                    |
|-------------------|--------------|------------------------------------------------|
| `customer_id`     | INT          | Unique identifier for each customer            |
| `first_name`      | VARCHAR(100) | Customer's first name                          |
| `last_name`       | VARCHAR(100) | Customer's last name                           |
| `email`           | VARCHAR(255) | Email address of the customer                  |
| `signup_date`     | DATE         | The date the customer signed up                |
| `last_purchase`   | DATE         | The date of the customer's most recent purchase|
| `total_spend`     | DECIMAL(10,2)| Total amount spent by the customer             |

---

## 2. **Table: `sales_transactions`**

This table tracks individual sales transactions for each customer.

| Column Name        | Data Type     | Description                                  |
|--------------------|---------------|----------------------------------------------|
| `transaction_id`   | INT           | Unique identifier for each transaction       |
| `customer_id`      | INT           | Foreign key referring to `customer_data`     |
| `transaction_date` | DATE          | The date the transaction occurred            |
| `transaction_amount`| DECIMAL(10,2) | The monetary value of the transaction        |
| `product_id`       | INT           | Identifier for the product being purchased   |

---

## 3. **Table: `product_catalog`**

This table contains information about the products available for sale.

| Column Name        | Data Type     | Description                                  |
|--------------------|---------------|----------------------------------------------|
| `product_id`       | INT           | Unique identifier for each product           |
| `product_name`     | VARCHAR(255)  | Name of the product                          |
| `category`         | VARCHAR(100)  | Product category (e.g., Electronics, Apparel)|
| `price`            | DECIMAL(10,2) | Unit price of the product                    |

---

## 4. **Table: `inventory`**

This table tracks the availability of products in stock.

| Column Name        | Data Type     | Description                                  |
|--------------------|---------------|----------------------------------------------|
| `product_id`       | INT           | Foreign key referring to `product_catalog`   |
| `warehouse_id`     | INT           | Identifier for the warehouse                 |
| `stock_quantity`   | INT           | The quantity of the product in stock         |

---

## 5. **Table: `warehouse`**

This table contains information about the warehouses where products are stored.

| Column Name        | Data Type     | Description                                  |
|--------------------|---------------|----------------------------------------------|
| `warehouse_id`     | INT           | Unique identifier for each warehouse         |
| `warehouse_name`   | VARCHAR(255)  | Name of the warehouse                        |
| `location`         | VARCHAR(255)  | Location of the warehouse (city, state)      |

---

### Notes:
- The `customer_data` table serves as the main reference for customer information.
- Sales data is tracked in the `sales_transactions` table, which is linked to customers via the `customer_id`.
- The `product_catalog` and `inventory` tables provide information about the products sold and their availability in different warehouses.
- Where possible, foreign key relationships have been inferred from the query context.

If you need more details or have any additional questions regarding the table structures, please refer to the SQL query comments or the project documentation.
