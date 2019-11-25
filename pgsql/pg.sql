SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 185 (class 1259 OID 1231247)
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
-- TOC entry 2189 (class 0 OID 0)
-- Dependencies: 185
-- Name: TABLE currency; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.currency IS 'Информация о валютах';


--
-- TOC entry 186 (class 1259 OID 1231253)
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
-- TOC entry 2190 (class 0 OID 0)
-- Dependencies: 186
-- Name: currency_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.currency_id_seq OWNED BY public.currency.id;


--
-- TOC entry 187 (class 1259 OID 1231255)
-- Name: rate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rate (
    "from" bigint NOT NULL,
    "to" bigint NOT NULL,
    percent double precision NOT NULL
);


ALTER TABLE public.rate OWNER TO postgres;

--
-- TOC entry 2191 (class 0 OID 0)
-- Dependencies: 187
-- Name: TABLE rate; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.rate IS 'Коэффициенты конвертации валют';


--
-- TOC entry 188 (class 1259 OID 1231258)
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
-- TOC entry 2192 (class 0 OID 0)
-- Dependencies: 188
-- Name: TABLE settings; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.settings IS 'Настройки по умолчанию ';


--
-- TOC entry 2193 (class 0 OID 0)
-- Dependencies: 188
-- Name: COLUMN settings.wallets; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.settings.wallets IS 'id кошельков, создаваемых по умолчанию';


--
-- TOC entry 2194 (class 0 OID 0)
-- Dependencies: 188
-- Name: COLUMN settings.currency; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.settings.currency IS 'Валюта, на которую зачисляется баланс';


--
-- TOC entry 2195 (class 0 OID 0)
-- Dependencies: 188
-- Name: COLUMN settings.balance; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.settings.balance IS 'Баланс для нового пользователя ';


--
-- TOC entry 189 (class 1259 OID 1231264)
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
-- TOC entry 2196 (class 0 OID 0)
-- Dependencies: 189
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.settings_id_seq OWNED BY public.settings.id;


--
-- TOC entry 190 (class 1259 OID 1231266)
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
-- TOC entry 2197 (class 0 OID 0)
-- Dependencies: 190
-- Name: TABLE transaction; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.transaction IS 'Информационная таблица, хранящая информацию о транзакциях';


--
-- TOC entry 2198 (class 0 OID 0)
-- Dependencies: 190
-- Name: COLUMN transaction.sender; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.transaction.sender IS 'Кошелек отправителя';


--
-- TOC entry 2199 (class 0 OID 0)
-- Dependencies: 190
-- Name: COLUMN transaction.recipient; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.transaction.recipient IS 'Кошелек получателя';


--
-- TOC entry 2200 (class 0 OID 0)
-- Dependencies: 190
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
-- TOC entry 191 (class 1259 OID 1231272)
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
-- TOC entry 2201 (class 0 OID 0)
-- Dependencies: 191
-- Name: transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transaction_id_seq OWNED BY public.transaction.id;


--
-- TOC entry 192 (class 1259 OID 1231274)
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
-- TOC entry 2202 (class 0 OID 0)
-- Dependencies: 192
-- Name: TABLE "user"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public."user" IS 'Информация о пользователях';


--
-- TOC entry 193 (class 1259 OID 1231280)
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
-- TOC entry 2203 (class 0 OID 0)
-- Dependencies: 193
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- TOC entry 194 (class 1259 OID 1231282)
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
-- TOC entry 2204 (class 0 OID 0)
-- Dependencies: 194
-- Name: TABLE wallet; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.wallet IS 'Информация о пользователях и их валютных счетах';


--
-- TOC entry 2205 (class 0 OID 0)
-- Dependencies: 194
-- Name: COLUMN wallet.currency; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.wallet.currency IS 'Ссылка на валюту';


--
-- TOC entry 2206 (class 0 OID 0)
-- Dependencies: 194
-- Name: COLUMN wallet."user"; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.wallet."user" IS 'Ссылка на пользователя, владельца счета';


--
-- TOC entry 2207 (class 0 OID 0)
-- Dependencies: 194
-- Name: COLUMN wallet.account; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.wallet.account IS '20-значный уникальный номер счета';


