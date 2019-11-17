--
-- PostgreSQL database dump
--

-- Dumped from database version 10.10
-- Dumped by pg_dump version 10.10

-- Started on 2019-11-17 23:28:00

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 199 (class 1259 OID 17128)
-- Name: currency; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.currency (
    id bigint NOT NULL,
    title text,
    code text,
    symbol character varying(1)
);


ALTER TABLE public.currency OWNER TO postgres;

--
-- TOC entry 2862 (class 0 OID 0)
-- Dependencies: 199
-- Name: TABLE currency; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.currency IS 'Информация о валютах';


--
-- TOC entry 198 (class 1259 OID 17126)
-- Name: currency_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.currency_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.currency_id_seq OWNER TO postgres;

--
-- TOC entry 2863 (class 0 OID 0)
-- Dependencies: 198
-- Name: currency_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.currency_id_seq OWNED BY public.currency.id;


--
-- TOC entry 204 (class 1259 OID 17158)
-- Name: rate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rate (
    "from" bigint NOT NULL,
    "to" bigint NOT NULL,
    percent double precision NOT NULL
);


ALTER TABLE public.rate OWNER TO postgres;

--
-- TOC entry 2864 (class 0 OID 0)
-- Dependencies: 204
-- Name: TABLE rate; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.rate IS 'Коэффициенты конвертации валют';


--
-- TOC entry 206 (class 1259 OID 17164)
-- Name: settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.settings (
    id bigint NOT NULL,
    wallets bigint[] NOT NULL,
    currency bigint NOT NULL,
    balance double precision NOT NULL,
    fee double precision NOT NULL
);


ALTER TABLE public.settings OWNER TO postgres;

--
-- TOC entry 2865 (class 0 OID 0)
-- Dependencies: 206
-- Name: TABLE settings; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.settings IS 'Настройки по умолчанию ';


--
-- TOC entry 2866 (class 0 OID 0)
-- Dependencies: 206
-- Name: COLUMN settings.wallets; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.settings.wallets IS 'id кошельков, создаваемых по умолчанию';


--
-- TOC entry 2867 (class 0 OID 0)
-- Dependencies: 206
-- Name: COLUMN settings.currency; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.settings.currency IS 'Валюта, на которую зачисляется баланс';


--
-- TOC entry 2868 (class 0 OID 0)
-- Dependencies: 206
-- Name: COLUMN settings.balance; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.settings.balance IS 'Баланс для нового пользователя ';


--
-- TOC entry 205 (class 1259 OID 17162)
-- Name: settings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.settings_id_seq OWNER TO postgres;

--
-- TOC entry 2869 (class 0 OID 0)
-- Dependencies: 205
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.settings_id_seq OWNED BY public.settings.id;


--
-- TOC entry 203 (class 1259 OID 17149)
-- Name: transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transaction (
    id bigint NOT NULL,
    sender text NOT NULL,
    recipient text NOT NULL,
    info json,
    create_at timestamp without time zone NOT NULL
);


ALTER TABLE public.transaction OWNER TO postgres;

--
-- TOC entry 2870 (class 0 OID 0)
-- Dependencies: 203
-- Name: TABLE transaction; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.transaction IS 'Информационная таблица, хранящая информацию о транзакциях';


--
-- TOC entry 2871 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN transaction.sender; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.transaction.sender IS 'Кошелек отправителя';


--
-- TOC entry 2872 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN transaction.recipient; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.transaction.recipient IS 'Кошелек получателя';


--
-- TOC entry 2873 (class 0 OID 0)
-- Dependencies: 203
-- Name: COLUMN transaction.info; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.transaction.info IS 'Информация о переводе:
id отправителя
id получателя
Валюта кошелька отправителя
Валюта кошелька получателя
Курс
Сумма списания
Сумма зачисления';


--
-- TOC entry 202 (class 1259 OID 17147)
-- Name: transaction_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transaction_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transaction_id_seq OWNER TO postgres;

--
-- TOC entry 2874 (class 0 OID 0)
-- Dependencies: 202
-- Name: transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transaction_id_seq OWNED BY public.transaction.id;


--
-- TOC entry 197 (class 1259 OID 17120)
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id bigint NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    name text,
    surname text
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- TOC entry 2875 (class 0 OID 0)
-- Dependencies: 197
-- Name: TABLE "user"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."user" IS 'Информация о пользователях';


--
-- TOC entry 196 (class 1259 OID 17118)
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO postgres;

--
-- TOC entry 2876 (class 0 OID 0)
-- Dependencies: 196
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- TOC entry 201 (class 1259 OID 17136)
-- Name: wallet; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wallet (
    id bigint NOT NULL,
    currency bigint NOT NULL,
    "user" bigint NOT NULL,
    account text NOT NULL,
    balance double precision DEFAULT 0 NOT NULL
);


