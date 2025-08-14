CREATE TABLE CUSTOMERS(
	customer_id  INT PRIMARY KEY,
	first_name VARCHAR(15),
	last_name VARCHAR(15),
	state  VARCHAR(20)
)

CREATE TABLE category(
	category_id INT PRIMARY KEY,
	category_name VARCHAR(20)
)

CREATE TABLE sellers(
	seller_id INT PRIMARY KEY,
	seller_name VARCHAR(25),
	origin VARCHAR(10)
)

CREATE TABLE products(
	product_id INT PRIMARY KEY,
	product_name VARCHAR(50),
	price FLOAT,
	cogs FLOAT,
	category_id INT,

CONSTRAINT fk_category_id FOREIGN KEY(category_id) REFERENCES category(category_id)
)

CREATE TABLE inventory(
	inventory_id INT PRIMARY KEY,
	product_id INT,
	stock INT,
	warehouse_id INT,
	last_stock_date DATE,
CONSTRAINT fk_product_id FOREIGN KEY(product_id) REFERENCES products(product_id)
)

CREATE TABLE orders(
	order_id INT PRIMARY KEY,
	order_data DATE,
	customer_id INT,
	seller_id INT,
	order_status VARCHAR(15),

CONSTRAINT fk_customer_id FOREIGN KEY(customer_id) REFERENCES customers(customer_id),
CONSTRAINT fk_seller_id FOREIGN KEY(seller_id ) REFERENCES sellers(seller_id)
)

CREATE TABLE payments(
	payment_id INT PRIMARY KEY,
	order_id INT,
	payment_date DATE,
	payment_status VARCHAR(20),

CONSTRAINT fk_order_id FOREIGN KEY(order_id) REFERENCES orders(order_id)	
)

CREATE TABLE shipping(
	shipping_id INT PRIMARY KEY,
	order_id INT,
	shipping_date DATE,
	return_date DATE,
	shipping_provider VARCHAR(10),
	delivery_status VARCHAR(10)
)

ALTER TABLE shipping
ADD CONSTRAINT fk_order_id FOREIGN KEY(order_id)
REFERENCES orders(order_id)

DROP TABLE IF EXISTS order_itmes;
CREATE TABLE order_itmes(
	order_item_id INT PRIMARY KEY,
	order_id INT,
	product_id INT,
	quantity INT,
	price_per_unit FLOAT,

CONSTRAINT fk_order_id FOREIGN KEY(order_id) REFERENCES orders(order_id),
CONSTRAINT fk_product_id FOREIGN KEY(product_id) REFERENCES products(product_id)
)