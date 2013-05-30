import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Scanner;
import java.util.Vector;
import java.util.Set;
import java.util.Iterator;
import java.util.HashSet;
import java.io.File;
import java.lang.Math;
import java.io.PrintWriter;
import java.io.FileWriter;
import java.io.IOException;

public class DataGenerator {
	private final static String[] CATEGORIES = { "chair", "table", "computer",
			"keyboard", "burger", "french fries", "bike", "helmet", "couch",
			"mouse", "dog", "cat", "fish", "cell phone", "sweater", "pants",
			"shirt", "underwear", "sandwich", "bagel", "glove", "hat", "wheel",
			"car", "jacket", "coat", "monitor", "pen", "pencil", "paper",
			"notebook", "backpack", "umbrella", "surfboard", "box", "cabinet",
			"trunk", "shoe", "sandal", "glasses", "hoodie", "flowers",
			"sponge", "myster object", "spaghetti sauce", "beef",
			"pork", "shrimp", "scallops" };

	private final static String[] ADJECTIVES = { "smelly", "old", "antiquated",
			"tall", "short", "narrow", "wide", "hoodrat", "turrible",
			"indestructible", "sexy", "invisible", "barf-inducing", "rustic",
			"slimy", "hairy", "new", "sparkly", "ugly", "pretty", "perfect",
			"impeccable", "scratched", "moldy", "wet", "ancient", "modern",
			"cheap", "expensive", "strong", "weak", "boring", "best", "worst",
			"good", "bad", "large", "fast", "strange", "sleek", "smooth",
			"bumpy", "rough", "jagged", "spikey", "warped", "pointy", "tiny",
			"microscopic", "giant" };
	private final static String[] COLORS = { "white", "blue", "green", "red",
			"yellow", "black", "brown", "purple", "teal", "orange", "beige",
			"tan", "maroon", "burgundy", "crimson", "amber", "bronze",
			"fuchsia", "ruby", "aqua", "grey", "pink", "olive", "violet",
			"chartreuse", "chestnut", "salmon", "khaki", "coral", "magenta",
			"lavender", "indigo", "navy", "rose", "silver", "bronze", "gold",
			"copper", "plum", "turquoise", "periwinkle" };

	private final static String[] STATES = { "AL", "AK", "AZ", "AR", "CA",
			"CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS",
			"KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT",
			"NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR",
			"PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV",
			"WI", "WY" };

    private static int M = 10000;

    public static void setM(int m)
    {
        M = m;
    }
    
	private static int getDaysInMonth(int m) {
		assert (m >= 1 && m <= 12);

		if (m == 1 || m == 3 || m == 5 || m == 7 || m == 9 || m == 10
				|| m == 12)
			return 31;
		else if (m == 4 || m == 6 || m == 8 || m == 11)
			return 30;
		else
			return 28;
	}

	private static void getNames(String path, Vector<String> vec) {
		try {
			Scanner reader = new Scanner(new File(path));
			while (reader.hasNextLine()) {
				vec.add((String) reader.nextLine().trim());
			}
		} catch (Exception e) {
			System.out.println("Couldn't getNames for file: " + path);
		}
	}
	
	private static void createMiscTables(Connection conn)
			throws SQLException {
		PreparedStatement createMiscPS = conn
				.prepareStatement("CREATE TABLE roles (id SERIAL PRIMARY KEY, name TEXT NOT NULL); CREATE TABLE states (id SERIAL PRIMARY KEY, name TEXT NOT NULL);");
		if (createMiscPS != null) {
			createMiscPS.execute();
			createMiscPS.close();
		}
		
		PreparedStatement insertStatesPS = conn
				.prepareStatement("INSERT INTO states (name) VALUES (?)");
		if (insertStatesPS != null) {
			for (int i = 0; i < STATES.length; i++) {
				insertStatesPS.setString(1, STATES[i]);
				insertStatesPS.executeUpdate();
			}
			insertStatesPS.close();
		}
		
		PreparedStatement insertRolesPS = conn
				.prepareStatement("INSERT INTO roles (id, name) VALUES (1, 'owner'); INSERT INTO roles (id, name) VALUES (2, 'customer');");
		if (insertRolesPS != null) {
			insertRolesPS.executeUpdate();
			insertStatesPS.close();
		}
	}
	
