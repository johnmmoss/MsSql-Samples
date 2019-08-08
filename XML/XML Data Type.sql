use Test

IF OBJECT_ID('XmlTable') IS NOT NULL DROP TABLE XmlTable

CREATE TABLE XmlTable
(
	TableID int,
	Source XML
)

INSERT INTO XmlTable (TableID, Source) VALUES
( 1, '<Product ID="1" Name="My Product"></Product>' ),
( 2, '<Product ID="2" Name="Product 101"></Product>' ),
( 3, '<Product />' )

Select * from XmlTable

SELECT 
	Source.value('(/Product/@ID)[1]', 'varchar(200)') as ProductID,
	Source.value('(/Product/@Name)[1]', 'varchar(200)') as ProductName
FROM XmlTable