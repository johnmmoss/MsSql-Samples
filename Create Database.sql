
-- CREATE DATABASE (Transact-SQL)
-- http://msdn.microsoft.com/en-us/library/ms176061.aspx

-- Create a simple database with all defaults.
CREATE DATABASE Blog5

--  Specifying name
CREATE DATABASE Blog
ON ( Name = Blog2_dat, FileName = 'C:\b1.mdf' )
LOG ON (Name = Blog2_log, FileName = 'C:\b1.ldf');
go


-- Example from msdn:
CREATE DATABASE Sales
ON 
( 
	NAME = Sales_dat,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\saledat.mdf',
	SIZE = 10,
	MAXSIZE = 50,
	FILEGROWTH = 5 
)
LOG ON
( 
	NAME = Sales_log,
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\salelog.ldf',
	SIZE = 5MB,
	MAXSIZE = 25MB,
	FILEGROWTH = 5MB 
);
GO
