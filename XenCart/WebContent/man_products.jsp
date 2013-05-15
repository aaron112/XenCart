<% String page_title="Manage Products"; %>
<%@include file="header.jsp" %>
<%@page import="java.util.*" %>
<h2>Manage Products</h2>
<%
	//Parse the incoming parameters first
	String action = (String) request.getParameter("a");
	String proname = (String) request.getParameter("proname");
	String catid = (String) request.getParameter("catid");
	String sku = (String) request.getParameter("sku");
	String price = (String) request.getParameter("price");
	String submit = (String) request.getParameter("Submit");
	String pid = (String) request.getParameter("pid");
	//String[] cat = new String[100]; 			// This is stupid....
	LinkedHashMap<Integer, String> categories = new LinkedHashMap<Integer, String>();
	
	
	//When the owner wants to insert a new product
	if(action != null && action.equals("insert"))
	{
			//check product name
			if(proname != null && !proname.equals(""))
			{
				//check sku
				if(sku != null && !sku.equals(""))
				{
					//check price
					if(price != null && Double.parseDouble(price) >= 0)
						try {
						statement.executeUpdate("INSERT INTO products (name, sku, category, price) VALUES ('"+proname+"', '"+sku+"', '"+catid+"','"+price.toString()+"')");
						statement.executeUpdate("UPDATE categories SET products=((SELECT products FROM categories WHERE id = '"+catid+"') + 1) WHERE id = '"+catid+"'");
						
						%><p style="color:green">Product <%=proname %> CREATED.</p><%

						
						} catch (SQLException e) {
						// SQL Error - mostly because of duplicate category name
						%><p style="color:red">INSERT ERROR: Duplicate product name!</p><%
						}
					else
						%><p style="color:red">INSERT ERROR: Price error!</p><%
					
				}
				else
					%><p style="color:red">INSERT ERROR: SKU error!</p><%
			}
			else
				%><p style="color:red">INSERT ERROR: Product name error!</p><%
				submit = "Search";
				catid = null;
				proname = null;
	}
	
	//When the owner wants to update a new product
		if(action != null && action.equals("UPDATE"))
		{
				//check product name
				if(proname != null && !proname.equals(""))
				{
					//check sku
					if(sku != null && !sku.equals(""))
					{
						//check price
						if(price != null && Double.parseDouble(price) >= 0)
							try {
							/*rs = statement.executeQuery("SELECT category FROM products WHERE id = '"+pid+"'");
							if(Integer.parseInt(catid) != (rs.getInt("category")))
							{
								//statement.executeUpdate("UPDATE categories SET products=((SELECT products FROM categories WHERE id = '"+rs.getInt("category")+"') - 1) WHERE id = '"+rs.getInt("category")+"'");
								statement.executeUpdate("UPDATE categories SET products=((SELECT products FROM categories WHERE id = '"+catid+"') + 1) WHERE id = '"+catid+"'");
							}*/
							statement.executeUpdate("UPDATE products SET name='"+proname+"', sku='"+sku+"', category= '"+catid+"', price='"+price+"' WHERE id = '"+pid+"'");
							

							%><p style="color:green">Product <%=proname %> UPDATED.</p><%
							
							} catch (SQLException e) {
							// SQL Error - mostly because of duplicate category name
							%><p style="color:red">UPDATE ERROR: Wrong category name!</p><%
							}
						else
							%><p style="color:red">UPDATE ERROR: Price error!</p><%
						
					}
					else
						%><p style="color:red">UPDATE ERROR: SKU error!</p><%
				}
				else
					%><p style="color:red">UPDATE ERROR: Product name error!</p><%
					submit = "Search";
					catid = null;
					proname = null;
		}
	
		//When the owner wants to delete a new product
		if(action != null && action.equals("DELETE"))
		{
				//check product name
			
			try {
				// Remove from this product from all carts first!
				statement.executeUpdate("DELETE FROM cart_entry WHERE item = '"+pid+"'");
				statement.executeUpdate("DELETE FROM products WHERE id = '"+pid+"'");
				%><p style="color:green">Product <%=proname %> DELETED.</p><%
				
			} catch (SQLException e) {
				// SQL Error - mostly because of duplicate category name
				%><p style="color:red">DELETE ERROR: Product ID '<%=pid %>' not found!</br>SQL Error: <%=e %></p><%
			}
			submit = "Search";
			catid = null;
			proname = null;

		}
	
%>

