
-- TWO TABLE SELECT USING AUTO
select 
	[Table].TABLE_NAME,
	[Table].TABLE_TYPE,
	[Column].COLUMN_NAME,
	[Column].IS_NULLABLE,
	[Column].COLUMN_DEFAULT,
	[Column].CHARACTER_MAXIMUM_LENGTH,
	[Column].NUMERIC_PRECISION,
	[Column].NUMERIC_PRECISION_RADIX,
	[Column].NUMERIC_SCALE,
	[Column].DATETIME_PRECISION,
	[Column].DATA_TYPE
from 
	INFORMATION_SCHEMA.TABLES as [Table] 
JOIN 
	INFORMATION_SCHEMA.COLUMNS as [Column] 
ON
	[Table].TABLE_NAME = [Column].TABLE_NAME
order by 
	[Table].TABLE_NAME
for xml auto, root('Tables')

-- THREE TABLE SELECT USING PATH
select 	
	[Table].TABLE_NAME,
	[Table].TABLE_TYPE ,
	(
		select 
			[Constraint].CONSTRAINT_NAME,
			[Constraint].CONSTRAINT_TYPE,
			[Constraint].IS_DEFERRABLE,
			[Constraint].INITIALLY_DEFERRED
		FROM 
			INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS [Constraint]
		WHERE [Constraint].TABLE_NAME = [Table].TABLE_NAME
		for xml PATH('Constraints'), TYPE
	) 
	As [ConstraintData],
	(
		select 
			[Column].COLUMN_NAME,
			[Column].IS_NULLABLE,
			[Column].COLUMN_DEFAULT,
			[Column].CHARACTER_MAXIMUM_LENGTH,
			[Column].NUMERIC_PRECISION,
			[Column].NUMERIC_PRECISION_RADIX,
			[Column].NUMERIC_SCALE,
			[Column].DATETIME_PRECISION,
			[Column].DATA_TYPE
		FROM 
			INFORMATION_SCHEMA.COLUMNS AS [Column]
		WHERE [Column].TABLE_NAME = [Table].TABLE_NAME
		for xml PATH('Columns'), TYPE
	) As [ColumnData]
from INFORMATION_SCHEMA.TABLES AS [Table]
for xml PATH('Tables')