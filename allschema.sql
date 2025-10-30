SET default_tablespace = '';
SET default_table_access_method = heap;

-- =========================
-- TABLE: bills
-- =========================
CREATE TABLE public.bills (
    id integer NOT NULL,
    order_id integer NOT NULL,
    total_amount numeric(10,2) NOT NULL,
    status character varying(20) DEFAULT 'unpaid',
    generated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE SEQUENCE public.bills_id_seq START 1 INCREMENT 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.bills_id_seq OWNED BY public.bills.id;

-- =========================
-- TABLE: bookings
-- =========================
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

CREATE SEQUENCE public.bookings_id_seq START 1 INCREMENT 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.bookings_id_seq OWNED BY public.bookings.id;

-- =========================
-- TABLE: menu_items
-- =========================
CREATE TABLE public.menu_items (
    id integer NOT NULL,
    name text NOT NULL,
    description text,
    price numeric(10,2) NOT NULL,
    category text,
    created_at timestamp without time zone DEFAULT now()
);

CREATE SEQUENCE public.menu_items_id_seq START 1 INCREMENT 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.menu_items_id_seq OWNED BY public.menu_items.id;

-- =========================
-- TABLE: order_items
-- =========================
CREATE TABLE public.order_items (
    id integer NOT NULL,
    order_id integer,
    menu_item_id integer,
    quantity integer,
    unit_price numeric(10,2)
);

CREATE SEQUENCE public.order_items_id_seq START 1 INCREMENT 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;

-- =========================
-- TABLE: orders
-- =========================
CREATE TABLE public.orders (
    id integer NOT NULL,
    user_id integer,
    table_id integer,
    total_amount numeric(10,2),
    status character varying(50) DEFAULT 'pending',
    order_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE SEQUENCE public.orders_id_seq START 1 INCREMENT 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;

-- =========================
-- TABLE: payments
-- =========================
CREATE TABLE public.payments (
    payment_id integer NOT NULL,
    bill_id integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    method character varying(50) NOT NULL,
    status character varying(20) DEFAULT 'pending',
    paid_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE SEQUENCE public.payments_payment_id_seq START 1 INCREMENT 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.payments_payment_id_seq OWNED BY public.payments.payment_id;

-- =========================
-- TABLE: restaurant_tables
-- =========================
CREATE TABLE public.restaurant_tables (
    id integer NOT NULL,
    table_number integer NOT NULL,
    capacity integer NOT NULL,
    status character varying(50) DEFAULT 'available'
);

CREATE SEQUENCE public.restaurant_tables_id_seq START 1 INCREMENT 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.restaurant_tables_id_seq OWNED BY public.restaurant_tables.id;

-- =========================
-- TABLE: users
-- =========================
CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    password character varying(100) NOT NULL,
    role character varying(50) NOT NULL
);

CREATE SEQUENCE public.users_id_seq START 1 INCREMENT 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;

-- =========================
-- DEFAULTS
-- =========================
ALTER TABLE ONLY public.bills ALTER COLUMN id SET DEFAULT nextval('public.bills_id_seq'::regclass);
ALTER TABLE ONLY public.bookings ALTER COLUMN id SET DEFAULT nextval('public.bookings_id_seq'::regclass);
ALTER TABLE ONLY public.menu_items ALTER COLUMN id SET DEFAULT nextval('public.menu_items_id_seq'::regclass);
ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);
ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);
ALTER TABLE ONLY public.payments ALTER COLUMN payment_id SET DEFAULT nextval('public.payments_payment_id_seq'::regclass);
ALTER TABLE ONLY public.restaurant_tables ALTER COLUMN id SET DEFAULT nextval('public.restaurant_tables_id_seq'::regclass);
ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);

-- =========================
-- CONSTRAINTS
-- =========================
ALTER TABLE ONLY public.bills ADD CONSTRAINT bills_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.bookings ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.menu_items ADD CONSTRAINT menu_items_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.order_items ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.orders ADD CONSTRAINT orders_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.payments ADD CONSTRAINT payments_pkey PRIMARY KEY (payment_id);
ALTER TABLE ONLY public.restaurant_tables ADD CONSTRAINT restaurant_tables_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.users ADD CONSTRAINT users_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.users ADD CONSTRAINT users_email_key UNIQUE (email);
ALTER TABLE ONLY public.restaurant_tables ADD CONSTRAINT unique_table_number UNIQUE (table_number);

-- =========================
-- FOREIGN KEYS
-- =========================
ALTER TABLE ONLY public.bills
    ADD CONSTRAINT bills_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_table_id_fkey FOREIGN KEY (table_id) REFERENCES public.restaurant_tables(id);

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_menu_item_id_fkey FOREIGN KEY (menu_item_id) REFERENCES public.menu_items(id);

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_table_id_fkey FOREIGN KEY (table_id) REFERENCES public.restaurant_tables(id);

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_bill_id_fkey FOREIGN KEY (bill_id) REFERENCES public.bills(id) ON DELETE CASCADE;

-- =========================
-- SEQUENCE VALUES (OPTIONAL)
-- =========================
SELECT pg_catalog.setval('public.bills_id_seq', 7, true);
SELECT pg_catalog.setval('public.bookings_id_seq', 23, true);
SELECT pg_catalog.setval('public.menu_items_id_seq', 51, true);
SELECT pg_catalog.setval('public.order_items_id_seq', 21, true);
SELECT pg_catalog.setval('public.orders_id_seq', 16, true);
SELECT pg_catalog.setval('public.payments_payment_id_seq', 6, true);
SELECT pg_catalog.setval('public.restaurant_tables_id_seq', 12, true);
SELECT pg_catalog.setval('public.users_id_seq', 18, true);
