<%@page import="java.util.*, org.json.simple.JSONObject" %>


<%
	// Need to create a todays_sales table or similar on confirm page or somewhere -> last_mod_time is a unix timestamp
	// Fetch only rows that were modified after the last modification? the last modification will be sent by a parameter ?=UNIXTIMESTAMP from update..
	try {
		rs = statement.executeQuery(" SELECT state, category, total, date_purchased, last_mod_time FROM todays_sales WHERE date_purchased now()::date - 365 AND ");
		
	}	} catch (SQLException e) {
	    throw new RuntimeException(e);
	}
	
	//JSON will send which cells to change -> rows that have last_mod_time greater than the .. "last mod time" will have a corresponding state and category which correspond to a state_category td id in the live.jsp
	JSONObject sales_today = new JSONObject();
	
	while (rs.next()) {
		sales_today.put("success", )
		sales_today.put("state", rs.getString("state"));
		sales_today.put("category", rs.getString("category"));
		sales_today.put("total", rs.getString("total"));
		sales_today.put("modified", rs.getString("last_mod_time"))
	}
	%>