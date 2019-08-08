
--------------------------------------
-- Creating and Using SQLCLR objects
--------------------------------------

-- Before writting CLR objects we need to enable the clr functionality:
-- To view the current value of clr enabled setting run:
EXEC sp_configure
-- if required, then run the following code to enable
EXEC sp_configure 'clr enabled', 1
RECONFIGURE

-- NOTE When writing sqlclr objects there is a 3 step process to follow:
--	1.) Write the code in .NET and Compile the code into an assembly.
--	2.) Load the assembly into the server
--	3.) Create the database object using DDL

--------------------------------------------------
-- Example 1: Creating a simple Stored Procedure
--------------------------------------------------

use AdventureWorks2008R2

-- 1.) Write the code and produce an assembly
-- Use Visual Studio to produce this: SqlServerCLRTest.dll

-- 2.) Load the assembly into the server
-- NOTE Before running this example, copy the TestData\CLR\spCustomerGetClr\SqlServerCLRTest.dll
-- to the C drive.
CREATE ASSEMBLY SqlServerCLRTest
FROM 'C:\SqlServerCLRTest.dll'
WITH PERMISSION_SET = SAFE 

-- Note the Permission Set can be one of SAFE, EXTERNAL ACCESS, UNSAFE
-- SAFE		- Not allowed to access any resources outside of the database
-- EXTERNAL	- Can access resources outside the database including: 
--			  another database instance, the file system or network resources
-- UNSAFE	- Is also allowed to execute non CLR code including:
--			  Win32 API and COM components.
	
-- We can view the assembly in the sys.assemblies view:
SELECT * FROM sys.assemblies

-- 3.) Create the database object using DDL
CREATE PROCEDURE Sales.spCustomerGetClr 
@CustomerID INT 
AS 
-- AssemblyName."Namespace.ClassName".MethodName
EXTERNAL NAME SqlServerCLRTest."SqlServerCLRTest.StoredProc1".CustomerGetProcedure; 
GO 

-- We can now execute the stored procedure as if it was a normal T-SQL statment.
EXEC Sales.spCustomerGetClr 1

-- To display all CLR modules we can query the sys.assembly_modules view
SELECT * FROM sys.assembly_modules 

-------------------------------------------
-- Example 2: Regex user Defined Function
-------------------------------------------

-- 1.) Create the code
-- Use Visual Studio.

-- 2.) Add the assembly using the CREATE ASSEMBLY statement.
CREATE ASSEMBLY SqlServerCLRTest2
FROM 'C:\SqlServerCLRTest2.dll'
WITH PERMISSION_SET = SAFE


-- Drop function IsRegexMatch
--3.)
CREATE FUNCTION dbo.IsRegexMatch( @Input NVARCHAR(MAX) , @Pattern NVARCHAR(100))
RETURNS BIT
AS
EXTERNAL NAME SqlServerCLRTest2."SqlServerCLRTest2.RegexTools".IsRegExMatch

-- Now we can use the CLR function 
-- Find all credit card entries that start with four 3s
SELECT *
FROM Sales.CreditCard 
WHERE dbo.IsRegexMatch(CardNumber, N'^3333.*$') = 1; 
