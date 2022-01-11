--
-- PostgreSQL database dump
--

-- Dumped from database version 12.9 (Ubuntu 12.9-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.9 (Ubuntu 12.9-0ubuntu0.20.04.1)

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

--
-- Name: spectral_value; Type: TYPE; Schema: public; Owner: gcpinckert
--

CREATE TYPE public.spectral_value AS ENUM (
    'O',
    'B',
    'A',
    'F',
    'G',
    'K',
    'M'
);


ALTER TYPE public.spectral_value OWNER TO gcpinckert;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: moons; Type: TABLE; Schema: public; Owner: gcpinckert
--

CREATE TABLE public.moons (
    id integer NOT NULL,
    designation integer NOT NULL,
    semi_major_axis numeric,
    mass numeric,
    planet_id integer NOT NULL,
    CONSTRAINT moons_mass_check CHECK ((mass > (0)::numeric)),
    CONSTRAINT moons_semi_major_axis_check CHECK ((semi_major_axis > (0)::numeric))
);


ALTER TABLE public.moons OWNER TO gcpinckert;

--
-- Name: moons_id_seq; Type: SEQUENCE; Schema: public; Owner: gcpinckert
--

CREATE SEQUENCE public.moons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.moons_id_seq OWNER TO gcpinckert;

--
-- Name: moons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gcpinckert
--

ALTER SEQUENCE public.moons_id_seq OWNED BY public.moons.id;


--
-- Name: planets; Type: TABLE; Schema: public; Owner: gcpinckert
--

CREATE TABLE public.planets (
    id integer NOT NULL,
    designation character(1) NOT NULL,
    mass numeric NOT NULL,
    stars_id integer NOT NULL,
    semi_major_axis numeric NOT NULL,
    CONSTRAINT valid_mass CHECK ((mass > (0)::numeric))
);


ALTER TABLE public.planets OWNER TO gcpinckert;

--
-- Name: planets_id_seq; Type: SEQUENCE; Schema: public; Owner: gcpinckert
--

CREATE SEQUENCE public.planets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.planets_id_seq OWNER TO gcpinckert;

--
-- Name: planets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gcpinckert
--

ALTER SEQUENCE public.planets_id_seq OWNED BY public.planets.id;


--
-- Name: stars; Type: TABLE; Schema: public; Owner: gcpinckert
--

CREATE TABLE public.stars (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    distance numeric NOT NULL,
    spectral_type public.spectral_value NOT NULL,
    companions integer DEFAULT 0 NOT NULL,
    CONSTRAINT stars_companions_check CHECK ((companions >= 0)),
    CONSTRAINT stars_distance_check CHECK ((distance > (0)::numeric))
);


ALTER TABLE public.stars OWNER TO gcpinckert;

--
-- Name: stars_id_seq; Type: SEQUENCE; Schema: public; Owner: gcpinckert
--

CREATE SEQUENCE public.stars_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stars_id_seq OWNER TO gcpinckert;

--
-- Name: stars_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gcpinckert
--

ALTER SEQUENCE public.stars_id_seq OWNED BY public.stars.id;


--
-- Name: moons id; Type: DEFAULT; Schema: public; Owner: gcpinckert
--

ALTER TABLE ONLY public.moons ALTER COLUMN id SET DEFAULT nextval('public.moons_id_seq'::regclass);


--
-- Name: planets id; Type: DEFAULT; Schema: public; Owner: gcpinckert
--

ALTER TABLE ONLY public.planets ALTER COLUMN id SET DEFAULT nextval('public.planets_id_seq'::regclass);


--
-- Name: stars id; Type: DEFAULT; Schema: public; Owner: gcpinckert
--

ALTER TABLE ONLY public.stars ALTER COLUMN id SET DEFAULT nextval('public.stars_id_seq'::regclass);


--
-- Data for Name: moons; Type: TABLE DATA; Schema: public; Owner: gcpinckert
--



--
-- Data for Name: planets; Type: TABLE DATA; Schema: public; Owner: gcpinckert
--



--
-- Data for Name: stars; Type: TABLE DATA; Schema: public; Owner: gcpinckert
--



--
-- Name: moons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gcpinckert
--

SELECT pg_catalog.setval('public.moons_id_seq', 1, false);


--
-- Name: planets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gcpinckert
--

SELECT pg_catalog.setval('public.planets_id_seq', 1, false);


--
-- Name: stars_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gcpinckert
--

SELECT pg_catalog.setval('public.stars_id_seq', 1, true);


--
-- Name: moons moons_pkey; Type: CONSTRAINT; Schema: public; Owner: gcpinckert
--

ALTER TABLE ONLY public.moons
    ADD CONSTRAINT moons_pkey PRIMARY KEY (id);


--
-- Name: planets planets_pkey; Type: CONSTRAINT; Schema: public; Owner: gcpinckert
--

ALTER TABLE ONLY public.planets
    ADD CONSTRAINT planets_pkey PRIMARY KEY (id);


--
-- Name: stars stars_name_key; Type: CONSTRAINT; Schema: public; Owner: gcpinckert
--

ALTER TABLE ONLY public.stars
    ADD CONSTRAINT stars_name_key UNIQUE (name);


--
-- Name: stars stars_pkey; Type: CONSTRAINT; Schema: public; Owner: gcpinckert
--

ALTER TABLE ONLY public.stars
    ADD CONSTRAINT stars_pkey PRIMARY KEY (id);


--
-- Name: moons moons_planet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gcpinckert
--

ALTER TABLE ONLY public.moons
    ADD CONSTRAINT moons_planet_id_fkey FOREIGN KEY (planet_id) REFERENCES public.planets(id);


--
-- Name: planets planets_stars_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gcpinckert
--

ALTER TABLE ONLY public.planets
    ADD CONSTRAINT planets_stars_id_fkey FOREIGN KEY (stars_id) REFERENCES public.stars(id);


--
-- PostgreSQL database dump complete
--

