
USE Test
GO
/****************************************************************************************************

WITH common_table_expression (Transact-SQL): 
	http://msdn.microsoft.com/en-us/library/ms175972.aspx
Using Common Table Expressions: 
	http://msdn.microsoft.com/en-us/library/ms190766.aspx
Recursive Queries Using Common Table Expressions
	http://msdn.microsoft.com/en-us/library/ms186243.aspx		
Get in the Loop with CTEs:
	http://www.sqlmag.com/article/tsql3/get-in-the-loop-with-ctes.aspx

A common table expression (CTE) can be thought of as a temporary result set that is defined within the 
execution scope of a single SELECT, INSERT, UPDATE, DELETE, or CREATE VIEW statement. A CTE is similar 
to a derived table in that it is not stored as an object and lasts only for the duration of the query.

*****************************************************************************************************/


---------------------
-- Create some data 
---------------------

IF OBJECT_ID('EmployeesCTEData') IS NOT NULL 
	DROP TABLE EmployeesCTEData
GO
IF OBJECT_ID('DepartmentCTEData') IS NOT NULL 
	DROP TABLE DepartmentCTEData
GO

CREATE TABLE DepartmentCTEData
(
	Id int PRIMARY KEY,
	name varchar(200),
	[open] bit DEFAULT(0)
)

INSERT into DepartmentCTEData VALUES
	  (1, 'Sales', 0)  
	, (2, 'Marketting', 1)
	, (3, 'Board', 0)
	
CREATE TABLE EmployeesCTEData
(
	EmployeeID INT NOT NULL,
	FirstName nvarchar(30)  NOT NULL,
	LastName  nvarchar(40) NOT NULL,
	Title nvarchar(50) NOT NULL,
	DeptID INT NOT NULL REFERENCES DepartmentCTEData(Id),
	ManagerID int NULL,
 CONSTRAINT PK_EmployeeIDCTEData PRIMARY KEY CLUSTERED (EmployeeID ASC) 
);

-- Populate the table with values.
INSERT INTO EmployeesCTEData VALUES 
	 (1, N'Ken', N'Sánchez', N'Chief Executive Officer',3,NULL)
	,(273, N'Brian', N'Welcker', N'Vice President of Sales',3,1)
	,(274, N'Stephen', N'Jiang', N'North American Sales Manager',1,273)
	,(275, N'Michael', N'Blythe', N'Sales Representative',1,274)
	,(276, N'Linda', N'Mitchell', N'Sales Representative',1,274)
	,(285, N'Syed', N'Abbas', N'Pacific Sales Manager',1,273)
	,(286, N'Lynn', N'Tsoflias', N'Sales Representative',1,285)
	,(16,  N'David',N'Bradley', N'Marketing Manager', 2, 273)
	,(23,  N'Mary', N'Gibson', N'Marketing Specialist', 2, 16);


-------------------
-- Simple CTE
--------------------

-- The statement preceding the cte has to be completed with a semi-colon
-- otherwise it might be specifing table or query hints: 
SELECT * FROM EmployeesCTEData;

-- A simple CTE is as shown below. Note that the parameter list can be ommitted:
WITH CTE1( FullName )
AS
(
	select FirstName + ' ' + LastName
	from EmployeesCTEData
)

SELECT FullName, UPPER(FullName) as [FullName UPPER] FROM CTE1;

----------------------
-- CTE using Variable
-----------------------

DECLARE @name varchar(10);
SET @name = 'M';

-- A CTE can include a variable which a view cant.
WITH CTE2( FirstName, LastName )
AS
(
	select FirstName, LastName 
	from EmployeesCTEData
	where FirstName like @name + '%'
)

SELECT * from CTE2;

-------------------------
-- Using CTE to update 
-------------------------

WITH CTE3 (EmployeeID, FirstName, LastName, Name, [Open])
AS
(
	SELECT EmployeeID, FirstName, LastName, name, [open] 
	FROM EmployeesCTEData AS e JOIN DepartmentCTEData AS D 
		ON e.DeptID = D.Id
)
-- Updates follow the same rules as views, for example, this will error:
-- View or function 'CTE3' is not updatable because the modification affects multiple base tables.
--DELETE FROM CTE3 WHERE [Open] = 0

-- This statement will update all FirstNames to be uppercase.
UPDATE CTE3 SET FirstName = UPPER(FirstName);


----------------------------
-- Specifying Multiple CTES 
----------------------------

