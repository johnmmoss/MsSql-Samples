
use Test

-----------------------------------
-- Creating FullText Search Index
-----------------------------------

-- 1.) First step create a fulltext catalog
CREATE FULLTEXT CATALOG DefaultTestDBCatalog AS DEFAULT

-- 2.) Create the table which will have the index on.
if OBJECT_ID('TestMessages') IS NOT NULL DROP TABLE TestMessages
SELECT message_id as id, [text] as [message]
INTO TestMessages
FROM sys.messages where language_id = 1033 AND SEVERITY = 20

-- 3.) If we are to create a fulltext index, we MUST have a unique single key column which
--	   (does not allow null values(?)):
ALTER TABLE TestMessages
	ADD CONSTRAINT PK_TestMessages
		PRIMARY KEY (id)
		
-- 4.) Now we have a Fulltext search Catalog and we know the columns to search
--	   We can create the full text search.

CREATE FULLTEXT INDEX ON TestMessages ([message])
KEY INDEX PK_TestMessages
ON DefaultTestDBCatalog
WITH STOPLIST = SYSTEM, CHANGE_TRACKING AUTO;

-- NOTES
---------
-- The 
-- There the optino CHANGE_TRACKING can have the following values:
--		AUTO				- Change are automatically propagate to the full text index
--		MANUAL				- Changs are manualy propagate using ALTER FULLTEXT INDEX ... START UPDATE POPULATION
--		OFF					- Changes are not tracked on this table HOWEVER on creation a population will be done.
--		OFF, NO POPULATION	- As above, except no initial fulltext population is done.
-- More than one column can be listed in the create clause 

-- Shown below, an example of Creating a full-text index on several table columns:
CREATE FULLTEXT INDEX ON Production.ProductReview
( 
  ReviewerName Language 1033,
  EmailAddress Language 1033,
  Comments Language 1033     
 ) 
KEY INDEX PK_ProductReview_ProductReviewID ; 
GO


---------------------------------------------
-- Getting Information about FullText Search
---------------------------------------------

-- To view the crawl status you can use the FULLTEXTCATALOGPROPERTY.
-- The PopulateStatus is to be removed in future versions of SQL Server.
-- http://msdn.microsoft.com/en-us/library/ms190370%28v=sql.90%29.aspx
SELECT 
	CASE FULLTEXTCATALOGPROPERTY('DefaultTestDBCatalog', 'PopulateStatus')
		
		WHEN 0 THEN 'Complete' -- Idle
		WHEN 1 THEN 'Full population in progress'
		WHEN 2 THEN 'Paused'
		WHEN 3 THEN 'Throttled'
		WHEN 4 THEN 'Recovering'
		WHEN 5 THEN 'Shutdown'
		WHEN 6 THEN 'Incremental population in progress'
		WHEN 7 THEN 'Building index'
		WHEN 8 THEN 'Disk is full. Paused.'
		WHEN 9 THEN 'Change tracking'

	END AS [Population Status]

--- To view all catalogs in the CURRENT database:
SELECT * FROM sys.fulltext_catalogs

-- To view all indexed columns in the CURRENT database:
SELECT * FROM sys.fulltext_index_columns

-- The index populate status of all fulltext indices in the server instance.
SELECT * FROM sys.dm_fts_index_population

-- You can use the dm_fts_parser view to the final tokenization result from a query.
-- Note this displays the actual terms and how they have been intrepted, NOT search results!
 select * from sys.dm_fts_parser('Error OR Warning', 1033, 0, 0)
 select * from sys.dm_fts_parser('FORMSOF(INFLECTIONAL, warning)', 1033, 0, 0)
  
-------------------------------------
-- FullText Search CONTAINS method
-------------------------------------

-- CONTAINS is used to search for:
--		1.) Simple Term
--		2.) Prefix Term
--		3.) Proximity Term
--		4.) Generation Term
--		5.) Weighted Term


-- 1.) Examples of Simple Search Terms
--------------------------------------

-- Find all rows where the message has a word of Error. 
-- Not case sensitive and  punctuation is ignored between phrases
SELECT * FROM TestMessages
WHERE CONTAINS([message], 'error')

-- Compare the results with a similar like statment. Note that the Message with ID 
-- of 21761 is not in  the above results. Because the word LIKE returned was "errors"
SELECT * FROM 
TestMessages 
WHERE [message] LIKE '%error%'

-- We can use an OR to search on two terms. Note this returns on extra result!
SELECT * FROM TestMessages
WHERE CONTAINS ([message], 'Warning OR Error')

-- Include phrases with quote marks:
SELECT * FROM TestMessages
WHERE CONTAINS ([message], '"Fatal error" OR Error')


-- 2.) Examples of Prefix Terms:
--------------------------------------

-- To find rows with word that is prefixed, use an *. Note that it needs to be included
-- in quote marks otherwise treated as a simple term!
SELECT * FROM TestMessages
WHERE CONTAINS ([message], '"dis*"')


-- 3.) Examples of Proximitry Terms:
--------------------------------------
-- NOTE The MSDN community content suggests that in  CONTAINS function, NEAR = AND???
-- Find all places where the word error is NEAR word reading.
SELECT * FROM TestMessages
WHERE CONTAINS ([message], 'reading NEAR error')

-- Syntatical Variation:
SELECT * FROM TestMessages
WHERE CONTAINS ([message], 'reading ~ error')

-- 4.) Examples of Generation Terms:
--------------------------------------

-- Specifies a match of words when the included simple terms include variants of the 
-- original word for which to search. Can use INFLECTIONAL or THESAURUS based.
-- Find all rows that contain a message which has a form of the word read.
SELECT * FROM TestMessages
WHERE CONTAINS ([message], 'FORMSOF (INFLECTIONAL, read) ')

-- Additional terms are generated to expand or replace the original pattern
SELECT * FROM TestMessages
WHERE CONTAINS ([message], 'FORMSOF (THESAURUS, terminating) ')

-- 5.) Examples of Weighted Terms:
--------------------------------------

-- When searching for multiple terms, you can assign each search word a weight value indicating its 
-- importance relative to the other words in the search condition. The results for this type of query return the most
-- relevant rows first, according to the relative weight you have assigned to search words
-- This type of query is only really applicable to CONTAINSTABLE ranking?? 
SELECT * FROM TestMessages
WHERE CONTAINS ([message], 'ISABOUT( open weight(.2), text weight (0.8) ) ')


-----------------------------------------
-- FullText Search CONTAINSTABLE method
-----------------------------------------

-- Contains table returns the Key with a matching rank that rows accuracy.
-- Typically would be used with the	WEIGHT option:
SELECT * FROM CONTAINSTABLE( TestMessages, [message], 'ISABOUT( open weight(.2), table weight (0.8) ) ')

-- Intended to use in a join. If we use an outer join, we can see a more complete picture.
SELECT * FROM TestMessages
	LEFT OUTER JOIN  CONTAINSTABLE( TestMessages, [message], 'ISABOUT( open weight(.2), table weight (0.8) ) ') as SearchResults
	ON SearchResults.[KEY] = TestMessages.id
