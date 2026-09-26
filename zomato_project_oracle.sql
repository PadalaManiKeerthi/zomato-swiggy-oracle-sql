-- =============================================
-- Project: Zomato/Swiggy Analysis
-- Created by: Padala Mani Keerthi
-- Database: Oracle SQL (11g Compatible)
-- =============================================

-- STEP 1: DROP TABLES IF ALREADY EXISTS
DROP TABLE orders CASCADE CONSTRAINTS;
DROP TABLE restaurants CASCADE CONSTRAINTS;
DROP TABLE users CASCADE CONSTRAINTS;

-- STEP 2: CREATE TABLES
CREATE TABLE users (
  user_id NUMBER PRIMARY KEY,
  name VARCHAR2(50),
  city VARCHAR2(50),
  signup_date DATE
);

CREATE TABLE restaurants (
  restaurant_id NUMBER PRIMARY KEY,
  name VARCHAR2(50),
  city VARCHAR2(50),
  cuisine VARCHAR2(50)
);

CREATE TABLE orders (
  order_id NUMBER PRIMARY KEY,
  user_id NUMBER,
  restaurant_id NUMBER,
  order_date DATE,
  amount NUMBER,
  rating NUMBER,
  CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(user_id),
  CONSTRAINT fk_rest FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);

-- STEP 3: INSERT DATA
INSERT INTO users VALUES (1,'Keerthi','Kakinada', TO_DATE('2024-01-10','YYYY-MM-DD'));
INSERT INTO users VALUES (2,'Rahul','Vizag', TO_DATE('2024-02-15','YYYY-MM-DD'));
INSERT INTO users VALUES (3,'Priya','Hyderabad', TO_DATE('2024-01-20','YYYY-MM-DD'));
INSERT INTO users VALUES (4,'Arjun','Kakinada', TO_DATE('2024-03-05','YYYY-MM-DD'));
INSERT INTO users VALUES (5,'Sneha','Vijayawada', TO_DATE('2024-02-10','YYYY-MM-DD'));
INSERT INTO users VALUES (6,'Vijay','Vizag', TO_DATE('2024-01-25','YYYY-MM-DD'));
INSERT INTO users VALUES (7,'Anjali','Hyderabad', TO_DATE('2024-03-12','YYYY-MM-DD'));
INSERT INTO users VALUES (8,'Kiran','Kakinada', TO_DATE('2024-02-28','YYYY-MM-DD'));

INSERT INTO restaurants VALUES (101,'Biryani House','Kakinada','Biryani');
INSERT INTO restaurants VALUES (102,'Pizza Corner','Vizag','Italian');
INSERT INTO restaurants VALUES (103,'Spice Kitchen','Hyderabad','South Indian');
INSERT INTO restaurants VALUES (104,'Burger King','Vijayawada','Fast Food');
INSERT INTO restaurants VALUES (105,'Andhra Spice','Kakinada','Andhra');

INSERT INTO orders VALUES (1,1,101, TO_DATE('2024-04-01','YYYY-MM-DD'), 250, 5);
INSERT INTO orders VALUES (2,2,102, TO_DATE('2024-04-02','YYYY-MM-DD'), 400, 4);
INSERT INTO orders VALUES (3,1,105, TO_DATE('2024-04-05','YYYY-MM-DD'), 300, 5);
INSERT INTO orders VALUES (4,3,103, TO_DATE('2024-04-06','YYYY-MM-DD'), 200, 3);
INSERT INTO orders VALUES (5,4,101, TO_DATE('2024-04-07','YYYY-MM-DD'), 350, 4);
INSERT INTO orders VALUES (6,5,104, TO_DATE('2024-04-08','YYYY-MM-DD'), 500, 5);
INSERT INTO orders VALUES (7,2,101, TO_DATE('2024-04-10','YYYY-MM-DD'), 250, 4);
INSERT INTO orders VALUES (8,1,102, TO_DATE('2024-04-15','YYYY-MM-DD'), 400, 5);
INSERT INTO orders VALUES (9,4,103, TO_DATE('2024-04-20','YYYY-MM-DD'), 310, 4);
INSERT INTO orders VALUES (10,1,101, TO_DATE('2024-04-25','YYYY-MM-DD'), 290, 5);

COMMIT;

-- STEP 4: ANALYSIS QUERIES (11g Compatible)

-- Q1. City-wise total orders
SELECT u.city, COUNT(*) AS total_orders 
FROM users u JOIN orders o ON u.user_id = o.user_id 
GROUP BY u.city;

-- Q2. Top restaurant
SELECT * FROM (
  SELECT r.name, COUNT(*) AS total
  FROM restaurants r JOIN orders o ON r.restaurant_id = o.restaurant_id
  GROUP BY r.name ORDER BY total DESC
) WHERE ROWNUM = 1;

-- Q3. Avg order value per city
SELECT u.city, AVG(o.amount) AS avg_amount 
FROM users u JOIN orders o ON u.user_id = o.user_id 
GROUP BY u.city;

-- Q4. Loyal customers > 2 orders
SELECT u.name, COUNT(*) AS order_count 
FROM users u JOIN orders o ON u.user_id = o.user_id 
GROUP BY u.name HAVING COUNT(*) > 2;

-- Q5. Highest rated restaurant
SELECT * FROM (
  SELECT r.name, AVG(o.rating) AS avg_rating
  FROM restaurants r JOIN orders o ON r.restaurant_id = o.restaurant_id
  GROUP BY r.name ORDER BY avg_rating DESC
) WHERE ROWNUM = 1;