

LOGON TRIGGER Example
----------------------
In the following code, the logon trigger denies log in attempts to SQL Server initiated by login login_test if there are already three user sessions created by that login

USE master;
GO
CREATE LOGIN login_test WITH PASSWORD = '3KHJ6dhx(0xVYsdf' MUST_CHANGE,
    CHECK_EXPIRATION = ON;
GO

GRANT VIEW SERVER STATE TO login_test;
GO

CREATE TRIGGER connection_limit_trigger
ON ALL SERVER WITH EXECUTE AS 'login_test'
FOR LOGON
AS
BEGIN
IF ORIGINAL_LOGIN()= 'login_test' AND
    (SELECT COUNT(*) FROM sys.dm_exec_sessions
            WHERE is_user_process = 1 AND
                original_login_name = 'login_test') > 3
    ROLLBACK;
END;

Example EventData XML for a login
---------------------------------

<EVENT_INSTANCE>
	<EventType>event_type</EventType>
	<PostTime>post_time</PostTime>
	<SPID>spid</SPID>
	<ServerName>server_name</ServerName>
	<LoginName>login_name</LoginName>
	<LoginType>login_type</LoginType>
	<SID>sid</SID>
	<ClientHost>client_host</ClientHost>
	<IsPooled>is_pooled</IsPooled>
</EVENT_INSTANCE>

<EventType> 	Contains LOGON.
<PostTime> 		Contains the time when a session is requested to be established.
<SID> 			Contains the base 64-encoded binary stream of the security identification number (SID) for the specified login name.
<ClientHost> 	Contains the host name of the client from where the connection is made. The value is '<local_machine>' if the client and server name are the same. Otherwise, the value is the IP address of the client.
<IsPooled> 		Is 1 if the connection is reused by using connection pooling. Otherwise, the value is 0.