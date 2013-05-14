
<% String page_title="Buy Shopping Cart"; %>
<%@include file="header.jsp" %>

<%-- Begin Shopping Cart Page --%>
<h2> Shopping Cart</h2>


<%@include file="showpurchase.jsp" %>


<%-- Insert credit card/purchase action --%>
<%-- Check valid credit card number ? --%>
<%-- If purchased is pressed, move go to confirm jsp --%>
<%
	String action = (String) request.getParameter("a");
	String ccnum = (String)request.getParameter("ccnum");
	boolean confirmed = false;


	//String action = (String)request.getParameter("a");
	String ccNum = (String)request.getParameter("ccNum");
%>


<form action ="confirm.jsp" name = "purchase" method="POST">
	<br/>
	<b>Credit Card Number: </b>
	<input type = "text" name = "ccNum" size ="24" value="<%= ccNum==null?"":ccNum %>">
	
	<input type = "submit" name = "Purchase" value = "Purchase">
	
</form>



<%@include file="footer.inc" %>