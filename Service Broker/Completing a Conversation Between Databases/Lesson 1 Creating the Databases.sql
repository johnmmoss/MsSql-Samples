--------------------------------------------------
-- SERVICE BROKER TUTORIAL: 
--		Completing a Conversation Between Databases
--		http://technet.microsoft.com/en-us/library/bb839498.aspx

-- Lesson 1, Creating the Databases
--------------------------------------------------

USE master;
GO

-- 1.) Create a database which will be the initiator of the messages
-- 2.) Create a database which will be the target of the messages
-- 3.) Set the TRUSWORTHY option on the initiator database 


-- 1.) Create the Initiator Databases
--------------------------------------
IF EXISTS (SELECT * FROM sys.databases
           WHERE name = N'InitiatorDB')
     DROP DATABASE InitiatorDB;
GO
CREATE DATABASE InitiatorDB;
GO

-- 2.) Create the Target Database
-----------------------------------
IF EXISTS (SELECT * FROM sys.databases
           WHERE name = N'TargetDB')
     DROP DATABASE TargetDB;
GO
CREATE DATABASE TargetDB;
GO


-- 3.) Set the TRUSWORTHY option on the initiator database
--	   Setting the TRUSTWORTHY option in the InitiatorDB lets you start conversations in that 
--	   database that reference target services in the TargetDB

ALTER DATABASE InitiatorDB SET TRUSTWORTHY ON;
GO
