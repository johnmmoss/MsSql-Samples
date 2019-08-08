------------------------------------------------------------------
-- SERVICE BROKER TUTORIAL: 
--		Completing a Conversation in a Single Database
--		http://technet.microsoft.com/en-us/library/bb839495.aspx

-- LESSON 2, Beginning a Conversation and Transmitting Messages
------------------------------------------------------------------

USE AdventureWorks2008R2;
GO

-------------------------------------------------------------
-- STEP ONE: Begin a conversation and send a request message
-------------------------------------------------------------
DECLARE @InitDlgHandle UNIQUEIDENTIFIER;
DECLARE @RequestMsg NVARCHAR(100) = N'<RequestMsg>Message for Target service.</RequestMsg>';

BEGIN TRANSACTION;

BEGIN DIALOG @InitDlgHandle
     FROM SERVICE
      [//AWDB/1DBSample/InitiatorService]
     TO SERVICE
      N'//AWDB/1DBSample/TargetService'
     ON CONTRACT
      [//AWDB/1DBSample/SampleContract]
     WITH
         ENCRYPTION = OFF;

SEND ON CONVERSATION @InitDlgHandle
     MESSAGE TYPE 
     [//AWDB/1DBSample/RequestMessage]
     (@RequestMsg);

SELECT @RequestMsg AS SentRequestMsg;

COMMIT TRANSACTION;
GO


------------------------------------------------------------------
-- STEP TWO: Recieve the Request and Send a reply from the TARGET
------------------------------------------------------------------
--A3812018-C46D-E011-97CB-E8B97D0C1D77
-- NOTE: At this point we can view any messages that have been sent to the target:
select * from TargetQueue1DB

DECLARE @RecvReqDlgHandle UNIQUEIDENTIFIER;
DECLARE @RecvReqMsg NVARCHAR(100);
DECLARE @RecvReqMsgName sysname;

BEGIN TRANSACTION;

-- WAITFOR ( ... ), TIMEOUT 1000;
WAITFOR
( RECEIVE TOP(1)
    @RecvReqDlgHandle = conversation_handle,
    @RecvReqMsg = message_body,
    @RecvReqMsgName = message_type_name
  FROM TargetQueue1DB
), TIMEOUT 1000;

SELECT @RecvReqMsg AS ReceivedRequestMsg;

IF @RecvReqMsgName =
   N'//AWDB/1DBSample/RequestMessage'
BEGIN
     DECLARE @ReplyMsg NVARCHAR(100);
     SELECT @ReplyMsg = N'<ReplyMsg>Message for Initiator service.</ReplyMsg>';
 
     SEND ON CONVERSATION @RecvReqDlgHandle
          MESSAGE TYPE 
          [//AWDB/1DBSample/ReplyMessage]
          (@ReplyMsg);

     END CONVERSATION @RecvReqDlgHandle;
END

SELECT @ReplyMsg AS SentReplyMsg;

COMMIT TRANSACTION;
GO


----------------------------------------------------------
-- STEP THREE: Receive the reply and end the conversation
----------------------------------------------------------

-- NOTE: At this poinrt we can view the messages the target has sent back to the recievers queue:
select * from InitiatorQueue1DB

DECLARE @RecvReplyMsg NVARCHAR(100);
DECLARE @RecvReplyDlgHandle UNIQUEIDENTIFIER;

BEGIN TRANSACTION;

WAITFOR
( RECEIVE TOP(1)
    @RecvReplyDlgHandle = conversation_handle,
    @RecvReplyMsg = message_body
  FROM InitiatorQueue1DB
), TIMEOUT 1000;

END CONVERSATION @RecvReplyDlgHandle;

SELECT @RecvReplyMsg AS ReceivedReplyMsg;

COMMIT TRANSACTION;
GO


-- NOTE: You can repeat the steps in this lesson as many times as you want 
-- to transmit a request-reply pair of messages