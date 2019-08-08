USE TEST
GO

/***************************************************************
	CREATE THE DATABASE
****************************************************************/

-- DROP TABLE Users
CREATE TABLE Users
(
	UserID INT IDENTITY NOT NULL,
	FirstName Varchar(200) NOT NULl,
	LastName VARCHAR(200) NOT NULL,
	FullName as FirstName + ' ' + LastName PERSISTED,
	FullNameUpper as Upper(FirstName + ' ' + LastName) PERSISTED,
	Address VARCHAR(200),
	City VARCHAR(200),
	PostCode VARCHAR(200),
	CreatedDate as convert(date, getDate()),
	LastLoginDate date
)
GO

-- Insert all of the data.
INSERT INTO [Test].[dbo].[Users] ([FirstName],[LastName],[Address],[City],[PostCode],[LastLoginDate])
VALUES('John', 'Moss', '178 Tinshill Lane', 'Leeds', 'LS16 7BL', '20100312')
INSERT INTO [Test].[dbo].[Users] ([FirstName],[LastName],[Address],[City],[PostCode],[LastLoginDate])
VALUES('Pauline', 'Moss', 'Flat 3 Sabine House', 'Abbots Langley', 'WD5 0NF', '20100312')
INSERT INTO [Test].[dbo].[Users] ([FirstName],[LastName],[Address],[City],[PostCode],[LastLoginDate])
VALUES('Marty', 'Moss', 'Flat 3 Sabine House', 'Abbots Langley', 'WD5 0NF', '20100312')
INSERT INTO [Test].[dbo].[Users] ([FirstName],[LastName],[Address],[City],[PostCode],[LastLoginDate])
VALUES('Angharad', 'Jones','178 Tinshill Lane', 'Leeds', 'LS16 7BL', '20100312')
INSERT INTO [Test].[dbo].[Users] ([FirstName],[LastName],[Address],[City],[PostCode],[LastLoginDate])
VALUES('Bryn', 'Jones', '637 Stonegate Road', 'Leeds', 'LS12 8GH', '20100312')
INSERT INTO [Test].[dbo].[Users] ([FirstName],[LastName],[Address],[City],[PostCode],[LastLoginDate])
VALUES('Nathan', 'Jones','637 Stonegate Road', 'Leeds', 'LS12 8GH', DEFAULT)
INSERT INTO [Test].[dbo].[Users] ([FirstName],[LastName],[Address],[City],[PostCode],[LastLoginDate])
VALUES('Pat', 'Jones', '637 Stonegate Road', 'Leeds', 'LS12 8GH', '20090817')
GO

-- Display the data
SELECT * FROM Users
GO

/***************************************************************
	Example Scalar Funtion
****************************************************************/

-- Scalar Function to get the month from the datetime
CREATE FUNCTION dbo.fnGetMonth(@DATE datetime)
RETURNS INT
AS
BEGIN
     DECLARE @month int;
     SET @month = DATEPART(MONTH,@DATE)
     RETURN(@month);
END
GO

-- Call the scalar funtion
SELECT dbo.fnGetMonth(GETDATE())
GO

/***************************************************************
	Example Table Valued Function
****************************************************************/

-- Table Valued Function, eg Parameterised view.
CREATE FUNCTION dbo.getUserByCity(@City VARCHAR(200))
RETURNS TABLE
AS
RETURN
(
	SELECT * FROM Users WHERE City = @City
)
GO

-- Call the table valued function
SELECT * FROM dbo.getUserByCity('Leeds')
SELECT * FROM dbo.getUserByCity('Abbots Langley')
GO

/***************************************************************
	Example Multi Statement Table Valued Function
****************************************************************/

-- Create a multi statement table valued function.
CREATE FUNCTION dbo.GetUserCities ()
RETURNS @userTable TABLE 
(
    UserID int primary key NOT NULL,
    FullName Varchar(200),
    FullNameCity Varchar(200)
)
AS
BEGIN
	-- Create a CTE to store the results
	WITH cteResults(UserID, FullName, FullNameCity) AS 
	(
		SELECT UserID, FullName, FullName + ' (' + City + ')'
		FROM Users
	)
	
	-- Copy output to table
	INSERT @userTable
	SELECT UserID, FullName, FullNameCity
	FROM cteResults 
   
	RETURN
END;
GO

-- Use the following SQL to determine if a function is deterministic
SELECT OBJECTPROPERTY(OBJECT_ID('dbo.GetUserCities'), 'IsDeterministic') AS [Is Deterministic]; 


-- Call the multi statement table valued function.
SELECT * FROM dbo.GetUserCities()