<%-- Big formatting table --%>
<table width="99%"><tr><td valign="top">
<h3>Categories:</h3>
<%-- Categories list on the left --%>
<a href="?<%=proname!=null?"proname="+proname:"" %>">All</a></br>
<%
	try {
		rs = statement.executeQuery("SELECT name,id FROM categories ORDER BY id ASC");
	} catch (SQLException e) {
		throw new RuntimeException(e);
	}
	
	while ( rs.next() ) {
		// Save result up to a HashMap
		categories.put(rs.getInt("id"), rs.getString("name"));
		
		%><a href="?catid=<%=rs.getInt("id")%><%=proname!=null?"&proname="+proname:"" %>"><%=rs.getString("name") %></a></br><%
	}
%>
</td>
<td>
<%-- Form for owner to insert products --%>
<form action="?a=insert" method="POST">
<fieldset><legend> Add a Product </legend>
<b>Product Name: </b> <input type="text" name="proname" value=""><br>
<b>Product SKU: </b> <input type="text" name="sku" value =""><br>
<b>Product Category: </b>
	<select name = "catid">
		<%
		try {
			rs = statement.executeQuery("SELECT name,id FROM categories ORDER BY id ASC");
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
		%>
		<% while (rs.next()) { %>
    	<option value="<%=rs.getInt("id")%>"><%=rs.getString("name")%></option>
		<% } %>
 	</select><br>
<b>Price: </b><input type="text" name="price" value=""/><br>
<input type="submit" name="Submit" value="Create Product">
</fieldset>
</form>
</br>

<%-- Form for searching a product --%>
<form name="search" action="" method="GET">
<fieldset><legend> Search Product </legend>
<input type="hidden" value="<%=catid==null?"":catid %>" name="catid"/>
<b>Partial Product Name: </b> <input type="text" name="proname" value="<%=proname==null?"":proname %>">
<input type="submit" value="Search">
<input type="button" value="Clear" onClick="javascript:location.href='?<%=catid==null?"":"catid="+catid %>'">
</fieldset>
</form>
<br/><hr/><br/>

<%
	// Search for product
    if((submit != null && submit.equals("Search")) || action == null) {
    	// Build Query
    	boolean criteriaSpecified = false;
    	String sqlquery = "SELECT * FROM products ";
    	if ( (catid == null || catid.equals("")) && (proname == null || proname.equals("")) ) {
    		// No search criteria specified
    	} else {
    		sqlquery += "WHERE ";
    		if ( catid != null && !catid.equals("") && !catid.equals("null") ) {
    			// Category ID specified
			    sqlquery += "category = '"+catid+"'";
			    criteriaSpecified = true;
		    }
		   
    		if ( proname != null && !proname.equals("") && !proname.equals("null") ) {
			    if ( criteriaSpecified )
				    sqlquery += " AND ";
			    // Product name specified
			    sqlquery += "LOWER(name) LIKE '%"+proname.toLowerCase()+"%'";
		    }
	    }
	    sqlquery += " ORDER BY id ASC";
	   
	    try {
	    	rs = statement.executeQuery(sqlquery);
	    } catch (SQLException e) {
 	    	throw new RuntimeException(e);
 		}
%>
	<%-- Tables showing the searched products --%>
	<table border = "1" width = "99%">
		<tr>
			<th>Product ID</th>
			<th>Product SKU</th>
			<th>Product Name</th>
			<th>Product Category</th>
			<th>Product Price</th>
			<th>Action</th>
		</tr>
	<% while ( rs.next() ) { %>
	<form action="?a=UPDATE" method="POST">
		<tr>
    		<td> <input type="hidden" value="<%=rs.getString("id")%>" name="pid"/><%=rs.getString("id")%></td>
        	<td> <input value="<%=rs.getString("sku")%>" name="sku"/></td>
        	<td> <input value="<%=rs.getString("name")%>" name="proname"/></td>
        	<td> 
        		<select name="catid">
        		<%
        		for (Map.Entry<Integer, String> entry : categories.entrySet()) {
        			%> <option value="<%=entry.getKey()%>" <%=entry.getKey()==rs.getInt("category")?"selected":"" %>><%=entry.getValue() %> <%
        		}
        		%>
				</select>
        	</td>
        	<td> $<input value="<%=rs.getString("price")%>" name="price"/></td>
        	<td> 
        		<input type="submit" value="UPDATE">
        		<input type="button" value="DELETE" onClick="javascript:location.href='?a=DELETE&pid=<%=rs.getString("id")%>&proname=<%=rs.getString("name")%>'">
        	</td>
    	</tr>
    </form>
	<%
	}
	%>
	</table>
	<%
   	}
	%>
</td></tr></table>
<%@include file="footer.inc" %>