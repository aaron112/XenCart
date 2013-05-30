Phase 2:
We have chosen to create 2 tables: sales_total_by_product and (sales_total_by_state OR sales_total_by_user).
The above tables stores their ranks and total amount of purchase, which later becomes the row and column of the view.

Program Architecture for XenCart (Phase 1):
db.jsp				- Handles database connections, included by header.jsp
header.jsp			- JSP and HTML Header for all pages, initializes common variables like current user
footer.inc			- Footer for all pages, to close database connection
index.jsp			- Place holder for the main page. Currently consist of a welcome sentence.
signup.jsp			- Page for signing up as a user
login.jsp			- Login Page
man_categories.jsp	- (For owner) Manages categories (Insert/Update/Delete)
man_products.jsp	- (For owner) Manages products (Insert/Update/Delete)
products.jsp		- (For customer) Browse Products
showpurchase.inc	- A jsp fragment that shows the content in cart.
cart.jsp			- (For customer) Shows the cart and offers an option to purchase.
confirm.jsp			- (For customer) Shows the cart then clear it. Simulating a completed order.