--
-- TOC entry 2208 (class 0 OID 0)
-- Dependencies: 194
-- Name: COLUMN wallet.balance; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.wallet.balance IS 'Баланс счета';


--
-- TOC entry 195 (class 1259 OID 1231289)
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
-- TOC entry 2209 (class 0 OID 0)
-- Dependencies: 195
-- Name: wallet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.wallet_id_seq OWNED BY public.wallet.id;


--
-- TOC entry 2034 (class 2604 OID 1231291)
-- Name: currency id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.currency ALTER COLUMN id SET DEFAULT nextval('public.currency_id_seq'::regclass);


--
-- TOC entry 2035 (class 2604 OID 1231292)
-- Name: settings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings ALTER COLUMN id SET DEFAULT nextval('public.settings_id_seq'::regclass);


--
-- TOC entry 2036 (class 2604 OID 1231293)
-- Name: transaction id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction ALTER COLUMN id SET DEFAULT nextval('public.transaction_id_seq'::regclass);


--
-- TOC entry 2037 (class 2604 OID 1231294)
-- Name: user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- TOC entry 2039 (class 2604 OID 1231295)
-- Name: wallet id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet ALTER COLUMN id SET DEFAULT nextval('public.wallet_id_seq'::regclass);


--
-- TOC entry 2172 (class 0 OID 1231247)
-- Dependencies: 185
-- Data for Name: currency; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.currency VALUES (1, 'U.S. dollar', 'USD', '$');
INSERT INTO public.currency VALUES (2, 'Euro', 'EUR', '€');
INSERT INTO public.currency VALUES (3, 'Yuan', 'CNY', '¥');
INSERT INTO public.currency VALUES (4, 'Russian ruble', 'RUB', '₽');
INSERT INTO public.currency VALUES (5, 'English Pound', 'GBP', '£');
INSERT INTO public.currency VALUES (6, 'Japanese yen', 'JPY', '¥');


--
-- TOC entry 2210 (class 0 OID 0)
-- Dependencies: 186
-- Name: currency_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.currency_id_seq', 6, true);


--
-- TOC entry 2174 (class 0 OID 1231255)
-- Dependencies: 187
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
-- TOC entry 2175 (class 0 OID 1231258)
-- Dependencies: 188
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.settings VALUES (1, '{1,2,3}', 1, 100, 3);


--
-- TOC entry 2211 (class 0 OID 0)
-- Dependencies: 189
-- Name: settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.settings_id_seq', 4, true);


