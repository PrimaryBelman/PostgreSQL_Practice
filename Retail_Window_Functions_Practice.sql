create table customers(customer_id SERIAL primary key,customer_fname TEXT,customer_lname TEXT, signup_date DATE);

create table products(product_id SERIAL primary key, product_name TEXT, category TEXT, price NUMERIC);

create table stores(store_id SERIAL primary key, store_name TEXT, location TEXT);

create table transactions(
transaction_id SERIAL primary key,
customer_id INT references customers(customer_id),
product_id INT references products(product_id),
store_id INT references stores(store_id),
quantity INT,
totaL_amount NUMERIC,
transaction_date DATE
);


INSERT INTO customers (customer_fname, customer_lname, signup_date) VALUES
('Alice', 'Anderson', '2023-01-10'),
('Bob', 'Brown', '2023-01-15'),
('Charlie', 'Clark', '2023-02-01'),
('Diana', 'Doe', '2023-02-20'),
('Eve', 'Evans', '2023-03-05'),
('Frank', 'Foster', '2023-03-10'),
('Grace', 'Green', '2023-03-15');

INSERT INTO customers (customer_fname, customer_lname, signup_date) VALUES
('Harinder', 'Singh', '2023-01-10'),
('Imogen','Iulia','2023-03-15'),
('Jenna','Jaimeson','2023-04-10');

INSERT INTO products (product_name, category, price) VALUES
('Laptop', 'Electronics', 1200.00),
('Headphones', 'Electronics', 150.00),
('Desk Chair', 'Furniture', 250.00),
('Standing Desk', 'Furniture', 500.00),
('Water Bottle', 'Accessories', 25.00),
('Monitor', 'Electronics', 300.00);

INSERT INTO products (product_name, category, price) VALUES
('Mobile Charger','Electronics',95.00),
('Egronomic stand','Accessories',45.00),
('Keyboard','Electronics',30.00),
('Mouse','Electronics',5.00),
('Writing Board','Accessories',40.00),
('Markers Box','Accessories',10.00),
('Eraser','Accessories',20.00);



INSERT INTO stores (store_name, location) VALUES
('Downtown NY', 'New York'),
('Uptown NY', 'New York'),
('Central SF', 'San Francisco'),
('Midtown LA', 'Los Angeles'),
('Downtown Chicago', 'Chicago');

INSERT INTO stores (store_name, location) VALUES
('Uptown Charlotte', 'Charlotte'),
('Downtown Atlanta', 'Atlanta'),
('Charleston', 'Charleston'),
('Downtown Columbia', 'Columbia');


INSERT INTO transactions (customer_id, product_id, store_id, quantity, total_amount, transaction_date) VALUES
(1, 1, 1, 1, 1200.00, '2023-03-01'),
(2, 2, 1, 2, 300.00, '2023-03-01'),
(1, 3, 2, 1, 250.00, '2023-03-05'),
(3, 1, 3, 1, 1200.00, '2023-03-07'),
(2, 4, 1, 1, 500.00, '2023-03-08'),
(1, 2, 1, 1, 150.00, '2023-03-10'),
(4, 5, 2, 3, 75.00, '2023-03-12'),
(3, 3, 3, 1, 250.00, '2023-03-15'),
(5, 1, 4, 1, 1200.00, '2023-03-16'),
(5, 2, 4, 1, 150.00, '2023-03-18'),
(1, 5, 1, 2, 50.00, '2023-03-20'),
(4, 4, 2, 1, 500.00, '2023-03-22'),
(2, 1, 1, 1, 1200.00, '2023-03-23'),
(3, 2, 3, 2, 300.00, '2023-03-25'),
(1, 3, 2, 1, 250.00, '2023-03-27'),
(6, 6, 5, 1, 300.00, '2023-03-28'),
(6, 1, 5, 1, 1200.00, '2023-03-30'),
(7, 2, 3, 2, 300.00, '2023-03-30'),
(6, 4, 5, 1, 500.00, '2023-04-01'),
(7, 3, 3, 1, 250.00, '2023-04-02'),
(2, 6, 1, 2, 600.00, '2023-04-03'),
(4, 2, 2, 1, 150.00, '2023-04-04'),
(1, 4, 1, 1, 500.00, '2023-04-05'),
(5, 5, 4, 2, 50.00, '2023-04-06'),
(3, 1, 3, 1, 1200.00, '2023-04-07'),
(7, 1, 3, 1, 1200.00, '2023-04-07'),
(6, 2, 5, 1, 150.00, '2023-04-08'),
(5, 6, 4, 1, 300.00, '2023-04-09'),
(2, 3, 1, 1, 250.00, '2023-04-10'),
(1, 6, 1, 1, 300.00, '2023-04-10');


