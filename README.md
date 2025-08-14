# 📊 Amazon Sales Analysis (SQL Project)

## 📌 Project Overview
This project is a **SQL-based business analysis** performed on an **Amazon-like e-commerce dataset** (mock data).  
The goal is to **solve real-world business questions** using SQL queries and extract **valuable insights** for decision-making.
##ER-diagram
<img width="1441" height="790" alt="Screenshot 2025-08-10 125722" src="https://github.com/user-attachments/assets/7766c14b-c246-45b4-9178-b093dce336c8" />


## 🗂 Dataset Description
The dataset contains multiple related tables:
- **category** – Product category details.
- **products** – Product information including cost of goods sold.
- **customers** – Customer profiles with location.
- **orders** – Order details with dates and statuses.
- **order_items** – Quantity, price, and total sales for each product in an order.
- **shipping** – Shipping details including provider and delivery status.
- **sellers** – Seller profiles.
- **payments** – Payment details and status.
- **inventory** – Stock levels and warehouse info.

> **Note:** The dataset is **synthetic** and does not contain real Amazon data.

## 🛠 Tools & Technologies
- **SQL** (PostgreSQL syntax)
- **Joins, CTEs, Window Functions**
- **Aggregation & Ranking**
- **Date Functions**
- **Stored Procedures**

## 🎯 Business Problems Solved
The following queries were implemented:

1. **Top Selling Products** – Identify the top 10 products by sales.
2. **Revenue by Category** – Calculate revenue and % contribution per category.
3. **Average Order Value (AOV)** – For customers with more than 5 orders.
4. **Monthly Sales Trend** – Compare sales with previous month.
5. **Customers with No Purchase** – Registered but never ordered.
6. **Best-Selling Categories by State**.
7. **Customer Lifetime Value (CLTV)** – Rank customers by total spend.
8. **Inventory Stock Alerts** – Products with low stock.
9. **Shipping Delays** – Orders delayed by more than 4 days.
10. **Payment Success Rate** – % of successful payments by status.
11. **Top Performing Sellers** – Including % of successful orders.
12. **High-Value Customers** – Purchases above average order value.
13. **Product Profit Margin** – Ranking by profitability.
14. **Most Returned Products** – Including return rate.
15. **Inactive Sellers** – No sales in last 6 months.
16. **Customer Status (Returning/New)** – Based on returns.
17. **Top Customers by State** – Top 5 by orders in each state.
18. **Revenue by Shipping Provider** – Total orders and avg delivery time.
19. **Products with Decreasing Revenue** – Year-over-year comparison.
20. **Inventory Update Procedure** – Automatically reduces stock after a sale.

## 📈 Key Insights
- Identified top-performing products and sellers.
- Found categories contributing the most to revenue.
- Detected potential supply chain delays.
- Highlighted customer retention and repeat purchase patterns.
- Developed a stored procedure to manage inventory in real-time.

## 💡 Sample Queries

### 1️⃣ Top Selling Products
```sql
SELECT p.product_name,
       ot.product_id,
       SUM(ot.quantity) AS total_quantity,
       SUM(ot.total_sales) AS total_sales,
       COUNT(ot.order_id) AS total_orders
FROM products AS p
JOIN order_items AS ot
  ON p.product_id = ot.product_id
GROUP BY 1, 2
ORDER BY total_quantity DESC
LIMIT 10;
```
### 2️⃣ Revenue by Category with % Contribution (Aggregation + Subquery)
```sql
SELECT cat.category_id,
cat.category_name,
SUM(ot.total_sales) AS total_sales,
ROUND(SUM(ot.total_sales)::NUMERIC /
(SELECT SUM(total_sales) FROM order_items)::NUMERIC * 100, 2) AS per_contribution
FROM category AS cat
JOIN products AS p
  ON p.category_id = cat.category_id
JOIN order_items AS ot
  ON ot.product_id = p.product_id
GROUP BY 1, 2
ORDER BY per_contribution DESC;

```
### 3️⃣ Monthly Sales Trend with Previous Month Comparison (CTE + Window Function)
```sql
 WITH monthly_trend AS (
SELECT EXTRACT(YEAR FROM o.order_data) AS year,
EXTRACT(MONTH FROM o.order_data) AS month,
ROUND(SUM(oi.total_sales)::NUMERIC, 2) AS total_sales,
LAG(SUM(oi.total_sales)) OVER(
ORDER BY EXTRACT(YEAR FROM o.order_data), EXTRACT(MONTH FROM o.order_data)
) AS previous_month
    FROM orders AS o
    JOIN order_items AS oi
      ON oi.order_id = o.order_id
    WHERE o.order_data >= CURRENT_DATE - INTERVAL '2 year'
    GROUP BY 1, 2
)
SELECT *,
       (total_sales - previous_month) / previous_month AS value_diff
FROM monthly_trend;

```

### 4️⃣ Customer Lifetime Value (CLTV) (Ranking + Aggregation)
```sql
SELECT cus.customer_id,
CONCAT(cus.first_name, ' ', cus.last_name) AS full_name,
SUM(quantity) AS total_quantity,
SUM(total_sales) AS total_spent,
DENSE_RANK() OVER(ORDER BY SUM(total_sales) DESC) AS rank_by_value
FROM orders AS o
JOIN customers AS cus
  ON cus.customer_id = o.customer_id
JOIN order_items AS oi
  ON oi.order_id = o.order_id
GROUP BY 1, 2
ORDER BY total_spent DESC;

```
5️⃣ Inventory Update Procedure (PL/pgSQL Stored Procedure)
```sql
CREATE OR REPLACE PROCEDURE update_inventory_after_sale(
    p_order_id INT,
    p_customer_id INT,
    p_seller_id INT,
    p_order_item_id INT,
    p_product_id INT,
    p_quantity INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_price FLOAT;
    v_count INT;
BEGIN
    SELECT price_per_unit
    INTO v_price
    FROM products
    WHERE product_id = p_product_id;

    SELECT COUNT(*)
    INTO v_count
    FROM inventory
    WHERE product_id = p_product_id
      AND stock >= p_quantity;

    IF v_count > 0 THEN
        INSERT INTO orders(order_id, order_data, customer_id, seller_id)
        VALUES (p_order_id, CURRENT_DATE, p_customer_id, p_seller_id);

        INSERT INTO order_items(order_item_id, order_id, product_id, quantity, price_per_unit, total_sales)
        VALUES (p_order_item_id, p_order_id, p_product_id, p_quantity, v_price, p_quantity * v_price);

        UPDATE inventory
        SET stock = stock - p_quantity
        WHERE product_id = p_product_id;

        RAISE NOTICE 'Thank you for purchasing';
    ELSE
        RAISE NOTICE 'Product is not available';
    END IF;
END;
$$;

```

## 🚀 How to Use
1. Import the dataset into your **PostgreSQL** database.
2. Run the provided SQL queries in sequence.
3. Modify table names or schema if needed.
4. Use the results for **business decision-making** or **dashboards**.

## 📬 Contact
**Author:** Sahil F  
**LinkedIn:** https://www.linkedin.com/in/sahilf2003  
**GitHub:** https://github.com/SahilCoder2003

