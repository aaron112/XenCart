<% String page_title="Manage Categories"; %>
<%@include file="header.jsp" %>
<h2>Manage Categories</h2>
<%
	String action = (String)request.getParameter("a");
	String catname = (String)request.getParameter("catname");
	String catdesc = (String)request.getParameter("catdesc");
	if ( action != null && action.equals("insert") ) {
		// Insert Request
		if ( catname != null && !catname.equals("") ) {
			try {
				statement.executeUpdate("INSERT INTO categories (name, description) VALUES ('"+catname+"', '"+catdesc+"')");

				%><p style="color:green">Category <%=catname %> CREATED.</p><%
				catname = null;
				catdesc = null;
			} catch (SQLException e) {
				// SQL Error - mostly because of duplicate category name
				%><p style="color:red">INSERT ERROR: Duplicate category name!</p><%
			}
		} else {
			// Catname error
			%><p style="color:red">INSERT ERROR: Empty category name is not allowed!</p><%
		}
	} else if ( action != null && action.equals("delete") ) {
		// Delete Request
		String deleteid = (String)request.getParameter("did");
		int parsed_deleteid;
		try {
			parsed_deleteid = Integer.parseInt(deleteid);
			// Check if products = 0
			rs = statement.executeQuery("SELECT count(*) AS count FROM products WHERE category = '"+parsed_deleteid+"'");
			if ( rs.next() && rs.getInt("count") < 1 ) {
				if ( statement.executeUpdate("DELETE FROM categories WHERE id = "+parsed_deleteid) == 0 ) {
					%><p style="color:red">DELETE ERROR: Category ID does not exist.</p><%
				} else {
					%><p style="color:green">Category ID <%=parsed_deleteid %> DELETED.</p><%
				}
			} else {
				%><p style="color:red">DELETE ERROR: Category does not exist or product count is not zero.</p><%
			}
		} catch (NumberFormatException e) {
			%><p style="color:red">DELETE ERROR: Incorrect delete id.</p><%
		} catch (SQLException e) {
			// SQL Error
			%><p style="color:red">DELETE ERROR: <%=e.toString() %></p><%
		}
	}
%>
<form action="?a=insert" name="insert" method="POST">
<fieldset><legend> Add a Category </legend>
<b>Category Name: </b><input type="text" name="catname" size="24" value="<%= catname==null?"":catname %>"/><br>
<b>Description: </b><input type="text" name="catdesc" size="24" value="<%= catdesc==null?"":catdesc %>"/><br>
<input type="submit" name="Submit" value="Create Category">
</fieldset>
</form>
<br><hr><br>
<%
	try {
		rs = statement.executeQuery("SELECT categories.id, categories.name, description, ( SELECT count(*) FROM products WHERE category = categories.id ) AS count FROM categories");
	} catch (SQLException e) {
	    throw new RuntimeException(e);
	}
%>
<table border='1' width="99%"><tr><td><b>ID</b></td><td><b>Name</b></td><td><b>Description</b></td><td><b>Product Count</b></td><td><b>Actions</b></td></tr>
<%
	while ( rs.next() )
		out.println("<tr><td>"+rs.getString("id")+"</td><td>"+rs.getString("name")+"</td><td>"+rs.getString("description")+"</td><td>"+rs.getString("count")+"</td><td>"+ ((rs.getInt("count")>0)?"":"<a href=\"?a=delete&did="+rs.getString("id")+"\"><b>DELETE</b></a>") +"</td></tr>");
%>
</table>

<%@include file="footer.inc" %>