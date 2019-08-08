----------------------------------------------------------
-- SERVICE BROKER TUTORIAL: 
--		Completing a Conversation Between Databases
--		http://technet.microsoft.com/en-us/library/bb839498.aspx

-- Lesson 3, Creating the Initiator Conversation Objects
-----------------------------------------------------------

-- 1.) Create the message types for the Initiator Database
-- 2.) Create the contract for the Initiator Database
-- 3.) Create the target Queue for the Initiator Database
-- 4.) Create the Service for the Initiator Database

USE InitiatorDB;
GO

-----------------------------------------------------------
-- 1.) Create the message types for the Initiator Database
-----------------------------------------------------------

-- The message type names and properties that you specify must be identical 
-- to the ones that you will create in the InitiatorDB in the next lesson.

CREATE MESSAGE TYPE [//BothDB/2DBSample/RequestMessage]
       VALIDATION = WELL_FORMED_XML;
CREATE MESSAGE TYPE [//BothDB/2DBSample/ReplyMessage]
       VALIDATION = WELL_FORMED_XML;
GO

-----------------------------------------------------
-- 2.) Create the Contract for the Initiator Database
-----------------------------------------------------

CREATE CONTRACT [//BothDB/2DBSample/SimpleContract]
      ([//BothDB/2DBSample/RequestMessage]
         SENT BY INITIATOR,
       [//BothDB/2DBSample/ReplyMessage]
         SENT BY TARGET
      );
GO

----------------------------------------------------------------
-- 3.) Create the queue and service for the Initiator Database
----------------------------------------------------------------

CREATE QUEUE InitiatorQueue2DB;

CREATE SERVICE [//InitDB/2DBSample/InitiatorService]
       ON QUEUE InitiatorQueue2DB;
GO
