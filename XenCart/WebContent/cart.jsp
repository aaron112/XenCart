<% String page_title="Buy Shopping Cart"; %>
<%@include file="header.jsp" %>


<%-- Begin Shopping Cart Page --%>
<h2> Shopping Cart</h2>

<%@include file="showpurchase.inc" %>

<%-- Insert credit card/purchase action --%>
<%-- If purchased is pressed, move go to confirm jsp --%>

<form action ="confirm.jsp?a=purchase" name = "purchase" method="POST">
	<br/>
	<b>Credit Card Number: </b>
	<input type = "text" name = "ccNum" size ="24" value="">
	
	<input type = "submit" name = "purchase" value = "purchase">
	
</form>



<%@include file="footer.inc" %>