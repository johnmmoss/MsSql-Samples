
-- CREATE TABLE (Transact-SQL)
-- http://msdn.microsoft.com/en-us/library/ms174979.aspx

/*
 * Create a database
*/

CREATE DATABASE Blog
GO
USE Blog
GO

/*
 * Add some tables
*/

CREATE TABLE Category
(
	CategoryID INT IDENTITY not null PRIMARY KEY,
	Title NVARCHAR(50) not null,
	[Description] NVARCHAR(500)
)
GO

CREATE TABLE Post
(
	PostID INT IDENTITY NOT NULL PRIMARY KEY,
	CategoryID INT NOT NULL REFERENCES Category (CategoryID),	
	Title NVARCHAR(50),
	[Text] NVARCHAR(500)
)
GO

CREATE TABLE Comment
(
	CommentID INT IDENTITY NOT NULL PRIMARY KEY,
	ParentID INT REFERENCES Comment (CommentID),
	PostID INT NOT NULL,
	Name VARCHAR(50) NOT NULL,
	EmailAddress VARCHAR(200) NOT NULL,
	[Text] VARCHAR(500) NOT NULL			
)
GO

/*
 * Populate tables with some data
*/

INSERT INTO Category (Title, [Description])	
VALUES 
('Sports News', 'Updates and latest news from football to curling'),
('Gardening', 'Learn how to tend your garden'),
('Begginners cookery', 'Getting started with cookery, its not as hard as you think.')
GO

INSERT INTO Post (CategoryID, Title, [Text])
VALUES
(1, 'Spurs sign Ronaldo', 'Spurs made an excellent signing today with Real Madrids star striker moving to the lane'),
(1, 'Arsenal manager bows out', 'Arsene Wenger finally throws in the towel after Arsenals appaling run of 23 games without a win')
GO

CREATE PROCEDURE GetBlog AS
	SELECT * FROM Post
GO


select * from Category
select * from Post