/*
===========================================================
Project : Swiggy Food Delivery Analysis
File    : 01_Create_Table.sql
Author  : Madhu Kamane

Description:
Creates the Swiggy table used for analysis.
===========================================================
*/

CREATE TABLE Swiggy (
    State VARCHAR(50),
    City VARCHAR(50),
    Order_Date DATE,
    Week_No INT,
    Quarter VARCHAR(10),
    Day VARCHAR(10),
    Restaurant_Name VARCHAR(250),
    Location VARCHAR(250),
    Category VARCHAR(100),
    Dish_Name VARCHAR(250),
    Food_Type VARCHAR(20),
    Price_INR DECIMAL(10,2),
    Rating DECIMAL(3,2),
    Rating_Count INT
);
