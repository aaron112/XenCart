<% String page_title="Login"; %>
<%@include file="header.jsp" %>

<%
	boolean showform = true;

	String username = (String)request.getParameter("username");
	if ( username != null ) {
		session.setAttribute("user", username);
		response.sendRedirect("index.jsp");
		%>
Logged in!
<%
	} else {
%>

<form action="login.jsp" method="post">
Username: <input type="text" name="username">
<input type="submit" value="Login!">
</form>

<% } %>
<%@include file="footer.inc" %>