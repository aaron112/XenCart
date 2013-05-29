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
	String pagenum = (String) request.getParameter("pg");

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
		int offset = 0, pg = 0;
		try
    	{
    		offset = Integer.parseInt(pagenum) * MAX;
    		pg = Integer.parseInt(pagenum);
   			if(pg < 0)
   				throw new Exception();
    	}
    	catch(Exception e)
    	{
    		offset = 0;
    		pg = 1;
    	}
		
		
		
		
%>
<table border = "1" width = "99%">
	<tr>
	</tr>
</table>
<p align="right">
   	<input type="button" value="Previous 10 <%=row.equals("0")?"Customer":"Customer States" %>" onClick="javascript:location.href='?a=show&row=<%=row%>&age=<%=age%>&state=<%=state%>&catid=<%=catid%>&quarter=<%=quarter%>&pg=<%=Integer.toString(pg-1)%>'">
   	<input type="button" value="Next 10 <%=row.equals("0")?"Customer":"Customer States" %>" onClick="javascript:location.href='?a=show&row=<%=row%>&age=<%=age%>&state=<%=state%>&catid=<%=catid%>&quarter=<%=quarter%>&pg=<%=Integer.toString(pg+1)%>'">
</p>
<%} %>
<%@include file="footer.inc" %>