	private static void createCartTable(Connection conn)
			throws SQLException {
		PreparedStatement createMiscPS = conn
				.prepareStatement("CREATE TABLE cart_entry (id SERIAL PRIMARY KEY, owner INTEGER REFERENCES users (id) NOT NULL, item INTEGER REFERENCES products (id) NOT NULL, count INTEGER NOT NULL);");
		if (createMiscPS != null) {
			createMiscPS.execute();
			createMiscPS.close();
		}
	}

	private static void createCategoriesTable(Connection conn)
			throws SQLException {
		PreparedStatement createCategoriesPS = conn
				.prepareStatement("CREATE TABLE categories (id SERIAL PRIMARY KEY, name TEXT UNIQUE NOT NULL, description TEXT);");
		if (createCategoriesPS != null) {
			createCategoriesPS.execute();
			createCategoriesPS.close();
		}

		PreparedStatement insertCategoryPS = conn
				.prepareStatement("INSERT INTO Categories (name, description) VALUES (?, ?)");
		if (insertCategoryPS != null) {
			for (int i = 0; i < CATEGORIES.length; i++) {
				insertCategoryPS.setString(1, CATEGORIES[i]);
				insertCategoryPS.setString(2, CATEGORIES[i] + " description");
				insertCategoryPS.executeUpdate();
			}
			insertCategoryPS.close();
		}
	}

	private static Object[] createProductsTable(Connection conn)
			throws SQLException {
		final int NUM_PRODUCTS = 10000;
		final int MAX_PRICE = 100000; // 1000 dollars

		//PreparedStatement createProductsPS = conn
		//		.prepareStatement("CREATE TABLE Products (sku SERIAL PRIMARY KEY, name TEXT NOT NULL UNIQUE, cat_id INT REFERENCES Categories (id) NOT NULL, price INT NOT NULL);");
		PreparedStatement createProductsPS = conn
				.prepareStatement("CREATE TABLE products (id SERIAL PRIMARY KEY, name TEXT NOT NULL, sku TEXT UNIQUE NOT NULL, category INTEGER REFERENCES categories (id) NOT NULL, price DECIMAL(10,2) NOT NULL);");
		if (createProductsPS != null) {
			createProductsPS.execute();
			createProductsPS.close();
		}

		Set<Product> ps = new HashSet();
		while (ps.size() < NUM_PRODUCTS) {
			int catId = (int) (Math.random() * CATEGORIES.length);
			String cat = CATEGORIES[catId];
			String adj = ADJECTIVES[(int) (Math.random() * ADJECTIVES.length)];
			String color = COLORS[(int) (Math.random() * COLORS.length)];
			String name = adj + " " + color + " " + cat;
			int price = (int) (Math.random() * MAX_PRICE);

			// +1 bc db will index from 1
			Product p = new Product(name, catId + 1, price);

			int suffix = 1;
			while (ps.contains(p)) {
				p.name = p.name + " " + Integer.toString(suffix++);
			}

			ps.add(p);
		}

		Object[] pArray = ps.toArray();

		PreparedStatement insertProductPS = conn
				.prepareStatement("INSERT INTO products (sku, name, category, price) VALUES (?, ?, ?, ?);");
		if (insertProductPS != null) {
			for (int i = 0; i < pArray.length; i++) {
				Product p = (Product) pArray[i];
				insertProductPS.setString(1, "A"+i);
				insertProductPS.setString(2, p.name);
				insertProductPS.setInt(3, p.catId);
				insertProductPS.setDouble(4, ((double)(p.price)/100.0));
				//insertProductPS.setInt(3, p.price);
				insertProductPS.executeUpdate();
			}
			insertProductPS.close();
		}

		return pArray;
	}

