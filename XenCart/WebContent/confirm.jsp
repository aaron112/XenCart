<% String page_title="Confirmation Page"; %>
<%@include file="header.jsp" %>
<h2> Confirmation Page</h2>
<<<<<<< HEAD
<p/ > You just bought: 


<%-- Does the same thing as cart.jsp? Is this bad? :( --%>

<%	
	int user_id = 0;
	try {
		rs = statement.executeQuery("SELECT users.id FROM users WHERE users.name = '"+user_name+"'");
		while(rs.next())
		{
			user_id = rs.getInt("id");
		}
	} catch (SQLException e) {
	    throw new RuntimeException(e);
	}

	// Get values from shopping cart rows associated with the user.
	try {
		rs = statement.executeQuery(  "SELECT products.name AS proname, "
									+ "products.price AS price_per_item, "
									+ "cart_entry.count AS amt, "
									+ "(products.price * cart_entry.count) AS amtprice "
									+ "FROM products, cart_entry "
									+ "WHERE products.id=cart_entry.item "
									+ "AND cart_entry.owner = '"+user_id+"';"
									);
	} catch (SQLException e) {
	    throw new RuntimeException(e);
	}
%>

<%-- Show shopping cart table --%>
<table border = '1' width = "99%">
	<tr>
		<td> Product </td>
		<td> Price </td>
		<td> Quantity </td>
		<td> Quantity * Price </td>
	</tr>


 
<%
	// Get shopping cart information
	while ( rs.next() ) {
		out.println("<tr><td>"
				+rs.getString("proname")
				+"</td><td>"
				+rs.getString("price_per_item")
				+"</td><td>"
				+rs.getInt("amt")
				+"</td><td>"
				+rs.getString("amtprice")
				+"</td>"
				);
	}
%>


<%-- Calculate the total price of the users shopping cart --%>
<%
	try {
		rs = statement.executeQuery(  "SELECT "
									+ "SUM(products.price * cart_entry.count) AS totalprice "
									+ "FROM products, cart_entry "
									+ "WHERE products.id = cart_entry.item "
									+ "AND cart_entry.owner = '"+user_id+"';"
									);
	} catch (SQLException e) {
	    throw new RuntimeException(e);
	}
%>


<%-- Display the total price --%>
<tr>
	<td style = "border: 0px">  </td>
	<td style = "border: 0px">  </td>
	<td align = "right" style = "border: 0px">Total:</td>
	<td> <% 
			while ( rs.next() )
			{
				String tprice = rs.getString("totalprice");
				if ( tprice != null )
				out.println(tprice);
			}
			%> </td>
</tr>	
</table>	


<%-- Delete values from shopping cart after displaying them --%>
<% 
		try {
			statement.executeUpdate(  "DELETE FROM cart_entry WHERE cart_entry.owner = '"+user_id+"';"
									);
		} catch (SQLException e) {
		    throw new RuntimeException(e);
}
%>
=======
>>>>>>> a46028d92f812b4b5eae507d510e93f229df6f71
<%@include file="footer.inc" %>