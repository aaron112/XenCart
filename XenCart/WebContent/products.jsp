<% String page_title="Products"; %>
<%@include file="header.jsp" %>

<%
	//Parse the parameters coming in
	String action = (String) request.getParameter("a");
	String proname = (String) request.getParameter("proname");
	String catname = (String) request.getParameter("catname");
	String sku = (String) request.getParameter("sku");
	String pid = (String) request.getParameter("pid");
	String quantity = (String) request.getParameter("quantity");
	String submit = (String) request.getParameter("Submit");
	
	//When the user wants to add products to the shopping cart
	if(action != null && action.equals("add"))
	{
		if(pid != null && !pid.equals(""))
		{
			int user_id = 0, count = 0;
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
				
				//Checks if it is already in cart_entry, bought=true if yes, false otherwise
				while(rs.next())
				{
					if(rs.getInt("item") == Integer.parseInt(pid))
					{
						bought = true;
						count = rs.getInt("count") + Integer.parseInt(quantity);
						break;
					}
				}
			} catch (SQLException e) {
			    throw new RuntimeException(e);
			}
			
			//If bought==true, initiate UPDATE instead of INSERT
			if(bought == true)
			{
				try {
					statement.executeUpdate("UPDATE cart_entry SET count = "+count+" WHERE item = "+pid+"");
					
					%><p style="color:green">UPDATED <%=proname %> to Cart</p><%
								
					proname = null;
					catname = null;
					
				} catch (SQLException e) {
					// SQL Error - mostly because of duplicate category name
					%><p style="color:red">UPDATE ERROR: Cannot find product</p><%
				}
			}
			else if(Integer.parseInt(quantity) != 0)
			{
			try {
				statement.executeUpdate("INSERT INTO cart_entry (owner,item,count) VALUES ('"+user_id+"', '"+pid+"', "+quantity+")");

				%><p style="color:green">INSERTED <%= proname %> to Cart</p><%
				
				proname = null;
				catname = null;

			} catch (SQLException e) {
				// SQL Error - mostly because of duplicate category name
				%><p style="color:red">INSERT ERROR: Product exists</p><%
			}
			}
			else
			{
				%><p style="color:red">ADD ERROR: Cannot add 0 products</p><%
				
				proname = null;
				catname = null;
			}
		}
	}
%>

<%-- Form for searching a particular product --%>

<form action="" method="GET">
<fieldset><legend> Search Product </legend>
<b>Product Name: </b> <input type="text" name="proname"><br>
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
	//Show search result if first visit page or submit serach query
   if((submit != null && submit.equals("Search")) || action == null || action.equals("add"))
   {
   		//Case 1: Product name and Category provided
   		if(proname != null && !proname.equals("") && !catname.equals("0"))
   		{
   			try {
      			rs = statement.executeQuery("SELECT products.id,sku,price,products.name AS proname, categories.name AS catname FROM products JOIN categories ON (products.category = categories.id) WHERE (categories.id = '"+catname+"') AND (lower(products.name) LIKE '%"+proname.toLowerCase()+"%')");
      			}
			catch (SQLException e) {
      	    	throw new RuntimeException(e);
      		}
   		}
		//Case 2: Category provided
   		else if(catname != null && !catname.equals("0"))
   		{
   		try {
   			rs = statement.executeQuery("SELECT products.id,sku,price,products.name AS proname, categories.name AS catname FROM products JOIN categories ON (products.category = categories.id) WHERE (categories.id = '"+catname+"')");
   			} 		catch (SQLException e) {
   	    		throw new RuntimeException(e);
   			}
   		}
		//Case 3: Product provided
   		else if(proname != null && !proname.equals("0"))
   		{
   			try {
      			rs = statement.executeQuery("SELECT products.id,sku,price,products.name AS proname, categories.name AS catname FROM products JOIN categories ON (products.category = categories.id) WHERE (lower(products.name) LIKE '%"+proname.toLowerCase()+"%')");
      			} 		catch (SQLException e) {
      	    	throw new RuntimeException(e);
      			}
   		}
		//Case4: Nothing provided, search All products
   		else
		{
   			try {
   				rs = statement.executeQuery("SELECT products.id,sku,price,products.name AS proname, categories.name AS catname FROM products JOIN categories ON (products.category = categories.id)");
   				} 		catch (SQLException e) {
   	    			throw new RuntimeException(e);
   				}
   		}
%>
	<%-- Table showing the search products, added ability to buy them --%>
	<table border = "1" width = "99%">
		<tr>
			<th>Product ID</th>
			<th>Product SKU</th>
			<th>Product Name</th>
			<th>Product Category</th>
			<th>Product Price</th>
            <th>Amount</th>
            <th>Add to Cart</th>
		</tr>
	<%
	while ( rs.next() )
	{
	%>
		<tr>
        	<form action="products.jsp" method="POST">
            <input type="hidden" name="a" value="add"/>
    		<td> <input type = "hidden" value="<%=rs.getString("id")%>" name="pid"/><%=rs.getString("id")%></td>
        	<td> <input type = "hidden" value="<%=rs.getString("sku")%>" name="sku"/><%=rs.getString("sku")%></td>
        	<td> <input type = "hidden" value="<%=rs.getString("proname")%>" name="proname"/><%=rs.getString("proname")%></td>
        	<td> <input type = "hidden" value="<%=rs.getString("catname")%>" name="catname"/><%=rs.getString("catname")%></td>
        	<td> <input type = "hidden" value="<%=rs.getString("price")%>" name="price"/><%=rs.getString("price")%></td>
            <td> <input type="number" min="0" name="quantity" value="0"/></td>
            <td> <input type="submit" value="ADD TO CART"/> </td> 
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