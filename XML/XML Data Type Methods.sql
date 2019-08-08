
use AdventureWorks2008R2

---------------------------------------
-- Using the Value and Nodes methods
---------------------------------------

-- Example of using the value method on a declared xml type:	
DECLARE @myDoc XML = 
	'<Root>
		<ProductDescription ProductID="1" ProductName="Road Bike">
			<Features>
			  <Warranty>1 year parts and labor</Warranty>
			  <Maintenance>3 year parts and labor extended maintenance is available</Maintenance>
			</Features>
		</ProductDescription>
		<ProductDescription ProductID="2" ProductName="Road Bike">
			<Features>
			  <Warranty>None</Warranty>
			  <Maintenance>None</Maintenance>
			</Features>
		</ProductDescription>
		<ProductDescription ProductID="3" ProductName="Road Bike">
			<Features>
			  <Warranty>2 year parts and labor</Warranty>
			  <Maintenance>2 year parts and labor</Maintenance>
			</Features>
		</ProductDescription>
		<ProductDescription ProductID="3" ProductName="Road Bike"> 
		</ProductDescription>
	</Root>'

-- We can use the value method to select out the product id and name from the
-- above xml fragment. Note that the value method must have a singleton, and
-- so the results of this query is only one row due to the '[1]'
SELECT 
	@myDoc.value('(/Root/ProductDescription/@ProductID)[1]', 'VARCHAR(50)') AS [Value ProductID]
	, @myDoc.value('(/Root/ProductDescription/@ProductName)[1]', 'VARCHAR(50)') AS [Value Name]

	
-- If we want to return the value of multiple rows, we need to use the nodes method.
-- The xquery string passed to the nodes method dictates the returned rows:

SELECT 
	MyXml.ProductXML.query('.') As [Nodes parsed by Features]
FROM @myDoc.nodes('/Root/ProductDescription/Features') as MyXml(ProductXML)

-- Compare these two methods. What is different? 
-- Four rows returned instead of three. last xml node has no Features!

SELECT 
	MyXml.ProductXML.query('.') As [Nodes parsed by ProductDescription]
FROM @myDoc.nodes('/Root/ProductDescription') as MyXml(ProductXML)

-- NOTE:
--	The nodes table valued function MUST have an alias
--	Also the select value must use one of the for XML data type methods
-- MSDN:
--	The result of the nodes() method is a rowset that contains logical copies of the original XML instances. 
--	In these logical copies, the context node of every row instance is set to one of the nodes identified with 
--	the query expression, so that subsequent queries can navigate relative to these context nodes. 

-- So finally if we want to find all Warranty and mainteancne values from the xml, we use the
-- following xml
SELECT 
	MyXml.Loc.value('(Features/Warranty)[1]', 'varchar(200)') as Warranty,
	MyXml.Loc.value('(Features/Maintenance)[1]', 'varchar(200)')  as Maintenance
FROM @myDoc.nodes('/Root/ProductDescription') as MyXml(Loc)

------------------------------
-- Using Typed XML with value
------------------------------

-- Using the Adventureworks Person.person Demographics column. We can select out just the value
-- using the following statment.

SELECT 
	Demographics.value('
		declare namespace IS="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
		(/IS:IndividualSurvey/IS:TotalPurchaseYTD)[1]', 'decimal') 
		AS [Demograhics Value]
FROM 
	Person.Person
WHERE 	
	Demographics.value('
		declare namespace IS="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey";
		(/IS:IndividualSurvey/IS:TotalPurchaseYTD)[1]', 'decimal')  != 0

-- Use the following select statment to see the full xml being stored.
-- SELECT CatalogDescription FROM Production.ProductModel where CatalogDescription IS NOT NULL
SELECT 
	CatalogDescription.value('           
		declare namespace PD="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";           
		(/PD:ProductDescription/@ProductModelID)[1]', 'int') AS Result           
FROM 
	Production.ProductModel         
WHERE 
	CatalogDescription.value('           
		declare namespace PD="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription";           
		(/PD:ProductDescription/@ProductModelID)[1]', 'int')
	IS NOT NULL
ORDER BY Result desc
