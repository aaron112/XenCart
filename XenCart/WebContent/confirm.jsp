<% String page_title="Confirmation Page"; %>
<%@include file="header.jsp" %>
<h2> Confirmation Page</h2>

<b>Thank you for your purchase! Here is your order:</b><br/><br/>

<%-- Does the same thing as cart.jsp? Is this bad? :( --%>
<%@include file="showpurchase.jsp" %>
<br/>
<b>Charged to Credit Card: <%=request.getParameter("ccNum") %></b>
<hr/>
<br/>
<b><a href="index.jsp">Click here to return to main page.</a></b>

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