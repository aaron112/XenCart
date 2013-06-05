<% String page_title="Confirmation Page"; %>
<%@include file="header.jsp" %>
<h2> Confirmation Page</h2>
<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>

<% 
String action = (String) request.getParameter("a");
%>

<%-- Update the sales table with the current users recently purchased cart
	 contents and date --%>
<% 	
	

	if(action.equals("purchase")) {
			
			statement.executeUpdate(" INSERT into sales (product_id, customer_id, day, month, quantity, total_cost) "
								+ 	"SELECT cart_entry.item, cart_entry.owner, EXTRACT(DAY FROM CURRENT_DATE), EXTRACT(MONTH FROM CURRENT_DATE), cart_entry.count, SUM(products.price * cart_entry.count) AS totalprice "
								+	"FROM products, cart_entry "
								+ 	"WHERE products.id = cart_entry.item AND cart_entry.owner = '"+user_id+"' "
								+	"GROUP BY cart_entry.item, cart_entry.owner, cart_entry.count"
								); }
		
		else {
			
		}
	
 %>
<b>Thank you for your purchase! Here is your order:</b><br/><br/>

<%@include file="showpurchase.inc" %>
<br/>
<b>Charged to Credit Card: <%=request.getParameter("ccNum") %></b>
<hr/>
<br/>
<b><a href="index.jsp">Click here to return to main page.</a></b>

<%-- Update sales table --%>


<%-- Delete values from shopping cart after displaying them --%>
<% 
		try {
			statement.executeUpdate(  "DELETE FROM cart_entry WHERE cart_entry.owner = '"+user_id+"';"
									);
		} catch (SQLException e) {
		    throw new RuntimeException(e);
}
%>
<%@include file="footer.inc" %>