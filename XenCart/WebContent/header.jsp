<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@include file="db.jsp" %>
<% 
session = request.getSession();
String user_name = (String)session.getAttribute("user");
int user_age = 0;
int user_role = 0; // Guest = 0
String user_state = "";

if ( user_name != null ) {
	try {
		rs = statement.executeQuery("SELECT users.age, users.role, states.name FROM users, states WHERE users.state = states.id AND users.name = '"+user_name+"';");
	} catch (SQLException e) {
	    throw new RuntimeException(e);
	}
	if ( rs.next() ) {
		user_age = rs.getInt("age");
		user_role = rs.getInt("role");
		user_state = rs.getString("name");
	} else {
		// Incorrect user name!
		user_name = null;
	}
}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>XenCart</title>
<style type="text/css">
A:link {
FONT-SIZE: 12px; 
COLOR: #4D4D4D; 
FONT-FAMILY:  Tahoma, Verdana; 
TEXT-DECORATION: none
}
A:visited {
FONT-SIZE: 12px; 
COLOR: #4D4D4D; 
FONT-FAMILY:  Tahoma, Verdana; 
TEXT-DECORATION: none
}
A:active {
FONT-SIZE: 12px; 
COLOR: #4D4D4D; 
FONT-FAMILY:  Tahoma, Verdana; 
TEXT-DECORATION: none
}
A:hover {
FONT-SIZE: 12px; 
COLOR: #4F5AC1; 
FONT-FAMILY:  Tahoma, Verdana; 
TEXT-DECORATION: none
}

body { font-family: Tahoma, Verdana; color: #757575; font-size: 12px; }

td {
	font-size: 9pt;
}

.menulink {
	font-weight: bold;
}
.menulinkinfo {
	font-size: 9pt;
}
</style>
</head>
<body>
<h1>XenCart</h1>
Welcome, <%=user_name==null?"Guest":user_name%>!
<hr>
<b><a href="login.jsp">Login</a> | </b>
<% if (user_role == 0) { %>
<b><a href="signup.jsp">Sign-up</a></b>
<% } else if (user_role == 1) { %>
<b><a href="man_categories.jsp">Manage Categories</a></b> |
<b><a href="man_products.jsp">Manage Products</a></b>
<% } else { %>
<b><a href="products.jsp">Browse Products</a></b> |
<b><a href="cart.jsp">View Shopping Cart</a></b>
<% } %>
<hr>

