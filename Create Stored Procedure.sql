
---------------------------------
-- CREATE DATABASE: WidgetWorks
---------------------------------

CREATE DATABASE WidgetWorks
GO

USE [WidgetWorks]
GO

---------------------------------
-- CREATE TABLE: Widgets
---------------------------------

--IF (EXISTS (SELECT TOP 1 * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME  = 'Widgets'))
--BEGIN
--	DROP TABLE Widgets
--END

IF NOT (EXISTS (SELECT TOP 1 * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME  = 'Widgets'))
	BEGIN
		CREATE TABLE [dbo].[Widgets](
			[Id] [int] IDENTITY(1,1) NOT NULL,
			[Name] [varchar](50) NULL,
			[Description] [varchar](50) NULL,
			[Category] [int] NULL,
		 CONSTRAINT [PK_Widgets] PRIMARY KEY CLUSTERED 
		(
			[Id] ASC
		)) ON [PRIMARY]
	
	END
ELSE
	BEGIN
        print ('Table Widgets already exists. No action taken!')        
    END

-- TRUNCATE TABLE [dbo].[Widgets]
SELECT *
FROM [dbo].[Widgets]

---------------------------------
-- INSERT INTO: Widgets
---------------------------------
INSERT INTO 
	[dbo].[Widgets] (Name, Description, Category) 
VALUES 
	('Widget 1', 'My first widget', 1) ,
	('Widget 2', 'My second widget', 2) ,
	('Widget 3', 'My first widget', 3) 
GO

------------------------------------
-- CREATE PROCEDURE: usp_GetAllWidgets
------------------------------------
IF OBJECT_ID('usp_GetAllWidgets', 'P') IS NOT NULL
BEGIN	
	DROP PROCEDURE usp_GetAllWidgets	
END
GO
CREATE PROCEDURE usp_GetAllWidgets	
AS
	SELECT * FROM Widgets	
GO
-- EXEC usp_GetAllWidgets

----------------------------------------
-- CREATE PROCEDURE: usp_GetWidgetsByCategory
----------------------------------------
IF OBJECT_ID('usp_GetWidgetsByCategory', 'P') IS NOT NULL
BEGIN	
	DROP PROCEDURE usp_GetWidgetsByCategory
END
GO
CREATE PROCEDURE usp_GetWidgetsByCategory
	@Category INT
AS
	SELECT * FROM Widgets
	where Category = @Category
GO
-- EXEC usp_GetWidgetsByCategory 2

------------------------------------
-- CREATE PROCEDURE: usp_AddWidget
------------------------------------
IF OBJECT_ID('usp_AddWidget', 'P') IS NOT NULL
BEGIN	
	DROP PROCEDURE usp_AddWidget
END
GO
CREATE PROCEDURE usp_AddWidget
	@NAME VARCHAR(50),
	@DESCRIPTION VARCHAR(50),
	@CATEGORY INT = 33
AS
	INSERT INTO 
	[dbo].[Widgets] (Name, Description, Category) 
VALUES 
	(@NAME, @DESCRIPTION, @CATEGORY)
GO
-- EXEC usp_AddWidget 'New Widget', 'My new Widget'
-- EXEC usp_AddWidget 'New Widget', 'My new Widget', '100'
-- EXEC usp_AddWidget @NAME = 'New Widget', @DESCRIPTION = 'My new Widget'
-- EXEC usp_AddWidget @NAME = 'New Widget', @DESCRIPTION = 'My new Widget', @CATEGORY = '101'