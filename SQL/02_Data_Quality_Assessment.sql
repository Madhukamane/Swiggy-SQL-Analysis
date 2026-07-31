/*
======================================================================
Project Name : Swiggy Food Delivery SQL Analysis

Description :
This script analyzes the Swiggy food delivery dataset using PostgreSQL.
It includes data quality assessment, business analysis, window functions,
CTEs, views, and user-defined functions to generate actionable insights.

Author : Madhu Kamane
Database : PostgreSQL
======================================================================
*/



/*
-----------------------------------------------------------
Business Question:
What does the Swiggy dataset look like?
-----------------------------------------------------------
*/
select * from swiggy
limit 10 ;


/*
-----------------------------------------------------------
Business Question:
How many total records are available in the dataset?
-----------------------------------------------------------
*/

select count(*) as Total_Rows
from swiggy;


/*
-----------------------------------------------------------
Business Question:
How many unique cities, states, restaurants, dishes,
food types, and categories are present in the dataset?
-----------------------------------------------------------
*/

select count(distinct city) as Total_Cities,
	   count(distinct state) as Total_State,
	   count(distinct restaurant_name) as Total_Restaurant,
	   count(distinct dish_name) as Total_Dishes,
	   count(distinct food_type) as Food_Type,
	   count(distinct category) as Total_Category
from swiggy;


/*
-----------------------------------------------------------
Business Question:
Does the dataset contain any missing (NULL) values?
-----------------------------------------------------------
*/

select 
sum(case when state is null then 1 else 0 end ) as null_state,
sum(case when city is null then 1 else 0 end ) as null_city,
sum(case when order_date is null then 1 else 0 end ) as null_date,
sum(case when week_no is null then 1 else 0 end ) as null_weekno,
sum(case when quarter is null then 1 else 0 end ) as null_quarter,
sum(case when day is null then 1 else 0 end ) as null_day,
sum(case when restaurant_name is null then 1 else 0 end ) as null_restaurant,
sum(case when location is null then 1 else 0 end ) as null_location,
sum(case when category is null then 1 else 0 end ) as null_category,
sum(case when Dish_Name is null then 1 else 0 end ) as null_dish,
sum(case when food_type is null then 1 else 0 end ) as null_food,
sum(case when Price_inr is null then 1 else 0 end ) as null_price,
sum(case when Rating is null then 1 else 0 end ) as null_rating,
sum(case when Rating_count is null then 1 else 0 end ) as null_ratingcount
from swiggy;	



/*
-----------------------------------------------------------
Business Question:
Are there any dishes with invalid (negative) prices?
-----------------------------------------------------------
*/

select price_inr
from swiggy 
where price_inr<0;


/*
-----------------------------------------------------------
Business Question:
Are there any ratings outside the valid range (0–5)?
-----------------------------------------------------------
*/

select Rating
from swiggy 
where rating<0 or rating>5;



/*
-----------------------------------------------------------
Business Question:
What are the minimum, maximum, and average dish prices?
-----------------------------------------------------------
*/

select max(price_inr) as Maximum,
	   min(price_inr) as Minimum,
	   avg(price_inr) as Average
from swiggy;



/*
-----------------------------------------------------------
Business Question:
What are the minimum, maximum, and average ratings?
-----------------------------------------------------------
*/


select max(Rating) as Maximum,
	   min(Rating) as Minimum,
	   avg(Rating) as Average
from swiggy;



/*
-----------------------------------------------------------
Business Question:
What is the date range covered by the dataset?
-----------------------------------------------------------
*/

select 
min(order_date) as "Start Date" , 
max(order_date) as "end Date" 
from swiggy;



/*
-----------------------------------------------------------
Business Question:
How are orders distributed across different days of
the week?
-----------------------------------------------------------
*/

select day,count(*) as Total_Order
from swiggy 
group by day 
order by Total_order desc;


/*
-----------------------------------------------------------
Business Question:
Which restaurants offer dishes priced below ₹10?
-----------------------------------------------------------
*/

select restaurant_name,
dish_name, price_inr, city 
from swiggy 
where Price_inr < 10;
