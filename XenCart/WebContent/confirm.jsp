<% String page_title="Confirmation Page"; %>
<%@include file="header.jsp" %>
<h2> Confirmation Page</h2>

<p/ > You just bought: 


<%-- Does the same thing as cart.jsp? Is this bad? :( --%>
<%@include file="showpurchase.jsp" %>

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