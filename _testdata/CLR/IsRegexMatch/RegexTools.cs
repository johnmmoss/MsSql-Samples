using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlTypes; 
using System.Text.RegularExpressions; 
using Microsoft.SqlServer.Server; 


namespace SqlServerCLRTest2
{
    public class RegexTools
    {
        [SqlFunction(IsDeterministic = true, IsPrecise = true)]
        static public SqlBoolean IsRegExMatch(SqlString input, SqlString pattern)
        {
            if (input.IsNull || pattern.IsNull)
                return SqlBoolean.Null; // Return NULL if either parameter is NULL.
 
            return (SqlBoolean)Regex.IsMatch(input.Value, pattern.Value);
        }
    }
}
