
USE Test

----------------------------------
-- Using Table Valued Parameters
----------------------------------

-- New in SQL Server 2008, you can pass table valued parameters to a routine:
-- 1.) Create a new table TYPE
-- 2.) Declare a routine (FUNCTION or SP) that has this type.
-- 3.) Declare a var using this new type and populate it.
-- 4.) Call the routine created above, passing the new table type variable.


-- Before we begin we create a table called UserLanguages that 
-- will be used for the example and clear up the objects created later.
IF OBJECT_ID('UserLanguages') IS NOT NULL DROP TABLE UserLanguages
SELECT TOP 10 langid, lcid, alias 
INTO UserLanguages
FROM sys.syslanguages
ORDER BY name desc
GO

IF OBJECT_ID('usp_InsertLanguages') IS NOT NULL DROP PROC usp_InsertLanguages
GO
IF TYPE_ID(N'LanguagesTableType') IS NOT NULL DROP TYPE LanguagesTableType
GO

-- 1.) So, first up we create a new table type like so:
CREATE TYPE LanguagesTableType AS TABLE 
( 
	LanguageID INT, 
	LCID INT ,
	Alias VARCHAR(50)
);
GO

-- 2.) Next we create a routine that takes the table valued tpe as a parameter.
-- Note that the parameter is marked as readonly. You cannot modify table valued
-- parameters inside the routine, and they HAVE to be marked as READONLY!!!

CREATE PROCEDURE usp_InsertLanguages 
    @languages LanguagesTableType READONLY
    AS 
    BEGIN
		SET NOCOUNT ON
		INSERT INTO UserLanguages (LangID, LCID, Alias)
		OUTPUT Inserted.*
		SELECT LanguageID, LCID, Alias FROM @languages
    END
GO    

-- 3.) Now that we have a new table type and a routine that uses this table type
-- we can use the new objects in an example:
DECLARE @NewLanguages AS LanguagesTableType;

INSERT INTO @NewLanguages (LanguageID, lcid, alias )
    SELECT TOP 10 langid, lcid, alias 
	FROM sys.syslanguages
	ORDER BY name asc

/* Pass the table variable data to a stored procedure. */
EXEC usp_InsertLanguages @NewLanguages;
GO

------------------------
-- Some Addtional Notes
------------------------

-- The TVP is scoped to the routine exactly like other parameters.
-- Also the local variable table value type has a scope like any other variable.
-- A TVP cannot be used as the target for a SELECT ... INTO or INSERT ... EXEC
-- A TVP cannot be written to, so cannot be used with the OUTPUT parameter


--------------------------------------------------------------
-- Finding out about Types, Table Types, and Object Parameters
---------------------------------------------------------------

-- You can veiw all parameters in the database using sys.parameters
select OBJECT_NAME(object_id) as ObjectName, * from sys.parameters

-- To learn about ALL types in the database
SELECT * FROM sys.Types

-- To learn about all table types in the database
select * from sys.table_types