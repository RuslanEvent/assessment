CREATE TABLE IF NOT EXISTS customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email_address VARCHAR(100) NOT NULL,
    country VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
DISTRIBUTED BY (customer_id);


CREATE TABLE IF NOT EXISTS products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    category VARCHAR(50),
    stock INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
DISTRIBUTED BY (product_id);

CREATE TABLE IF NOT EXISTS sales_transactions (
    transaction_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    quantity_purchased INT NOT NULL,
    total_amount NUMERIC(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
)
DISTRIBUTED BY (customer_id);

CREATE TABLE sales_transactions_2023 PARTITION OF sales_transactions
    FOR VALUES FROM ('2023-01-01') TO ('2023-12-31');
CREATE TABLE sales_transactions_2024 PARTITION OF sales_transactions
    FOR VALUES FROM ('2024-01-01') TO ('2024-12-31');

CREATE INDEX idx_total_amount ON sales_transactions USING btree (total_amount);


CREATE TABLE IF NOT EXISTS shipping_details (
    transaction_id INT,
    shipping_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    shipping_address VARCHAR(255) NOT NULL,
    city VARCHAR(100),
    country VARCHAR(50),
    FOREIGN KEY (transaction_id) REFERENCES sales_transactions(transaction_id)
)
DISTRIBUTED BY (transaction_id);