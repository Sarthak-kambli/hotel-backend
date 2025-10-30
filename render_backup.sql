--
-- PostgreSQL database dump
--

\restrict 0TNAqGj8bFROvhWOhSUGogeS2zQrLibhPzHMZAWLDyJlT4vtJenpDd3mbAxGbmg

-- Dumped from database version 17.6 (Debian 17.6-1.pgdg12+1)
-- Dumped by pg_dump version 17.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: sarthak
--

-- *not* creating schema, since initdb creates it



SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: bills; Type: TABLE; Schema: public; Owner: sarthak
--

CREATE TABLE public.bills (
    id integer NOT NULL,
    order_id integer NOT NULL,
    total_amount numeric(10,2) NOT NULL,
    status character varying(20) DEFAULT 'unpaid'::character varying,
    generated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);



--
-- Name: bills_id_seq; Type: SEQUENCE; Schema: public; Owner: sarthak
--

CREATE SEQUENCE public.bills_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: bills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sarthak
--

ALTER SEQUENCE public.bills_id_seq OWNED BY public.bills.id;


--
-- Name: bookings; Type: TABLE; Schema: public; Owner: sarthak
--

CREATE TABLE public.bookings (
    id integer NOT NULL,
    name text NOT NULL,
    phone text,
    date date NOT NULL,
    "time" time without time zone,
    guests integer,
    table_id integer,
    created_at timestamp without time zone DEFAULT now()
);



--
-- Name: bookings_id_seq; Type: SEQUENCE; Schema: public; Owner: sarthak
--

CREATE SEQUENCE public.bookings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: bookings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sarthak
--

ALTER SEQUENCE public.bookings_id_seq OWNED BY public.bookings.id;


--
-- Name: menu_items; Type: TABLE; Schema: public; Owner: sarthak
--

CREATE TABLE public.menu_items (
    id integer NOT NULL,
    name text NOT NULL,
    description text,
    price numeric(10,2) NOT NULL,
    category text,
    created_at timestamp without time zone DEFAULT now()
);



--
-- Name: menu_items_id_seq; Type: SEQUENCE; Schema: public; Owner: sarthak
--

CREATE SEQUENCE public.menu_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: menu_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sarthak
--

ALTER SEQUENCE public.menu_items_id_seq OWNED BY public.menu_items.id;


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: sarthak
--

CREATE TABLE public.order_items (
    id integer NOT NULL,
    order_id integer,
    menu_item_id integer,
    quantity integer,
    unit_price numeric(10,2)
);



--
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: sarthak
--

CREATE SEQUENCE public.order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sarthak
--

ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: sarthak
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    user_id integer,
    table_id integer,
    total_amount numeric(10,2),
    status character varying(50) DEFAULT 'pending'::character varying,
    order_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);



--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: sarthak
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sarthak
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: sarthak
--

CREATE TABLE public.payments (
    payment_id integer NOT NULL,
    bill_id integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    method character varying(50) NOT NULL,
    status character varying(20) DEFAULT 'pending'::character varying,
    paid_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);



--
-- Name: payments_payment_id_seq; Type: SEQUENCE; Schema: public; Owner: sarthak
--

CREATE SEQUENCE public.payments_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: payments_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sarthak
--

ALTER SEQUENCE public.payments_payment_id_seq OWNED BY public.payments.payment_id;


--
-- Name: restaurant_tables; Type: TABLE; Schema: public; Owner: sarthak
--

CREATE TABLE public.restaurant_tables (
    id integer NOT NULL,
    table_number integer NOT NULL,
    capacity integer NOT NULL,
    status character varying(50) DEFAULT 'available'::character varying
);



--
-- Name: restaurant_tables_id_seq; Type: SEQUENCE; Schema: public; Owner: sarthak
--

CREATE SEQUENCE public.restaurant_tables_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: restaurant_tables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sarthak
--

ALTER SEQUENCE public.restaurant_tables_id_seq OWNED BY public.restaurant_tables.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: sarthak
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    password character varying(100) NOT NULL,
    role character varying(50) NOT NULL
);



--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: sarthak
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sarthak
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: bills id; Type: DEFAULT; Schema: public; Owner: sarthak
--

ALTER TABLE ONLY public.bills ALTER COLUMN id SET DEFAULT nextval('public.bills_id_seq'::regclass);


