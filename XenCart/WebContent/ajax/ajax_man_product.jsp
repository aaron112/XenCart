<%@include file="../db.jsp" %><%@page import="java.util.*, org.json.simple.JSONObject, java.text.*" %><%
	String action = (String) request.getParameter("a");
	String proname = (String) request.getParameter("proname");
	String catid = (String) request.getParameter("catid");
	String sku = (String) request.getParameter("sku");
	String price = (String) request.getParameter("price");
	//String submit = (String) request.getParameter("Submit");
	String pid = (String) request.getParameter("id");
	JSONObject result = new JSONObject();

	LinkedHashMap<Integer, String> categories = new LinkedHashMap<Integer, String>();
	
	int parsed_catid = -1;
	try {
		parsed_catid = Integer.parseInt(catid);
	} catch (Exception e) {};
	
	try {
		rs = statement.executeQuery("SELECT name,id FROM categories ORDER BY id ASC");
	} catch (SQLException e) {
		throw new RuntimeException(e);
	}
	
	while ( rs.next() ) {
		// Save result up to a HashMap
		categories.put(rs.getInt("id"), rs.getString("name"));
	}

	if(action != null && action.equals("INSERT")) {
		//check product name
		if(proname != null && !proname.equals("")) {
			//check sku
			if(sku != null && !sku.equals("")) {
				//check price
				if(price != null && Double.parseDouble(price) >= 0) {
					try {
					statement.executeUpdate("INSERT INTO products (name, sku, category, price) VALUES ('"+proname+"', '"+sku+"', '"+catid+"','"+price+"')");
					rs = statement.executeQuery("SELECT id FROM products WHERE name = '"+proname+"'");
					DecimalFormat df = new DecimalFormat("#.00");
					result.put("print", "Product "+proname+" CREATED.\n SKU: "+sku+"\n Category: "+categories.get(Integer.parseInt(catid))+"\nPrice: "+price);
					result.put("proname", proname);
					result.put("sku", sku);
					result.put("price", (String) df.format(Double.parseDouble(price)));
					result.put("catid", parsed_catid);
					while(rs.next())
					{
						result.put("pid", rs.getString("id"));
					}
					result.put("success", true);
					out.print(result);
					out.flush();
					
					} catch (SQLException e) {
						// SQL Error - mostly because of duplicate category name

						result.put("print", "INSERT ERROR: Duplicate product name or SKU!");
						result.put("success", false);
						result.put("error", e.toString());
						out.print(result);
						out.flush();
					}
				} else { 
					result.put("print", "INSERT ERROR: Price error!");
					result.put("success", false);
					out.print(result);
					out.flush();
				}
			} else {						
				result.put("print", "INSERT ERROR: SKU error!");
				result.put("success", false);
				out.print(result);
				out.flush();
			}
		} else {
			result.put("print", "INSERT ERROR: Product name error!");
			result.put("success", false);
			out.print(result);
			out.flush();
		}
		//submit = "Search";
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
							statement.executeUpdate("UPDATE products SET name='"+proname+"', sku='"+sku+"', category= '"+catid+"', price='"+price+"' WHERE id = '"+pid+"'");
							
							DecimalFormat df = new DecimalFormat("#.00");
							result.put("print", "Product "+proname+" UPDATED.");
							result.put("proname", proname);
							result.put("sku", sku);
							result.put("price", (String) df.format(Double.parseDouble(price)));
							result.put("catid", parsed_catid);
							result.put("success", true);
							out.print(result);
							out.flush();
						} catch (SQLException e) {
						// SQL Error - mostly because of duplicate category name
							result.put("print", "Wrong category name!");
							result.put("success", true);
							out.print(result);
							out.flush();
						}
					else
					{
						result.put("print", "UPDATE ERROR: Price error!");
						result.put("success", true);
						out.print(result);
						out.flush();
					}
					
				}
				else
				{
					result.put("print", "UPDATE ERROR: SKU error!");
					result.put("success", true);
					out.print(result);
					out.flush();
				}
			}
			else
			{
				result.put("print", "UPDATE ERROR: Product name error!");
				result.put("success", true);
				out.print(result);
				out.flush();
			}
	}
	if(action != null && action.equals("DELETE"))
	{
		//check product name
				
		try {
			// Remove from this product from all carts first!
			statement.executeUpdate("DELETE FROM cart_entry WHERE item = '"+pid+"'");
			statement.executeUpdate("DELETE FROM products WHERE id = '"+pid+"'");

			result.put("print", "Product "+proname+" DELETED.");
			result.put("success", true);
			result.put("deleted", true);
			out.print(result);
			out.flush();
				
			} catch (SQLException e) {
			// SQL Error - mostly because of duplicate category name
			result.put("print", "DELETE ERROR: Product does not exist or still referenced by a slaes record.");
			result.put("success", false);
			result.put("deleted", false);
			out.print(result);
			out.flush();
			}
			//submit = "Search";
			catid = null;
			proname = null;

	}
	if(action != null && action.equals("GET_CATEGORIES"))
	{
		for (Map.Entry<Integer, String> entry : categories.entrySet()) {
  			result.put("cid", entry.getKey());
  			result.put("cname", entry.getValue());
  			out.println(result);
  		}
		out.flush();
	}
%>