

-- USE AdventureWorks2008R2

-----------------
-- FOR XML RAW
-----------------

-- 1.)	Adding XML Raw creates a row xml node with each column as an attribute:
SELECT 
	ProductID
	, Name
	, ProductNumber
	, Color
	, MakeFlag
FROM 
	Production.Product
FOR XML RAW

-- 2.)	Adding a parameter to the RAW keyword sets the XML row name to this value
--		Adding the ROOT keywork adds a root element.
SELECT 
	ProductID
	, Name
	, ProductNumber
	, Color
	, MakeFlag
FROM 
	Production.Product
FOR XML RAW('Product')
	, ROOT('Products')

-- 3.)  Finally, adding the ELEMENTS keyword forces each column to have its own node.
--		Adding the XSINIL element introduces the XSI schema in the root node, and also
--		Adds the xsi:nil attribute to null values.
SELECT 
	ProductID
	, Name
	, ProductNumber
	, Color
	, MakeFlag
FROM 
	Production.Product
FOR XML RAW('Product')
	, ROOT('Products')
	, ELEMENTS XSINIL	
	
-----------------
-- FOR XML AUTO
-----------------

-- Consider the same query from above, For AUTO mode, the table alias dictates the row node value.
SELECT 
	ProductID
	, Name
	, ProductNumber
	, Color
	, MakeFlag
FROM 
	Production.Product
FOR XML AUTO


-- Hence the ROW tag name is now no longer valid, but the ROOT, ELEMENTS and XSINIL
-- keywords are still leggit!
SELECT 
	ProductID
	, Name
	, ProductNumber
	, Color
	, MakeFlag
FROM 
	Production.Product
FOR XML AUTO
	, ROOT('Products')
	, ELEMENTS XSINIL	

-- To get the same result, use a table alias
SELECT 
	ProductID
	, Name
	, ProductNumber
	, Color
	, MakeFlag
FROM 
	Production.Product ProductRow
FOR XML AUTO
	, ROOT('Products')
	, ELEMENTS XSINIL	
	
-- The real benefit of AUTO mode is that in naturally supports hiearchies.
-- Note that the hierarchy is taken from the order of the columns.
-- Also that the ordering of the XML results set dictates the XML order.
SELECT 	
	Customer.CustomerID AS Id
	, Customer.AccountNumber
	, "Order".SalesOrderID
	, "Order".rowguid AS RowGuid 
FROM 
	Sales.SalesOrderHeader AS "Order" 
	RIGHT OUTER JOIN Sales.Customer AS Customer 
		ON Customer.CustomerID = "Order".CustomerID 
ORDER BY Customer.CustomerID
FOR XML AUTO, ROOT('Customers');

-----------------
-- FOR XML PATH
-----------------

-- Consider the above query, but this time with the PATH clause.
-- Continuing with the above query, if we simply add PATH, then we get 
-- the equivalent of "FOR XML RAW , ELEMENTS":	
SELECT 
	ProductID
	, Name 
	, ProductNumber 
	, Color 
	, MakeFlag 
FROM 
	Production.Product
FOR XML PATH

SELECT 
	ProductID as "@Id"
	, Name as "@Name"
	, null as "AdditionalInfo"
	, ProductNumber as "AdditionalInfo/Number"
	, Color as "AdditionalInfo/Color"
	, MakeFlag as "AdditionalInfo/MakeFlag"
FROM 
	Production.Product
FOR XML PATH('Products')