	private static void createCustomersTable(Connection conn,
			Vector<String> firstNames, Vector<String> lastNames, int N)
			throws SQLException {

		//PreparedStatement createCustomersPS = conn
		//		.prepareStatement("CREATE TABLE Customers (id SERIAL PRIMARY KEY, name TEXT NOT NULL, age INT NOT NULL, state CHARACTER(2) NOT NULL);");
		PreparedStatement createCustomersPS = conn
				.prepareStatement("CREATE TABLE users (id SERIAL PRIMARY KEY, name TEXT UNIQUE NOT NULL, age INTEGER, role INTEGER REFERENCES roles (id) NOT NULL, state INTEGER REFERENCES states (id) NOT NULL);");
		if (createCustomersPS != null) {
			createCustomersPS.execute();
			createCustomersPS.close();
		}

		int totalCustomers = M * N;
		final int MAX_AGE = 120;
		Set<Customer> customers = new HashSet<Customer>();

		while (customers.size() < totalCustomers) {
			// create a customer
			String fname = firstNames.get((int) (Math.random() * firstNames
					.size()));
			String mname = lastNames.get((int) (Math.random() * lastNames
					.size()));
			String lname = lastNames.get((int) (Math.random() * lastNames
					.size()));
			String name = fname + " " + mname + " " + lname;
			int st = (int) (Math.random() * STATES.length) + 1;
			int age = (int) (Math.random() * MAX_AGE);

			Customer c = new Customer(name, st, age);
			int suffix = 1;
			while (customers.contains(c)) {
				c.name = c.name + " " + Integer.toString(suffix++);// change
																	// name to
																	// have a
																	// unique
																	// number
			}

			customers.add(c);
		}

		Iterator<Customer> iter = customers.iterator();
		PreparedStatement insertCustomerPS = conn
				.prepareStatement("INSERT INTO users (name, age, state, role) VALUES (?, ?, ?, ?)");
		if (insertCustomerPS != null) {
			while (iter.hasNext()) {
				Customer c = iter.next();
				insertCustomerPS.setString(1, c.name);
				insertCustomerPS.setInt(2, c.age);
				insertCustomerPS.setInt(3, c.state);
				insertCustomerPS.setInt(4, 2);
				insertCustomerPS.executeUpdate();
			}
			insertCustomerPS.close();
		}
	}

	// needs productsLength, needs customersLength
	private static void createSalesTable(Connection conn, Object[] pArr, int N) throws SQLException {
		final int MAX_QUANT = 10;
		final int NUM_MONTHS = 12;
		final int NUM_SALES = N * M * 100;
		final int NUM_PRODUCTS_PER_CUSTOMER = 20;
		final int NUM_SALES_PER_PRODUCT_PER_CUSTOMER = 5;

		PreparedStatement createSalesPS = conn
				.prepareStatement("CREATE TABLE sales (id SERIAL PRIMARY KEY, product_id INT REFERENCES products (id) NOT NULL, customer_id INT REFERENCES users (id) NOT NULL, day INT NOT NULL, month INT NOT NULL, quantity INT NOT NULL, total_cost DECIMAL(10,2) NOT NULL);");
		if (createSalesPS != null) {
			createSalesPS.execute();
			createSalesPS.close();
		}

		int numQueries = 0;
		PreparedStatement insertSalePS = conn
				.prepareStatement("INSERT INTO sales (product_id, customer_id, day, month, quantity, total_cost) VALUES (?, ?, ?, ?, ?, ?)");
		if (insertSalePS != null) {
			for (int curCustomer = 1; curCustomer <= N * M; curCustomer++) {
				for (int i = 0; i < NUM_PRODUCTS_PER_CUSTOMER; i++) {
					int pId = (int) (Math.random() * pArr.length);
					Product product = (Product) pArr[pId];

					for (int j = 0; j < NUM_SALES_PER_PRODUCT_PER_CUSTOMER; j++) {
						int month = (int) (Math.random() * NUM_MONTHS) + 1;
						int day = (int) (Math.random() * getDaysInMonth(month)) + 1;
						int quantity = (int) (Math.random() * MAX_QUANT) + 1;

						int totalPrice = product.price * quantity;

						insertSalePS.setInt(1, pId + 1);
						insertSalePS.setInt(2, curCustomer);
						insertSalePS.setInt(3, day);
						insertSalePS.setInt(4, month);
						insertSalePS.setInt(5, quantity);
						insertSalePS.setDouble(6, ((double)(totalPrice)/100.0));

						insertSalePS.executeUpdate();

                        if(numQueries % 1000 == 0) conn.commit();
						numQueries++;
					}
				}
			}
			insertSalePS.close();
		}
		assert (numQueries == NUM_SALES);
	}

