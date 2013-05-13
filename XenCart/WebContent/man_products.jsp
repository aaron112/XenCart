<% String page_title="Manage Products"; %>
<%@include file="header.jsp" %>

<%
	String action = (String) request.getParameter("a");
	String proname = (String) request.getParameter("proname");
	String catname = (String) request.getParameter("catname");
	String sku = (String) request.getParameter("sku");
	Double price = null;
	
	try
	{
		price = Double.parseDouble(request.getParameter("price"));
	}
	catch(Exception e)
	{
	}

	
	if(action != null && action.equals("insert"))
	{

			if(proname != null && !proname.equals(""))
			{
				if(sku != null && !sku.equals(""))
				{
					if(price >= 0)
						try {
						statement.executeUpdate("INSERT INTO products (name, sku, category, price) VALUES ('"+proname+"', '"+sku+"', '"+catname+"','"+price.toString()+"')");

						%><p style="color:green">Product <%=proname %> CREATED.</p><%
						proname = null;
						sku = null;
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
	}
	/*else if(action != null && action.equals("show"))
	{
		if(catname != null && !catname.equals(""))
		{
			try {
				rs = statement.executeQuery("SELECT name,id FROM categories");
			} catch (SQLException e) {
			    throw new RuntimeException(e);
			}
		}
	}*/
%>

<form action="?a=insert" method="POST">
<fieldset><legend> Add a Product </legend>
<b>Product Name: </b> <input type="text" name="proname" value="<%=proname==null?"":proname%>"><br>
<b>Product SKU: </b> <input type="text" name="sku" value ="<%= sku==null?"":sku%>"><br>
<b>Product Category: </b>
	<select name = "catname">
		<%
		try {
		rs = statement.executeQuery("SELECT name,id FROM categories");
		} 		catch (SQLException e) {
	    	throw new RuntimeException(e);
		}
		%>
		<% while (rs.next()) { %>
    	<option value="<%=rs.getInt("id")%>"><%=rs.getString("name")%></option>
		<% } %>
 	</select><br>
<b>Price: </b><input type="text" name="price" value="<%=price==null?"":price %>"/><br>
<input type="submit" name="Submit" value="Create Product">
</fieldset>
</form>

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
	</tr>
	<%
	while ( rs.next() )
		out.println("<tr><td>"+rs.getString("id")+"</td><td>"+rs.getString("sku")+"</td><td>"+rs.getString("proname")+"</td><td>"+ rs.getString("catname")+"</td><td>" + rs.getString("price")+"</td></tr>");
	%>
</table>
<%@include file="footer.inc" %>