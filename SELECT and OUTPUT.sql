use AdventureWorks2008R2

--------------------------------------
--	SELECT ... INTO, Simple Examples
--------------------------------------

-- Create a new table which is a backup of the Product table
SELECT * 
INTO Production.Product_20110115
FROM Production.Product

-- Now we have a copy of the product table 
SELECT * FROM Production.Product_20110115

-- Create a new table which is the id, name and number of all products which start with D
SELECT ProductID, Name, ProductNumber
INTO Production.Product_D
FROM Production.Product
WHERE Name like 'D%'

SELECT * FROM Production.Product_D

--------------------------------------
--	SELECT ... INTO, Minimal Logging
--------------------------------------

-- Minimal Logging, set the RECOVERY to BULK_LOGGED
ALTER DATABASE AdventureWorks2008R2 SET RECOVERY BULK_LOGGED

-- Now the table creation/select operation will be quicker
SELECT * 
INTO Production.MidRangeProducts
FROM Production.Product
WHERE ListPrice > $25 AND ListPrice < $100;

-- Return the recovery mode when completed
ALTER DATABASE AdventureWorks2008R2 SET RECOVERY FULL;

SELECT * FROM Production.MidRangeProducts

--------------------------------------
--	SELECT ... INTO, Adding Identity
--------------------------------------

-- First determine the IDENTITY status of the source column AddressID using sys.identity_columns
SELECT OBJECT_NAME(object_id) AS TableName, name AS column_name, is_identity, seed_value, increment_value
FROM sys.identity_columns
WHERE name = 'AddressID';

-- This example includes a join, so we need to 'Manually' recreate the IDENTITY column
-- Create a new table with columns from the existing table Person.Address. 
-- A new IDENTITY column is created by using the IDENTITY function.
SELECT 
	IDENTITY (int, 100, 5) AS AddressID, 
	a.AddressLine1, 
	a.City, 
	b.Name AS State, 
	a.PostalCode
INTO Person.USAddress 
FROM Person.Address AS a
INNER JOIN Person.StateProvince AS b ON a.StateProvinceID = b.StateProvinceID
WHERE b.CountryRegionCode = N'US'; 

-- Now we should see both AddressIDs appearing in the sys.identity_columns view.
SELECT OBJECT_NAME(object_id) AS TableName, name AS column_name, is_identity, seed_value, increment_value
FROM sys.identity_columns
WHERE name = 'AddressID';

--------------------------------------
--	DROP TABLES
--------------------------------------

DROP TABLE Production.Product_20110115
DROP TABLE Production.Product_D
DROP TABLE Production.MidRangeProducts
DROP TABLE Person.USAddress
