<% String page_title="Dashbaord"; %>
<%@include file="header.jsp" %>
<%@page import="java.util.*" %>
<h2>Sales Analytics</h2>

<%-- Parse Input Parameters --%>
<%
	final int MAX = 10; 
	String action = (String) request.getParameter("a");
	
	int row_dim;
	String raw_row_dim = (String) request.getParameter("row_dim");
	if ( raw_row_dim != null && raw_row_dim.equals("1") )
		row_dim = 1;
	else
		row_dim = 0;
	
	
	String age = (String) request.getParameter("age");
	if ( age == null || age.equals("") )
		age = "-1";
	int age_parsed;
	try {
		age_parsed = Integer.parseInt(age);
	} catch (Exception e) {
		age_parsed = -1;
	}
	
	String state = (String) request.getParameter("state");
	if ( state == null || state.equals("") )
		state = "-1";

	// Force All states if row_dim = 1
	if (row_dim == 1) {
		state = "-1";
	}
	
	String catid = (String) request.getParameter("catid");
	if ( catid == null || catid.equals("") )
		catid = "-1";
	
	String quarter = (String) request.getParameter("quarter");
	if ( quarter == null || quarter.equals("") )
		quarter = "-1";
	
	String custpg = (String) request.getParameter("cpg");
	String prodpg = (String) request.getParameter("ppg");
	
	Integer[] productRank = new Integer[10];
	
	String query_string = "?a=show&row_dim="+row_dim+"&age="+age+"&state="+state+"&catid="+catid+"&quarter="+quarter;
	
	if(action != null && action.equals("generate")) {
		// Update then refresh to show state.
		out.println("Loading...");
		out.flush();
		response.flushBuffer();
		
		int qtr_start = -1;
		if (quarter.equals("0")) qtr_start = 1;
		else if (quarter.equals("1")) qtr_start = 4;
		else if (quarter.equals("2")) qtr_start = 7;
		else if (quarter.equals("3")) qtr_start = 10;
		
		
		String from_where_statement = "FROM sales, users, products WHERE sales.customer_id = users.id AND sales.product_id = products.id " +
		(age_parsed==-1?"":"AND users.age BETWEEN "+age_parsed+" AND "+(age_parsed+9)+" ") +
		(state.equals("-1")?"":"AND users.state = "+state+" ") + 
		(catid.equals("-1")?"":"AND products.category = "+catid+" ") + 
		(qtr_start==-1?"":"AND sales.month BETWEEN "+qtr_start+" AND "+(qtr_start+2)+" ")
		;
		try {
			statement.executeUpdate("DROP TABLE IF EXISTS sales_total_by_user, sales_total_by_state, sales_total_by_product;");
			statement.executeUpdate("SELECT sales.product_id, SUM(sales.total_cost) AS product_total INTO sales_total_by_product "+from_where_statement+" GROUP BY sales.product_id ORDER BY product_total DESC; ");
			if (row_dim == 0) {
				statement.executeUpdate("SELECT sales.customer_id, SUM(sales.total_cost) AS customer_total INTO sales_total_by_user "+from_where_statement+" GROUP BY sales.customer_id ORDER BY customer_total DESC;");
			} else {
				statement.executeUpdate("SELECT users.state, SUM(sales.total_cost) AS state_total INTO sales_total_by_state "+from_where_statement+" GROUP BY users.state ORDER BY state_total DESC;");
			}
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
		
		//response.sendRedirect("dashboard.jsp"+query_string);
		%><meta http-equiv="refresh" content="0; URL=dashboard.jsp<%=query_string %>"><%
	} else {
%>

<%-- Form for setting report Criteria --%>
<form method="GET">
<fieldset><legend> Sales Analytics </legend>
<input type="hidden" name="a" value="generate" />
<b>Row Dimension: </b>
	<select name="row_dim">
		<option value="0" <%=row_dim==0?"selected":"" %>>Customers</option>
		<option value="1" <%=row_dim==1?"selected":"" %>>States</option>
	</select><br>
<b>Filter by Age: </b>
	<select name="age">
		<option value="-1" <%=age.equals("-1")?"selected":"" %>></option>
		<option value="0" <%=age.equals("0")?"selected":"" %>>0-9</option>
		<option value="10" <%=age.equals("10")?"selected":"" %>>10-19</option>
		<option value="20" <%=age.equals("20")?"selected":"" %>>20-29</option>
		<option value="30" <%=age.equals("30")?"selected":"" %>>30-39</option>
		<option value="40" <%=age.equals("40")?"selected":"" %>>40-49</option>
		<option value="50" <%=age.equals("50")?"selected":"" %>>50-59</option>
		<option value="60" <%=age.equals("60")?"selected":"" %>>60-69</option>
		<option value="70" <%=age.equals("70")?"selected":"" %>>70-79</option>
		<option value="80" <%=age.equals("80")?"selected":"" %>>80-89</option>
		<option value="90" <%=age.equals("90")?"selected":"" %>>90-99</option>
	</select><br>
<b>Filter by State: </b>
	<select name="state">
	<option value="-1">All States</option>
		<%
		try {
			rs = statement.executeQuery("SELECT id, name FROM states ORDER BY id ASC");
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
		%>
		<% while (rs.next()) { %>
    	<option value="<%=rs.getInt("id")%>" <%=state.equals(rs.getInt("id"))?"selected":"" %>><%=rs.getString("name")%></option>
		<% } %>
	</select><br>
<b>Product Category: </b>
	<select name = "catid">
		<option value="-1">All Categories</option>
		<%
		try {
			rs = statement.executeQuery("SELECT name,id FROM categories ORDER BY id ASC");
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
		%>
		<% while (rs.next()) { %>
    	<option value="<%=rs.getInt("id")%>" <%=catid.equals(rs.getInt("id"))?"selected":"" %>><%=rs.getString("name")%></option>
		<% } %>
 	</select><br>
<b>Quarter: </b>
	<select name="quarter">
		<option value="-1" <%=quarter.equals("-1")?"selected":"" %>>All</option>
		<option value="0" <%=quarter.equals("0")?"selected":"" %>>Winter (1-3)</option>
		<option value="1" <%=quarter.equals("1")?"selected":"" %>>Spring (4-6)</option>
		<option value="2" <%=quarter.equals("2")?"selected":"" %>>Summer (7-9)</option>
		<option value="3" <%=quarter.equals("3")?"selected":"" %>>Fall (10-12)</option>
	</select><br>
<input type="submit" value="Run/Update Query">
</fieldset>
</form>
<br><hr><br>

<%-- 10 * 10 Table showing the data --%>
<%	if(action != null && action.equals("show"))
	{
		int cpgoffset = 0, cpg = 0, ppgoffset = 0, ppg = 0;
		try
    	{
    		cpgoffset = Integer.parseInt(custpg) * MAX;
    		cpg = Integer.parseInt(custpg);

   			if(cpg < 0)
   				throw new Exception();
   			
    	}
    	catch(Exception e)
    	{
    		cpgoffset = 0;
    		cpg = 0;
    	}
		
		try
    	{
    		ppgoffset = Integer.parseInt(prodpg) * MAX;
    		ppg = Integer.parseInt(prodpg);
   			if(ppg < 0)
   				throw new Exception();
   			
    	}
    	catch(Exception e)
    	{
    		ppgoffset = 0;
    		ppg = 0;
    	}
		
		//if(row!=null && row.equals("0"))
		/*
		{
			try {
				String sqlquery = "SELECT customer_id, SUM(total_cost) AS cost FROM precompute GROUP BY customer_id ORDER BY cost DESC LIMIT 10 OFFSET " +cpgoffset;
		    	rs = statement.executeQuery(sqlquery);
		    } catch (SQLException e) {
	 	    	throw new RuntimeException(e);
	 		}
			int i = 0;
			while(rs.next())
			{
				customerRank[i] = rs.getInt("customer_id");
				totalSales.put(rs.getInt("customer_id"), rs.getDouble("cost"));
				i++;
			}
		}
		*/
		
		
		
		
%>
<table border = "1" width = "99%">
	<tr>
		<th></th>
		<th><input type="button" value="^ 10" onClick="javascript:location.href='<%=query_string %>&cpg=<%=Integer.toString(cpg-1)%>&ppg=<%=ppg%>'">
   	<input type="button" value="v 10" onClick="javascript:location.href='<%=query_string %>&cpg=<%=Integer.toString(cpg+1)%>&ppg=<%=ppg%>'"></th>
		<th><input type="button" value="< 10" onClick="javascript:location.href='<%=query_string %>&cpg=<%=cpg%>&ppg=<%=Integer.toString(ppg-1)%>'">
   	<input type="button" value="> 10" onClick="javascript:location.href='<%=query_string %>&cpg=<%=cpg%>&ppg=<%=Integer.toString(ppg+1)%>'"></th>
		<th colspan=2>Product <%=ppgoffset+1%></th>
		<th colspan=2>Product <%=ppgoffset+2%></th>
		<th colspan=2>Product <%=ppgoffset+3%></th>
		<th colspan=2>Product <%=ppgoffset+4%></th>
		<th colspan=2>Product <%=ppgoffset+5%></th>
		<th colspan=2>Product <%=ppgoffset+6%></th>
		<th colspan=2>Product <%=ppgoffset+7%></th>
		<th colspan=2>Product <%=ppgoffset+8%></th>
		<th colspan=2>Product <%=ppgoffset+9%></th>
		<th colspan=2>Product <%=ppgoffset+10%></th>
	</tr>
	<%
	// Get Top 10 Products
	try {
		String sqlquery = "SELECT id, name FROM sales_total_by_product, products "+
				"WHERE sales_total_by_product.product_id = products.id " +
				//(catid.equals("-1")?"":"AND products.category = "+catid+" ") + 
				"ORDER BY sales_total_by_product.product_total DESC LIMIT 10 OFFSET "+ppgoffset;
    	rs = statement.executeQuery(sqlquery);
	} catch (SQLException e) {
	    throw new RuntimeException(e);
	}
	%>
	<tr>
		<th>Rank</th>
		<th>Customer / State</th>
		<th>Total Amount</th>
		<% int i_p = 0;
		while(rs.next() && i_p < 10) { %>
		<th colspan=2><%=rs.getString("name") %></th>
		<% 
			productRank[i_p] = rs.getInt("id");
			++i_p;
		} %>
	</tr>
	<%
	// Get Top 10 Customers / States
	try {
		String sqlquery;
		if (row_dim == 0) {
			sqlquery = "SELECT id, name, customer_total," +
					"(SELECT SUM(total_cost) FROM sales WHERE customer_id = users.id AND product_id = "+productRank[0]+" GROUP BY customer_id LIMIT 1) AS prod1,"+
					"(SELECT SUM(quantity) FROM sales WHERE customer_id = users.id AND product_id = "+productRank[0]+" GROUP BY customer_id LIMIT 1) AS prodq1,"+
					"(SELECT SUM(total_cost) FROM sales WHERE customer_id = users.id AND product_id = "+productRank[1]+" GROUP BY customer_id LIMIT 1) AS prod2,"+
					"(SELECT SUM(quantity) FROM sales WHERE customer_id = users.id AND product_id = "+productRank[1]+" GROUP BY customer_id LIMIT 1) AS prodq2,"+
					"(SELECT SUM(total_cost) FROM sales WHERE customer_id = users.id AND product_id = "+productRank[2]+" GROUP BY customer_id LIMIT 1) AS prod3,"+
					"(SELECT SUM(quantity) FROM sales WHERE customer_id = users.id AND product_id = "+productRank[2]+" GROUP BY customer_id LIMIT 1) AS prodq3,"+
					"(SELECT SUM(total_cost) FROM sales WHERE customer_id = users.id AND product_id = "+productRank[3]+" GROUP BY customer_id LIMIT 1) AS prod4,"+
					"(SELECT SUM(quantity) FROM sales WHERE customer_id = users.id AND product_id = "+productRank[3]+" GROUP BY customer_id LIMIT 1) AS prodq4,"+
					"(SELECT SUM(total_cost) FROM sales WHERE customer_id = users.id AND product_id = "+productRank[4]+" GROUP BY customer_id LIMIT 1) AS prod5,"+
					"(SELECT SUM(quantity) FROM sales WHERE customer_id = users.id AND product_id = "+productRank[4]+" GROUP BY customer_id LIMIT 1) AS prodq5,"+
					"(SELECT SUM(total_cost) FROM sales WHERE customer_id = users.id AND product_id = "+productRank[5]+" GROUP BY customer_id LIMIT 1) AS prod6,"+
					"(SELECT SUM(quantity) FROM sales WHERE customer_id = users.id AND product_id = "+productRank[5]+" GROUP BY customer_id LIMIT 1) AS prodq6,"+
					"(SELECT SUM(total_cost) FROM sales WHERE customer_id = users.id AND product_id = "+productRank[6]+" GROUP BY customer_id LIMIT 1) AS prod7,"+
					"(SELECT SUM(quantity) FROM sales WHERE customer_id = users.id AND product_id = "+productRank[6]+" GROUP BY customer_id LIMIT 1) AS prodq7,"+
					"(SELECT SUM(total_cost) FROM sales WHERE customer_id = users.id AND product_id = "+productRank[7]+" GROUP BY customer_id LIMIT 1) AS prod8,"+
					"(SELECT SUM(quantity) FROM sales WHERE customer_id = users.id AND product_id = "+productRank[7]+" GROUP BY customer_id LIMIT 1) AS prodq8,"+
					"(SELECT SUM(total_cost) FROM sales WHERE customer_id = users.id AND product_id = "+productRank[8]+" GROUP BY customer_id LIMIT 1) AS prod9,"+
					"(SELECT SUM(quantity) FROM sales WHERE customer_id = users.id AND product_id = "+productRank[8]+" GROUP BY customer_id LIMIT 1) AS prodq9,"+
					"(SELECT SUM(total_cost) FROM sales WHERE customer_id = users.id AND product_id = "+productRank[9]+" GROUP BY customer_id LIMIT 1) AS prod10,"+
					"(SELECT SUM(quantity) FROM sales WHERE customer_id = users.id AND product_id = "+productRank[9]+" GROUP BY customer_id LIMIT 1) AS prodq10"+
					" FROM sales_total_by_user, users WHERE sales_total_by_user.customer_id = users.id "+
					"ORDER BY customer_total DESC LIMIT 10 OFFSET "+cpgoffset;
		} else {
			sqlquery = "SELECT states.id, states.name, state_total, "+
					"(SELECT SUM(total_cost) FROM sales, users WHERE sales.customer_id = users.id AND users.state = states.id AND product_id = "+productRank[0]+" GROUP BY state LIMIT 1) AS prod1,"+
					"(SELECT SUM(quantity) FROM sales, users WHERE sales.customer_id = users.id AND users.state = states.id AND product_id = "+productRank[0]+" GROUP BY state LIMIT 1) AS prodq1,"+
					"(SELECT SUM(total_cost) FROM sales, users WHERE sales.customer_id = users.id AND users.state = states.id AND product_id = "+productRank[1]+" GROUP BY state LIMIT 1) AS prod2,"+
					"(SELECT SUM(quantity) FROM sales, users WHERE sales.customer_id = users.id AND users.state = states.id AND product_id = "+productRank[1]+" GROUP BY state LIMIT 1) AS prodq2,"+
					"(SELECT SUM(total_cost) FROM sales, users WHERE sales.customer_id = users.id AND users.state = states.id AND product_id = "+productRank[2]+" GROUP BY state LIMIT 1) AS prod3,"+
					"(SELECT SUM(quantity) FROM sales, users WHERE sales.customer_id = users.id AND users.state = states.id AND product_id = "+productRank[2]+" GROUP BY state LIMIT 1) AS prodq3,"+
					"(SELECT SUM(total_cost) FROM sales, users WHERE sales.customer_id = users.id AND users.state = states.id AND product_id = "+productRank[3]+" GROUP BY state LIMIT 1) AS prod4,"+
					"(SELECT SUM(quantity) FROM sales, users WHERE sales.customer_id = users.id AND users.state = states.id AND product_id = "+productRank[3]+" GROUP BY state LIMIT 1) AS prodq4,"+
					"(SELECT SUM(total_cost) FROM sales, users WHERE sales.customer_id = users.id AND users.state = states.id AND product_id = "+productRank[4]+" GROUP BY state LIMIT 1) AS prod5,"+
					"(SELECT SUM(quantity) FROM sales, users WHERE sales.customer_id = users.id AND users.state = states.id AND product_id = "+productRank[4]+" GROUP BY state LIMIT 1) AS prodq5,"+
					"(SELECT SUM(total_cost) FROM sales, users WHERE sales.customer_id = users.id AND users.state = states.id AND product_id = "+productRank[5]+" GROUP BY state LIMIT 1) AS prod6,"+
					"(SELECT SUM(quantity) FROM sales, users WHERE sales.customer_id = users.id AND users.state = states.id AND product_id = "+productRank[5]+" GROUP BY state LIMIT 1) AS prodq6,"+
					"(SELECT SUM(total_cost) FROM sales, users WHERE sales.customer_id = users.id AND users.state = states.id AND product_id = "+productRank[6]+" GROUP BY state LIMIT 1) AS prod7,"+
					"(SELECT SUM(quantity) FROM sales, users WHERE sales.customer_id = users.id AND users.state = states.id AND product_id = "+productRank[6]+" GROUP BY state LIMIT 1) AS prodq7,"+
					"(SELECT SUM(total_cost) FROM sales, users WHERE sales.customer_id = users.id AND users.state = states.id AND product_id = "+productRank[7]+" GROUP BY state LIMIT 1) AS prod8,"+
					"(SELECT SUM(quantity) FROM sales, users WHERE sales.customer_id = users.id AND users.state = states.id AND product_id = "+productRank[7]+" GROUP BY state LIMIT 1) AS prodq8,"+
					"(SELECT SUM(total_cost) FROM sales, users WHERE sales.customer_id = users.id AND users.state = states.id AND product_id = "+productRank[8]+" GROUP BY state LIMIT 1) AS prod9,"+
					"(SELECT SUM(quantity) FROM sales, users WHERE sales.customer_id = users.id AND users.state = states.id AND product_id = "+productRank[8]+" GROUP BY state LIMIT 1) AS prodq9,"+
					"(SELECT SUM(total_cost) FROM sales, users WHERE sales.customer_id = users.id AND users.state = states.id AND product_id = "+productRank[9]+" GROUP BY state LIMIT 1) AS prod10,"+
					"(SELECT SUM(quantity) FROM sales, users WHERE sales.customer_id = users.id AND users.state = states.id AND product_id = "+productRank[9]+" GROUP BY state LIMIT 1) AS prodq10"+
					" FROM sales_total_by_state, states WHERE sales_total_by_state.state = states.id " +
					"ORDER BY state_total DESC LIMIT 10 OFFSET "+cpgoffset;
		}
    	rs = statement.executeQuery(sqlquery);
	} catch (SQLException e) {
	    throw new RuntimeException(e);
	}
	
	int rowCount = 0;
	while(rowCount < 10 && rs.next()){
	%>
	<tr>
		<th><%= cpgoffset + rowCount + 1 %></th>
		<th><%=rs.getString(2)%></th>
		<th>$<%=rs.getString(3)%></th>
		<% for (int i=4; i < 24; ++i) { %>
		<td>$<%=(rs.getString(i)==null)?"":rs.getString(i) %></td><% ++i; %><td><%=(rs.getString(i)==null)?"":rs.getString(i) %></td>
		<% }
		rowCount++;%>
	</tr>
<%} %>
</table>
<%} }%>
<%@include file="footer.inc" %>