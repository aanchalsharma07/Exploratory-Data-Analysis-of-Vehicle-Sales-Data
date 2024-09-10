--Query to retrieve all columns from the table
SELECT * FROM Vehicle_Sales_Data

--To know total number of columns in the table
Select COUNT(*) AS No_of_Cols FROM Vehicle_Sales_Data

--To know count of distinct companies in the table
Select COUNT(Distinct Company) AS distinct_Company from Vehicle_Sales_Data

--To know count of distinct models in the table
Select COUNT(Distinct Model) AS distinct_model from Vehicle_Sales_Data

--DATA CLEANING--

Select * from Vehicle_Sales_Data 
where Company IS NULL

Select * from Vehicle_Sales_Data 
where Model is null

Delete from Vehicle_Sales_Data
where Company IS NULL

ALTER TABLE Vehicle_Sales_Data
DROP COLUMN Condition_Rating;

ALTER TABLE Vehicle_Sales_Data
DROP COLUMN Odometer_Reading;
 
UPDATE Vehicle_Sales_Data
SET Transmission_Type = 'NotProvided'
WHERE Transmission_Type IS NULL;

Delete from Vehicle_Sales_Data
where Transmission_Type='NotProvided';

Select * from Vehicle_Sales_Data 
where Selling_Price is null

UPDATE Vehicle_Sales_Data
SET Size = 'NotProvided'
WHERE Size IS NULL;

UPDATE Vehicle_Sales_Data
SET Company = 'Volkswagen'
WHERE Company = 'Vw';

UPDATE Vehicle_Sales_Data
SET Size = 'Sedan'
WHERE Size = 'sedan';

ALTER TABLE Vehicle_Sales_Data
ALTER COLUMN Selling_Price bigint;

ALTER TABLE Vehicle_Sales_Data
ALTER COLUMN MMR bigint;

ALTER TABLE Vehicle_Sales_Data
ALTER COLUMN Difference float;

SELECT *, Selling_Price-MMR AS difference
from Vehicle_Sales_Data

SELECT *, Selling_Price-MMR AS difference,
CASE 
 WHEN (Selling_Price-MMR) >0 THEN 'Premium'
 Else 'Discount'
 END AS PriceCategory
FROM Vehicle_Sales_Data

UPDATE Vehicle_Sales_Data
SET Difference= Selling_Price-MMR

UPDATE Vehicle_Sales_Data
SET PriceCategory = CASE
    WHEN Difference > 0 THEN 'Premium'
    WHEN Difference < 0 THEN 'Discount'
	WHEN Difference = 0 THEN 'Breakeven'
END

--SALES PERFORMANCE ANALYSIS--

--Query to identify the best performing model in terms of revenue
SELECT TOP 1 Company,Model, Selling_Price
FROM Vehicle_Sales_Data 
ORDER BY Selling_Price DESC

--Query to identify the worst performing model in terms of revenue
SELECT TOP 1 Company, Model, Selling_Price
FROM Vehicle_Sales_Data 
ORDER BY Selling_Price ASC

--Query to know the average selling price of each type and size of car 
SELECT Distinct Type, Size , AVG(Selling_Price) AS avg_SP FROM Vehicle_Sales_Data 
GROUP BY Type, Size
ORDER BY SIZE

--Which 100 car companies are generating the most revenue?
SELECT TOP 100 Company FROM Vehicle_Sales_Data 
ORDER BY Selling_Price DESC

--Query to find out the transmission type which is more popular in terms of sales
SELECT DISTINCT Transmission_Type , SUM(Selling_Price) AS SP
FROM Vehicle_Sales_Data 
GROUP BY Transmission_Type 
ORDER BY SUM(Selling_Price) Desc

--PRICE CATEGORY INSIGHTS--

--Query to know the price category having highest number of sales
SELECT DISTINCT PriceCategory , SUM(Selling_Price) AS SP 
FROM Vehicle_Sales_Data 
GROUP BY PriceCategory
Order By SP Desc

--Query to know the average difference for each price category
SELECT Distinct PriceCategory, ROUND(AVG(Difference),2) AS avg_difference
FROM Vehicle_Sales_Data
GROUP BY PriceCategory

--MARKET DEMAND AND TRENDS--

---Find out company name, it's model and it's interior color which is  most popular among buyers
Select Company, Model, Interior_Color, COUNT(Interior_Color) AS Total_Number
FROM Vehicle_Sales_Data
Group By Interior_Color, Company, Model
HAVING COUNT(Interior_Color) >=50
ORDER BY Total_Number Desc

--Find out company name, it's model and it's exterior color which is most popular among buyers
Select Company, Model, Exterior_Color, COUNT(Exterior_Color) AS Total_Number
FROM Vehicle_Sales_Data
Group By Exterior_Color, Company, Model
HAVING COUNT(Exterior_Color) >=50
ORDER BY Total_Number DESC

--Find out the top 100 companies, which are being sold at 'Premium', in descending order
SELECT TOP 100 Company, Model,Type, Difference
from Vehicle_Sales_Data
where PriceCategory='Premium'
order by Difference Desc

--Find out the top 100 companies, which are being sold at 'Discount'.
SELECT TOP 100 Company,Model, Type, Difference
from Vehicle_Sales_Data
where PriceCategory='Discount'
order by Difference

--Find out the top 100 companies, which are being sold at 'Breakeven'.
SELECT TOP 100 Company,Model, Type, Difference
from Vehicle_Sales_Data
where PriceCategory='Breakeven'
order by Difference

--PROFITABILITY AND EFFICIENCY--

--Which car model have highest difference?
SELECT TOP 1 Company, Model,Type, MAX(Difference) AS difference
FROM Vehicle_Sales_Data 
GROUP BY Model, Company, Type
ORDER BY MAX(Difference) DESC

--What is the average difference for each car size?
SELECT DISTINCT Size, ROUND(AVG(Difference),2) AS difference
FROM Vehicle_Sales_Data 
GROUP BY Size
ORDER BY Size

--Query to rank top 500 companies having highest difference
SELECT TOP 500 Company,Model,Type, Difference,
DENSE_RANK() OVER (ORDER BY Difference DESC) AS denserank
FROM Vehicle_Sales_Data

--Query to know the percetage change in price
SELECT Company, Model, Type,Difference, ROUND((Difference/MMR),3) * 100 AS Percentage_Change
FROM Vehicle_Sales_Data
ORDER BY Percentage_Change DESC

--CUSTOMER PREFERENCES AND TARGETING--

--What is the most preferred Transmission_Type based on different size, in breakeven price category?
Select DISTINCT Size, Transmission_Type 
FROM Vehicle_Sales_Data
WHERE PriceCategory ='Breakeven'
ORDER BY Transmission_Type

--What is the most preferred Transmission_Type based on different size, in premium price category?
Select DISTINCT Size, Transmission_Type 
FROM Vehicle_Sales_Data
WHERE PriceCategory ='Premium'
ORDER BY Transmission_Type

--What is the most preferred Transmission_Type based on different size, in discount price category?
Select DISTINCT Size, Transmission_Type 
FROM Vehicle_Sales_Data
WHERE PriceCategory ='Discount'
ORDER BY Transmission_Type

