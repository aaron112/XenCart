<% String page_title="Login"; %>
<%@include file="header.jsp" %>

<%
	String action = (String)request.getParameter("a");
	
	if ( action != null && action.equals("logout") ) {
		// Logging out
		session.setAttribute("user", "");
		response.sendRedirect("login.jsp");
		
	} else {
		String username = (String)request.getParameter("username");
		if ( username != null && !username.equals("") ) {
			rs = statement.executeQuery("SELECT count(*) AS count FROM users WHERE name = '"+username+"' ");
			
			if ( rs.next() && rs.getInt(1) > 0 ) {
				// User found in db, logging in
				session.setAttribute("user", username);
				response.sendRedirect("index.jsp");
			} else {
				// User not found!
				%>User '<%=username %>' not found!<%
			}
		}
	}
	

%>

<form action="login.jsp" method="post">
Username: <input type="text" name="username">
<input type="submit" value="Login!">
</form>

<%@include file="footer.inc" %>