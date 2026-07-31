1. Top Rated Restaurants
/*
-----------------------------------------------------------
Business Question:
Which restaurants have the highest average customer
ratings along with the total number of customer reviews?
-----------------------------------------------------------
*/

select 
	Restaurant_NAME as Restuarant ,city ,
	avg(rating) as Avg_Rating,
	sum(Rating_count) as Customer_Reviews
from swiggy 
group by restuarant_name,city
order by Avg_Rating desc,customer_reviews desc
limit 10 ;


2. Rank Restaurants within Each City (DENSE_RANK)
/*
-----------------------------------------------------------
Business Question:
How do restaurants rank based on average ratings within
each city?
-----------------------------------------------------------
*/

select city,
	   Restaurant_name,
	   Round(avg(rating),2) as Avg_Rating,
	   dense_rank() over(partition by city 
	   					order by avg(rating) desc) 
	   as city_rank
from swiggy
group by city,Restaurant_name;



3. Top 3 Restaurants in Every City (CTE)
/*
-----------------------------------------------------------
Business Question:
Which are the Top 3 highest-rated restaurants in every
city?
-----------------------------------------------------------
*/

with RestaurantRank As (
	select city,
		   Restaurant_name,
		   Round(avg(rating),2) as Avg_Rating,
		   dense_rank() over(partition by city 
		   					order by avg(rating) desc) 
		   as city_rank
	from swiggy
	group by city,Restaurant_name
) 
select * from RestaurantRank 
where city_rank<=3
ORDER BY City, city_rank;



4. Most Expensive Dish in Each Category (ROW_NUMBER)
/*
-----------------------------------------------------------
Business Question:
Which is the most expensive dish in each food category?
-----------------------------------------------------------
*/

with dish_rank as(
	select category,
		   Dish_Name,
		   Price_inr,
		   row_number() over(partition by category order by price_inr desc)
		   as rn
	from swiggy 
	
)
select * from dish_rank
where rn=1;


5. Rank Dishes by Price (DENSE_RANK)
/*
-----------------------------------------------------------
Business Question:
How do dishes rank by price within each food category?
-----------------------------------------------------------
*/

select category,
		   restaurant_name,
		   dish_name,
		   price_inr,
		   dense_rank() over(partition by category order by price_inr desc ) as Ranking_Dishes
from swiggy	;


6. Compare Dish Prices (LAG)
/*
-----------------------------------------------------------
Business Question:
How does each dish's price compare with the previous
priced dish within the same category?
-----------------------------------------------------------
*/

select category,dish_name,
		price_inr,
		lag(price_inr) over(partition by category order by price_inr) as previous_dish_price,
		(lag(price_inr) over(partition by category order by price_inr)-price_inr) as Price_Differnce
from swiggy;		



7. Highest Rated Dish (ROW_NUMBER)
/*
-----------------------------------------------------------
Business Question:
Which is the highest-rated dish in each food category?
-----------------------------------------------------------
*/

with highestRatedDish as(
	select category,
			   restaurant_name,
			   dish_name,
			   Rating,
			   row_number() over(partition by category order by rating desc ) as Ranking_Dishes
	from swiggy	
)
select * from highestRatedDish
where Ranking_Dishes=1;



8. Price Quartile (NTILE)
/*
-----------------------------------------------------------
Business Question:
Into which price quartile does each dish fall based on
its price?
-----------------------------------------------------------
*/

SELECT
    Dish_Name,
    Restaurant_Name,
    Category,
    Price_INR,
    NTILE(4) OVER (ORDER BY Price_INR) AS Price_Quartile
FROM Swiggy;



9. Price Quartile Summary (CTE + NTILE)
/*
-----------------------------------------------------------
Business Question:
How are dishes distributed across four price quartiles,
and what are the minimum, maximum, and average prices
within each quartile?
-----------------------------------------------------------
*/

WITH PriceQuartile AS (
    SELECT
        Price_INR,
        NTILE(4) OVER (ORDER BY Price_INR) AS Quartile
    FROM Swiggy
)
SELECT
    Quartile,
    COUNT(*) AS Total_Dishes,
    ROUND(MIN(Price_INR),2) AS Min_Price,
    ROUND(MAX(Price_INR),2) AS Max_Price,
    ROUND(AVG(Price_INR),2) AS Avg_Price
FROM PriceQuartile
GROUP BY Quartile
ORDER BY Quartile;	  



10. Create View
/*
-----------------------------------------------------------
Business Question:
Can we create a reusable city-level summary for reporting?
-----------------------------------------------------------
*/

create View vw_city_summary AS 
select city,
	   count(distinct Restaurant_name)as Total_Restaurant,
	   count(*) as Total_Dishes,
	   Round(avg(price_inr),2) as Avg_price,
	   Round(avg(rating),2) as Avg_Rating
from swiggy
group by city ;



11. Query the View
/*
-----------------------------------------------------------
Business Question:
What insights can be obtained using the reusable city
summary view?
-----------------------------------------------------------
*/

select * from vw_city_summary
order by Total_Restaurant desc;


12. PostgreSQL Function
/*
-----------------------------------------------------------
Business Question:
Can we create a reusable PostgreSQL function to generate
city-wise restaurant performance reports?
-----------------------------------------------------------
*/

create or replace function get_city_summary(city_name varchar)
returns table (
	city varchar,
	total_restaurants Bigint,
	total_dishes bigint,
	avg_price numeric,
	avg_rating numeric
)

as $$
Begin
	return Query
	select
		s.city,
		Count(distinct s.Restaurant_Name),
		Count(*),
		Round(Avg(s.price_inr),2),
		Round(avg(s.Rating),2)
	from swiggy s
	where s.city=city_name
	group by s.city;
end;
$$ language plpgsql;


13. Execute the Function
/*
-----------------------------------------------------------
Business Question:
How can the city summary function be executed for
different cities?
-----------------------------------------------------------
*/

select * from get_city_summary('Bengaluru');

select * from get_city_summary('Ahmedabad');
