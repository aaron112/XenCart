<% String page_title="Signup"; %>
<%@include file="header.jsp" %>

<%
	boolean showform = true;

	String username = (String)request.getParameter("username");
	String role = (String)request.getParameter("role");
	String age = (String)request.getParameter("age");
	String state = (String)request.getParameter("state");
	
	if ( username != null ) {
		// We got input!
		showform = false;
		
		int parsed_age;
		try {
			parsed_age = Integer.parseInt(age);
			if ( parsed_age < 1 )
				throw new NumberFormatException();
			statement.executeUpdate("INSERT INTO users (name, age, role, state) VALUES ('"+username+"', '"+age+"', '"+role+"', '"+state+"')");
		} catch (NumberFormatException e) {
			%><p style="color:red">Incorrect age! Please try again!</p><%
			showform = true;
		} catch (SQLException e) {
			%><p style="color:red">Username already taken. Please enter another one!</p><%
		    showform = true;
		}
	}
	
	if ( !showform ) {
		%>Success!<%
	}

%>
<%
	// ----------------- Below: Display Form
	if ( showform ) {
		try {
			rs = statement.executeQuery("SELECT name, id FROM roles");
			//rs_states = statement.executeQuery("SELECT name, id FROM states");
		} catch (SQLException e) {
		    throw new RuntimeException(e);
		}
%>

<form action="signup.jsp" method="post">
<b>Complete the following form for registration:<br><br>
Username: <input type="text" name="username" value="<%=username==null?"":username%>"><br>
Role: <select name="role">
<%-- -------- List Roles -------- --%>
<% while (rs.next()) { %>
 <option value="<%=rs.getInt("id")%>" <%=rs.getString("id").equals(role)?"selected":""%>><%=rs.getString("name")%></option><% } %>
</select><br>
Age: <input type="text" name="age" value="<%=age==null?"":age%>" size="5"><br>
State: <select name="state">
<%
	try {
		rs = statement.executeQuery("SELECT name, id FROM states");
	} catch (SQLException e) {
	    throw new RuntimeException(e);
	}
	while (rs.next()) {
%>
 <option value="<%=rs.getInt("id")%>" <%=rs.getString("id").equals(state)?"selected":""%>><%=rs.getString("name")%></option> <% } %>
</select><br>
<input type="submit" value="Submit"></b>
</form> 

<% } %>
<%@include file="footer.inc" %>