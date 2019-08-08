
-------------------
--	CAST/CONVERT
-------------------

SELECT CAST(2000 AS VARCHAR(20))			-- 2000
SELECT CAST(SYSDATETIME() AS VARCHAR(10))	-- 2011-01-09

SELECT CONVERT(VARCHAR(30), SYSDATETIME())		-- 2011-01-09 13:59:14.5430000
SELECT CONVERT(VARCHAR(30), SYSDATETIME(), 1)	-- 01/09/2011
SELECT CONVERT(VARCHAR(30), SYSDATETIME(), 101)	-- 01/09/2011

-------------------
--	SUBSTRING
-------------------

SELECT SUBSTRING ( 'Hello World', 0, 6 )	-- Returns 'Hello'
SELECT SUBSTRING ( 'Hello World', 1, 6 )	-- Returns 'Hello'
SELECT SUBSTRING ( 'Hello World', 7, 5 )	-- Returns 'World'
SELECT SUBSTRING ( 'Hello World', -1, 5 )	-- Starts at first character dispite Negative
SELECT SUBSTRING ( 'Hello World', 12, 5 )	-- Start is greater than value length, returns ''
SELECT SUBSTRING ( 'Hello World', 7, -5 )	-- Negtive length causes an error

-- RIGHT: Returns the right part of a character string with the specified number of characters
SELECT RIGHT('Hello World', 6)		-- Returns 'World'
SELECT RIGHT('Hello World', -6)		-- Negative value causes an error.

-- LEFT: Returns the left part of a character string with the specified number of characters
SELECT LEFT('Hello World', 6)		-- Returns 'Hello'
SELECT LEFT('Hello World', -6)		-- Negative value causes an error.

---------------------
--	MATCH/REPLACE
---------------------

SELECT REPLACE('abcdefghiCDE','cde','XXX')	-- Returns 'abXXXfghiXXX', CAPS is ignored
-- Forces the use of a collation. Returns 'Das ist ein desk'
-- Note, keyword COLLATE is inside function.
-- Note, params can be string or bin data.
SELECT REPLACE('Das ist ein Test'  
	COLLATE Latin1_General_BIN, 'Test', 'desk')	

SELECT PATINDEX('tell', 'This is my truth tell me YOURS')	-- 0
SELECT PATINDEX('%tell%', 'This is my truth tell me YOURS') -- 18
SELECT PATINDEX ( '%ein%', 'Das ist ein Test'  
	COLLATE Latin1_General_BIN) ;							-- 9

SELECT CHARINDEX('tell','This is my truth tell me YOURS')		-- 18
-- Optional third charcter dictates the start position of search!
SELECT CHARINDEX('tell','This is my truth tell me YOURS', 19)	-- 0

------------------------
--	SOUNDEX/DIFFERENCE
------------------------

-- SOUNDEX: converts an alphanumeric string to a four-character code to find similar-sounding words or names. The first character of the code is the first character of character_expression and the second through fourth characters of the code are numbers. Vowels in character_expression are ignored unless they are the first letter of the string. String functions can be nested.
SELECT SOUNDEX ('Smith'), SOUNDEX ('Smythe')	-- S530, S530
SELECT SOUNDEX('Anothers'), SOUNDEX('Brothers')	-- A536	B636

-- The DIFFERENCE function compares the difference of the SOUNDEX pattern results. 
-- The integer returned is the number of characters in the SOUNDEX values that are the same. The return value ranges from 0 through 4: 0 indicates weak or no similarity, and 4 indicates strong similarity or the same values. 
-- The following example shows two strings that differ only in vowels. The difference returned is 4, the lowest possible difference.
SELECT DIFFERENCE('Smithers', 'Smythers')		-- 4
-- In the following example, the strings differ in consonants; therefore, the difference returned is 2, the greater difference.
SELECT DIFFERENCE('Anothers', 'Brothers')		-- 2

SELECT DATALENGTH('Hello World')	-- 11,  Chars
SELECT DATALENGTH(N'Hello World')	-- 22, UCS Code

---------------------
--	OTHER FUNCTIONS
---------------------

SELECT UPPER('Hello World') -- Returns 'HELLO WORLD'
SELECT LOWER('Hello WORLD') -- Returns 'hello world'

SELECT NCHAR(97)	-- a, where 97 is unicode number!
SELECT CHAR(97)		-- a

SELECT ASCII('a')	-- 97
SELECT REPLICATE('Hello ', 3)		-- Hello Hello Hello 
SELECT QUOTENAME(STR(23))			-- [        23]