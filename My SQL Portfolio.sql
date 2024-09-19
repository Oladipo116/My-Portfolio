--JOIN QUERY FOR ADVENTURE WORKS


SELECT* FROM Sales.SalesOrderDetail;
SELECT* FROM Sales.SalesOrderHeader;
SELECT* FROM Sales.Customer;
SELECT* FROM Person.Person;
--1. SALES ANALYSIS
--Get the top 10 customers with the highest total sales amount, along with their average order value and total number of orders

SELECT TOP 10 sc.CustomerID, pp.FirstName, pp.LastName, pp.MiddleName, SUM(soh.Subtotal) AS Total_Sales_Amount, 
AVG(sod.LineTotal) AS Average_Order_value, COUNT(sod.OrderQty) AS Total_Order
FROM Sales.Customer sc
INNER JOIN Person.Person pp
ON sc.CustomerID = pp.BusinessEntityID
INNER JOIN Sales.SalesOrderHeader soh
ON sc.CustomerID = soh.CustomerID
LEFT JOIN Sales.SalesOrderDetail sod
ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY sc.CustomerID, pp.FirstName, pp.LastName, pp.MiddleName
ORDER BY Total_Sales_Amount DESC;






SELECT* FROM Production.ProductSubcategory;
SELECT* FROM Sales.SalesOrderDetail;
SELECT* FROM Production.ProductCategory;
SELECT* FROM Production.Product;
--2. Get the list of categories with the highest total sales amount, along with the top-selling product in each category.
SELECT   ppc.Name as Category,MAX(pp.Name) AS Top_Selling_Product, SUM (sod.LineTotal) AS Sales_Amount  
FROM Production.ProductCategory ppc
INNER JOIN Production.ProductSubcategory pps
ON ppc.ProductCategoryID = pps.ProductCategoryID
INNER JOIN Production.Product pp
ON pps.ProductSubcategoryID = pp.ProductSubcategoryID
INNER JOIN Sales.SalesOrderDetail sod
ON pp.ProductID = sod.ProductID
GROUP BY ppc.Name
ORDER BY Sales_Amount;





SELECT* FROM Sales.SalesOrderDetail;
SELECT* FROM Production.Product;
SELECT* FROM Sales.SalesTerritory;
SELECT* FROM Sales.SalesOrderHeader
--3 Get the list of regions with the highest total sales amount, along with the top-selling product in each region.
SELECT sst.Name AS Region, MAX(pp.Name) AS Top_Selling_Product, SUM (sod.LineTotal) AS Sales_Amount
FROM Sales.SalesTerritory sst
INNER JOIN Sales.SalesOrderHeader soh
ON sst.TerritoryID = soh.TerritoryID
INNER JOIN Sales.SalesOrderDetail sod
ON soh.SalesOrderID = sod.SalesOrderID
INNER JOIN Production.Product pp
ON sod.ProductID =pp.ProductID
GROUP BY sst.Name
ORDER BY Sales_Amount DESC;






SELECT* FROM Sales.SalesOrderDetail;
SELECT* FROM Sales.SalesOrderHeader;
SELECT* FROM Sales.Customer;
--4. Retrieve the list of customers who have placed orders with a total sales amount greater than $10,000, along with their 
--average order value and total number of orders 
SELECT sc.CustomerID, SUM(soh.SubTotal) AS Total_Sales_Amount, AVG(soh.SubTotal) Average_Order_Value, COUNT(sod.OrderQty) AS Total_Orders 
FROM Sales.Customer sc
INNER JOIN Sales.SalesOrderHeader soh
ON sc.CustomerID = soh.CustomerID
INNER JOIN Sales.SalesOrderDetail sod
ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY sc.CustomerID
HAVING SUM(soh.SubTotal) > 10000;







SELECT* FROM Sales.SalesTerritory
SELECT* FROM Sales.SalesOrderHeader;
SELECT* FROM Production.Product;
SELECT* FROM Sales.SalesOrderDetail;
--5 Get the list of regions with the highest total sales amount, along with the top-selling product in each region.
SELECT sst.CountryRegionCode, sst.[Group], MAX(pp.Name) AS Top_Selling_Product, SUM(soh.SubTotal) AS Total_Sales_Amount
FROM Sales.SalesTerritory sst
INNER JOIN Sales.SalesOrderHeader soh
ON sst.TerritoryID = soh.TerritoryID
INNER JOIN Sales.SalesOrderDetail sod
ON soh.SalesOrderID = sod.SalesOrderID
INNER JOIN Production.Product pp
ON SOD.ProductID = PP.ProductID
GROUP BY sst.CountryRegionCode, sst.[Group]
ORDER BY Total_Sales_Amount DESC;







