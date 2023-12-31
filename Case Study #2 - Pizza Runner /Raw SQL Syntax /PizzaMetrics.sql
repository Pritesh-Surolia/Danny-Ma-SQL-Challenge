-- This file covers Solutions to Questions regarding Pizza Metrics.


 /* Q1. How many pizzas were ordered? */

 SELECT 
		COUNT(pizza_id) AS pizza_order_count
 FROM #customer_orders;

 -- So, 14 pizzas were ordered.


 /* Q2. How many unique customer orders were made?  */

 SELECT 
		COUNT(DISTINCT customer_id) AS unique_customer_count
 FROM #customer_orders;
 
 -- So, 5 unique customer orders were made.


 /* Q3. How many successful orders were delivered by each runner?  */


 SELECT
		runner_id, 
		COUNT(pickup_time) AS successful_order_count
 FROM #runner_orders
 WHERE pickup_time != ''
 GROUP BY runner_id;


 /* Q4. How many of each type of pizza was delivered?  */

 SELECT 
		c.pizza_id , 
		COUNT(r.pickup_time) AS pizza_count
 FROM #customer_orders c
 JOIN #runner_orders r
 ON c.order_id =r.order_id
 WHERE r.pickup_time != ''
 GROUP BY c.pizza_id;



/* Q5. How many Vegetarian and Meatlovers were ordered by each customer?  */


 SELECT
		c.customer_id, 
		CAST(p.pizza_name AS VARCHAR(20)) AS pizza_name,
		COUNT(CAST(p.pizza_name AS VARCHAR(20))) AS pizza_count
 FROM #customer_orders c
 JOIN pizza_names p                                                    
 ON c.pizza_id = p.pizza_id
 GROUP BY c.customer_id,CAST(p.pizza_name AS VARCHAR(20));        -- Here, pizza_name (TEXT) is cast as VARCHAR(20) to enable comparisons and calculations.



/* Q6. What was the maximum number of pizzas delivered in a single order?  */


 WITH pizza_per_order_cte AS

 (SELECT 
		c.order_id, 
		COUNT(c.pizza_id) AS pizza_count_per_order
 FROM #customer_orders c
 JOIN #runner_orders r
 ON c.order_id = r.order_id
 WHERE r.pickup_time != ''
 GROUP BY c.order_id
 )

 SELECT 
		MAX(pizza_count_per_order) AS max_pizza_count
 FROM pizza_per_order_cte;

 -- So, the maximum number of pizzas delivered in a single order is 3.



/*  Q7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?  */

 SELECT 
		c.customer_id,
		SUM
			(CASE WHEN c.exclusions != '' OR c.extras != '' THEN 1
			ELSE 0
			END) AS at_least_1_change,
		SUM
			(CASE WHEN c.exclusions = '' AND c.extras = '' THEN 1
			ELSE 0
			END) AS no_change

 FROM #customer_orders c
 JOIN #runner_orders r
 ON c.order_id = r.order_id
 WHERE r.pickup_time != ''
 GROUP BY c.customer_id;

  

  /* Q8. How many pizzas were delivered that had both exclusions and extras?  */


  SELECT 
		COUNT(c.pizza_id) AS pizza_count_w_exclusions_extras
  FROM #customer_orders c
  JOIN #runner_orders r
  ON c.order_id = r.order_id
  WHERE
		(c.exclusions != '' AND c.extras != '') 
		AND (r.pickup_time != '');

 -- So, there is just 1 pizza which had both exclusions and extras.



 /*  Q9. What was the total volume of pizzas ordered for each hour of the day?  */

  SELECT 
		DATEPART(HOUR,order_time) AS hour_of_the_day,
		COUNT(pizza_id) as pizza_count
  FROM #customer_orders 
  GROUP BY DATEPART(HOUR,order_time);

  

  /*  Q10. What was the volume of orders for each day of the week?  */

  SELECT 
		FORMAT(DATEADD(DAY, 2, order_time),'dddd') AS day_of_week, -- add 2 to adjust 1st day of the week as Monday
		COUNT(order_id) AS order_count
  FROM #customer_orders
  GROUP BY FORMAT(DATEADD(DAY, 2, order_time),'dddd');
  
  
  ---------------------------------------------------------------------------------------------------------------------------------------------------