-- This query is a bit of a waste of time, but does demonstrate the point.
-- DO NOT repeate the with word, use a csv to list all CTEs 
WITH EmpsCTE(FirstName, LastName, DeptID)
AS
(
	SELECT FirstName, LastName, DeptID FROM EmployeesCTEData
), 
DeptCTE(ID, Name)
AS
(
	select Id, Name FROM DepartmentCTEData
	where Exists(select DeptID from EmpsCTE)
)

SELECT FirstName, LastName, Name FROM EmpsCTE JOIN DeptCTE 
	ON EmpsCTE.DeptID = DeptCTE.ID

-------------------
-- Recursive CTE
--------------------

-- Recursive CTE semantics:
--	1.) Split the CTE expression into anchor and recursive members.
--	2.) Run the anchor member(s) creating the first invocation or base result set (T0).
--	3.) Run the recursive member(s) with Ti as an input and Ti+1 as an output.
--	4.) Repeat step 3 until an empty set is returned.
--	5.) Return the result set. This is a UNION ALL of T0 to Tn.

-- Note the use of the Level column to control 
WITH DirectReports (ManagerID, EmployeeID, Title, Level)
AS
(
	-- Anchor member definition
	-- Select the manager, by filtering on manager = null
		SELECT e.ManagerID, e.EmployeeID, e.Title, 0 AS Level
		FROM EmployeesCTEData AS e 
		WHERE ManagerID IS NULL
    UNION ALL
	-- Recursive member definition (because it includes the DirectReports cte)
	-- In this second section, you can use
		SELECT e.ManagerID, e.EmployeeID, e.Title, Level + 1
		FROM EmployeesCTEData AS e INNER JOIN DirectReports AS d
			ON e.ManagerID = d.EmployeeID
)
-- Statement that executes the CTE
SELECT ManagerID, EmployeeID, Title, Level
FROM DirectReports;


-----------------------------------
-- Recursive CTE and MAXRECURSION
-----------------------------------

-- Use the MAXRECURSION option defined on the statement that is using the CTE.
-- Will retun n+1 results and then returns an error:
WITH DirectReports (ManagerID, EmployeeID, Title, Level)
AS
(
	-- Anchor member definition
	-- Select the manager, by filtering on manager = null
		SELECT e.ManagerID, e.EmployeeID, e.Title, 0 AS Level
		FROM EmployeesCTEData AS e 
		WHERE ManagerID IS NULL
    UNION ALL
	-- Recursive member definition (because it includes the DirectReports cte)
	-- In this second section, you can use
		SELECT e.ManagerID, e.EmployeeID, e.Title, Level + 1
		FROM EmployeesCTEData AS e INNER JOIN DirectReports AS d
			ON e.ManagerID = d.EmployeeID
		
)
SELECT ManagerID, EmployeeID, Title, LEVEL
FROM DirectReports
OPTION( MAXRECURSION 2);

-- MAXRECURSION Defaults to 100 if you set no value 
-- MAXRECURSION is not limited at all if you set to 0
-- To Logically limit calls, use a pseudo level column:
WITH DirectReports (ManagerID, EmployeeID, Title, Level)
AS
(
	-- Anchor member definition
	-- Select the manager, by filtering on manager = null
		SELECT e.ManagerID, e.EmployeeID, e.Title, 0 AS Level
		FROM EmployeesCTEData AS e 
		WHERE ManagerID IS NULL
    UNION ALL
	-- Recursive member definition (because it includes the DirectReports cte)
	-- In this second section, you can use
		SELECT e.ManagerID, e.EmployeeID, e.Title, Level + 1
		FROM EmployeesCTEData AS e INNER JOIN DirectReports AS d
			ON e.ManagerID = d.EmployeeID
		WHERE Level < 3
)
-- Statement that executes the CTE
SELECT ManagerID, EmployeeID, Title, LEVEL
FROM DirectReports

-------------------------
-- Additional CTE Notes:
-------------------------

-- Multiple CTE query definitions can be defined in a nonrecursive CTE. 
-- The definitions must be combined by one of: UNION ALL, UNION, INTERSECT, or EXCEPT.

-- A CTE can reference itself and previously defined CTEs in the same WITH clause. 
-- But Forward referencing is not allowed.

-- The following cannot be used in a CTE:
--		COMPUTE or COMPUTE BY, INTO, FOR XML/BROWSE,  
--		ORDER BY (except when a TOP clause is specified)
--		OPTION clause with query hints
