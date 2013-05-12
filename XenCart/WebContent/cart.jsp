
<% String page_title="Buy Shopping Cart"; %>
<%@include file="header.jsp" %>

<%-- Begin Shopping Cart Page --%>
<h2> Shopping Cart</h2>





<%-- Show table of Shopping Cart --%>

<%-- Get details from Shopping Cart table from DB --%>

<%
	try {
		rs = statement.executeQuery("SELECT * FROM cart_entry");
	} catch (SQLException e) {
	    throw new RuntimeException(e);
	}
%>

<%-- Show shopping cart table --%>
<table border = '1' width = "90%">
	<tr>
		<td> Product </td>
		<td> Quantity </td>
		<td> Price </td>
		<td> Quantity * Price </td>
	</tr>


 
<%
	// Get shopping cart information
	while ( rs.next() ) {
		out.println(
				"<tr><td>"+
				rs.getString("item")+
				"</td><td>"+
				rs.getInt("count")+
				"</td><td>"
				);
	}
%>

<tr>
	<td style = "border: 0px">  </td>
	<td style = "border: 0px">  </td>
	<td align = "right" style = "border: 0px">Total:</td>
	<td>  </td>
</tr>	
</table>	

<%-- Insert credit card/purchase action --%>

<%
	//String action = (String)request.getParameter("a");
	String ccNum = (String)request.getParameter("ccNum");
%>


<form action ="?a=purchase" name = "purchase" method="POST">
	<br/>
	<b>Credit Card Number: </b>
	<input type = "text" name = "ccNum" size ="24" value="<%= ccNum==null?"":ccNum %>">
	
	<input type = "submit" name = "Purchase" value = "Purchase">
	
</form>



<%@include file="footer.inc" %>