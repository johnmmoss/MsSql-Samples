------------------------------
-- Server Trigger Example
------------------------------

-- Frist we drop the trigger if it already exists:
IF EXISTS (SELECT * FROM sys.server_triggers 
	WHERE name = 'ddl_trig_database')
DROP TRIGGER ddl_trig_database
ON ALL SERVER;
GO

-- Now we create a trigger at server scope for the database:
CREATE TRIGGER ddl_trig_database 
ON ALL SERVER 
FOR CREATE_DATABASE 
AS 
    PRINT 'Database Created.'
    SELECT EVENTDATA()
GO

-- Now we create the database and a message is printed 
-- with the event data xml displayed
CREATE DATABASE Test1

-- Example XML data:

	<EVENT_INSTANCE>
	  <EventType>CREATE_DATABASE</EventType>
	  <PostTime>2011-12-01T18:57:43.960</PostTime>
	  <SPID>54</SPID>
	  <ServerName>XERXES\DEVELOPER2008</ServerName>
	  <LoginName>XERXES\John Moss</LoginName>
	  <DatabaseName>Test1</DatabaseName>
	  <TSQLCommand>
		<SetOptions ANSI_NULLS="ON" ANSI_NULL_DEFAULT="ON" ANSI_PADDING="ON" QUOTED_IDENTIFIER="ON" ENCRYPTED="FALSE" />
		<CommandText>CREATE DATABASE Test1
	</CommandText>
	  </TSQLCommand>
	</EVENT_INSTANCE>

select * FROM Test.sys.triggers
-- Create a database trigger in the test db:
USE Test;
GO

------------------------------
-- Database Trigger Example
------------------------------

-- First we change the context to the db we are going to use:
USE Test;
GO 

-- This trigger rolls back any attempts to drop or alter a table
CREATE TRIGGER safety 
ON DATABASE 
FOR DROP_TABLE, ALTER_TABLE 
AS 
   PRINT 'You must disable Trigger "safety" to drop or alter tables!' 
   SELECT eventdata();
   ROLLBACK;



-- So the table does not get dropped when we try to drop it...  
DROP TABLE TestTable

-- Will result in the error and no action, as well as the following xml:

	<EVENT_INSTANCE>
	  <EventType>DROP_TABLE</EventType>
	  <PostTime>2011-12-01T19:06:17.400</PostTime>
	  <SPID>54</SPID>
	  <ServerName>XERXES\DEVELOPER2008</ServerName>
	  <LoginName>XERXES\John Moss</LoginName>
	  <UserName>dbo</UserName>
	  <DatabaseName>Test</DatabaseName>
	  <SchemaName>dbo</SchemaName>
	  <ObjectName>TestPhotos</ObjectName>
	  <ObjectType>TABLE</ObjectType>
	  <TSQLCommand>
		<SetOptions ANSI_NULLS="ON" ANSI_NULL_DEFAULT="ON" ANSI_PADDING="ON" QUOTED_IDENTIFIER="ON" ENCRYPTED="FALSE" />
		<CommandText>DROP TABLE TestPhotos</CommandText>
	  </TSQLCommand>
	</EVENT_INSTANCE>


-- We can view the triggers in the Test db using:
SELECT * FROM Test.sys.triggers

