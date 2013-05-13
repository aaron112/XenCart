<% String page_title="Manage Products"; %>
<%@include file="header.jsp" %>

<%
	String action = (String) request.getParameter("a");
	String proname = (String) request.getParameter("proname");
	String catname = (String) request.getParameter("catname");
	String sku = (String) request.getParameter("sku");
	String pid = (String) request.getParameter("pid");
	Double price = null;
	
	if(action != null && action.equals("add"))
	{
		if(pid != null && !pid.equals(""))
		{
			int user_id = 0, quantity = 0;
			boolean bought = false;
			
			try {
				rs = statement.executeQuery("SELECT users.id FROM users WHERE users.name = '"+user_name+"'");
				while(rs.next())
				{
					user_id = rs.getInt("id");
				}
			} catch (SQLException e) {
			    throw new RuntimeException(e);
			}
			
			try {
				rs = statement.executeQuery("SELECT item,count FROM cart_entry WHERE owner = '"+user_id+"';");
				
				while(rs.next())
				{
					if(rs.getInt("item") == Integer.parseInt(pid))
					{
						bought = true;
						quantity = rs.getInt("count");
						break;
					}
				}
			} catch (SQLException e) {
			    throw new RuntimeException(e);
			}
			
			if(bought == true)
			{
				try {
					statement.executeUpdate("UPDATE cart_entry SET count = "+(++quantity)+" WHERE item = "+pid+"");
					pid = null;
					proname = null;
					%><p style="color:green">UPDATED to Cart</p><%
								
					
				} catch (SQLException e) {
					// SQL Error - mostly because of duplicate category name
					%><p style="color:red">UPDATE ERROR: Cannot find product</p><%
				}
			}
			else
			{
			try {
				statement.executeUpdate("INSERT INTO cart_entry (owner,item,count) VALUES ('"+user_id+"', '"+pid+"', '1')");

				%><p style="color:green">INSERTED to Cart</p><%
				pid = null;
				proname = null;
			} catch (SQLException e) {
				// SQL Error - mostly because of duplicate category name
				%><p style="color:red">INSERT ERROR: Product exists</p><%
			}
			}
		}
	}
%>

<form action="" method="GET">
<fieldset><legend> Search Product </legend>
<b>Product Name: </b> <input type="text" name="proname" value="<%=proname==null?"":proname%>"><br>
<b>Product Category: </b>
	<select name = "catname">
		<%
		try {
		rs = statement.executeQuery("SELECT name,id FROM categories");
		} 		catch (SQLException e) {
	    	throw new RuntimeException(e);
		}
		%>
		<option value="0"> All </option>
		<% while (rs.next()) { %>
    	<option value="<%=rs.getInt("id")%>"><%=rs.getString("name")%></option>
		<% } %>
 	</select><br>
<input type="submit" name="Submit" value="Search">
</fieldset>
</form>


<%
   if(request.getParameter("Submit") != null && request.getParameter("Submit").equals("Search") && !catname.equals("0"))
   {
   	if(proname != null && !proname.equals(""))
   	{
   		try {
      		rs = statement.executeQuery("SELECT products.id,sku,price,products.name AS proname, categories.name AS catname FROM products JOIN categories ON (products.category = categories.id) WHERE (categories.id = '"+catname+"') AND (lower(products.name) LIKE '%"+proname.toLowerCase()+"%')");
      		} 		catch (SQLException e) {
      	    	throw new RuntimeException(e);
      		}
   	}
   	else
   	{
   	try {
   		rs = statement.executeQuery("SELECT products.id,sku,price,products.name AS proname, categories.name AS catname FROM products JOIN categories ON (products.category = categories.id) WHERE (categories.id = '"+catname+"')");
   		} 		catch (SQLException e) {
   	    	throw new RuntimeException(e);
   		}
   	}
   }
	
   else
   {
   	if(proname != null && !proname.equals(""))
   	{
   		try {
      		rs = statement.executeQuery("SELECT products.id,sku,price,products.name AS proname, categories.name AS catname FROM products JOIN categories ON (products.category = categories.id) WHERE (lower(products.name) LIKE '%"+proname.toLowerCase()+"%')");
      		} 		catch (SQLException e) {
      	    	throw new RuntimeException(e);
      		}
   	}
   	else
   	try {
   		rs = statement.executeQuery("SELECT products.id,sku,price,products.name AS proname, categories.name AS catname FROM products JOIN categories ON (products.category = categories.id)");
   		} 		catch (SQLException e) {
   	    	throw new RuntimeException(e);
   		}
   }
%>
<table border = "1" width = "99%">
	<tr>
	<th>Product ID</th>
	<th>Product SKU</th>
	<th>Product Name</th>
	<th>Product Category</th>
	<th>Product Price</th>
	<th>Add Product to Cart</th>
	</tr>
	<%
	while ( rs.next() )
		out.println("<tr><td>"+rs.getString("id")+"</td><td>"+rs.getString("sku")+"</td><td>"+rs.getString("proname")+"</td><td>"+ rs.getString("catname")+"</td><td>" + rs.getString("price")+"</td><td><a href=\"?a=add&pid="+rs.getString("id")+"&proname="+rs.getString("proname")+"\">ADD TO CART</a></td>");
	%>
</table>
<%@include file="footer.inc" %>