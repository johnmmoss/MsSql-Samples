USE master;
GO
CREATE SERVER AUDIT Test_Server_Audit
    TO FILE ( FILEPATH = 'e:\trace\' );
GO
ALTER SERVER AUDIT Test_Server_Audit
    WITH (STATE = ON);
GO
 
USE AdventureWorks;
GO
CREATE DATABASE AUDIT SPECIFICATION Test_Database_Audit
    FOR SERVER AUDIT Test_Server_Audit
    ADD (SELECT ON Person.Address BY PUBLIC)
    WITH (STATE = ON);
GO
 
SELECT *
    FROM Person.Address;
GO
 
SELECT *
    FROM fn_get_audit_file('e:\trace\*', NULL, NULL);
GO
 
USE AdventureWorks;
GO
ALTER DATABASE AUDIT SPECIFICATION Test_Database_Audit
    WITH (STATE = OFF);
GO
DROP DATABASE AUDIT SPECIFICATION Test_Database_Audit;
GO
USE master;
GO
ALTER SERVER AUDIT Test_Server_Audit
    WITH (STATE = OFF);
GO
DROP SERVER AUDIT Test_Server_Audit;
 