--SUBQUERY

SELECT* FROM Sales.SalesPerson;
SELECT* FROM Production.Product;
SELECT* FROM Sales.SalesOrderDetail;
SELECT* FROM Sales.SalesOrderHeader;
SELECT* FROM Sales.Customer;
SELECT* FROM Person.Person;
SELECT* FROM Sales.SalesTerritory;

--1. Find the personal information of  customers within the Northwest territory.
--INNER QUERY
SELECT soh.CustomerID 
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.SalesTerritory sst
ON soh.TerritoryID = sst.TerritoryID
WHERE sst.Name = 'Northwest';


SELECT pp.FirstName, pp.MiddleName, pp.LastName,sc.CustomerID
FROM Person.Person pp
RIGHT JOIN Sales.Customer sc
ON pp.BusinessEntityID = sc.PersonID
WHERE sc.CustomerID IN (SELECT soh.CustomerID 
						FROM Sales.SalesOrderHeader soh
						INNER JOIN Sales.SalesTerritory sst
						ON soh.TerritoryID = sst.TerritoryID
						WHERE sst.Name = 'Northwest');






SELECT* FROM Production.Product;
SELECT* FROM Sales.SalesOrderDetail;
--2. Retrieve the top 20 products that has been ordered the most
--INNER QUERY 
SELECT pp.Name, COUNT(sod.OrderQty) AS Times_Ordered
FROM Production.Product pp
INNER JOIN Sales.SalesOrderDetail sod
ON PP.ProductID = sod.ProductID
GROUP BY  pp.Name;

--SUBQUERY
SELECT TOP 50 Name, Times_Ordered
FROM (SELECT pp.Name, COUNT(sod.OrderQty) AS Times_Ordered
		FROM Production.Product pp
		INNER JOIN Sales.SalesOrderDetail sod
		ON PP.ProductID = sod.ProductID
		GROUP BY  pp.Name) AS Product_Order_Count
ORDER BY Times_Ordered DESC;




SELECT* FROM Production.Product;
SELECT* FROM Production.ProductCategory;
SELECT* FROM Production.ProductSubcategory;
--3 Identify the names of products that have a higher weight than the average weight of all products in the 'Components' category.
--INNER QUERY
SELECT AVG(pp.Weight)AS Components_Product_Average_Weight
FROM Production.Product pp
INNER JOIN Production.ProductSubcategory pps
ON pps.ProductSubcategoryID = pp.ProductSubcategoryID
INNER JOIN Production.ProductCategory ppc
ON pps.ProductCategoryID = ppc.ProductCategoryID
WHERE ppc.Name = 'Components';

--SUBQUERY
SELECT [Name],ProductNumber, [Weight]
FROM Production.Product
WHERE [Weight] > (SELECT AVG(pp.Weight)AS Components_Product_Average_Weight
					FROM Production.Product pp
					INNER JOIN Production.ProductSubcategory pps
					ON pps.ProductSubcategoryID = pp.ProductSubcategoryID
					INNER JOIN Production.ProductCategory ppc
					ON pps.ProductCategoryID = ppc.ProductCategoryID
					WHERE ppc.Name = 'Components');









SELECT* FROM Production.Product;
SELECT* FROM Production.ProductCategory;
SELECT* FROM Production.ProductSubcategory;

SELECT* FROM Sales.SalesOrderDetail;
SELECT* FROM Sales.SalesOrderHeader;
SELECT* FROM Sales.Customer;
SELECT* FROM Person.Person;
SELECT* FROM Production.Product;
--4.Retrieve the names of customers who have placed orders for products that have a higher list price than the 
--average list price of all products in the 'Components' category
--INNER QUERY
SELECT AVG(pp.ListPrice) AS Components_Product_Average_ListPrice
FROM Production.Product pp
INNER JOIN Production.ProductSubcategory pps
ON pps.ProductSubcategoryID = pp.ProductSubcategoryID
INNER JOIN Production.ProductCategory ppc
ON pps.ProductCategoryID = ppc.ProductCategoryID
WHERE ppc.Name = 'Components';


--SUBQUERY

