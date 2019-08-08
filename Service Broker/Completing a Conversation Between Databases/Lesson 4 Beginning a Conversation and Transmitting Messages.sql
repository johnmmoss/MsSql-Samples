-----------------------------------------------------------------
-- SERVICE BROKER TUTORIAL: 
--		Completing a Conversation Between Databases
--		http://technet.microsoft.com/en-us/library/bb839498.aspx

-- Lesson 4, Beginning a Conversation and Transmitting Messages
-----------------------------------------------------------------

-------------------------------------------------------------
-- STEP ONE: Start a conversation and send a request message
-------------------------------------------------------------

-- First switch to the Initiator DB
USE InitiatorDB;
GO

DECLARE @InitDlgHandle UNIQUEIDENTIFIER;
DECLARE @RequestMsg NVARCHAR(100);

BEGIN TRANSACTION;

BEGIN DIALOG @InitDlgHandle
     FROM SERVICE [//InitDB/2DBSample/InitiatorService]
     TO SERVICE N'//TgtDB/2DBSample/TargetService'
     ON CONTRACT [//BothDB/2DBSample/SimpleContract]
     WITH
         ENCRYPTION = OFF;

SELECT @RequestMsg =
   N'<RequestMsg>Message for Target service.</RequestMsg>';

SEND ON CONVERSATION @InitDlgHandle
     MESSAGE TYPE [//BothDB/2DBSample/RequestMessage]
      (@RequestMsg);

SELECT @RequestMsg AS SentRequestMsg;

COMMIT TRANSACTION;
GO


---------------------------------------------------
-- STEP TWO: Receive the request and send a reply
---------------------------------------------------

-- First switch to the TargetDB
USE TargetDB;
GO

-- View the message just sent by looking at the queue
select * from TargetQueue2DB

-- Recieve the request and reply
DECLARE @RecvReqDlgHandle UNIQUEIDENTIFIER;
DECLARE @RecvReqMsg NVARCHAR(100);
DECLARE @RecvReqMsgName sysname;

BEGIN TRANSACTION;

WAITFOR
( RECEIVE TOP(1)
    @RecvReqDlgHandle = conversation_handle,
    @RecvReqMsg = message_body,
    @RecvReqMsgName = message_type_name
  FROM TargetQueue2DB
), TIMEOUT 1000;

SELECT @RecvReqMsg AS ReceivedRequestMsg;

IF @RecvReqMsgName =
   N'//BothDB/2DBSample/RequestMessage'
BEGIN
     DECLARE @ReplyMsg NVARCHAR(100);
     SELECT @ReplyMsg =
        N'<ReplyMsg>Message for Initiator service.</ReplyMsg>';
 
     SEND ON CONVERSATION @RecvReqDlgHandle
          MESSAGE TYPE
            [//BothDB/2DBSample/ReplyMessage] (@ReplyMsg);

     END CONVERSATION @RecvReqDlgHandle;
END

SELECT @ReplyMsg AS SentReplyMsg;

COMMIT TRANSACTION;
GO

-------------------------------------------------------------
-- STEP THREE, Receive the reply and end the conversation
-------------------------------------------------------------

-- First switch back to the initiator
USE InitiatorDB;
GO

-- View the message reply from the target by looking in the initiator queue
select * from InitiatorQueue2DB

DECLARE @RecvReplyMsg NVARCHAR(100);
DECLARE @RecvReplyDlgHandle UNIQUEIDENTIFIER;

BEGIN TRANSACTION;

WAITFOR
( RECEIVE TOP(1)
    @RecvReplyDlgHandle = conversation_handle,
    @RecvReplyMsg = message_body
  FROM InitiatorQueue2DB
), TIMEOUT 1000;

END CONVERSATION @RecvReplyDlgHandle;

-- Display recieved request.
SELECT @RecvReplyMsg AS ReceivedReplyMsg;

COMMIT TRANSACTION;
GO
