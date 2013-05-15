<%-- Show table of Shopping Cart --%>

<%-- Get details from Shopping Cart table from DB --%>

<%--
	try {
		rs = statement.executeQuery(  "SELECT products.name AS proname, "
									+ "products.price AS price_per_item, "
									+ "cart_entry.count AS amt, "
									+ "(products.price * cart_entry.count) AS amtprice "
									+ "FROM products "
									+ "JOIN cart_entry "
									+ "ON products.id = cart_entry.item "
									);
	} catch (SQLException e) {
	    throw new RuntimeException(e);
	}
--%>


<%
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
		<th> Product </th>
		<th> Price </th>
		<th> Quantity </th>
		<th> Amount </th>
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
	<td align = "right" style = "border: 0px"><b>Total:</b></td>
	<td> <b><% 
			while ( rs.next() )
			{
				String tprice = rs.getString("totalprice");
				if ( tprice != null )
				out.println(tprice);
			}
			%> </b></td>
</tr>	
</table>	