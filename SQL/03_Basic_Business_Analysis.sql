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

03_Basic_Business_Analysis


/*
-----------------------------------------------------------
Business Question:
How many Veg and Non-Veg dishes are available, and what
percentage, average price, and average rating does each
food type contribute?
-----------------------------------------------------------
*/

select Food_Type, count(*) as Total_Dishes,
concat(round(count(*)*100/sum(count(*)) over(),2),'%') as Percentage_Contribution,
round(avg(Price_inr),2)  as Average_Price,
round(avg(Rating),2) as Average_Rating
from swiggy 
group by Food_Type
order by 2 desc;



/*
-----------------------------------------------------------
Business Question:
Which cities have an average dish price greater than ₹300?
-----------------------------------------------------------
*/

select city , 
	   round(avg(price_inr),2) as Avg_Dish_price,
	   count(*) as Total_dishes
from swiggy
group by city 
having avg(price_inr)>300
order by 2 desc ;



/*
-----------------------------------------------------------
Business Question:
How do weekday and weekend orders compare in terms of
total dishes, average price, and average rating?
-----------------------------------------------------------
*/

select (case when day in ('Sun','Sat') then  'Weekend'
			else 'Weekday' end)
		as Order_Type,
		count(*) as Total_Dishes,
		Round(avg(price_inr),2) as Avg_Dish_price,
		Round(avg(rating),2) as Avg_Rating
from swiggy 
group by 1;


/*
-----------------------------------------------------------
Business Question:
How are dishes distributed across Budget, Mid-Range,
and Premium price segments?
-----------------------------------------------------------
*/

select case 
			when price_inr<200 then 'Budget' 
			when price_inr between 200 and 500 then 'Mid-Range'
			else 'Premium'
		end  as Prices_Range,
		Count(*) as Total_Dishes,
		concat(round(count(*)*100/sum(count(*)) over(),2),'%') as percentage,
		Round(avg(price_inr),2) as Avg_price
from swiggy 
group by 1;



/*
-----------------------------------------------------------
Business Question:
Which restaurants have the highest average customer
ratings along with the total number of customer reviews?
-----------------------------------------------------------
*/

select 
	Restaurant_NAME as Restuarant ,city ,
	avg(rating) as Average_Rating,
	sum(Rating_count) as Customer_Reviews
from swiggy 
group by restuarant_name,city
order by Avg_Rating desc,customer_reviews desc
limit 10 ;


/*
-----------------------------------------------------------
Business Question:
Which restaurants offer the largest variety of unique
dishes on their menu?
-----------------------------------------------------------
*/

select Restaurant_name,count(distinct dish_name) as Unique_Dishes
from swiggy
group by Restaurant_name
order by 2 desc;


/*
-----------------------------------------------------------
Business Question:
Which cities have the highest average customer ratings?
-----------------------------------------------------------
*/
select city,Round(avg(Rating),2) Average_Rating
from swiggy
group by city
order by 2 desc;


/*
-----------------------------------------------------------
Business Question:
What are the Top 5 most expensive dishes available across
all restaurants?
-----------------------------------------------------------
*/

select dish_name,
	   restaurant_name,
	   max(price_inr) as Highest_price
from swiggy
group by dish_name,Restaurant_Name
order by 3 desc
limit 5;


/*
-----------------------------------------------------------
Business Question:
Which restaurants have the highest average dish price?
-----------------------------------------------------------
*/

select restaurant_name,round(Avg(price_inr),2) as Average_price
from swiggy
group by restaurant_name
having count(*)>=10
order by 2 desc;


/*
-----------------------------------------------------------
Business Question:
Which food categories contribute the highest number of
dishes in the dataset?
-----------------------------------------------------------
*/

select category,
	   count(*) as Total_Dishes,
	   round(Count(*)*100/sum(count(*)) over(),2) as contribution_percentage
from swiggy 
group by category
order by 3 desc;
