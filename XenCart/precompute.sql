CREATE TABLE precompute(
   customer_id  INTEGER REFERENCES users (id) NOT NULL,
   product_id	INTEGER REFERENCES products (id) NOT NULL,
   category	INTEGER REFERENCES categories (id) NOT NULL,
   age		INTEGER,
   state	INTEGER REFERENCES states (id) NOT NULL,
   count	INTEGER,
   month	INTEGER
);

INSERT INTO precompute
SELECT customer_id, product_id, category, age, state, sum(quantity) AS count, month 
FROM (sales JOIN users ON customer_id = users.id) JOIN products ON product_id = products.id 
GROUP BY customer_id, age, state, product_id, category, month 
ORDER BY customer_id ASC
