<% String page_title="Manage Categories"; %>
<%@include file="header.jsp" %>
<h2>Manage Categories</h2>
<%
	String action = (String)request.getParameter("a");
	String catname = (String)request.getParameter("catname");
	String catdesc = (String)request.getParameter("catdesc");
	String pagenum = (String) request.getParameter("pg");
	
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
	} else if ( action != null && action.equals("update") ) {
		// Update Request
		String update_cid = (String)request.getParameter("update_cid");
		String update_cname = (String)request.getParameter("update_cname");
		String update_cdesc = (String)request.getParameter("update_cdesc");
		try {
			if ( statement.executeUpdate("UPDATE categories SET name = '"+update_cname+"', description = '"+update_cdesc+"' WHERE id = '"+update_cid+"'") == 0 ) {
				%><p style="color:red">UPDATE ERROR: Category '<%=update_cname %>' does not exist.</p><%
			} else {
				%><p style="color:green">Category '<%=update_cname %>' UPDATED.</p><%
			}
		} catch (NumberFormatException e) {
			%><p style="color:red">UPDATE ERROR: Incorrect category id.</p><%
		} catch (SQLException e) {
			// SQL Error
			%><p style="color:red">UPDATE ERROR: <%=e.toString() %></p><%
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
	int offset = 0, pg = 0;

	try
	{
		offset = Integer.parseInt(pagenum) * LIMIT;
		pg = Integer.parseInt(pagenum);
		if(pg < 0)
			throw new Exception();
	}
	catch(Exception e)
	{
		offset = 0;
		pg = 1;
	}

	try {
		rs = statement.executeQuery("SELECT categories.id, categories.name, description, ( SELECT count(*) FROM products WHERE category = categories.id ) AS count FROM categories ORDER BY categories.id ASC LIMIT " +LIMIT+ " OFFSET " +offset);
	} catch (SQLException e) {
	    throw new RuntimeException(e);
	}
%>
<table border='1' width="99%"><tr><th>ID</th><th>Name</th><th>Description</th><th>Product Count</th><th>Actions</th></tr>
<%
	while ( rs.next() ) { %>
	<form action="?a=update" method="POST">
	<tr>
		<td> <input type="hidden" value="<%=rs.getString("id")%>" name="update_cid"/><%=rs.getString("id")%> </td>
        <td> <input value="<%=rs.getString("name")%>" name="update_cname"/> </td>
        <td> <input value="<%=rs.getString("description")%>" name="update_cdesc"/> </td>
        <td> <%=rs.getString("count") %> </td>
        <td> 
        	<input type="submit" value="UPDATE">
        	<input type="button" value="DELETE" <%=(rs.getInt("count")>0)?"disabled":"onClick=\"javascript:location.href='?a=delete&did="+rs.getString("id")+"'\"" %>/>
        </td>
    </tr>
    </form>
	<% }
%>
</table>
<p align="right">
	<input type="button" value="Previous 20 Categories" onClick="javascript:location.href='?catid=<%=catname==null?"":catname%>&pg=<%=Integer.toString(pg-1)%>'">
	<input type="button" value="Next 20 Categories" onClick="javascript:location.href='?catid=<%=catname==null?"":catname%>&pg=<%=Integer.toString(pg+1)%>'">
</p>	


<%@include file="footer.inc" %>