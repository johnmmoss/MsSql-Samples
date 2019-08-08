
/******************************************/
--	Execution DMVs
/******************************************/


SELECT * FROM sys.dm_exec_cached_plans

SELECT * FROM sys.dm_exec_query_stats

SELECT query_plan.*, query_stats.*
FROM sys.dm_exec_query_stats AS query_stats
CROSS APPLY sys.dm_exec_query_plan(query_stats.plan_handle) AS query_plan

-- Retrieve information about the top five queries by average CPU time
SELECT TOP 5 total_worker_time/execution_count AS [Avg CPU Time], Plan_handle, query_plan 
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle)
ORDER BY total_worker_time/execution_count DESC;
GO

SELECT * FROM sys.dm_exec_connections

SELECT * FROM sys.dm_exec_sessions

SELECT * FROM sys.dm_exec_requests
