------------------------------------------------------
-- SERVICE BROKER TUTORIAL: 
--		Completing a Conversation Between Databases
--		http://technet.microsoft.com/en-us/library/bb839498.aspx

-- Lesson 2, Creating the Target Conversation Objects
------------------------------------------------------

-- 1.) Create the message types for the Target Database
-- 2.) Create the contract for the Target Database
-- 3.) Create the target Queue for the Target Database
-- 4.) Create the Service for the Target Database

USE TargetDB;
GO

-------------------------------------------------------
-- 1.) Create the message types for the Target Database
-------------------------------------------------------

-- The message type names and properties that you specify must be identical 
-- to the ones that you will create in the InitiatorDB in the next lesson.

CREATE MESSAGE TYPE [//BothDB/2DBSample/RequestMessage]
       VALIDATION = WELL_FORMED_XML;
CREATE MESSAGE TYPE [//BothDB/2DBSample/ReplyMessage]
       VALIDATION = WELL_FORMED_XML;
GO

---------------------------------------------------
-- 2.) Create the contract for the Target Database
---------------------------------------------------

CREATE CONTRACT [//BothDB/2DBSample/SimpleContract]
      ([//BothDB/2DBSample/RequestMessage]
         SENT BY INITIATOR,
       [//BothDB/2DBSample/ReplyMessage]
         SENT BY TARGET
      );
GO

-------------------------------------------------------------------
-- 3.) Create the target queue and service for the Target Database
-------------------------------------------------------------------

CREATE QUEUE TargetQueue2DB;

CREATE SERVICE [//TgtDB/2DBSample/TargetService]
       ON QUEUE TargetQueue2DB
       ([//BothDB/2DBSample/SimpleContract]);
GO
