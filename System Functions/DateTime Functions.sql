
-------------------
--	NEW FUNCTIONS
-------------------

-- Returns a datetime2(7) value that contains the date and time of the computer on which the instance of SQL Server is running. The time zone offset is not included.
SELECT SYSDATETIME()		-- 2011-01-09 12:25:56.6210000
-- Returns a datetimeoffset(7) value that contains the date and time of the computer on which the instance of SQL Server is running. The time zone offset is included.
SELECT SYSDATETIMEOFFSET()	-- 2011-01-09 12:26:39.0680000 +00:00
-- Returns a datetime2(7) value that contains the date and time of the computer on which the instance of SQL Server is running. The date and time is returned as UTC time (Coordinated Universal Time).
SELECT SYSUTCDATETIME()		-- 2011-01-09 12:27:09.3810000

------------------------
--	EXISTING FUNCTIONS
------------------------

-- Returns a datetime2(7) value that contains the date and time of the computer on which the instance of SQL Server is running. The time zone offset is not included.
SELECT CURRENT_TIMESTAMP
-- Returns a datetime2(7) value that contains the date and time of the computer on which the instance of SQL Server is running. The time zone offset is not included.
SELECT GETDATE()
-- Returns a datetime2(7) value that contains the date and time of the computer on which the instance of SQL Server is running. The date and time is returned as UTC time (Coordinated Universal Time).
SELECT GETUTCDATE()

---------------
--	DATENAME
---------------

-- Returns a character string that represents the specified datepart of the specified date.
SELECT DATENAME( MONTH, sysdatetime()) -- January (On 09/01/2011)
SELECT DATENAME( MM, sysdatetime()) -- January (On 09/01/2011)
SELECT DATENAME( M, sysdatetime()) -- January (On 09/01/2011)

---------------
--	DATEPART
---------------

-- Returns an integer that represents the specified datepart of the specified date.
SELECT DATEPART( MONTH, SYSDATETIME())		-- 1 (On 09/01/2011)
SELECT DATEPART( MM, SYSDATETIME())			-- 1 (On 09/01/2011)
SELECT DATEPART( M, SYSDATETIME())			-- 1 (On 09/01/2011)
-- Year
SELECT DATEPART( YEAR, SYSDATETIME())		-- 2011 (On 09/01/2011)
SELECT DATEPART( YY, SYSDATETIME())			-- 2011(On 09/01/2011)
SELECT DATEPART( YYYY, SYSDATETIME())		-- 2011(On 09/01/2011)
-- Day of Month
SELECT DATEPART( DAY, '20110621')		-- 21
SELECT DATEPART( D, '20110621')			-- 21
-- Day of Year
SELECT DATEPART( DY, '20110621')		-- 172 
SELECT DATEPART( Y, '20110621')			-- 172 
	
-- Returns an integer that represents the day day part of the specified date.
SELECT DAY(SYSDATETIME())	-- 9 (On 09/01/2011)

-- Returns an integer that represents the month part of a specified date.
SELECT MONTH (SYSDATETIME()) -- 1 (On 09/01/2011)

-- Returns an integer that represents the year part of a specified date.
SELECT YEAR ( SYSDATETIME()) -- 2011 (On 09/01/2011)

----------------
--	Date DIFFS
----------------
	
-- Returns the number of date or time datepart boundaries that are crossed between two specified dates.
SELECT DATEDIFF( YEAR, SYSDATETIME(), '20000101') -- -11 eg, the number of years since 2000!
SELECT DATEDIFF( MONTH, SYSDATETIME(), '20000101') -- -132 eg, the number of months since 2000!
SELECT DATEDIFF( DAY, SYSDATETIME(), '20000101') -- --4026 eg, the number of days since 2000!

-- Returns a new datetime value by adding an interval to the specified datepart of the specified date
SELECT DATEADD(YEAR, 10, SYSDATETIME())	-- 2021-01-09 12:39:06.8350000 (On 09/01/2011)
SELECT DATEADD(MONTH, 10, '20110501')	-- 2012-03-01 00:00:00.000
SELECT DATEADD(DAY, 366, '20000101')	-- 2001-01-01 00:00:00.000

