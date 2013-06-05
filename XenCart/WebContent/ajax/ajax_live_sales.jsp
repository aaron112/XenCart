<%@page contentType="application/json; charset=UTF-8"%><%@page import="java.util.*"%><%@page import="org.json.simple.*"%><%@include file="../db.jsp" %><% 
String raw_lastupdate = request.getParameter("lastupdate");
int lastupdate;

try {
	lastupdate = Integer.parseInt(raw_lastupdate);
} catch (Exception e) {
	lastupdate = 0;			// Default to 0
}

Calendar cal = Calendar.getInstance();
int updated_count = 0;
try {
	rs = statement.executeQuery("SELECT id FROM sales ORDER BY id DESC LIMIT 1");
	if (rs.next())
		out.println(rs.getInt(1));
	
	// Get updated sales:
	rs = statement.executeQuery("SELECT s.id, c.id FROM sales, states AS s, products, categories AS c, users "+
			"WHERE sales.id > "+lastupdate+" AND sales.customer_id = users.id AND "+
			"products.id = sales.product_id AND c.id = products.category AND "+
			"users.state = s.id GROUP BY s.id, c.id");
	
	String where_str = "(";
	while (rs.next()) {
		if (updated_count != 0) where_str += " OR ";
		where_str += "(c.id = "+rs.getInt(2)+" AND s.id = "+rs.getInt(1)+")";
		++updated_count;
	}
	where_str += ")";
	
	if ( updated_count == 0 ) {
		out.println("Not updated.");
		
		if ( rs != null )
		   rs.close();
		statement.close();
		conn.close();
		
		return;
	}
	
	String sqlquery = "SELECT c.id, s.id, SUM(total_cost) "+
			"FROM sales, states AS s, products, users, categories AS c "+
			"WHERE sales.day = "+cal.get(Calendar.DAY_OF_MONTH)+" AND sales.month = "+(cal.get(Calendar.MONTH)+1)+" AND sales.product_id = products.id AND "+
			"s.id = users.state AND products.category = c.id AND users.id = sales.customer_id "+
			" AND "+where_str+
			" GROUP BY s.id, c.id ORDER BY c.name, s.id";
	
	rs = statement.executeQuery(sqlquery);
} catch (SQLException e) {
	throw new RuntimeException(e);
}

while (rs.next()) {
	JSONObject jobj = new JSONObject();
	jobj.put("c", rs.getString(1)+"."+rs.getString(2));
	jobj.put("t", rs.getString(3));
	
	out.println(jobj.toJSONString());
}

// Close the ResultSet
if ( rs != null )
   rs.close();

// Close the Statement
statement.close();

// Close the Connection
conn.close();
%>