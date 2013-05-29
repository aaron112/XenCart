<% String page_title="Dashbaord"; %>
<%@include file="header.jsp" %>
<%@page import="java.util.*" %>
<h2>Dashboard</h2>

<%-- Parse Input Parameters --%>
<%
	final int MAX = 10; 
	String action = (String) request.getParameter("a");
	String row = (String) request.getParameter("row");
	String age = (String) request.getParameter("age");
	String state = (String) request.getParameter("state");
	String catid = (String) request.getParameter("catid");
	String quarter = (String) request.getParameter("quarter");
	String custpg = (String) request.getParameter("cpg");
	String prodpg = (String) request.getParameter("ppg");
	LinkedHashMap<Integer, Double> totalSales = new LinkedHashMap<Integer, Double>();
	Integer[] customerRank = new Integer[10];
%>

<%-- Form for setting report Criteria --%>
<form method="GET">
<fieldset><legend> Show Report </legend>
<input type="hidden" name="a" value="show" />
<b>Row Dimension: </b>
	<select name="row">
		<option value="0">customers</option>
		<option value="1">customer states</option>
	</select><br>
<b>Age: </b>
	<select name="age">
		<option value="" selected></option>
		<option value="0">0-9</option>
		<option value="1">10-19</option>
		<option value="2">20-29</option>
		<option value="3">30-39</option>
		<option value="4">40-49</option>
		<option value="5">50-59</option>
		<option value="6">60-69</option>
		<option value="7">70-79</option>
		<option value="8">80-89</option>
		<option value="9">90-99</option>
	</select><br>
<b>State: </b>
	<select name="state">
	<option value="" selected></option>
		<%
		try {
			rs = statement.executeQuery("SELECT id, name FROM states ORDER BY id ASC");
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
		%>
		<% while (rs.next()) { %>
    	<option value="<%=rs.getInt("id")%>"><%=rs.getString("name")%></option>
		<% } %>
	</select><br>
<b>Product Category: </b>
	<select name = "catid">
		<option value="" selected></option>
		<%
		try {
			rs = statement.executeQuery("SELECT name,id FROM categories ORDER BY id ASC");
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
		%>
		<% while (rs.next()) { %>
    	<option value="<%=rs.getInt("id")%>"><%=rs.getString("name")%></option>
		<% } %>
 	</select><br>
<b>Quarter: </b>
	<select name="quarter">
		<option value="" selected></option>	
		<option value="0">Spring</option>
		<option value="1">Summer</option>
		<option value="2">Autumn</option>
		<option value="3">Winter</option>
	</select><br>
<input type="submit" name="Submit" value="Run Query">
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
		
		
		
		
%>
<table border = "1" width = "99%">
	<tr>
		<th>Rank</th>
		<th>Customer</th>
		<th>Total Amount</th>
		<th>Product <%=ppgoffset+1%></th>
		<th>Product <%=ppgoffset+2%></th>
		<th>Product <%=ppgoffset+3%></th>
		<th>Product <%=ppgoffset+4%></th>
		<th>Product <%=ppgoffset+5%></th>
		<th>Product <%=ppgoffset+6%></th>
		<th>Product <%=ppgoffset+7%></th>
		<th>Product <%=ppgoffset+8%></th>
		<th>Product <%=ppgoffset+9%></th>
		<th>Product <%=ppgoffset+10%></th>
	</tr>
	<%  int rowCount = 0;
		while(rowCount < 10){
	%>
	<tr>
		<td><%= cpgoffset + rowCount + 1 %></td>
		<%try {
				String sqlquery = "SELECT name FROM users WHERE id = "+Integer.toString(customerRank[rowCount]);
		    	rs = statement.executeQuery(sqlquery);
		    } catch (SQLException e) {
	 	    	throw new RuntimeException(e);
	 		}
			while(rs.next()){
		%>
			<td><%=rs.getString("name")%></td>
			<%} %>
			<td>$<%=totalSales.get(customerRank[rowCount])%></td>
			
		<%
		try {
				String sqlquery = "SELECT users.name, SUM(count) AS count, sum(total_cost) AS cost " +
							"FROM precompute JOIN users ON customer_id = users.id " +
							"WHERE customer_id = " + Integer.toString(customerRank[rowCount]) +
							" GROUP BY users.name, product_id "+
							"ORDER BY cost DESC" +
							" LIMIT 10 OFFSET " + ppgoffset;
		    	rs = statement.executeQuery(sqlquery);
		    } catch (SQLException e) {
	 	    	throw new RuntimeException(e);
	 		}
			while(rs.next())
			{%>	
				<td>$<%=rs.getDouble("cost")%>, count = <%= rs.getInt("count")%></td>
			<%}
			rowCount++;
		%>
	</tr>
<%} %>
</table>
<p align="right">
   	<input type="button" value="Previous 10 <%=row.equals("0")?"Customer":"Customer States" %>" onClick="javascript:location.href='?a=show&row=<%=row%>&age=<%=age%>&state=<%=state%>&catid=<%=catid%>&quarter=<%=quarter%>&cpg=<%=Integer.toString(cpg-1)%>&ppg=<%=ppg%>'">
   	<input type="button" value="Next 10 <%=row.equals("0")?"Customer":"Customer States" %>" onClick="javascript:location.href='?a=show&row=<%=row%>&age=<%=age%>&state=<%=state%>&catid=<%=catid%>&quarter=<%=quarter%>&cpg=<%=Integer.toString(cpg+1)%>&ppg=<%=ppg%>'">
   	</br></br>
   	<input type="button" value="Previous 10 Products" onClick="javascript:location.href='?a=show&row=<%=row%>&age=<%=age%>&state=<%=state%>&catid=<%=catid%>&quarter=<%=quarter%>&cpg=<%=cpg%>&ppg=<%=Integer.toString(ppg-1)%>'">
   	<input type="button" value="Next 10 Products" onClick="javascript:location.href='?a=show&row=<%=row%>&age=<%=age%>&state=<%=state%>&catid=<%=catid%>&quarter=<%=quarter%>&cpg=<%=cpg%>&ppg=<%=Integer.toString(ppg+1)%>'">
</p>
<%} %>
<%@include file="footer.inc" %>