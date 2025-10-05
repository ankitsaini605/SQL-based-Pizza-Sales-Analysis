use pizzahut;


-- Basic:


-- Q1-Retrieve the total number of orders placed.
-- Ans-1select count(order_id) from orders;

-- Q2-Calculate the total revenue generated from pizza sales.
-- Ans2-select round(sum(orders_details.quantity*pizzas.price),2) as total_pizza_sales
-- from orders_details join pizzas on orders_details.pizza_id = 
-- pizzas.pizza_id;

-- Q3-Identify the highest-priced pizza.
-- Ans3-select pizza_types.name,pizzas.price from pizza_types join pizzas
-- on pizza_types.pizza_type_id =pizzas.pizza_type_id order by pizzas.price 
-- desc limit 1;

-- Q4-Identify the most common pizza size ordered.
-- Ans4-select pizzas.size,count(orders_details.order_details_id) as total_count
-- from pizzas join orders_details on pizzas.pizza_id = orders_details.pizza_id
-- group by pizzas.size order by total_count desc limit 1;

-- Q5-List the top 5 most ordered pizza types along with their quantities.
-- Ans5-select pizza_types.name,sum(orders_details.quantity) as total_quantity
-- from pizza_types join pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id
-- join orders_details on orders_details.pizza_id = pizzas.pizza_id group by
-- pizza_types.name order by total_quantity desc limit 5;


-- Intermediate:


-- Q1-Join the necessary tables to find the total quantity of each pizza 
-- category ordered.
-- Ans1-select pizza_types.category,sum(orders_details.quantity) as total_quantity from orders_details join
-- pizzas on orders_details.pizza_id = pizzas.pizza_id join pizza_types on 
-- pizza_types.pizza_type_id = pizzas.pizza_type_id group by pizza_types.category 
-- order by total_quantity;

-- Q2-Determine the distribution of orders by hour of the day.
-- Ans2-select hour(order_time),count(order_id) from orders group by hour(order_time);

-- Q3-Join relevant tables to find the category-wise distribution of pizzas.
-- Ans3-select count(name), category from pizza_types group by category;

-- Q4-Group the orders by date and calculate the average number of pizzas 
-- ordered per day. 
-- Ans4-select round(avg(quantity),0) as avg_pizza_order_every_day from
-- (select orders.order_date,sum(orders_details.quantity) as quantity from orders join 
-- orders_details on orders.order_id=orders_details.order_id group by orders.order_date)
-- as order_quantity;

-- Q5-Determine the top 3 most ordered pizza types based on revenue.
-- select pizza_types.name, sum(orders_details.quantity * pizzas.price) as revenue from 
-- pizza_types join pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id join 
-- orders_details on orders_details.pizza_id=pizzas.pizza_id group by pizza_types.name
-- order by revenue desc limit 3;


-- Advanced:


-- Q1-Calculate the percentage contribution of each pizza type to total revenue.
-- Ans1-select pizza_types.category, round(sum(orders_details.quantity * pizzas.price)/(select 
-- round(sum(orders_details.quantity*pizzas.price),2) as total_pizza_sales
-- from orders_details join pizzas on orders_details.pizza_id = pizzas.pizza_id)*100,2) as 
-- revenue from pizza_types join pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id join 
-- orders_details on orders_details.pizza_id=pizzas.pizza_id group by pizza_types.category
-- order by revenue desc;

-- Q2-Analyze the cumulative revenue generated over time.
-- Ans2-select order_date,sum(revenue) over(order by order_date) as cum_revenue from
-- (select orders.order_date,sum(orders_details.quantity * pizzas.price) as revenue 
-- from orders_details join pizzas on orders_details.pizza_id=pizzas.pizza_id join orders
-- on orders.order_id=orders_details.order_id group by orders.order_date) as sales;

-- Q3-Determine the top 3 most ordered pizza types based on revenue for each pizza category.
-- Ans3-select category,name,revenue from(select category,name,revenue, rank() over
-- (partition by category order by revenue desc)as rn from
-- (select pizza_types.category,pizza_types.name,sum(orders_details.quantity * pizzas.price)
-- as revenue from pizza_types join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
-- join orders_details on orders_details.pizza_id=pizzas.pizza_id group by 
-- pizza_types.category,pizza_types.name)as a) as b where rn<=3;