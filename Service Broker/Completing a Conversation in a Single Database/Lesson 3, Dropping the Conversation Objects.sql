------------------------------------------------------------------
-- SERVICE BROKER TUTORIAL: 
--		Completing a Conversation in a Single Database
--		http://technet.microsoft.com/en-us/library/bb839495.aspx

-- LESSON 3, Dropping the Conversation Objects
------------------------------------------------------------------

USE AdventureWorks2008R2;
GO

-------------------------------------------------------------
-- STEP ONE: Drop the conversation objects
-------------------------------------------------------------

IF EXISTS (SELECT * FROM sys.services
           WHERE name =
           N'//AWDB/1DBSample/TargetService')
     DROP SERVICE
     [//AWDB/1DBSample/TargetService];

IF EXISTS (SELECT * FROM sys.service_queues
           WHERE name = N'TargetQueue1DB')
     DROP QUEUE TargetQueue1DB;

-- Drop the intitator queue and service if they already exist.
IF EXISTS (SELECT * FROM sys.services
           WHERE name =
           N'//AWDB/1DBSample/InitiatorService')
     DROP SERVICE
     [//AWDB/1DBSample/InitiatorService];

IF EXISTS (SELECT * FROM sys.service_queues
           WHERE name = N'InitiatorQueue1DB')
     DROP QUEUE InitiatorQueue1DB;

IF EXISTS (SELECT * FROM sys.service_contracts
           WHERE name =
           N'//AWDB/1DBSample/SampleContract')
     DROP CONTRACT
     [//AWDB/1DBSample/SampleContract];

IF EXISTS (SELECT * FROM sys.service_message_types
           WHERE name =
           N'//AWDB/1DBSample/RequestMessage')
     DROP MESSAGE TYPE
     [//AWDB/1DBSample/RequestMessage];

IF EXISTS (SELECT * FROM sys.service_message_types
           WHERE name =
           N'//AWDB/1DBSample/ReplyMessage')
     DROP MESSAGE TYPE
     [//AWDB/1DBSample/ReplyMessage];
GO


SELECT * FROM sys.services
SELECT * FROM sys.service_queues
SELECT * FROM sys.service_contracts
SELECT * FROM sys.service_message_types