SELECT DISTINCT pp.FirstName, pp.MiddleName, pp.LastName
FROM Person.Person pp
INNER JOIN Sales.Customer sc
ON PP.BusinessEntityID = sc.PersonID
INNER JOIN Sales.SalesOrderHeader soh
ON sc.CustomerID = soh.CustomerID
INNER JOIN Sales.SalesOrderDetail sod
ON soh.SalesOrderID = sod.SalesOrderID
INNER JOIN Production.Product prp
ON sod.ProductID = prp.ProductID
WHERE prp.ListPrice > (SELECT AVG(pp.ListPrice) AS Components_Product_Average_ListPrice
						FROM Production.Product pp
						INNER JOIN Production.ProductSubcategory pps
						ON pps.ProductSubcategoryID = pp.ProductSubcategoryID
						INNER JOIN Production.ProductCategory ppc
						ON pps.ProductCategoryID = ppc.ProductCategoryID
						WHERE ppc.Name = 'Components');








SELECT* FROM Production.Product;
SELECT* FROM Production.ProductSubcategory
--5. Identify the product names and colors that have a higher list price than the average list price of all mountain bikes in the product catalog
--INNER QUERY
SELECT AVG(pp.ListPrice) AS mountain_bikes_Average_ListPrice
FROM Production.Product pp
INNER JOIN Production.ProductSubcategory pps
ON pps.ProductSubcategoryID = pp.ProductSubcategoryID
WHERE pps.Name = 'mountain bikes';

--SUBQUERY
SELECT Name,Color
FROM Production.Product
WHERE ListPrice > (SELECT AVG(pp.ListPrice) AS mountain_bikes_Average_ListPrice
					FROM Production.Product pp
					INNER JOIN Production.ProductSubcategory pps
					ON pps.ProductSubcategoryID = pp.ProductSubcategoryID
					WHERE pps.Name = 'mountain bikes');





--CTE (COMMON TABLE EXPRESSION)

--1 List products that have been ordered more than 100 times.
WITH ProductOrderCounts AS (
							SELECT SOD.ProductID, SUM(SOD.OrderQty) AS OrderCount
							FROM Sales.SalesOrderDetail SOD
							GROUP BY SOD.ProductID)
SELECT P.Name, POC.OrderCount
FROM ProductOrderCounts POC
JOIN Production.Product P ON POC.ProductID = P.ProductID
WHERE POC.OrderCount > 100
ORDER BY POC.OrderCount DESC;


--2. Retrieve the list of the products with the lowest prices in each subcategory
WITH MinPriceProducts AS (
			SELECT ProductSubcategoryID, MIN(ListPrice) AS MinPrice
			FROM Production.Product
			GROUP BY ProductSubcategoryID)
SELECT P.Name, P.ListPrice
FROM Production.Product P
JOIN MinPriceProducts MPP ON P.ProductSubcategoryID = MPP.ProductSubcategoryID AND P.ListPrice = MPP.MinPrice;



--3.Find the most popular product in terms of order quantity.
WITH ProductQuantities AS (
    SELECT SOD.ProductID, SUM(SOD.OrderQty) AS TotalQuantity
    FROM Sales.SalesOrderDetail SOD
    GROUP BY SOD.ProductID)
SELECT P.Name, PQ.TotalQuantity
FROM ProductQuantities PQ
JOIN Production.Product P ON PQ.ProductID = P.ProductID
ORDER BY PQ.TotalQuantity DESC;


--4. Find employees who work in multiple departments.
WITH EmployeeDepartments AS (
    SELECT EDH.BusinessEntityID, COUNT(DISTINCT EDH.DepartmentID) AS DepartmentCount
    FROM HumanResources.EmployeeDepartmentHistory EDH
    GROUP BY EDH.BusinessEntityID)
SELECT P.FirstName + ' ' + P.LastName AS EmployeeName
FROM EmployeeDepartments ED
JOIN Person.Person P ON ED.BusinessEntityID = P.BusinessEntityID
WHERE ED.DepartmentCount > 1;




--5. List the average order total for each customer and their last order date.
WITH CustomerOrderStats AS (
    SELECT SOH.CustomerID, AVG(SOH.TotalDue) AS AverageOrderTotal, MAX(SOH.OrderDate) AS LastOrderDate
    FROM Sales.SalesOrderHeader SOH
    GROUP BY SOH.CustomerID)
SELECT P.FirstName + ' ' + P.LastName AS CustomerName, COS.AverageOrderTotal, COS.LastOrderDate
FROM CustomerOrderStats COS
JOIN Person.Person P ON COS.CustomerID = P.BusinessEntityID;





