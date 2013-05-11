CREATE TABLE roles (
   id		SERIAL PRIMARY KEY,
   name		TEXT NOT NULL
);

CREATE TABLE states (
   id		SERIAL PRIMARY KEY,
   name		TEXT NOT NULL
);

CREATE TABLE users (
   id		SERIAL PRIMARY KEY,
   name		TEXT UNIQUE NOT NULL,
   age		INTEGER,
   role		INTEGER REFERENCES roles (id) NOT NULL,
   state	INTEGER REFERENCES states (id) NOT NULL
);

CREATE TABLE categories (
   id		SERIAL PRIMARY KEY,
   name		TEXT UNIQUE NOT NULL,
   description	TEXT,
   products	INTEGER DEFAULT 0
);

CREATE TABLE products (
   id		SERIAL PRIMARY KEY,
   name		TEXT NOT NULL,
   sku		TEXT UNIQUE NOT NULL,
   category	INTEGER REFERENCES categories (id) NOT NULL,
   price	DECIMAL(10,2) NOT NULL
);

CREATE TABLE cart_entry (
   id		SERIAL PRIMARY KEY,
   owner	INTEGER REFERENCES users (id) NOT NULL,
   item		INTEGER REFERENCES products (id) NOT NULL,
   count	INTEGER NOT NULL
);

