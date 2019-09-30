
-- CREATE LOGIN: https://docs.microsoft.com/en-us/sql/t-sql/statements/create-login-transact-sql?view=sql-server-2017
-- CREATE USER: https://docs.microsoft.com/en-us/sql/t-sql/statements/create-user-transact-sql?view=sql-server-2017

-- sp_addsrvrolemember: https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-addsrvrolemember-transact-sql?view=sql-server-2017
-- sp_addrolemember: https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-addrolemember-transact-sql?view=sql-server-2017

-- ALTER ROLE: https://docs.microsoft.com/en-us/sql/t-sql/statements/alter-role-transact-sql?view=sql-server-2017
-- ALTER SERVER ROLE: https://docs.microsoft.com/en-us/sql/t-sql/statements/alter-server-role-transact-sql?view=sql-server-2017

-- Show all current db users
SELECT * FROM sys.sysusers 

-- Show server logins
SELECT * FROM master.sys.server_principals

IF NOT EXISTS(SELECT * FROM sys.sysusers where name = 'RecurlyListenerUser' ) 
	AND EXISTS (SELECT 1 FROM master.sys.server_principals WHERE NAME = 'RecurlyListenerUser' )   
BEGIN        
	CREATE LOGIN [FOUser] WITH PASSWORD = 'Password1!', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
	--EXEC sp_addsrvrolemember 'FOUser', 'sysadmin'
	ALTER SERVER ROLE  sysadmin  ADD MEMBER FOUser

	CREATE USER [FOUser] FROM LOGIN [FOUser]  
	--EXEC sp_addrolemember 'db_owner', 'FOUser'
	ALTER ROLE db_owner ADD MEMBER FOUser;  
END  

-- Add execute to an SP
GRANT EXECUTE ON get_product_costs TO [RecurlyListenerUser] 
GRANT EXECUTE ON [dbo].[BookingInvoicePay] TO [RecurlyListenerUser]

-- Add select to tables
GRANT SELECT ON dbo.contacts TO RecurlyListenerUser;
GRANT SELECT ON dbo.products TO RecurlyListenerUser;


