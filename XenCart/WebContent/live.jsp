<% String page_title="Today's Live Sales"; %>


<%@include file="header.jsp" %>

<!--  Right now this only shows one category with table ids = statename_categoryname -->
<h1> Overview of today's sales</h1>
<table id = "livesales" style="border: 0px;">

	<%-- Get States --%>
	<tr id = "states">
	<th colspan = "1"  style="border: 0px;">
	State / Product Category </th>
		<%
			try {
				rs = statement.executeQuery("SELECT states.name, id FROM states");
			} catch (SQLException e) {
			    throw new RuntimeException(e);
			}
			while (rs.next()) {
		%>
		<th value="<%=rs.getInt("id")%>" colspan = "1"><%=rs.getString("name") %>_ <%=rs.getString("id")%></th> <% } %>
	 <%-- end states --%>
	
	<%-- Get List of Products and display in table --%>
	<%
			try {
				String sqlquery = "SELECT id, name FROM categories ";
		    	rs = statement.executeQuery(sqlquery);
			} catch (SQLException e) {
			    throw new RuntimeException(e);
			}
			while(rs.next()) { 
				
			int curr_cat_id = rs.getInt("id");
			String curr_cat_name = rs.getString("name");
		%>
		<tr><td value="curr_cat_id" > <%=curr_cat_id %> <%=curr_cat_name %> </td> 
		
	<%-- EXTRACT(DAY FROM CURRENT_DATE), EXTRACT(MONTH FROM CURRENT_DATE)  --%>
	<%-- For each category, get total sales for each state --%>
						<%
						int num_states = 50;
						
						int curr_state = 1;
			
						try {
							rs = statement.executeQuery("SELECT id as st_id, name as st_nm FROM states");
						} catch (SQLException e) {
							throw new RuntimeException(e);
						}
						
						//for (curr_state=1; curr_state <= num_states; ++curr_state) {
							while(rs.next()){
							%>
							<!-- td id = state.name_category.name -->
							<td id = "<%=rs.getString("st_nm")%>_<%=curr_cat_name %>"> <%=rs.getString("st_nm")%>_<%=curr_cat_name %></td> <!--Insert today's current sales in this table-->
							
							<%
							}// for loop
						}
	%>
		</tr>
	
</table>

<%@include file="footer.inc" %>