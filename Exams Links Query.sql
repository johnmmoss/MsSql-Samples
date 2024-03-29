
USE Exams
GO

SELECT * FROM Link
SELECT * FROM Topic
SELECT * FROM TopicLink
GO

EXEC uspShowTopicLinks
GO

EXEC uspAddLink 'SQL Server Reporting Services (SSRS', '', ''
GO

/**************************************************/
-- Stored Procedures
/**************************************************/

--------------------------------------------------
-- uspShowTopicLinks
-- Displays the current links
--------------------------------------------------
ALTER PROCEDURE uspShowTopicLinks
AS
WITH Topics
AS
(
	SELECT t2.ID, t1.Name, t2.Name AS Topic
	FROM Topic t1 JOIN Topic t2 ON t1.ID = t2.ParentID
	--where t1.ParentID IS not null
)
SELECT t.Name, t.Topic, Title, Href  FROM Topics t 
	LEFT OUTER JOIN TopicLink tl ON t.ID = tl.TopicID
	LEFT OUTER JOIN Link l on l.ID = tl.LinkID
GO

--------------------------------------------------
-- uspAddLink
-- Add a link with its title to an existing Topic
--------------------------------------------------
CREATE PROCEDURE uspAddLink
	@TopicName varchar(200),
	@Title varchar(200),
	@Href Varchar(200)
AS
BEGIN TRY
	-- Check that the params have values
	IF (@TopicName = NULL OR @TopicName = '')
		RAISERROR ('Please provide a valid TopicName', 16, 1)
	IF (@Title = NULL OR @Title = '')
		RAISERROR ('Please provide a valid Title', 16, 1)
	IF (@Href = NULL OR @Href = '')
		RAISERROR ('Please provide a valid Href', 16, 1)

	-- See if the TopicName actually exists
	DECLARE @TopicID INT;
	SELECT @TopicID = ID FROM Topic where Name = @TopicName
	IF (@TopicID < 1)
		RAISERROR ('Topic does not exist', 16, 1)

	--	Insert the Link
	INSERT INTO Link (Title, Href) 
	VALUES ( @Title, @Href)

	-- Get the new link ID out and insert into the TopicLink table
	DECLARE @LinkID INT = SCOPE_IDENTITY();
	INSERT INTO TopicLink (TopicID, LinkID)
	VALUES (@TopicID, @LinkID)

	-- Print success message:
	PRINT 'Link "' +@Title + '" added to topic "' + @TopicName + '"';

END TRY
BEGIN CATCH
	PRINT 'Statment terminated, please fix error:';
	PRINT ERROR_MESSAGE();
END CATCH
GO