select * from customers;
select * from products;
select * from stores;
select * from transactions;


--WINDOW FUNCTIONS

--Row number function
-- This function creates no ties it simply orders the column based on our specification and then gives number
select customer_fname,customer_lname,
row_number() over(order by signup_date desc) as signup_order
from  customers;

--Rank creates a same number for equal values but the function will skip the next number in sequence 
select customer_fname,customer_lname,
rank() over(order by signup_date desc) as signup_order
from  customers;

--Rank creates a same number for equal values but the function will not skip the next number in sequence
select customer_fname,customer_lname,
dense_rank() over(order by signup_date desc) as signup_order
from  customers;

--Partitioning is used to rank or give row numbers based on division(in this case category)

select product_name, category, 
rank() over(partition by category order by price desc)  
as price_order from products;

-- This query retrieves each customer's purchased product along with the previous and next product prices they paid.
-- It uses LAG() and LEAD() window functions to look at the price of the product purchased just before and just after
-- for the same customer, based on descending product price. This helps analyze customer spending patterns or changes
-- in their purchase behavior over time or price.

SELECT 
    p.product_name AS Product_bought,
    c.customer_fname AS firstName,
    c.customer_lname AS lastName,
   LAG(p.price) OVER (PARTITION BY c.customer_id ORDER BY t.transaction_date) AS previous_price,
    LEAD(p.price) OVER (PARTITION BY c.customer_id ORDER BY t.transaction_date) AS next_price
FROM 
    transactions t
JOIN products p ON t.product_id = p.product_id
JOIN customers c ON t.customer_id = c.customer_id;

-- I want to divide price into three equal groups in products on price with division as category
SELECT product_name, price,category,
       NTILE(3) OVER (partition by category ORDER BY price DESC) AS price_quartile
FROM products;


-- This query calculates the running total (SUM) and running average (AVG) of each customer's total spending over time.
-- It uses window functions with PARTITION BY customer_id and ORDER BY transaction_date to ensure the calculations
-- are done independently for each customer in chronological order.
-- This helps track how much each customer has spent cumulatively and on average per transaction over time.

SELECT 
    c.customer_fname AS first_name,
    t.transaction_date,
    SUM(t.total_amount) OVER (PARTITION BY c.customer_id ORDER BY t.transaction_date) AS total_price,
    AVG(t.total_amount) OVER (PARTITION BY c.customer_id ORDER BY t.transaction_date) AS avg_price
FROM 
    transactions t
JOIN products p ON t.product_id = p.product_id
JOIN customers c ON t.customer_id = c.customer_id;

--percent rank creates a percentage kind of rank for each product here
--cumulative rank creates a rank within its partition. for example if there are 3 products within the category, 
--then you rank them row number divided by the number of rows within the category

SELECT product_name, category, price,
       PERCENT_RANK() OVER (PARTITION BY category ORDER BY price DESC) AS percentage_rank,
       CUME_DIST() OVER (PARTITION BY category ORDER BY price DESC) AS cumulative_distribution
FROM products;

--first and last values in the group

SELECT customer_id, transaction_date, total_amount,
       FIRST_VALUE(total_amount) OVER (PARTITION BY customer_id ORDER BY transaction_date) AS first_purchase,
       LAST_VALUE(total_amount) OVER (PARTITION BY customer_id ORDER BY transaction_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_purchase
FROM transactions;


--Moving average
SELECT transaction_date, total_amount,
       AVG(total_amount) OVER (
           ORDER BY transaction_date
           ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
       ) AS moving_avg_7day
FROM transactions;