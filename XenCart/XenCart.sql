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
   description	TEXT
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

CREATE TABLE sales (
	id 			SERIAL PRIMARY KEY,
	product_id	INT REFERENCES products (id) NOT NULL,
	customer_id	INT REFERENCES users (id) NOT NULL,
	day			INT NOT NULL,
	month		INT NOT NULL,
	quantity	INT NOT NULL,
	total_cost	DECIMAL(10,2) NOT NULL
);

COPY roles (id, name) FROM stdin;
1	owner
2	customer
\.

COPY states (id, name) FROM stdin;
1	AL
2	AK
3	AZ
4	AR
5	CA
6	CO
7	CT
8	DE
9 	FL
10	GA
11	HI
12	ID
13	IL
14	IN
15	IA
16	KS
17	KY
18	LA
19	ME
20	MD
21	MA
22	MI
23	MN
24	MS
25	MO
26	MT
27	NE
28	NV
29	NH
30	NJ
31	NM
32	NY
33	NC
34	ND
35	OH
36	OK
37	OR
38	PA
39	RI
40	SC
41	SD
42	TN
43	TX
44	UT
45	VT
46	VA
47	WA
48	WV
49	WI
50	WY
\.
