<% String page_title="Signup"; %>
<%@include file="header.jsp" %>

<%
	boolean showform = true;

	String username = (String)request.getParameter("username");
	String role = (String)request.getParameter("role");
	String age = (String)request.getParameter("age");
	String state = (String)request.getParameter("state");
	
	if ( username != null) {
		// We got input!

			int parsed_role;
			int parsed_age;
			try {
				parsed_role = Integer.parseInt(role);
				
				if (parsed_role == 1) {
					statement.executeUpdate("INSERT INTO users (name, role) VALUES ('"+username+"', '"+role+"')");
					showform = false;

				}
				
				if (parsed_role == 2){
					parsed_age = Integer.parseInt(age);
					statement.executeUpdate("INSERT INTO users (name, age, role, state) VALUES ('"+username+"', '"+parsed_age+"', '"+role+"', '"+state+"')");
					showform = false;

				}//out.println( "role");

			} 
			catch (NumberFormatException e) {

				%><p style="color:red">Please insert a valid age.</p><%
					    showform = true;
			}
			catch (SQLException e) {
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

<form name = "signup" action="signup.jsp" method="post" onsubmit = "return validate(this);">
<b>Complete the following form for registration:<br><br>

<span id = "username_error" style="display:none">
<p style="color:red">Please enter a valid username.</p>
</span>
Username: <input type="text" name="username" value="<%=username==null?"":username%>"><br>

<span id = "role_error" style="display:none">
<p style="color:red">Please select a role.</p><br> 
</span>
Role: <select id ="role" name="role" onchange="disable()">
<%-- -------- List Roles -------- --%>
<option id = "blank" value ="0"> </option>
<% while (rs.next()) { %>
<option value="<%=rs.getInt("id")%>" <%=rs.getString("id").equals(role)?"selected":""%>><%=rs.getString("name")%></option><% } %>
</select><br>

<span id = "age_error" style="display:none">
<p style="color:red">Please insert a valid age.</p> </span>
<span id ="options" style ="display:none">
Age:<input id = "age" type="text" name="age" value="<%=age==null?"":age%>" size="5"><br>
State: <select id = "state" name="state">
<%
	try {
		rs = statement.executeQuery("SELECT name, id FROM states");
	} catch (SQLException e) {
	    throw new RuntimeException(e);
	}
	while (rs.next()) {
%>
<option value="<%=rs.getInt("id")%>" <%=rs.getString("id").equals(state)?"selected":""%>><%=rs.getString("name")%></option> <% } %>
</select><br></span>

<input type="submit" value="Submit"></b>

</form> 

<% } %>
<%@include file="footer.inc" %>	