</body>
<%
//Close the ResultSet
if ( rs != null )
   rs.close();

// Close the Statement
statement.close();

// Close the Connection
conn.close();
%></html>