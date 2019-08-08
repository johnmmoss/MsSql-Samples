
-------------------------------------
-- FILESTREAM Column Example
-------------------------------------

select * from sys.databases
-- SETUP
--------------
-- Before we can use FILESTREAM storage it needs to be enabled, both through the SQL Configuration
-- manager, and also by setting the sp_configure option "filestream access level". The values are:
--  0 = No file stream access is allowed.
--	1 = Only T-SQL can access.
--	2 = Direct access via the file system is possible
--	3 = Accessable through a Network Share

EXEC sp_configure 'filestream access level', 1
RECONFIGURE

----------------------
-- FILESTREAM Example
----------------------
-- To create a filestream column we simply specify the FILESTREAM option on the appropriate column.
-- Specifying this option forces the column value to be stored on the file system, rather than in 
-- the database itself. 

-- However, there is some further setup to do before we can get to this stage:
--	1.) Add a new FILESTREAM filegroup to the database in question.
--	2.) Add a file to the file group just created. Note this is a folder where the files will be stored.
--	3.) Create a table that uses the filestream directory by using the FILESTREAM option.


USE Test

-- 1.) Add a new FILESTREAM filegroup to the database in question.
ALTER DATABASE Test 
	ADD FILEGROUP FileStreamPhotosFG 
		CONTAINS FILESTREAM; 


-- 2.) Next add a file to the file group we created above. Note that this "File" is 
-- actually a directory which is the new location of any FILESTREAM objects.
ALTER DATABASE Test 
	ADD FILE 
	(
		NAME = 'FileStreamPhotosDF' 
		,FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL10.DEVELOPER2008\MSSQL\DATA\FileStreamPhotosDF' 
	)
	TO FILEGROUP FileStreamPhotosFG; 

-- 3.) Now that we have set up the required database filegroup and database file, we can create a table which 
--	   uses a FILESTREAM object. 
--	   In order to sucessfuly use the FILESTREAM option, we must declare a non null unique row ID field.
--	   The ROWGUIDCOL property indicates that the uniqueidentifier values in the column uniquely identify 
--     rows in the table. 
--	   Therefore, our RowGuid column below is unique, has a default of NEWSEQUENTIALID 
--	   and uniquely identifes rows!
IF OBJECT_ID('TestPhotos') IS NOT NULL DROP TABLE TestPhotos
CREATE TABLE TestPhotos
(
	PhotoID int,
	Name VARCHAR(300) NOT NULL, 
	[Description] VARCHAR(300),
	Photo VARBINARY(MAX) FILESTREAM NULL,
	RowGuid UNIQUEIDENTIFIER NOT NULL ROWGUIDCOL 
		CONSTRAINT DFProductPhotoRowGuid DEFAULT NEWSEQUENTIALID() 
		CONSTRAINT UQProductPhotoRowGuid UNIQUE
)

-- Finally we can insert some data into out test photos table:
INSERT INTO TestPhotos (PhotoID, Name, [Description], Photo)
SELECT 1, 'Euro Fighter.jpg', 'A Euro Fighter firing a missile on a practice bombing run', photo.*  
FROM OPENROWSET(BULK 'C:\Euro Fighter.jpg', SINGLE_BLOB) photo
GO
INSERT INTO TestPhotos (PhotoID, Name, [Description], Photo)
SELECT 2, 'F16.jpg', 'An F16 Hornet flying a reconnaissance mission',  photo.* 
FROM OPENROWSET(BULK 'C:\F16.jpg', SINGLE_BLOB) photo
GO
INSERT INTO TestPhotos (PhotoID, Name, [Description], Photo)
SELECT 3, 'F18.jpg', 'An F18 Hornet flying operations over the Atlantic',  photo.*  
FROM OPENROWSET(BULK 'C:\F18.jpg', SINGLE_BLOB) photo
GO
INSERT INTO TestPhotos (PhotoID, Name, [Description], Photo)
SELECT 4, 'Tornado.jpg', 'A Tornado GR1 takes off in the dawn sky',  photo.*  
FROM OPENROWSET(BULK 'C:\Tornado.jpg', SINGLE_BLOB) photo
GO
-- We can see the four plane photos added to the 
SELECT * FROM TestPhotos

---------------------
-- ADDITIONAL NOTES:
---------------------
-- Is most advantageous for values greater than 1Mb - Greatly improves performance.
-- FILESTREAM objects are only limited by the size of the file system.
-- VARBINARY values are normally limited to 2GB.
-- Database Mirroring cannot be used on databases containing FILESTREAM data.
-- Database snapshots cannot include the FILESTREAM filegroups.
-- FILESTREAM data cannot be encrypted natively by SQL Server.

------------------------------------------------
-- Viewing information about FILESTREAM objects
------------------------------------------------

-- We can view all current file groups in the database using sys.filegroups
-- Note that this is just for the current database. 
select * from sys.filegroups

select * from sys.master_files