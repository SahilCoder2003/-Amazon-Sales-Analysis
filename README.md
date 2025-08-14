# 📊 Amazon Sales Analysis (SQL Project)

## 📌 Project Overview
This project is a **SQL-based business analysis** performed on an **Amazon-like e-commerce dataset** (mock data).  
The goal is to **solve real-world business questions** using SQL queries and extract **valuable insights** for decision-making.

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

## 🚀 How to Use
1. Import the dataset into your **PostgreSQL** database.
2. Run the provided SQL queries in sequence.
3. Modify table names or schema if needed.
4. Use the results for **business decision-making** or **dashboards**.

## 📬 Contact
**Author:** Sahil F  
**LinkedIn:** https://www.linkedin.com/in/sahilf2003  
**GitHub:** https://github.com/SahilCoder2003