	// Math.random() * 5
	/*
	 * a customer table with N * 1M tuples with uniform and independent
	 * distribution over age groups and states 50 product categories a product
	 * table with 10K products a sales table with N * 100M columns (Product,
	 * Customer, Date, Quantity), with dates uniformly distributed over last
	 * year, quantity uniformly distributed over 1-10. Each customer purchases
	 * only 20 randomly selected products and makes 5*20 purchases during the
	 * year (5*20 = 100M / 1M)
	 */
	public static void main(String[] args) {
		Vector<String> firstNames = new Vector<String>();
		Vector<String> lastNames = new Vector<String>();
		String outDir = new String("");

		getNames("FirstNames.txt", firstNames);
		getNames("LastNames.txt", lastNames);

		int n = -1;
        int m = -1;
		String server = null;
		int port = -1;
		String dbName = null;
		String username = null;
		String password = null;

		System.out.println("size of CATEGORIES: " + CATEGORIES.length);
		System.out.println("size of ADJECTIVES: " + ADJECTIVES.length);
		System.out.println("size of COLORS:" + COLORS.length);
		System.out.println("size of firstNames:" + firstNames.size());
		System.out.println("size of lastNames:" + lastNames.size());

		Scanner reader = new Scanner(System.in);
		while (n < 0) {
			System.out.println("Please specify an N value, where #Customers = N * M and #Sales = N * M * 100:");
			try {
				n = Integer.parseInt(reader.nextLine().trim());
			} catch (Exception e) {
				System.out.println("Try again.");
			}
		}
		System.out.println("n was chosen to be: " + n);

		while (m < 0) {
			System.out.println("Please specify an M value, where #Customers = N * M and #Sales = N * M * 100:");
			try {
				m = Integer.parseInt(reader.nextLine().trim());
			} catch (Exception e) {
				System.out.println("Try again.");
			}
		}
		System.out.println("m was chosen to be: " + m);
		
		System.out.println("Please specify a server [localhost]:");
		String serverString = reader.nextLine().trim();
		if(serverString.length() == 0) 
			server = "localhost";
		else
			server = serverString;
		
		System.out.println("Please specify a port [5432]:");
		String portString = reader.nextLine().trim();
		if(portString.length() == 0) 
		{
			port = 5432;
		}
		else
		{
			try
			{
				port = Integer.parseInt(portString);
			}
			catch(NumberFormatException e)
			{
				port = 5432;
			}
		}
		
		System.out.println("Please specify a database name [cse135]:");
		String dbNameString = reader.nextLine().trim();
		if(dbNameString.length() == 0) 
			dbName = "cse135";
		else
			dbName = dbNameString;
		
		System.out.println("Please specify a user name [postgres]:");
		String userNameString = reader.nextLine().trim();
		if(userNameString.length() == 0) 
			username = "postgres";
		else
			username = userNameString;
		
		System.out.println("Please specify a password [postgres]:");
		String passwordString = reader.nextLine().trim();
		if(passwordString.length() == 0) 
			password = "postgres";
		else
			password = userNameString;
		
		String connString = "jdbc:postgresql://" + server + ":" + Integer.toString(port) + "/" + dbName;
		
		System.out.println("connection string: " + connString);
		System.out.println("username: " + username);
		System.out.println("password: " + password);
		
		Connection conn = null;
		try {
			Class.forName("org.postgresql.Driver");
			conn = DriverManager.getConnection(connString, username, password);

            conn.setAutoCommit(false);
            DataGenerator.setM(m);
            createMiscTables(conn);
            conn.commit();
			createCustomersTable(conn, firstNames, lastNames, n);
            conn.commit();
			createCategoriesTable(conn);
            conn.commit();
			Object[] ps = null;
			ps = createProductsTable(conn);
			assert (ps != null);
			
			createCartTable(conn);
            conn.commit();

            conn.commit();
			createSalesTable(conn, ps, n);

            conn.commit();

			System.out.println("Success...?");
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Failed.");
		}
	}
}