--
-- TOC entry 2177 (class 0 OID 1231266)
-- Dependencies: 190
-- Data for Name: transaction; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.transaction VALUES (1, '42302810570000123456', '40840840570000123456', '{"amount_from": 3.0, "amount_to": 2.72631, "commission": 0, "rate": 0.90877, "wallet_from_before": {"id": 1, "balance": 100.0, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_to_before": {"id": 2, "balance": 0.0, "account": "40840840570000123456", "user": 1, "currency": 2}, "wallet_from_after": {"id": 1, "balance": 97.0, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_to_after": {"id": 2, "balance": 2.72631, "account": "40840840570000123456", "user": 1, "currency": 2}}', '2019-11-25 12:50:37');
INSERT INTO public.transaction VALUES (2, '42302810570000123456', '40840840570000123456', '{"amount_from": 3.0, "amount_to": 2.72631, "commission": 0, "rate": 0.90877, "wallet_from_before": {"id": 1, "balance": 97.0, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_to_before": {"id": 2, "balance": 2.72631, "account": "40840840570000123456", "user": 1, "currency": 2}, "wallet_from_after": {"id": 1, "balance": 94.0, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_to_after": {"id": 2, "balance": 5.45262, "account": "40840840570000123456", "user": 1, "currency": 2}}', '2019-11-25 12:50:38');
INSERT INTO public.transaction VALUES (3, '42302810570000123456', '40840840570000123456', '{"amount_from": 3.0, "amount_to": 2.72631, "commission": 0, "rate": 0.90877, "wallet_from_before": {"id": 1, "balance": 94.0, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_to_before": {"id": 2, "balance": 5.45262, "account": "40840840570000123456", "user": 1, "currency": 2}, "wallet_from_after": {"id": 1, "balance": 91.0, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_to_after": {"id": 2, "balance": 8.17893, "account": "40840840570000123456", "user": 1, "currency": 2}}', '2019-11-25 12:50:39');
INSERT INTO public.transaction VALUES (4, '42302810570000123456', '42303978570000123456', '{"amount_from": 3.0, "amount_to": 21.0741, "commission": 0, "rate": 7.0247, "wallet_from_before": {"id": 1, "balance": 91.0, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_to_before": {"id": 3, "balance": 0.0, "account": "42303978570000123456", "user": 1, "currency": 3}, "wallet_from_after": {"id": 1, "balance": 88.0, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_to_after": {"id": 3, "balance": 21.0741, "account": "42303978570000123456", "user": 1, "currency": 3}}', '2019-11-25 12:50:43');
INSERT INTO public.transaction VALUES (5, '42302810570000123456', '42303978570000123456', '{"amount_from": 3.0, "amount_to": 21.0741, "commission": 0, "rate": 7.0247, "wallet_from_before": {"id": 1, "balance": 88.0, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_to_before": {"id": 3, "balance": 21.0741, "account": "42303978570000123456", "user": 1, "currency": 3}, "wallet_from_after": {"id": 1, "balance": 85.0, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_to_after": {"id": 3, "balance": 42.1482, "account": "42303978570000123456", "user": 1, "currency": 3}}', '2019-11-25 12:50:44');
INSERT INTO public.transaction VALUES (6, '42302810570000123456', '42303978570000123456', '{"amount_from": 3.0, "amount_to": 21.0741, "commission": 0, "rate": 7.0247, "wallet_from_before": {"id": 1, "balance": 85.0, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_to_before": {"id": 3, "balance": 42.1482, "account": "42303978570000123456", "user": 1, "currency": 3}, "wallet_from_after": {"id": 1, "balance": 82.0, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_to_after": {"id": 3, "balance": 63.222300000000004, "account": "42303978570000123456", "user": 1, "currency": 3}}', '2019-11-25 12:50:45');
INSERT INTO public.transaction VALUES (7, '42302810570000123456', '42304810570000123456', '{"amount_from": 5.0, "amount_to": 5.0, "commission": 0.15, "rate": 1.0, "wallet_from_before": {"id": 1, "balance": 82.0, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_to_before": {"id": 4, "balance": 100.0, "account": "42304810570000123456", "user": 2, "currency": 1}, "wallet_from_after": {"id": 1, "balance": 76.85, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_to_after": {"id": 4, "balance": 105.0, "account": "42304810570000123456", "user": 2, "currency": 1}}', '2019-11-25 12:50:55');
INSERT INTO public.transaction VALUES (8, '42302810570000123456', '42304810570000123456', '{"amount_from": 5.0, "amount_to": 5.0, "commission": 0.15, "rate": 1.0, "wallet_from_before": {"id": 1, "balance": 77.0, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_to_before": {"id": 4, "balance": 105.0, "account": "42304810570000123456", "user": 2, "currency": 1}, "wallet_from_after": {"id": 1, "balance": 71.85, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_to_after": {"id": 4, "balance": 110.0, "account": "42304810570000123456", "user": 2, "currency": 1}}', '2019-11-25 12:50:56');
INSERT INTO public.transaction VALUES (9, '42302810570000123456', '42304810570000123456', '{"amount_from": 5.0, "amount_to": 5.0, "commission": 0.15, "rate": 1.0, "wallet_from_before": {"id": 1, "balance": 72.0, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_to_before": {"id": 4, "balance": 110.0, "account": "42304810570000123456", "user": 2, "currency": 1}, "wallet_from_after": {"id": 1, "balance": 66.85, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_to_after": {"id": 4, "balance": 115.0, "account": "42304810570000123456", "user": 2, "currency": 1}}', '2019-11-25 12:50:57');
INSERT INTO public.transaction VALUES (10, '42302810570000123456', '42307810570000123456', '{"amount_from": 5.0, "amount_to": 5.0, "commission": 0.15, "rate": 1.0, "wallet_from_before": {"id": 1, "balance": 67.0, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_to_before": {"id": 7, "balance": 100.0, "account": "42307810570000123456", "user": 3, "currency": 1}, "wallet_from_after": {"id": 1, "balance": 61.849999999999994, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_to_after": {"id": 7, "balance": 105.0, "account": "42307810570000123456", "user": 3, "currency": 1}}', '2019-11-25 12:50:59');
INSERT INTO public.transaction VALUES (11, '42302810570000123456', '42307810570000123456', '{"amount_from": 5.0, "amount_to": 5.0, "commission": 0.15, "rate": 1.0, "wallet_from_before": {"id": 1, "balance": 62.0, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_to_before": {"id": 7, "balance": 105.0, "account": "42307810570000123456", "user": 3, "currency": 1}, "wallet_from_after": {"id": 1, "balance": 56.85, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_to_after": {"id": 7, "balance": 110.0, "account": "42307810570000123456", "user": 3, "currency": 1}}', '2019-11-25 12:51:00');
INSERT INTO public.transaction VALUES (12, '42302810570000123456', '42307810570000123456', '{"amount_from": 5.0, "amount_to": 5.0, "commission": 0.15, "rate": 1.0, "wallet_from_before": {"id": 1, "balance": 57.0, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_to_before": {"id": 7, "balance": 110.0, "account": "42307810570000123456", "user": 3, "currency": 1}, "wallet_from_after": {"id": 1, "balance": 51.85, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_to_after": {"id": 7, "balance": 115.0, "account": "42307810570000123456", "user": 3, "currency": 1}}', '2019-11-25 12:51:01');
INSERT INTO public.transaction VALUES (13, '42302810570000123456', '42306978570000123456', '{"amount_from": 5.0, "amount_to": 35.1235, "commission": 0.15, "rate": 7.0247, "wallet_from_before": {"id": 1, "balance": 52.0, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_to_before": {"id": 6, "balance": 0.0, "account": "42306978570000123456", "user": 2, "currency": 3}, "wallet_from_after": {"id": 1, "balance": 46.85, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_to_after": {"id": 6, "balance": 35.1235, "account": "42306978570000123456", "user": 2, "currency": 3}}', '2019-11-25 12:51:07');
INSERT INTO public.transaction VALUES (14, '42302810570000123456', '42305840570000123456', '{"amount_from": 5.0, "amount_to": 4.54385, "commission": 0.15, "rate": 0.90877, "wallet_from_before": {"id": 1, "balance": 47.0, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_to_before": {"id": 5, "balance": 0.0, "account": "42305840570000123456", "user": 2, "currency": 2}, "wallet_from_after": {"id": 1, "balance": 41.85, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_to_after": {"id": 5, "balance": 4.54385, "account": "42305840570000123456", "user": 2, "currency": 2}}', '2019-11-25 12:51:28');
INSERT INTO public.transaction VALUES (24, '42304810570000123456', '42307810570000123456', '{"amount_from": 5.0, "amount_to": 5.0, "commission": 0.15, "rate": 1.0, "wallet_from_before": {"id": 4, "balance": 105.0, "account": "42304810570000123456", "user": 2, "currency": 1}, "wallet_to_before": {"id": 7, "balance": 125.0, "account": "42307810570000123456", "user": 3, "currency": 1}, "wallet_from_after": {"id": 4, "balance": 99.85, "account": "42304810570000123456", "user": 2, "currency": 1}, "wallet_to_after": {"id": 7, "balance": 130.0, "account": "42307810570000123456", "user": 3, "currency": 1}}', '2019-11-25 12:53:25');
INSERT INTO public.transaction VALUES (27, '42307810570000123456', '42302810570000123456', '{"amount_from": 5.0, "amount_to": 5.0, "commission": 0.15, "rate": 1.0, "wallet_from_before": {"id": 7, "balance": 120.0, "account": "42307810570000123456", "user": 3, "currency": 1}, "wallet_to_before": {"id": 1, "balance": 65.7204, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_from_after": {"id": 7, "balance": 114.85, "account": "42307810570000123456", "user": 3, "currency": 1}, "wallet_to_after": {"id": 1, "balance": 70.7204, "account": "42302810570000123456", "user": 1, "currency": 1}}', '2019-11-25 12:54:01');
INSERT INTO public.transaction VALUES (30, '42307810570000123456', '42302810570000123456', '{"amount_from": 5.0, "amount_to": 5.0, "commission": 0.15, "rate": 1.0, "wallet_from_before": {"id": 7, "balance": 105.0, "account": "42307810570000123456", "user": 3, "currency": 1}, "wallet_to_before": {"id": 1, "balance": 80.7204, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_from_after": {"id": 7, "balance": 99.85, "account": "42307810570000123456", "user": 3, "currency": 1}, "wallet_to_after": {"id": 1, "balance": 85.7204, "account": "42302810570000123456", "user": 1, "currency": 1}}', '2019-11-25 12:54:04');
INSERT INTO public.transaction VALUES (15, '42303978570000123456', '42302810570000123456', '{"amount_from": 10.0, "amount_to": 1.4236, "commission": 0, "rate": 0.14236, "wallet_from_before": {"id": 3, "balance": 63.2223, "account": "42303978570000123456", "user": 1, "currency": 3}, "wallet_to_before": {"id": 1, "balance": 42.0, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_from_after": {"id": 3, "balance": 53.2223, "account": "42303978570000123456", "user": 1, "currency": 3}, "wallet_to_after": {"id": 1, "balance": 43.4236, "account": "42302810570000123456", "user": 1, "currency": 1}}', '2019-11-25 12:52:16');
INSERT INTO public.transaction VALUES (16, '42303978570000123456', '42302810570000123456', '{"amount_from": 10.0, "amount_to": 1.4236, "commission": 0, "rate": 0.14236, "wallet_from_before": {"id": 3, "balance": 53.2223, "account": "42303978570000123456", "user": 1, "currency": 3}, "wallet_to_before": {"id": 1, "balance": 43.4236, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_from_after": {"id": 3, "balance": 43.2223, "account": "42303978570000123456", "user": 1, "currency": 3}, "wallet_to_after": {"id": 1, "balance": 44.8472, "account": "42302810570000123456", "user": 1, "currency": 1}}', '2019-11-25 12:52:17');
INSERT INTO public.transaction VALUES (17, '42303978570000123456', '42302810570000123456', '{"amount_from": 10.0, "amount_to": 1.4236, "commission": 0, "rate": 0.14236, "wallet_from_before": {"id": 3, "balance": 43.2223, "account": "42303978570000123456", "user": 1, "currency": 3}, "wallet_to_before": {"id": 1, "balance": 44.8472, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_from_after": {"id": 3, "balance": 33.2223, "account": "42303978570000123456", "user": 1, "currency": 3}, "wallet_to_after": {"id": 1, "balance": 46.2708, "account": "42302810570000123456", "user": 1, "currency": 1}}', '2019-11-25 12:52:18');
INSERT INTO public.transaction VALUES (18, '42303978570000123456', '42302810570000123456', '{"amount_from": 10.0, "amount_to": 1.4236, "commission": 0, "rate": 0.14236, "wallet_from_before": {"id": 3, "balance": 33.2223, "account": "42303978570000123456", "user": 1, "currency": 3}, "wallet_to_before": {"id": 1, "balance": 46.2708, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_from_after": {"id": 3, "balance": 23.222299999999997, "account": "42303978570000123456", "user": 1, "currency": 3}, "wallet_to_after": {"id": 1, "balance": 47.6944, "account": "42302810570000123456", "user": 1, "currency": 1}}', '2019-11-25 12:52:19');
INSERT INTO public.transaction VALUES (19, '42303978570000123456', '42302810570000123456', '{"amount_from": 10.0, "amount_to": 1.4236, "commission": 0, "rate": 0.14236, "wallet_from_before": {"id": 3, "balance": 23.2223, "account": "42303978570000123456", "user": 1, "currency": 3}, "wallet_to_before": {"id": 1, "balance": 47.6944, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_from_after": {"id": 3, "balance": 13.2223, "account": "42303978570000123456", "user": 1, "currency": 3}, "wallet_to_after": {"id": 1, "balance": 49.118, "account": "42302810570000123456", "user": 1, "currency": 1}}', '2019-11-25 12:52:20');
INSERT INTO public.transaction VALUES (20, '40840840570000123456', '42302810570000123456', '{"amount_from": 3.0, "amount_to": 3.3012, "commission": 0, "rate": 1.1004, "wallet_from_before": {"id": 2, "balance": 8.17893, "account": "40840840570000123456", "user": 1, "currency": 2}, "wallet_to_before": {"id": 1, "balance": 49.118, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_from_after": {"id": 2, "balance": 5.178929999999999, "account": "40840840570000123456", "user": 1, "currency": 2}, "wallet_to_after": {"id": 1, "balance": 52.419200000000004, "account": "42302810570000123456", "user": 1, "currency": 1}}', '2019-11-25 12:52:28');
INSERT INTO public.transaction VALUES (21, '40840840570000123456', '42302810570000123456', '{"amount_from": 3.0, "amount_to": 3.3012, "commission": 0, "rate": 1.1004, "wallet_from_before": {"id": 2, "balance": 5.17893, "account": "40840840570000123456", "user": 1, "currency": 2}, "wallet_to_before": {"id": 1, "balance": 52.4192, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_from_after": {"id": 2, "balance": 2.1789300000000003, "account": "40840840570000123456", "user": 1, "currency": 2}, "wallet_to_after": {"id": 1, "balance": 55.7204, "account": "42302810570000123456", "user": 1, "currency": 1}}', '2019-11-25 12:52:30');
INSERT INTO public.transaction VALUES (22, '42304810570000123456', '42307810570000123456', '{"amount_from": 5.0, "amount_to": 5.0, "commission": 0.15, "rate": 1.0, "wallet_from_before": {"id": 4, "balance": 115.0, "account": "42304810570000123456", "user": 2, "currency": 1}, "wallet_to_before": {"id": 7, "balance": 115.0, "account": "42307810570000123456", "user": 3, "currency": 1}, "wallet_from_after": {"id": 4, "balance": 109.85, "account": "42304810570000123456", "user": 2, "currency": 1}, "wallet_to_after": {"id": 7, "balance": 120.0, "account": "42307810570000123456", "user": 3, "currency": 1}}', '2019-11-25 12:53:23');
INSERT INTO public.transaction VALUES (25, '42307810570000123456', '42302810570000123456', '{"amount_from": 5.0, "amount_to": 5.0, "commission": 0.15, "rate": 1.0, "wallet_from_before": {"id": 7, "balance": 130.0, "account": "42307810570000123456", "user": 3, "currency": 1}, "wallet_to_before": {"id": 1, "balance": 55.7204, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_from_after": {"id": 7, "balance": 124.85, "account": "42307810570000123456", "user": 3, "currency": 1}, "wallet_to_after": {"id": 1, "balance": 60.7204, "account": "42302810570000123456", "user": 1, "currency": 1}}', '2019-11-25 12:53:59');
INSERT INTO public.transaction VALUES (28, '42307810570000123456', '42302810570000123456', '{"amount_from": 5.0, "amount_to": 5.0, "commission": 0.15, "rate": 1.0, "wallet_from_before": {"id": 7, "balance": 115.0, "account": "42307810570000123456", "user": 3, "currency": 1}, "wallet_to_before": {"id": 1, "balance": 70.7204, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_from_after": {"id": 7, "balance": 109.85, "account": "42307810570000123456", "user": 3, "currency": 1}, "wallet_to_after": {"id": 1, "balance": 75.7204, "account": "42302810570000123456", "user": 1, "currency": 1}}', '2019-11-25 12:54:02');
INSERT INTO public.transaction VALUES (31, '42307810570000123456', '42302810570000123456', '{"amount_from": 5.0, "amount_to": 5.0, "commission": 0.15, "rate": 1.0, "wallet_from_before": {"id": 7, "balance": 100.0, "account": "42307810570000123456", "user": 3, "currency": 1}, "wallet_to_before": {"id": 1, "balance": 85.7204, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_from_after": {"id": 7, "balance": 94.85, "account": "42307810570000123456", "user": 3, "currency": 1}, "wallet_to_after": {"id": 1, "balance": 90.7204, "account": "42302810570000123456", "user": 1, "currency": 1}}', '2019-11-25 12:54:05');
INSERT INTO public.transaction VALUES (33, '42307810570000123456', '42302810570000123456', '{"amount_from": 5.0, "amount_to": 5.0, "commission": 0.15, "rate": 1.0, "wallet_from_before": {"id": 7, "balance": 90.0, "account": "42307810570000123456", "user": 3, "currency": 1}, "wallet_to_before": {"id": 1, "balance": 95.7204, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_from_after": {"id": 7, "balance": 84.85, "account": "42307810570000123456", "user": 3, "currency": 1}, "wallet_to_after": {"id": 1, "balance": 100.7204, "account": "42302810570000123456", "user": 1, "currency": 1}}', '2019-11-25 12:54:07');
INSERT INTO public.transaction VALUES (23, '42304810570000123456', '42307810570000123456', '{"amount_from": 5.0, "amount_to": 5.0, "commission": 0.15, "rate": 1.0, "wallet_from_before": {"id": 4, "balance": 110.0, "account": "42304810570000123456", "user": 2, "currency": 1}, "wallet_to_before": {"id": 7, "balance": 120.0, "account": "42307810570000123456", "user": 3, "currency": 1}, "wallet_from_after": {"id": 4, "balance": 104.85, "account": "42304810570000123456", "user": 2, "currency": 1}, "wallet_to_after": {"id": 7, "balance": 125.0, "account": "42307810570000123456", "user": 3, "currency": 1}}', '2019-11-25 12:53:24');
INSERT INTO public.transaction VALUES (26, '42307810570000123456', '42302810570000123456', '{"amount_from": 5.0, "amount_to": 5.0, "commission": 0.15, "rate": 1.0, "wallet_from_before": {"id": 7, "balance": 125.0, "account": "42307810570000123456", "user": 3, "currency": 1}, "wallet_to_before": {"id": 1, "balance": 60.7204, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_from_after": {"id": 7, "balance": 119.85, "account": "42307810570000123456", "user": 3, "currency": 1}, "wallet_to_after": {"id": 1, "balance": 65.7204, "account": "42302810570000123456", "user": 1, "currency": 1}}', '2019-11-25 12:54:00');
INSERT INTO public.transaction VALUES (29, '42307810570000123456', '42302810570000123456', '{"amount_from": 5.0, "amount_to": 5.0, "commission": 0.15, "rate": 1.0, "wallet_from_before": {"id": 7, "balance": 110.0, "account": "42307810570000123456", "user": 3, "currency": 1}, "wallet_to_before": {"id": 1, "balance": 75.7204, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_from_after": {"id": 7, "balance": 104.85, "account": "42307810570000123456", "user": 3, "currency": 1}, "wallet_to_after": {"id": 1, "balance": 80.7204, "account": "42302810570000123456", "user": 1, "currency": 1}}', '2019-11-25 12:54:03');
INSERT INTO public.transaction VALUES (32, '42307810570000123456', '42302810570000123456', '{"amount_from": 5.0, "amount_to": 5.0, "commission": 0.15, "rate": 1.0, "wallet_from_before": {"id": 7, "balance": 95.0, "account": "42307810570000123456", "user": 3, "currency": 1}, "wallet_to_before": {"id": 1, "balance": 90.7204, "account": "42302810570000123456", "user": 1, "currency": 1}, "wallet_from_after": {"id": 7, "balance": 89.85, "account": "42307810570000123456", "user": 3, "currency": 1}, "wallet_to_after": {"id": 1, "balance": 95.7204, "account": "42302810570000123456", "user": 1, "currency": 1}}', '2019-11-25 12:54:06');


