
-------------------------------------------
-- Example taken from:
--		http://blog.sqlauthority.com/2010/02/24/sql-server-introduction-to-rollup-clause/
-------------------------------------------

USE Test

------------------------
-- Create the test data
------------------------

IF OBJECT_ID('tblPopulation') IS NOT NULL DROP TABLE tblPopulation

CREATE TABLE tblPopulation (
	Country VARCHAR(100),
	[State] VARCHAR(100),
	City VARCHAR(100),
	Population INT
)
GO

INSERT INTO tblPopulation VALUES('India', 'Delhi','East Delhi',9 )
INSERT INTO tblPopulation VALUES('India', 'Delhi','South Delhi',8 )
INSERT INTO tblPopulation VALUES('India', 'Delhi','North Delhi',5.5)
INSERT INTO tblPopulation VALUES('India', 'Delhi','West Delhi',7.5)
INSERT INTO tblPopulation VALUES('India', 'Karnataka','Bangalore',9.5)
INSERT INTO tblPopulation VALUES('India', 'Karnataka','Belur',2.5)
INSERT INTO tblPopulation VALUES('India', 'Karnataka','Manipal',1.5)
INSERT INTO tblPopulation VALUES('India', 'Maharastra','Mumbai',30)
INSERT INTO tblPopulation VALUES('India', 'Maharastra','Pune',20)
INSERT INTO tblPopulation VALUES('India', 'Maharastra','Nagpur',11 )
INSERT INTO tblPopulation VALUES('India', 'Maharastra','Nashik',6.5)

INSERT INTO tblPopulation VALUES('Scotland', 'Lothian','Edingburgh',8.5)
INSERT INTO tblPopulation VALUES('Scotland', 'Lothian','Dalkieth',6.0)
INSERT INTO tblPopulation VALUES('Scotland', 'Lothian','Falkirk',6.5)
INSERT INTO tblPopulation VALUES('England', 'Lancashire','Manchester', 9.0)
INSERT INTO tblPopulation VALUES('England', 'Lancashire','Barnsley', 4.0)
INSERT INTO tblPopulation VALUES('England', 'Yorkshire','Leeds', 14)
INSERT INTO tblPopulation VALUES('England', 'Yorkshire','Doncaster', 6.5)
INSERT INTO tblPopulation VALUES('England', 'Yorkshire','Bradford', 12)
INSERT INTO tblPopulation VALUES('England', 'London','Chelsea', 2.5)
GO

-- Some observations on our data:
--	   Country is the super set 
--	   State is the sub set
--	   City is the leaf set
-- Lets anaylse the 
--	1.) The total population					i.e. across ALL rows	= () 
--	2.) The total population in each Country	i.e. the super set		= (Country)
--	3.) The total population in each State		i.e. each sub set		= (Country, State)
--	4.) The total population in each city		i.e. each leaf set		= (Country, State, City)

-----------------------------------------
-- Aggregating data with GROUP BY Clause
-----------------------------------------

-- 1.)  The total population - ()
SELECT SUM([Population]) AS [Total Population]  
FROM tblPopulation

-- 2.) The total population in each Country - (Country)
SELECT Country, SUM([Population]) As [Total Population]  
FROM tblPopulation
GROUP BY Country

-- 3.) The total population in each state - (Country, State)
SELECT Country, State, SUM([Population]) As [Total Population]  
FROM tblPopulation
GROUP BY Country, State

-- 4.) The population by city - (Country, State, City)
--	   Note that this is equivalent to select *
SELECT Country, State, City, SUM([Population]) AS Population
FROM tblPopulation 
GROUP BY Country, State, City

-- So in order to get aggregations for all of these in one results set 
-- we can union all of these:
SELECT NULL, NULL, NULL, SUM([Population]) AS [Total Population]  
FROM tblPopulation
UNION ALL
SELECT Country, NULL, NULL, SUM([Population]) As [Total Population]  
FROM tblPopulation
GROUP BY Country
UNION ALL
SELECT Country, State, NULL, SUM([Population]) As [Total Population]  
FROM tblPopulation
GROUP BY Country, State
UNION ALL
SELECT Country, State, City, SUM([Population]) AS Population
FROM tblPopulation 
GROUP BY Country, State, City

---------------------------------------
-- Aggregating data with ROLLUP Clause
---------------------------------------

-- The ROLLUP clause can be used to provide all of the aggregations outline in one statment:
-- The clause will create four aggregations, ie one more than the number of columns in the group by clause:
-- e.g. GROUP BY (a,b,c) is equivalent:
--		GROUP BY (a,b,c) 
--		GROUP BY (a,b) 
--		GROUP BY (a) 
--		GROUP BY () 
-- These bracketed values are essentially the group by clause parameters
-- The rollup is done from left to right.S

SELECT Country,[State],City, SUM ([Population]) AS [Population (in Millions)]
	, GROUPING(State)
FROM tblPopulation
GROUP BY Country,[State],City 
WITH ROLLUP

---------------------------------------
-- Aggregating data with CUBE Clause
---------------------------------------

SELECT Country,[State],City, SUM ([Population]) AS [Population (in Millions)]
FROM tblPopulation
GROUP BY Country,[State],City 
WITH CUBE

-----------------------------------------------
-- Aggregating data with GROUPING SETS Clause
-----------------------------------------------

-- Grouping sets can be used in place of the GROUP BY, ROLLUP or CUBE operators.
-- In simple terms, you add each set of parameters for the GROUP BY into the GROUPING SETS clause

-- As a starting example, here is the ROLLUP clause implemented using GROUPING SETS:
SELECT Country,[State],City, SUM ([Population]) AS [Population (in Millions)]
FROM tblPopulation
GROUP BY GROUPING SETS
(
	(Country, [State],City), 
	(Country, [State]), 
	(Country), 
	()
)

-- The CUBE operator can be written as a GROUPING SET also:
SELECT Country,[State],City, SUM ([Population]) AS [Population (in Millions)]
FROM tblPopulation
GROUP BY GROUPING SETS
(
	(Country,[State], City),
	(Country,[State]),
	(Country, City), 
	([State], City), 
	(Country),
	([State]),
	(City),
	()
)

SELECT NULL, [State], [City], SUM ([Population]) 
FROM tblPopulation
GROUP BY [State], City

SELECT Country, NULL, NULL, SUM ([Population]) 
FROM tblPopulation
GROUP BY (Country)

SELECT NULL, [State], NULL, SUM ([Population]) 
FROM tblPopulation
GROUP BY ([State])

SELECT NULL, NULL, City, SUM ([Population]) 
FROM tblPopulation
GROUP BY (City)