<% String page_title="Live Sales"; %>
<%@include file="header.jsp" %>
<%@page import="java.util.*" %>

<%
int lastupdate = 0;
try {
	rs = statement.executeQuery("SELECT id FROM sales ORDER BY id DESC LIMIT 1");
	if (rs.next())
		lastupdate = rs.getInt(1);
	
} catch (SQLException e) {
	throw new RuntimeException(e);
}
%>
<script>lastupdate=<%=lastupdate %>;
setInterval(function(){makeRequest();}, 2000);</script>
<h2>Live Sales (Today)</h2>
<%
	// Load states from db
	LinkedList<String> states = new LinkedList<String>();
	try {
		rs = statement.executeQuery("SELECT name FROM states");
		while (rs.next())
			states.add(rs.getString(1));
	} catch (SQLException e) {
		throw new RuntimeException(e);
	}
	
	Calendar cal = Calendar.getInstance();
	try {
		rs = statement.executeQuery("SELECT categories.id, categories.name, states.id, SUM(total_cost) "+
				"FROM sales, states, products, users, categories "+
				"WHERE sales.day = "+cal.get(Calendar.DAY_OF_MONTH)+" AND sales.month = "+(cal.get(Calendar.MONTH)+1)+" AND sales.product_id = products.id AND "+
				"states.id = users.state AND products.category = categories.id AND users.id = sales.customer_id "+
				"GROUP BY states.id, categories.id ORDER BY categories.name, states.id");
%>
<div id="connection_lost" style="display: none;">
<p style="color:red">Connection to Server Lost!</p>
</div>

<%-- Table showing the data --%>
<table border = "1" width = "99%">
<tr><th>Categories\States</th>
<% 
		for (String s : states)
			out.print("<th>"+s+"</th>");
%>
</tr>
<%
		int last_cat = -1;
		int last_state = 0, this_state;
		int this_cat;
		while (rs.next()) {
			if ( rs.getInt(1) != last_cat ) {
				if ( last_cat != -1 ) {
					// Finish up last row
					while (last_state < 50) {
						++last_state;
						out.println("<td><span id=\""+rs.getInt(1)+"."+last_state+"\"></span></td>");
					}
					out.println("</tr>");
				}
				
				// New Row
				out.println("</tr><tr><th>"+rs.getString(2)+"</th>");
				last_cat = rs.getInt(1);
				last_state = 0;
			}
			
			this_state = rs.getInt(3);
			while (last_state < (this_state-1)) {
				++last_state;
				out.println("<td><span id=\""+last_cat+"."+last_state+"\"></span></td>");
			}
			out.println("<td><span id=\""+last_cat+"."+this_state+"\">$"+rs.getString(4)+"</span></td>");
			
			last_state = this_state;
		}
		while (last_state < 50) {
			++last_state;
			out.println("<td><span id=\""+last_cat+"."+last_state+"\"></span></td>");
		}
%>
</tr>
</table>
<%
	// End try block
	} catch (SQLException e) {
		throw new RuntimeException(e);
	}
%>
<%@include file="footer.inc" %>