--
-- TOC entry 2212 (class 0 OID 0)
-- Dependencies: 191
-- Name: transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transaction_id_seq', 33, true);


--
-- TOC entry 2179 (class 0 OID 1231274)
-- Dependencies: 192
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."user" VALUES (3, 'user3@example.com', '12345678', 'Oleg', 'Ivanov');
INSERT INTO public."user" VALUES (2, 'user2@example.com', '12345678', 'Petr', 'Smirnov');
INSERT INTO public."user" VALUES (1, 'user1@example.com', '12345678', 'Ivan', 'Petrov');
INSERT INTO public."user" VALUES (6, 'user4@example.com', '12345678', 'Иван', 'Иванов');
INSERT INTO public."user" VALUES (7, 'user5@example.com', '12345678', 'Иван', 'Иванов');


--
-- TOC entry 2213 (class 0 OID 0)
-- Dependencies: 193
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_id_seq', 7, true);


--
-- TOC entry 2181 (class 0 OID 1231282)
-- Dependencies: 194
-- Data for Name: wallet; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.wallet VALUES (8, 2, 3, '40817840570000123456', 0);
INSERT INTO public.wallet VALUES (9, 3, 3, '42301978570000123456', 0);
INSERT INTO public.wallet VALUES (7, 1, 3, '42307810570000123456', 85);
INSERT INTO public.wallet VALUES (1, 1, 1, '42302810570000123456', 100.72040000000001);
INSERT INTO public.wallet VALUES (10, 1, 7, '25790344085034017735', 100);
INSERT INTO public.wallet VALUES (11, 2, 7, '67531756868564183731', 0);
INSERT INTO public.wallet VALUES (12, 3, 7, '24468414939645839905', 0);
INSERT INTO public.wallet VALUES (6, 3, 2, '42306978570000123456', 35.1235);
INSERT INTO public.wallet VALUES (5, 2, 2, '42305840570000123456', 4.5438499999999999);
INSERT INTO public.wallet VALUES (3, 3, 1, '42303978570000123456', 13.222300000000004);
INSERT INTO public.wallet VALUES (2, 2, 1, '40840840570000123456', 2.1789299999999994);
INSERT INTO public.wallet VALUES (4, 1, 2, '42304810570000123456', 100);