--
-- Name: bookings id; Type: DEFAULT; Schema: public; Owner: sarthak
--

ALTER TABLE ONLY public.bookings ALTER COLUMN id SET DEFAULT nextval('public.bookings_id_seq'::regclass);


--
-- Name: menu_items id; Type: DEFAULT; Schema: public; Owner: sarthak
--

ALTER TABLE ONLY public.menu_items ALTER COLUMN id SET DEFAULT nextval('public.menu_items_id_seq'::regclass);


--
-- Name: order_items id; Type: DEFAULT; Schema: public; Owner: sarthak
--

ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: sarthak
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: payments payment_id; Type: DEFAULT; Schema: public; Owner: sarthak
--

ALTER TABLE ONLY public.payments ALTER COLUMN payment_id SET DEFAULT nextval('public.payments_payment_id_seq'::regclass);


--
-- Name: restaurant_tables id; Type: DEFAULT; Schema: public; Owner: sarthak
--

ALTER TABLE ONLY public.restaurant_tables ALTER COLUMN id SET DEFAULT nextval('public.restaurant_tables_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: sarthak
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: bills; Type: TABLE DATA; Schema: public; Owner: sarthak
--

COPY public.bills (id, order_id, total_amount, status, generated_at) FROM stdin;
3	4	750.00	paid	2025-09-26 16:46:38.118084
4	12	160.00	paid	2025-09-26 16:46:46.601252
2	6	60.00	paid	2025-09-26 16:46:19.044957
5	5	40.00	paid	2025-09-26 16:47:16.231595
\.


--
-- Data for Name: bookings; Type: TABLE DATA; Schema: public; Owner: sarthak
--

COPY public.bookings (id, name, phone, date, "time", guests, table_id, created_at) FROM stdin;
8	Aditi	2638231097	2025-09-30	20:00:00	6	1	2025-09-25 00:16:46.986104
17	Tanmay Kharat	9488653707	2025-10-05	12:00:00	5	5	2025-09-25 00:51:25.334112
7	Sarthak Kambli	9876230815	2025-09-21	22:00:00	2	6	2025-09-21 16:03:17.593469
18	adit santosh shewale	1234567890	2025-10-23	06:04:00	5	\N	2025-10-22 14:34:20.479698
19	lily	1234567890	2025-10-23	23:54:00	6	\N	2025-10-22 16:24:58.752298
20	lily	1234567890	2025-10-30	23:55:00	1	\N	2025-10-22 16:25:30.61858
21	lily	1234567890	2025-10-30	23:56:00	1	\N	2025-10-22 16:26:28.463739
22	lily	1234567890	2025-10-23	23:02:00	1	\N	2025-10-22 16:32:35.393614
23	lily	1234567890	2025-10-23	09:15:00	9	\N	2025-10-22 16:45:59.856926
\.


--
-- Data for Name: menu_items; Type: TABLE DATA; Schema: public; Owner: sarthak
--

COPY public.menu_items (id, name, description, price, category, created_at) FROM stdin;
2	Tea	Hot	20.00	breakfast	2025-09-21 15:06:08.609662
4	Idli	Only Sambhar	60.00	South-Indian Breakfast	2025-09-21 16:16:39.831355
3	Coffee	one by two	80.00	breakfast	2025-09-21 15:10:19.270871
7	Panner Chilly		220.00	Veg Starter	2025-09-23 19:39:16.601612
8	Panner Masala	Spicy	250.00	Veg Maincourse	2025-09-23 19:40:02.213809
5	Pizza	Cheese Burst Pizza	250.00	Italian Cuisine	2025-09-22 17:19:11.506814
9	Wada Pav		20.00	Breakfast	2025-09-29 14:45:54.482135
10	Kanda Bhaji		60.00	Breakfast	2025-09-29 14:49:02.504758
11	Batata Bhaji		50.00	Breakfast	2025-09-29 14:49:33.555635
12	Misal Pav		70.00	Breakfast	2025-09-29 14:50:12.868403
13	Dahi Misal		80.00	Breakfast	2025-09-29 14:50:38.74389
14	Usal Pav		50.00	Breakfast	2025-09-29 14:51:10.452087
15	Wada Rassa		70.00	Breakfast	2025-09-29 14:51:55.912463
16	Puri Bhaji		80.00	Breakfast	2025-09-29 14:52:52.706575
17	Kanda Poha		40.00	Breakfast	2025-09-29 14:53:31.299255
18	Shira		40.00	Breakfast	2025-09-29 14:53:58.073412
19	Upma		40.00	Breakfast	2025-09-29 14:54:17.377627
20	Idli Sambar		70.00	Breakfast	2025-09-29 14:55:03.604317
21	Wada Sambar		80.00	Breakfast	2025-09-29 14:56:21.32613
22	Dahi Wada		80.00	Breakfast	2025-09-29 14:56:52.111641
23	Sada Dosa		80.00	Breakfast	2025-09-29 14:57:27.415464
24	Masala Dosa		90.00	Breakfast	2025-09-29 14:58:06.433404
25	Rawa Dosa		120.00	Breakfast	2025-09-29 14:58:30.605044
26	Mysore Masala Dosa		120.00	Breakfast	2025-09-29 14:59:38.478849
27	Schezwan Dosa		120.00	Breakfast	2025-09-29 15:00:33.459834
28	Cheese Dosa		150.00	Breakfast	2025-09-29 15:01:03.562006
29	Paneer Dosa		140.00	Breakfast	2025-09-29 15:03:15.044929
30	Paper Dosa		120.00	Breakfast	2025-09-29 15:04:32.270486
31	Paper Masala Dosa		130.00	Breakfast	2025-09-29 15:05:10.645247
32	Ghee Dosa		110.00	Breakfast	2025-09-29 15:05:35.899995
33	Matka Dosa		150.00	Breakfast	2025-09-29 15:06:22.444761
34	Plain Uttappa		90.00	Breakfast	2025-09-29 15:09:55.620592
35	Onion Uttappa		100.00	Breakfast	2025-09-29 15:10:30.815209
36	Masala Uttappa		110.00	Breakfast	2025-09-29 15:10:58.129097
37	Coconut Uttappa		100.00	Breakfast	2025-09-29 15:12:07.930388
38	Cheese Uttappa		120.00	Breakfast	2025-09-29 15:12:50.055778
39	Panner Uttappa		110.00	Breakfast	2025-09-29 15:13:20.313526
40	Tomato Omlet		100.00	Breakfast	2025-09-29 15:14:17.181248
41	Finger Chips		80.00	Breakfast	2025-09-29 15:14:53.358859
42	Sabudana Wada	2pec	60.00	Breakfast	2025-09-29 15:16:00.703159
43	Sabudana Khichidi		80.00	Breakfast	2025-09-29 15:16:55.45827
44	Kheema Pav		80.00	Breakfast	2025-09-29 15:17:30.903785
45	Burji Pav		70.00	Breakfast	2025-09-29 15:18:05.025533
46	Omlet Pav		60.00	Breakfast	2025-09-29 15:18:52.945308
47	Pav Bhaaji		100.00	Pav Bhaaji	2025-09-29 15:20:56.680805
48	Cheese Pav Bhaaji		130.00	Pav Bhaaji	2025-09-29 15:22:18.150313
49	Panner Pav Bhaaji		120.00	Pav Bhaaji	2025-09-29 15:22:35.4561
50	Jain Pav Bhaaji		120.00	Pav Bhaaji	2025-09-29 15:23:01.595459
51	Masala Pav Single		20.00	Pav Bhaaji	2025-09-29 15:23:55.299691
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: sarthak
--

COPY public.order_items (id, order_id, menu_item_id, quantity, unit_price) FROM stdin;
6	5	2	2	20.00
7	6	4	1	60.00
8	4	5	3	250.00
19	12	3	2	80.00
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: sarthak
--

COPY public.orders (id, user_id, table_id, total_amount, status, order_time) FROM stdin;
5	2	4	40.00	pending	2025-09-22 17:25:27.986861
6	5	5	60.00	pending	2025-09-22 17:27:54.827954
4	1	1	750.00	pending	2025-09-22 17:21:52.56703
12	12	3	160.00	pending	2025-09-25 01:56:31.387333
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: sarthak
--

COPY public.payments (payment_id, bill_id, amount, method, status, paid_at) FROM stdin;
2	3	750.00	UPI	success	2025-09-26 17:09:31.156563
3	4	160.00	Cash	success	2025-09-26 17:10:15.961401
4	2	60.00	Cash	success	2025-09-26 17:22:34.865905
6	5	40.00	Cash	success	2025-09-26 17:27:46.921817
\.


--
-- Data for Name: restaurant_tables; Type: TABLE DATA; Schema: public; Owner: sarthak
--

COPY public.restaurant_tables (id, table_number, capacity, status) FROM stdin;
1	1	4	available
5	7	6	occupied
6	3	4	occupied
3	11	4	occupied
4	5	4	available
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: sarthak
--

COPY public.users (id, name, email, password, role) FROM stdin;
3	Raj Kambli	rajexample.com	raj1234	admin
1	Sarthak Kambli	sarthakexample.com	sk123456	customer
2	Aditi Shewale	aditiexample.com	adi654321	customer
12	Jane Foster	jfoster23@gmail.com	foster_98	customer
18	Test User	testuser@example.com	$2b$10$16n0acVpULds/cw7dym4Q.gGGI8s5390cXVGeqqE5N1q420mRVSBG	admin
5	Mariya Aves	maves123@gmail.com	aves4561	customer
\.


--
-- Name: bills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sarthak
--

SELECT pg_catalog.setval('public.bills_id_seq', 7, true);


--
-- Name: bookings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sarthak
--

SELECT pg_catalog.setval('public.bookings_id_seq', 23, true);


--
-- Name: menu_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sarthak
--

SELECT pg_catalog.setval('public.menu_items_id_seq', 51, true);


--
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sarthak
--

SELECT pg_catalog.setval('public.order_items_id_seq', 21, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sarthak
--

SELECT pg_catalog.setval('public.orders_id_seq', 16, true);


--
-- Name: payments_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sarthak
--

SELECT pg_catalog.setval('public.payments_payment_id_seq', 6, true);


--
-- Name: restaurant_tables_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sarthak
--

SELECT pg_catalog.setval('public.restaurant_tables_id_seq', 12, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sarthak
--

SELECT pg_catalog.setval('public.users_id_seq', 18, true);


--
-- Name: bills bills_pkey; Type: CONSTRAINT; Schema: public; Owner: sarthak
--

ALTER TABLE ONLY public.bills
    ADD CONSTRAINT bills_pkey PRIMARY KEY (id);


--
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: sarthak
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- Name: menu_items menu_items_pkey; Type: CONSTRAINT; Schema: public; Owner: sarthak
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT menu_items_pkey PRIMARY KEY (id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: sarthak
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: sarthak
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: sarthak
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (payment_id);


--
-- Name: restaurant_tables restaurant_tables_pkey; Type: CONSTRAINT; Schema: public; Owner: sarthak
--

ALTER TABLE ONLY public.restaurant_tables
    ADD CONSTRAINT restaurant_tables_pkey PRIMARY KEY (id);


--
-- Name: restaurant_tables unique_table_number; Type: CONSTRAINT; Schema: public; Owner: sarthak
--

ALTER TABLE ONLY public.restaurant_tables
    ADD CONSTRAINT unique_table_number UNIQUE (table_number);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: sarthak
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: sarthak
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: bills bills_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sarthak
--

ALTER TABLE ONLY public.bills
    ADD CONSTRAINT bills_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: bookings bookings_table_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sarthak
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_table_id_fkey FOREIGN KEY (table_id) REFERENCES public.restaurant_tables(id);


--
-- Name: order_items order_items_menu_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sarthak
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_menu_item_id_fkey FOREIGN KEY (menu_item_id) REFERENCES public.menu_items(id);


--
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sarthak
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: orders orders_table_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sarthak
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_table_id_fkey FOREIGN KEY (table_id) REFERENCES public.restaurant_tables(id);


--
-- Name: orders orders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sarthak
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: payments payments_bill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sarthak
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_bill_id_fkey FOREIGN KEY (bill_id) REFERENCES public.bills(id) ON DELETE CASCADE;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON SEQUENCES TO sarthak;


--
-- Name: DEFAULT PRIVILEGES FOR TYPES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TYPES TO sarthak;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON FUNCTIONS TO sarthak;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TABLES TO sarthak;


--
-- PostgreSQL database dump complete
--

\unrestrict 0TNAqGj8bFROvhWOhSUGogeS2zQrLibhPzHMZAWLDyJlT4vtJenpDd3mbAxGbmg

