<%@ page import="java.sql.*"%>
<%
	final String sqlhost = "127.0.0.1";
	final String sqluser = "xencart";
	final String sqlpw = "xencart";
	final String sqldb = "cse135-2";
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	Statement statement = null;
	
	try {
	    // Registering Postgresql JDBC driver with the DriverManager
	    Class.forName("org.postgresql.Driver");
	
	    // Open a connection to the database using DriverManager
	    conn = DriverManager.getConnection(
	        "jdbc:postgresql://"+sqlhost+"/"+sqldb+"?" +
	        "user="+sqluser+"&password="+sqlpw);

		// Create the statement
		statement = conn.createStatement();
		
	} catch (SQLException e) {

        // Wrap the SQL exception in a runtime exception to propagate
        // it upwards
        throw new RuntimeException(e);
    }
%>