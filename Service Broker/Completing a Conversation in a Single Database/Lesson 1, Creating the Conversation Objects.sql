--------------------------------------------------
-- SERVICE BROKER TUTORIAL: 
--		Completing a Conversation in a Single Database
--		http://technet.microsoft.com/en-us/library/bb839495.aspx

-- LESSON 1, Creating the Conversation Objects
--------------------------------------------------

------------------------------------------------------------------------
-- STEP ONE: Enable the service broker and Switch Context to correct db.
------------------------------------------------------------------------

USE master;

ALTER DATABASE AdventureWorks2008R2
      SET NEW_BROKER;
      --SET ENABLE_BROKER;
GO      
USE AdventureWorks2008R2;

-- You can view the Service broker status using sys.databases view
select 
	name, 
	is_broker_enabled, 
	service_broker_guid, 
	is_honor_broker_priority_on 
from sys.databases

-------------------------------------------------------
-- STEP TWO: Create Message Types for the Converstation
-------------------------------------------------------
-- Because Service Broker objects are often referenced across multiple instances of the 
-- Database Engine, most Service Broker objects are given names in a URI format
CREATE MESSAGE TYPE
       [//AWDB/1DBSample/RequestMessage]
       VALIDATION = WELL_FORMED_XML;
CREATE MESSAGE TYPE
       [//AWDB/1DBSample/ReplyMessage]
       VALIDATION = WELL_FORMED_XML;
GO

-------------------------------------------------------
-- STEP THREE: Create the contract for the Conversation
-------------------------------------------------------

CREATE CONTRACT [//AWDB/1DBSample/SampleContract]
      ([//AWDB/1DBSample/RequestMessage]
       SENT BY INITIATOR,
       [//AWDB/1DBSample/ReplyMessage]
       SENT BY TARGET
      );
GO

--------------------------------------------------
-- STEP FOUR: Create the target queue and service
--------------------------------------------------

CREATE QUEUE TargetQueue1DB;
CREATE SERVICE
       [//AWDB/1DBSample/TargetService]
       ON QUEUE TargetQueue1DB
       ([//AWDB/1DBSample/SampleContract]);
GO


-----------------------------------------------------
-- STEP FIVE: Create the initiator queue and service
-----------------------------------------------------

CREATE QUEUE InitiatorQueue1DB;
CREATE SERVICE
       [//AWDB/1DBSample/InitiatorService]
       ON QUEUE InitiatorQueue1DB;
GO
