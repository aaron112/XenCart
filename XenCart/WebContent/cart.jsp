<%-- CSE 135 Project - XenCart
  -- Team Xen
  -- 
  -- cart.jsp - Show Shopping Cart
  -- 
  --%>

<% String page_title="Buy Shopping Cart"; %>
<%@include file="header.jsp" %>

<%-- Begin Shopping Cart Page --%>
<h2> Shopping Cart</h2>

<%@include file="showpurchase.jsp" %>

<%-- Insert credit card/purchase action --%>
<%-- Check valid credit card number ? --%>
<%-- If purchased is pressed, move go to confirm jsp --%>

<form action ="confirm.jsp" name = "purchase" method="POST">
	<br/>
	<b>Credit Card Number: </b>
	<input type = "text" name = "ccNum" size ="24" value="">
	
	<input type = "submit" name = "Purchase" value = "Purchase">
	
</form>



<%@include file="footer.inc" %>