ALTER TABLE public.wallet OWNER TO postgres;

--
-- TOC entry 2877 (class 0 OID 0)
-- Dependencies: 201
-- Name: TABLE wallet; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.wallet IS 'Информация о пользователях и их валютных счетах';


--
-- TOC entry 2878 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN wallet.currency; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.wallet.currency IS 'Ссылка на валюту';


--
-- TOC entry 2879 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN wallet."user"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.wallet."user" IS 'Ссылка на пользователя, владельца счета';


--
-- TOC entry 2880 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN wallet.account; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.wallet.account IS '20-значный уникальный номер счета';


--
-- TOC entry 2881 (class 0 OID 0)
-- Dependencies: 201
-- Name: COLUMN wallet.balance; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.wallet.balance IS 'Баланс счета';


--
-- TOC entry 200 (class 1259 OID 17134)
-- Name: wallet_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.wallet_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wallet_id_seq OWNER TO postgres;

--
-- TOC entry 2882 (class 0 OID 0)
-- Dependencies: 200
-- Name: wallet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.wallet_id_seq OWNED BY public.wallet.id;


--
-- TOC entry 2704 (class 2604 OID 17131)
-- Name: currency id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.currency ALTER COLUMN id SET DEFAULT nextval('public.currency_id_seq'::regclass);


--
-- TOC entry 2708 (class 2604 OID 17167)
-- Name: settings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings ALTER COLUMN id SET DEFAULT nextval('public.settings_id_seq'::regclass);


--
-- TOC entry 2707 (class 2604 OID 17152)
-- Name: transaction id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction ALTER COLUMN id SET DEFAULT nextval('public.transaction_id_seq'::regclass);


--
-- TOC entry 2703 (class 2604 OID 17123)
-- Name: user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- TOC entry 2705 (class 2604 OID 17139)
-- Name: wallet id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet ALTER COLUMN id SET DEFAULT nextval('public.wallet_id_seq'::regclass);


--
-- TOC entry 2848 (class 0 OID 17128)
-- Dependencies: 199
-- Data for Name: currency; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.currency VALUES (1, 'U.S. dollar', 'USD', '$');
INSERT INTO public.currency VALUES (2, 'Euro', 'EUR', '€');
INSERT INTO public.currency VALUES (3, 'Yuan', 'CNY', '¥');
INSERT INTO public.currency VALUES (4, 'Russian ruble', 'RUB', '₽');
INSERT INTO public.currency VALUES (5, 'English Pound', 'GBP', '£');
INSERT INTO public.currency VALUES (6, 'Japanese yen', 'JPY', '¥');


--
-- TOC entry 2853 (class 0 OID 17158)
-- Dependencies: 204
-- Data for Name: rate; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.rate VALUES (1, 2, 0.90876999999999997);
INSERT INTO public.rate VALUES (1, 3, 7.0247000000000002);
INSERT INTO public.rate VALUES (1, 4, 64.3249);
INSERT INTO public.rate VALUES (1, 5, 0.7782);
INSERT INTO public.rate VALUES (1, 6, 108.81999999999999);
INSERT INTO public.rate VALUES (2, 1, 1.1004);
INSERT INTO public.rate VALUES (2, 3, 7.7294);
INSERT INTO public.rate VALUES (2, 4, 70.782499999999999);
INSERT INTO public.rate VALUES (2, 5, 0.85641999999999996);
INSERT INTO public.rate VALUES (2, 6, 119.73999999999999);
INSERT INTO public.rate VALUES (3, 1, 0.14235999999999999);
INSERT INTO public.rate VALUES (3, 2, 0.12938);
INSERT INTO public.rate VALUES (3, 4, 9.1576000000000004);
INSERT INTO public.rate VALUES (3, 5, 0.1108);
INSERT INTO public.rate VALUES (3, 6, 15.494);
INSERT INTO public.rate VALUES (4, 1, 0.01555);
INSERT INTO public.rate VALUES (4, 2, 0.01413);
INSERT INTO public.rate VALUES (4, 3, 0.10920000000000001);
INSERT INTO public.rate VALUES (4, 5, 0.0121);
INSERT INTO public.rate VALUES (4, 6, 1.6918);
INSERT INTO public.rate VALUES (5, 1, 1.2849999999999999);
INSERT INTO public.rate VALUES (5, 2, 1.1677);
INSERT INTO public.rate VALUES (5, 3, 9.0251999999999999);
INSERT INTO public.rate VALUES (5, 4, 82.649299999999997);
INSERT INTO public.rate VALUES (5, 6, 139.83000000000001);
INSERT INTO public.rate VALUES (6, 1, 0.0091900000000000003);
INSERT INTO public.rate VALUES (6, 2, 0.0083510000000000008);
INSERT INTO public.rate VALUES (6, 3, 0.06454);
INSERT INTO public.rate VALUES (6, 4, 0.59106999999999998);
INSERT INTO public.rate VALUES (6, 5, 0.0071510000000000002);


