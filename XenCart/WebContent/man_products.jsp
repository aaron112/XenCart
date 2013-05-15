<% String page_title="Manage Products"; %>
<%@include file="header.jsp" %>

<%
	//Parse the incoming parameters first
	String action = (String) request.getParameter("a");
	String proname = (String) request.getParameter("proname");
	String catid = (String) request.getParameter("catid");
	String sku = (String) request.getParameter("sku");
	String price = (String) request.getParameter("price");
	String submit = (String) request.getParameter("Submit");
	String pid = (String) request.getParameter("pid");
	String[] cat = new String[100]; 


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
				statement.executeUpdate("DELETE FROM products WHERE id = '"+pid+"'");
				//statement.executeUpdate("UPDATE categories SET products=((SELECT products FROM categories WHERE id = '"+catid+"') - 1) WHERE id = '"+catid+"'");
				%><p style="color:green">Product <%=proname %> DELETED.</p><%
				
				} catch (SQLException e) {
				// SQL Error - mostly because of duplicate category name
				
				%><p style="color:red">DELETE ERROR: Product not found!</p><%
				}
			submit = "Search";
			catid = null;
			proname = null;

		}
	
%>

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
		
		} 		catch (SQLException e) {
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
</br>

<%-- Form for searching a product --%>
<form action="" method="GET">
<fieldset><legend> Search Product </legend>
<b>Product Name: </b> <input type="text" name="proname" value=""><br>
<b>Product Category: </b>
	<select name = "catid">
		<%
		try {
		rs = statement.executeQuery("SELECT name,id FROM categories ORDER BY id ASC");
		} 		catch (SQLException e) {
	    	throw new RuntimeException(e);
		}
		%>
		<option value="0"> All </option>
		<% while (rs.next()) { 
			cat[rs.getInt("id")] = rs.getString("name"); %>
    	<option value="<%=rs.getInt("id")%>"><%=rs.getString("name")%></option>
		<% } %>
 	</select><br>
<input type="submit" name="Submit" value="Search">
</fieldset>
</form>
</br>
</br>

<%
	//Search for product
   if((submit != null && submit.equals("Search")) || action == null)
   {
   		//Case 1: product name and category name provided
   		if(proname != null && !proname.equals("") && !catid.equals("0"))
   		{
   			try {
      			rs = statement.executeQuery("SELECT products.id,sku,price,products.name AS proname, categories.name AS catid FROM products JOIN categories ON (products.category = categories.id) WHERE (categories.id = '"+catid+"') AND (lower(products.name) LIKE '%"+proname.toLowerCase()+"%') ORDER BY products.id ASC");
      			}
			catch (SQLException e) {
      	    	throw new RuntimeException(e);
      		}
   		}
		//Case 2: category name provided
   		else if(catid != null && !catid.equals("0"))
   		{
   		try {
   			rs = statement.executeQuery("SELECT products.id,sku,price,products.name AS proname, categories.name AS catid FROM products JOIN categories ON (products.category = categories.id) WHERE (categories.id = '"+catid+"') ORDER BY products.id ASC");
   			} 		catch (SQLException e) {
   	    		throw new RuntimeException(e);
   			}
   		}
		//Case 3: product name provided
   		else if(proname != null && !proname.equals("0"))
   		{
   			try {
      			rs = statement.executeQuery("SELECT products.id,sku,price,products.name AS proname, categories.name AS catid FROM products JOIN categories ON (products.category = categories.id) WHERE (lower(products.name) LIKE '%"+proname.toLowerCase()+"%') ORDER BY products.id ASC");
      			} 		catch (SQLException e) {
      	    	throw new RuntimeException(e);
      			}
   		}
		//Case 4: nothing provided, search ALL
   		else
		{
   			try {
   				rs = statement.executeQuery("SELECT products.id,sku,price,products.name AS proname, categories.name AS catid FROM products JOIN categories ON (products.category = categories.id) ORDER BY products.id ASC");
   				} 		catch (SQLException e) {
   	    			throw new RuntimeException(e);
   				}
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
	<%
	while ( rs.next() )
	{
		int i = 1;
	%>
		<tr>
			<form action="?a=UPDATE" method="POST">
    		<td> <input type="hidden" value="<%=rs.getString("id")%>" name="pid"/><%=rs.getString("id")%></td>
        	<td> <input value="<%=rs.getString("sku")%>" name="sku"/></td>
        	<td> <input value="<%=rs.getString("proname")%>" name="proname"/></td>
        	<td> 
        		<select name="catid">
        		<% while (i < cat.length) { 
        			if(cat[i] == null)
        			{
        				i++;
        				continue;
        			}%>
    			<option <% if(cat[i].equals(rs.getString("catid"))) out.println("selected = \"selected\""); else out.println(""); %> value="<%=i%>"><%=cat[i]%></option>
				<% i++; } %>
				</select>
        	</td>
        	<td> <input value="<%=rs.getString("price")%>" name="price"/></td>
        	<td> 
        		<input type="submit" value="UPDATE">
        		<input type="button" value="DELETE" onClick="javascript:location.href='?a=DELETE&pid=<%=rs.getString("id")%>&proname=<%=rs.getString("proname")%>'">
        	</td>
        	</form>
    	</tr>
	<%
	}
	%>
	</table>
	<%
   	}
	%>
<%@include file="footer.inc" %>