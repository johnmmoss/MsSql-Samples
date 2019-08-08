


use test

--CREATE TABLE dbo.Customers
--(
--customerid CHAR(5) NOT NULL PRIMARY KEY,
--city VARCHAR(10) NOT NULL
--);
--INSERT INTO dbo.Customers(customerid, city) VALUES('FISSA', 'Madrid');
--INSERT INTO dbo.Customers(customerid, city) VALUES('FRNDO', 'Madrid');
--INSERT INTO dbo.Customers(customerid, city) VALUES('KRLOS', 'Madrid');
--INSERT INTO dbo.Customers(customerid, city) VALUES('MRPHS', 'Zion');
--CREATE TABLE dbo.Orders
--(
--orderid INT NOT NULL PRIMARY KEY,
--customerid CHAR(5) NULL REFERENCES Customers(customerid)
--);
--INSERT INTO dbo.Orders(orderid, customerid) VALUES(1, 'FRNDO');
--INSERT INTO dbo.Orders(orderid, customerid) VALUES(2, 'FRNDO');
--INSERT INTO dbo.Orders(orderid, customerid) VALUES(3, 'KRLOS');
--INSERT INTO dbo.Orders(orderid, customerid) VALUES(4, 'KRLOS');
--INSERT INTO dbo.Orders(orderid, customerid) VALUES(5, 'KRLOS');
--INSERT INTO dbo.Orders(orderid, customerid) VALUES(6, 'MRPHS');
--INSERT INTO dbo.Orders(orderid, customerid) VALUES(7, NULL);

select * from Customers
select * from Orders



-- Madrid Customers with Fewer than Three Orders:
SELECT C.customerid, COUNT(O.orderid) AS numorders
FROM dbo.Customers AS C
LEFT OUTER JOIN dbo.Orders AS O
ON C.customerid = O.customerid
WHERE C.city = 'Madrid'
GROUP BY C.customerid
HAVING COUNT(O.orderid) < 3
ORDER BY numorders;

-- Step One is a cartesian product:
select * from Customers cross join Orders


-- Step Two Evaluates the ON to give the equivalent internal virtual table
select * from Customers cross join Orders
WHERE Customers.CustomerID = Orders.CustomerID

-- Step Three: Adding the outer rows.
--This step is relevant only for an outer join. For an outer join, you mark one or both input
--tables as preserved by specifying the type of outer join (LEFT, RIGHT, or FULL). Marking a
--table as preserved means that you want all of its rows returned, even when filtered out by the
--<join_condition>. A left outer join marks the left table as preserved, a right outer join marks the
--right, and a full outer join marks both. Step 3 returns the rows from VT2, plus rows from the
--preserved table for which a match was not found in step 2. These added rows are referred to
--as outer rows. NULLs are assigned to the attributes (column values) of the nonpreserved table
--in the outer rows. As a result, virtual table VT3 is generated.

-- Step 4 Applying the WHERE clause.
-- Trying to get customers and orders for cities where = Madrid
SELECT C.customerid, City, orderid
FROM dbo.Customers AS C
LEFT OUTER JOIN dbo.Orders AS O
ON C.customerid = O.customerid
-- ... If you include filter in the On clause, ie before outer rows are applied
-- then the filtered rows will get added back in with the preserved, outer table,
-- rows:
-- AND C.city = 'Madrid'			
-- WHERE C.city = 'Madrid'