--
-- TOC entry 2855 (class 0 OID 17164)
-- Dependencies: 206
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.settings VALUES (1, '{1,2,3}', 1, 100, 3);


--
-- TOC entry 2852 (class 0 OID 17149)
-- Dependencies: 203
-- Data for Name: transaction; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 2846 (class 0 OID 17120)
-- Dependencies: 197
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."user" VALUES (3, 'user3@example.com', '12345678', 'Oleg', 'Ivanov');
INSERT INTO public."user" VALUES (2, 'user2@example.com', '12345678', 'Petr', 'Smirnov');
INSERT INTO public."user" VALUES (1, 'user1@example.com', '12345678', 'Ivan', 'Petrov');
INSERT INTO public."user" VALUES (6, 'user4@example.com', '12345678', 'Иван', 'Иванов');


--
-- TOC entry 2850 (class 0 OID 17136)
-- Dependencies: 201
-- Data for Name: wallet; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.wallet VALUES (1, 1, 1, '42302810570000123456', 100);
INSERT INTO public.wallet VALUES (2, 2, 1, '40840840570000123456', 0);
INSERT INTO public.wallet VALUES (3, 3, 1, '42303978570000123456', 0);
INSERT INTO public.wallet VALUES (4, 1, 2, '42304810570000123456', 100);
INSERT INTO public.wallet VALUES (5, 2, 2, '42305840570000123456', 0);
INSERT INTO public.wallet VALUES (6, 3, 2, '42306978570000123456', 0);
INSERT INTO public.wallet VALUES (7, 1, 3, '42307810570000123456', 100);
INSERT INTO public.wallet VALUES (8, 2, 3, '40817840570000123456', 0);
INSERT INTO public.wallet VALUES (9, 3, 3, '42301978570000123456', 0);


--
-- TOC entry 2883 (class 0 OID 0)
-- Dependencies: 198
-- Name: currency_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.currency_id_seq', 6, true);


--
-- TOC entry 2884 (class 0 OID 0)
-- Dependencies: 205
-- Name: settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.settings_id_seq', 4, true);


--
-- TOC entry 2885 (class 0 OID 0)
-- Dependencies: 202
-- Name: transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transaction_id_seq', 1, false);


--
-- TOC entry 2886 (class 0 OID 0)
-- Dependencies: 196
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_id_seq', 6, true);


--
-- TOC entry 2887 (class 0 OID 0)
-- Dependencies: 200
-- Name: wallet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.wallet_id_seq', 9, true);


--
-- TOC entry 2713 (class 2606 OID 17133)
-- Name: currency currency_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.currency
    ADD CONSTRAINT currency_pkey PRIMARY KEY (id);


--
-- TOC entry 2723 (class 2606 OID 17172)
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- TOC entry 2720 (class 2606 OID 17157)
-- Name: transaction transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT transaction_pkey PRIMARY KEY (id);


--
-- TOC entry 2711 (class 2606 OID 17125)
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- TOC entry 2718 (class 2606 OID 17142)
-- Name: wallet wallet_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet
    ADD CONSTRAINT wallet_pkey PRIMARY KEY (id);


--
-- TOC entry 2715 (class 1259 OID 17214)
-- Name: unique_account; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX unique_account ON public.wallet USING btree (account);


--
-- TOC entry 2888 (class 0 OID 0)
-- Dependencies: 2715
-- Name: INDEX unique_account; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON INDEX public.unique_account IS 'Счета пользователей не должны повторяться ';


--
-- TOC entry 2714 (class 1259 OID 17238)
-- Name: unique_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX unique_code ON public.currency USING btree (code);


--
-- TOC entry 2709 (class 1259 OID 17177)
-- Name: unique_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX unique_email ON public."user" USING btree (email);


--
-- TOC entry 2721 (class 1259 OID 17161)
-- Name: unique_from_to_currency; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX unique_from_to_currency ON public.rate USING btree ("from", "to");


--
-- TOC entry 2716 (class 1259 OID 17145)
-- Name: unique_user_currency; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX unique_user_currency ON public.wallet USING btree ("user", currency);


--
-- TOC entry 2889 (class 0 OID 0)
-- Dependencies: 2716
-- Name: INDEX unique_user_currency; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON INDEX public.unique_user_currency IS 'У пользователя может быть только один счет для одной валюты';


-- Completed on 2019-11-17 23:28:00

--
-- PostgreSQL database dump complete
--

