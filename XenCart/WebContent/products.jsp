<% String page_title="Browse Products"; %>
<%@include file="header.jsp" %>
<%@page import="java.util.*" %>
<h2>Browse Products</h2>
<%
	//Parse the parameters coming in
	String action = (String) request.getParameter("a");
	String proname = (String) request.getParameter("proname");
	String catid = (String) request.getParameter("catid");
	String sku = (String) request.getParameter("sku");
	String pid = (String) request.getParameter("pid");
	String quantity = (String) request.getParameter("quantity");
	String submit = (String) request.getParameter("Submit");
	String pagenum = (String) request.getParameter("pg");
	LinkedHashMap<Integer, String> categories = new LinkedHashMap<Integer, String>();
	
	int parsed_catid = -1;
	try {
		parsed_catid = Integer.parseInt(catid);
	} catch (Exception e) {};
	
	//When the user wants to add products to the shopping cart
	if(action != null && action.equals("add"))
	{
		if(pid != null && !pid.equals("")) {
			int bought_count = 0;
			
			try {
				rs = statement.executeQuery("SELECT count FROM cart_entry WHERE owner = '"+user_id+"' AND item = '"+pid+"';");
				
				//Checks if it is already in cart_entry
				if ( rs.next() )
					bought_count = rs.getInt("count"); 
				
			} catch (SQLException e) {
			    throw new RuntimeException(e);
			}
			
			//If bought_count > 0, initiate UPDATE instead of INSERT
			if( bought_count > 0 ) {
				try {
					statement.executeUpdate("UPDATE cart_entry SET count = "+(bought_count+Integer.parseInt(quantity))+" WHERE item = "+pid+"");
					%><p style="color:green">ADDED <%=proname %> to Cart</p><%
					
				} catch (SQLException e) {
					// SQL Error - mostly because of duplicate category name
					%><p style="color:red">UPDATE ERROR: Cannot find product</p><%
				}
			} else if(Integer.parseInt(quantity) != 0) {
				try {
					statement.executeUpdate("INSERT INTO cart_entry (owner,item,count) VALUES ('"+user_id+"', '"+pid+"', "+quantity+")");
					%><p style="color:green">ADDED <%= proname %> to Cart</p><%

				} catch (SQLException e) {
					// SQL Error - mostly because of duplicate category name
					%><p style="color:red">INSERT ERROR: Product exists</p><%
				}
			} else {
				%><p style="color:red">ADD ERROR: Cannot add 0 products</p><%
			}

			proname = null;
			catid = null;
		}
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
		
		%><a href="?catid=<%=rs.getInt("id")%><%=proname!=null?"&proname="+proname:"" %>"><%=rs.getString("name") %></a>
		<% if ( parsed_catid == rs.getInt("id") ) out.println(" <b><-</b>"); %>
		</br><%
	}
%>
</td>
<td>

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
    	// Build Query
    	boolean criteriaSpecified = false;
    	int offset = 0, pg = 0;
    	String sqlquery = "SELECT * FROM products ";
    	
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
	    sqlquery += " ORDER BY id ASC LIMIT "+LIMIT+" OFFSET "+offset;
	   
	    try {
	    	rs = statement.executeQuery(sqlquery);
	    } catch (SQLException e) {
 	    	throw new RuntimeException(e);
 		}
%>

	<%-- Table showing the search products, added ability to buy them --%>
	<table border = "1" width = "99%">
		<tr>
			<th>Product ID</th>
			<th>SKU</th>
			<th>Name</th>
			<th>Category</th>
			<th>Unit Price</th>
            <th>Quantity</th>
            <th>Actions</th>
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
        	<td> <input type = "hidden" value="<%=rs.getString("name")%>" name="proname"/><%=rs.getString("name")%></td>
        	<td> <input type = "hidden" value="<%=rs.getString("category")%>" name="catname"/><%=categories.get( rs.getInt("category") )%></td>
        	<td> <input type = "hidden" value="<%=rs.getString("price")%>" name="price"/>$<%=rs.getString("price")%></td>
            <td> <input type="number" min="0" name="quantity" value="0"/></td>
            <td> <input type="submit" value="ADD TO CART"/> </td> 
            </form>
    	</tr>
	<%
	}
	%>
	</table>
    <p align="right">
    	<input type="button" value="Previous 20 Products" onClick="javascript:location.href='?catid=<%=catid==null?"":catid%>&proname=<%=proname==null?"":proname%>&pg=<%=Integer.toString(pg-1)%>'">
    	<input type="button" value="Next 20 Products" onClick="javascript:location.href='?catid=<%=catid==null?"":catid%>&proname=<%=proname==null?"":proname%>&pg=<%=Integer.toString(pg+1)%>'">
    </p>	
</td></tr></table>
<%@include file="footer.inc" %>