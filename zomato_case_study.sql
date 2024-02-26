CREATE DATABASE ZOMATO;
USE ZOMATO;
SHOW tables;
SELECT * FROM ZOMATO;
DROP TABLE zomato;

show tables;
-- count number of rows
SELECT COUNT(*) FROM users;


-- return 5 random records
SELECT * from users 
ORDER BY rand()
LIMIT 5; 

-- find null values
select * from orders;
SELECT * FROM orders where restaurant_rating is null;

-- find no of orders placed by each customers
SELECT t1.name, t2.user_id, count(*) AS TOTAL_ORDERS FROM users t1
JOIN orders t2 ON t2.user_id = t1.user_id
GROUP BY t2.user_id, t1.name
ORDER BY TOTAL_ORDERS DESC;

-- FIND RESTAURANTS WITH MOST NUMBER OF MENU ITEMS
SELECT t1.r_name, count(*) FROM restaurants t1
JOIN menu t2 ON t2.r_id = t1.r_id
GROUP BY t2.r_id, t1.r_name
ORDER BY COUNT(*);


-- find number of votes and avg ratings for all the restaurants
SELECT t1.r_name, count(*) as num_votes, ROUND(AVG(restaurant_rating),1) AS avg_rating  FROM restaurants t1
JOIN orders t2 ON t2.r_id = t1.r_id
WHERE restaurant_rating != ""
group by t2.r_id, t1.r_name
ORDER BY avg_rating DESC;

-- FIND THE FOOD ITEM THAT IS BEING SOLD BY MOST OF THE RESTAURANTS
SELECT t2.f_name, t1.f_id, count(*) FROM menu t1
JOIN food t2 ON t2.f_id = t1.f_id
GROUP BY t1.f_id, t2.f_name
ORDER BY COUNT(*) DESC
LIMIT 1;


-- FIND THE RESTAURANT WITH MAX REVENUE IN A GIVEN MONTH
SELECT t1.r_name, sum(t2.amount) as total_revenue FROM restaurants t1
JOIN orders t2 ON t2.r_id = t1.r_id
WHERE monthname(DATE(date)) = "June"
GROUP BY t1.r_id, t1.r_name
ORDER BY total_revenue DESC;


-- find restaurant sales > x
SELECT t1.r_name, sum(t2.amount) as revenue FROM restaurants t1
JOIN orders t2 ON t2.r_id = t1.r_id
GROUP BY t1.r_id, t1.r_name
HAVING revenue > 1500;

-- find customers who have never ordered
SELECT t1.name,t1.user_id, t2.order_id FROM users t1
LEFT JOIN orders t2 ON t2.user_id = t1.user_id
WHERE t2.order_id is null
GROUP BY t1.user_id, t1.name, t2.order_id;

-- show order details of a particluar customer on a given date range
SELECT t1.order_id, f_name,t1.user_id, date FROM orders t1
JOIN order_details t2 ON t2.order_id = t1.order_id
JOIN food t3 ON t3.f_id = t2.f_id
WHERE t1.user_id = 1 AND date between "2022-05-01" AND "2022-06-01";


-- FIND MOST COSTLY RESTAURANTS(AVG PRICE/ DISH)
SELECT r_name, SUM(price)/count(*) AS cost FROM menu t1
JOIN restaurants t2 ON t2.r_id = t1.r_id
GROUP BY t1.r_id, r_name
ORDER BY cost DESC
LIMIT 1;

-- FIND DELIVERY PARTNER COMPENSATION USING THE FORMULA(#DELIVERIES * 100 + 1000 * AVG RATING)
SELECT t1.partner_id, COUNT(*)*100 + 1000*AVG(t1.delivery_rating) AS compensation FROM orders t1
JOIN delivery_partner t2 ON t2.partner_id = t1.partner_id
GROUP BY t1.partner_id
ORDER BY compensation DESC;

-- FIND ALL THE VEG RESTAURANTS
SELECT t3.r_id, t3.r_name FROM menu t1
JOIN food t2 ON t1.f_id = t2.f_id
JOIN restaurants t3 ON t3.r_id = t1.r_id
GROUP BY t3.r_id, t3.r_name
HAVING MIN(t2.type) = 'Veg' AND max(t2.type) = 'Veg';


-- FIND MIN AND MAX ORDER VALUES OF ALL CUSTOMERS
SELECT t2. name, t1.user_id, min(t1.amount) AS min_amount, max(t1.amount) as max_amount FROM orders t1
JOIN users t2 ON t1.user_id = t2.user_id
group by t1.user_id, t2.name