--
-- TOC entry 2214 (class 0 OID 0)
-- Dependencies: 195
-- Name: wallet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.wallet_id_seq', 12, true);


--
-- TOC entry 2041 (class 2606 OID 1231297)
-- Name: currency currency_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.currency
    ADD CONSTRAINT currency_pkey PRIMARY KEY (id);


--
-- TOC entry 2045 (class 2606 OID 1231299)
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- TOC entry 2047 (class 2606 OID 1231301)
-- Name: transaction transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT transaction_pkey PRIMARY KEY (id);


--
-- TOC entry 2050 (class 2606 OID 1231303)
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- TOC entry 2054 (class 2606 OID 1231305)
-- Name: wallet wallet_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet
    ADD CONSTRAINT wallet_pkey PRIMARY KEY (id);


--
-- TOC entry 2051 (class 1259 OID 1231306)
-- Name: unique_account; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX unique_account ON public.wallet USING btree (account);


--
-- TOC entry 2215 (class 0 OID 0)
-- Dependencies: 2051
-- Name: INDEX unique_account; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON INDEX public.unique_account IS 'Счета пользователей не должны повторяться ';


--
-- TOC entry 2042 (class 1259 OID 1231307)
-- Name: unique_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX unique_code ON public.currency USING btree (code);


--
-- TOC entry 2048 (class 1259 OID 1231308)
-- Name: unique_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX unique_email ON public."user" USING btree (email);


--
-- TOC entry 2043 (class 1259 OID 1231309)
-- Name: unique_from_to_currency; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX unique_from_to_currency ON public.rate USING btree ("from", "to");


--
-- TOC entry 2052 (class 1259 OID 1231310)
-- Name: unique_user_currency; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX unique_user_currency ON public.wallet USING btree ("user", currency);


--
-- TOC entry 2216 (class 0 OID 0)
-- Dependencies: 2052
-- Name: INDEX unique_user_currency; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON INDEX public.unique_user_currency IS 'У пользователя может быть только один счет для одной валюты';


-- Completed on 2019-11-25 12:59:47

--
-- PostgreSQL database dump complete
--

