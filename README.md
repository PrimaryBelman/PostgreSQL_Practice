Understanding SQL Window Functions with a Retail Dataset

I have been practicing advanced SQL functions and wanted to refresh my knowledge of window functions for future assessments and tests. Today, I practiced SQL window functions using a self-made retail database which was a quick refresher. If you're new to OVER() clauses, here's a quick tour of what I learned:

ROW_NUMBER(), RANK(), and DENSE_RANK()
These functions help assign a position or rank to each row:

ROW_NUMBER() assigns a unique position to each row.

select customer_fname,customer_lname, row_number() over(order by signup_date desc) as signup_order from customers;

Article content
ROW_NUMBER()
RANK() gives ties the same rank, but skips the next number.

select customer_fname,customer_lname, rank() over(order by signup_date desc) as signup_order from customers;

Article content
RANK()
DENSE_RANK() gives ties the same rank, without skipping.

select customer_fname,customer_lname, dense_rank() over(order by signup_date desc) as signup_order from customers;

Article content
DENSE_RANK()
PARTITION BY: Ranking Within Groups
Want to rank items within categories?

Use PARTITION BY.

select product_name, category,  rank() over(partition by category order by price desc)  as price_order from products;

Article content
PARTITION BY
LAG() and LEAD(): Comparing Rows Over Time
These functions let you look backward or forward in the dataset.

I used it to compare what a customer paid for their previous and next purchases

SELECT p.product_name AS Product_bought, c.customer_fname AS firstName, c.customer_lname AS lastName, LAG(p.price) OVER (PARTITION BY c.customer_id ORDER BY t.transaction_date) AS previous_price, LEAD(p.price) OVER (PARTITION BY c.customer_id ORDER BY t.transaction_date) AS next_price FROM  transactions t JOIN products p ON t.product_id = p.product_id JOIN customers c ON t.customer_id = c.customer_id;

Article content
LAG and LEAD
NTILE(): Dividing Data into Quartiles
Want to split products into tiers (e.g., high-end, mid-range, low-end)?

SELECT product_name, price, category, NTILE(3) OVER (partition by category ORDER BY price DESC) AS price_quartile FROM products;

Article content
NTILE
Running Totals & Averages with SUM() and AVG()
By using PARTITION BY customer_id and ORDER BY transaction_date, I tracked each customer’s cumulative spending:

SELECT  c.customer_fname AS first_name,t.transaction_date, SUM(t.total_amount) OVER (PARTITION BY c.customer_id ORDER BY t.transaction_date) AS total_price, AVG(t.total_amount) OVER (PARTITION BY c.customer_id ORDER BY t.transaction_date) AS avg_price FROM  transactions t JOIN products p ON t.product_id = p.product_id JOIN customers c ON t.customer_id = c.customer_id;



Article content
SUM and AVG
PERCENT_RANK() and CUME_DIST()
These functions helped me answer: Where does this product stand within its category?

PERCENT_RANK() → relative rank from 0 to 1
CUME_DIST() → What percentage of products are cheaper or equal in price

SELECT product_name, category, price, PERCENT_RANK() OVER (PARTITION BY category ORDER BY price DESC) AS percentage_rank,  CUME_DIST() OVER (PARTITION BY category ORDER BY price DESC) AS cumulative_distribution FROM products;



Article content


Key- Takeaway
Window functions are incredibly powerful for:

Ranking and ordering
Comparative analytics
Running totals and trends
Data partitioning without subqueries

I’m excited to keep building on this; maybe a simple UI next!!

You can access my dataset at https://github.com/PrimaryBelman/PostgreSQL_Practice

#SQL #PostgreSQL #DataAnalytics #LearningInPublic #WindowFunctions #DataScience
