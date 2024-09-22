--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2
-- Dumped by pg_dump version 15.2

-- Started on 2024-09-22 16:43:35

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
-- TOC entry 5 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 3624 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 221 (class 1259 OID 16425)
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16424)
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO postgres;

--
-- TOC entry 3626 (class 0 OID 0)
-- Dependencies: 220
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- TOC entry 223 (class 1259 OID 16434)
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16433)
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO postgres;

--
-- TOC entry 3627 (class 0 OID 0)
-- Dependencies: 222
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- TOC entry 219 (class 1259 OID 16418)
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16417)
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO postgres;

--
-- TOC entry 3628 (class 0 OID 0)
-- Dependencies: 218
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- TOC entry 225 (class 1259 OID 16441)
-- Name: auth_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16450)
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16449)
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_user_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_groups_id_seq OWNER TO postgres;

--
-- TOC entry 3629 (class 0 OID 0)
-- Dependencies: 226
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_user_groups_id_seq OWNED BY public.auth_user_groups.id;


--
-- TOC entry 224 (class 1259 OID 16440)
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_id_seq OWNER TO postgres;

--
-- TOC entry 3630 (class 0 OID 0)
-- Dependencies: 224
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_user_id_seq OWNED BY public.auth_user.id;


--
-- TOC entry 229 (class 1259 OID 16457)
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16456)
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_user_user_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_user_permissions_id_seq OWNER TO postgres;

--
-- TOC entry 3631 (class 0 OID 0)
-- Dependencies: 228
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_user_user_permissions_id_seq OWNED BY public.auth_user_user_permissions.id;


--
-- TOC entry 231 (class 1259 OID 16516)
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16515)
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_admin_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_admin_log_id_seq OWNER TO postgres;

--
-- TOC entry 3632 (class 0 OID 0)
-- Dependencies: 230
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- TOC entry 217 (class 1259 OID 16409)
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16408)
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_content_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO postgres;

--
-- TOC entry 3633 (class 0 OID 0)
-- Dependencies: 216
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- TOC entry 215 (class 1259 OID 16400)
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 16399)
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_migrations_id_seq OWNER TO postgres;

--
-- TOC entry 3634 (class 0 OID 0)
-- Dependencies: 214
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- TOC entry 258 (class 1259 OID 18602)
-- Name: django_q_ormq; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_q_ormq (
    id integer NOT NULL,
    key character varying(100) NOT NULL,
    payload text NOT NULL,
    lock timestamp with time zone
);


ALTER TABLE public.django_q_ormq OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 18601)
-- Name: django_q_ormq_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_q_ormq_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_q_ormq_id_seq OWNER TO postgres;

--
-- TOC entry 3635 (class 0 OID 0)
-- Dependencies: 257
-- Name: django_q_ormq_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_q_ormq_id_seq OWNED BY public.django_q_ormq.id;


--
-- TOC entry 255 (class 1259 OID 18580)
-- Name: django_q_schedule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_q_schedule (
    id integer NOT NULL,
    func character varying(256) NOT NULL,
    hook character varying(256),
    args text,
    kwargs text,
    schedule_type character varying(1) NOT NULL,
    repeats integer NOT NULL,
    next_run timestamp with time zone,
    task character varying(100),
    name character varying(100),
    minutes smallint,
    cron character varying(100),
    cluster character varying(100),
    CONSTRAINT django_q_schedule_minutes_check CHECK ((minutes >= 0))
);


ALTER TABLE public.django_q_schedule OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 18579)
-- Name: django_q_schedule_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_q_schedule_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_q_schedule_id_seq OWNER TO postgres;

--
-- TOC entry 3636 (class 0 OID 0)
-- Dependencies: 254
-- Name: django_q_schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_q_schedule_id_seq OWNED BY public.django_q_schedule.id;


--
-- TOC entry 256 (class 1259 OID 18589)
-- Name: django_q_task; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_q_task (
    name character varying(100) NOT NULL,
    func character varying(256) NOT NULL,
    hook character varying(256),
    args text,
    kwargs text,
    result text,
    started timestamp with time zone NOT NULL,
    stopped timestamp with time zone NOT NULL,
    success boolean NOT NULL,
    id character varying(32) NOT NULL,
    "group" character varying(100),
    attempt_count integer NOT NULL
);


ALTER TABLE public.django_q_task OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16570)
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16580)
-- Name: django_site; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_site (
    id integer NOT NULL,
    domain character varying(100) NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.django_site OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 16579)
-- Name: django_site_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_site_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_site_id_seq OWNER TO postgres;

--
-- TOC entry 3637 (class 0 OID 0)
-- Dependencies: 236
-- Name: django_site_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_site_id_seq OWNED BY public.django_site.id;


--
-- TOC entry 233 (class 1259 OID 16546)
-- Name: registration_registrationprofile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.registration_registrationprofile (
    id integer NOT NULL,
    activation_key character varying(64) NOT NULL,
    user_id integer NOT NULL,
    activated boolean NOT NULL
);


ALTER TABLE public.registration_registrationprofile OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16545)
-- Name: registration_registrationprofile_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.registration_registrationprofile_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.registration_registrationprofile_id_seq OWNER TO postgres;

--
-- TOC entry 3638 (class 0 OID 0)
-- Dependencies: 232
-- Name: registration_registrationprofile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.registration_registrationprofile_id_seq OWNED BY public.registration_registrationprofile.id;


--
-- TOC entry 234 (class 1259 OID 16560)
-- Name: registration_supervisedregistrationprofile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.registration_supervisedregistrationprofile (
    registrationprofile_ptr_id integer NOT NULL
);


ALTER TABLE public.registration_supervisedregistrationprofile OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 18553)
-- Name: train_chart; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.train_chart (
    id integer NOT NULL,
    name character varying(1000) NOT NULL,
    dataset_attribute character varying(1000),
    data text NOT NULL,
    dataset_id integer,
    type_id integer
);


ALTER TABLE public.train_chart OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 18552)
-- Name: train_chart_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.train_chart_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.train_chart_id_seq OWNER TO postgres;

--
-- TOC entry 3639 (class 0 OID 0)
-- Dependencies: 252
-- Name: train_chart_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.train_chart_id_seq OWNED BY public.train_chart.id;


--
-- TOC entry 251 (class 1259 OID 18544)
-- Name: train_charttype; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.train_charttype (
    id integer NOT NULL,
    name character varying(50),
    type character varying(50) NOT NULL,
    status character varying(20),
    template text NOT NULL
);


ALTER TABLE public.train_charttype OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 18543)
-- Name: train_charttype_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.train_charttype_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.train_charttype_id_seq OWNER TO postgres;

--
-- TOC entry 3640 (class 0 OID 0)
-- Dependencies: 250
-- Name: train_charttype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.train_charttype_id_seq OWNED BY public.train_charttype.id;


--
-- TOC entry 243 (class 1259 OID 16632)
-- Name: train_clusternode; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.train_clusternode (
    id integer NOT NULL,
    node_type character varying(10) NOT NULL,
    ip_address character varying(15) NOT NULL,
    port integer NOT NULL
);


ALTER TABLE public.train_clusternode OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 16631)
-- Name: train_clusternode_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.train_clusternode_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.train_clusternode_id_seq OWNER TO postgres;

--
-- TOC entry 3641 (class 0 OID 0)
-- Dependencies: 242
-- Name: train_clusternode_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.train_clusternode_id_seq OWNED BY public.train_clusternode.id;


--
-- TOC entry 247 (class 1259 OID 18502)
-- Name: train_dataset; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.train_dataset (
    id integer NOT NULL,
    description character varying(300) NOT NULL,
    dataset character varying(100) NOT NULL,
    dataset_test character varying(100),
    process_details text NOT NULL,
    processed_at timestamp with time zone NOT NULL,
    metainfo text NOT NULL,
    source_dataset_id_id integer,
    user_id integer NOT NULL
);


ALTER TABLE public.train_dataset OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 18501)
-- Name: train_dataset_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.train_dataset_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.train_dataset_id_seq OWNER TO postgres;

--
-- TOC entry 3642 (class 0 OID 0)
-- Dependencies: 246
-- Name: train_dataset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.train_dataset_id_seq OWNED BY public.train_dataset.id;


--
-- TOC entry 239 (class 1259 OID 16590)
-- Name: train_dataset_img; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.train_dataset_img (
    id integer NOT NULL,
    data_name character varying(300) NOT NULL,
    data_path character varying(300) NOT NULL,
    metainfo text NOT NULL,
    processed_at timestamp with time zone NOT NULL,
    delete_at timestamp with time zone,
    status character varying(300) NOT NULL,
    user_id integer NOT NULL,
    extracted_path text NOT NULL,
    data_path_test character varying(300) NOT NULL,
    extracted_path_test text NOT NULL
);


ALTER TABLE public.train_dataset_img OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 16589)
-- Name: train_dataset_img_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.train_dataset_img_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.train_dataset_img_id_seq OWNER TO postgres;

--
-- TOC entry 3643 (class 0 OID 0)
-- Dependencies: 238
-- Name: train_dataset_img_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.train_dataset_img_id_seq OWNED BY public.train_dataset_img.id;


--
-- TOC entry 260 (class 1259 OID 52942)
-- Name: train_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.train_permission (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.train_permission OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 52941)
-- Name: train_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.train_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.train_permission_id_seq OWNER TO postgres;

--
-- TOC entry 3644 (class 0 OID 0)
-- Dependencies: 259
-- Name: train_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.train_permission_id_seq OWNED BY public.train_permission.id;


--
-- TOC entry 249 (class 1259 OID 18511)
-- Name: train_trainedmodel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.train_trainedmodel (
    id integer NOT NULL,
    model_file character varying(100),
    description character varying(300),
    status character varying(100) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    key_attributes text NOT NULL,
    class_label text NOT NULL,
    dataset_id integer,
    user_id integer NOT NULL,
    dataset_img_id integer
);


ALTER TABLE public.train_trainedmodel OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 18510)
-- Name: train_trainedmodel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.train_trainedmodel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.train_trainedmodel_id_seq OWNER TO postgres;

--
-- TOC entry 3645 (class 0 OID 0)
-- Dependencies: 248
-- Name: train_trainedmodel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.train_trainedmodel_id_seq OWNED BY public.train_trainedmodel.id;


--
-- TOC entry 241 (class 1259 OID 16610)
-- Name: train_training_job; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.train_training_job (
    id integer NOT NULL,
    job_name character varying(300) NOT NULL,
    status character varying(300) NOT NULL,
    started_at timestamp with time zone,
    ended_at timestamp with time zone,
    algo character varying(300) NOT NULL,
    dataset_img_id integer NOT NULL,
    user_id integer NOT NULL,
    result text,
    parameter_settings text,
    training_log text,
    training_log_history text
);


ALTER TABLE public.train_training_job OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 16609)
-- Name: train_training_job_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.train_training_job_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.train_training_job_id_seq OWNER TO postgres;

--
-- TOC entry 3646 (class 0 OID 0)
-- Dependencies: 240
-- Name: train_training_job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.train_training_job_id_seq OWNED BY public.train_training_job.id;


--
-- TOC entry 245 (class 1259 OID 16641)
-- Name: uac_group_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.uac_group_config (
    id integer NOT NULL,
    welcome_url character varying(150),
    group_id integer
);


ALTER TABLE public.uac_group_config OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 16640)
-- Name: uac_group_config_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.uac_group_config_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.uac_group_config_id_seq OWNER TO postgres;

--
-- TOC entry 3647 (class 0 OID 0)
-- Dependencies: 244
-- Name: uac_group_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.uac_group_config_id_seq OWNED BY public.uac_group_config.id;


--
-- TOC entry 3293 (class 2604 OID 16428)
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- TOC entry 3294 (class 2604 OID 16437)
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- TOC entry 3292 (class 2604 OID 16421)
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- TOC entry 3295 (class 2604 OID 16444)
-- Name: auth_user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user ALTER COLUMN id SET DEFAULT nextval('public.auth_user_id_seq'::regclass);


--
-- TOC entry 3296 (class 2604 OID 16453)
-- Name: auth_user_groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups ALTER COLUMN id SET DEFAULT nextval('public.auth_user_groups_id_seq'::regclass);


--
-- TOC entry 3297 (class 2604 OID 16460)
-- Name: auth_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_user_user_permissions_id_seq'::regclass);


--
-- TOC entry 3298 (class 2604 OID 16519)
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- TOC entry 3291 (class 2604 OID 16412)
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- TOC entry 3290 (class 2604 OID 16403)
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- TOC entry 3310 (class 2604 OID 18605)
-- Name: django_q_ormq id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_q_ormq ALTER COLUMN id SET DEFAULT nextval('public.django_q_ormq_id_seq'::regclass);


--
-- TOC entry 3309 (class 2604 OID 18583)
-- Name: django_q_schedule id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_q_schedule ALTER COLUMN id SET DEFAULT nextval('public.django_q_schedule_id_seq'::regclass);


--
-- TOC entry 3300 (class 2604 OID 16583)
-- Name: django_site id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_site ALTER COLUMN id SET DEFAULT nextval('public.django_site_id_seq'::regclass);


--
-- TOC entry 3299 (class 2604 OID 16549)
-- Name: registration_registrationprofile id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registration_registrationprofile ALTER COLUMN id SET DEFAULT nextval('public.registration_registrationprofile_id_seq'::regclass);


--
-- TOC entry 3308 (class 2604 OID 18556)
-- Name: train_chart id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.train_chart ALTER COLUMN id SET DEFAULT nextval('public.train_chart_id_seq'::regclass);


--
-- TOC entry 3307 (class 2604 OID 18547)
-- Name: train_charttype id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.train_charttype ALTER COLUMN id SET DEFAULT nextval('public.train_charttype_id_seq'::regclass);


--
-- TOC entry 3303 (class 2604 OID 16635)
-- Name: train_clusternode id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.train_clusternode ALTER COLUMN id SET DEFAULT nextval('public.train_clusternode_id_seq'::regclass);


--
-- TOC entry 3305 (class 2604 OID 18505)
-- Name: train_dataset id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.train_dataset ALTER COLUMN id SET DEFAULT nextval('public.train_dataset_id_seq'::regclass);


--
-- TOC entry 3301 (class 2604 OID 16593)
-- Name: train_dataset_img id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.train_dataset_img ALTER COLUMN id SET DEFAULT nextval('public.train_dataset_img_id_seq'::regclass);


--
-- TOC entry 3311 (class 2604 OID 52945)
-- Name: train_permission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.train_permission ALTER COLUMN id SET DEFAULT nextval('public.train_permission_id_seq'::regclass);


--
-- TOC entry 3306 (class 2604 OID 18514)
-- Name: train_trainedmodel id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.train_trainedmodel ALTER COLUMN id SET DEFAULT nextval('public.train_trainedmodel_id_seq'::regclass);


--
-- TOC entry 3302 (class 2604 OID 16613)
-- Name: train_training_job id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.train_training_job ALTER COLUMN id SET DEFAULT nextval('public.train_training_job_id_seq'::regclass);


--
-- TOC entry 3304 (class 2604 OID 16644)
-- Name: uac_group_config id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uac_group_config ALTER COLUMN id SET DEFAULT nextval('public.uac_group_config_id_seq'::regclass);


--
-- TOC entry 3579 (class 0 OID 16425)
-- Dependencies: 221
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group (id, name) FROM stdin;
1	admin
2	enduser
\.


--
-- TOC entry 3581 (class 0 OID 16434)
-- Dependencies: 223
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
1	1	1
2	1	2
3	1	3
4	1	4
5	1	5
6	1	6
7	1	7
8	1	8
9	1	9
10	1	10
11	1	11
12	1	12
13	1	13
14	1	14
15	1	15
16	1	16
17	1	17
18	1	18
19	1	19
20	1	20
21	1	21
22	1	22
23	1	23
24	1	24
25	1	25
26	1	26
27	1	27
28	1	28
29	1	29
30	1	30
31	1	31
32	1	32
33	1	33
34	1	34
35	1	35
36	1	36
37	1	37
38	1	38
39	1	39
40	1	40
96	2	93
\.


--
-- TOC entry 3577 (class 0 OID 16418)
-- Dependencies: 219
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add group_config	1	add_group_config
2	Can change group_config	1	change_group_config
3	Can delete group_config	1	delete_group_config
4	Can view group_config	1	view_group_config
5	Can add registration profile	2	add_registrationprofile
6	Can change registration profile	2	change_registrationprofile
7	Can delete registration profile	2	delete_registrationprofile
8	Can view registration profile	2	view_registrationprofile
9	Can add supervised registration profile	3	add_supervisedregistrationprofile
10	Can change supervised registration profile	3	change_supervisedregistrationprofile
11	Can delete supervised registration profile	3	delete_supervisedregistrationprofile
12	Can view supervised registration profile	3	view_supervisedregistrationprofile
13	Can add site	4	add_site
14	Can change site	4	change_site
15	Can delete site	4	delete_site
16	Can view site	4	view_site
17	Can add dataset_img	5	add_dataset_img
18	Can change dataset_img	5	change_dataset_img
19	Can delete dataset_img	5	delete_dataset_img
20	Can view dataset_img	5	view_dataset_img
21	Can add training_job	6	add_training_job
22	Can change training_job	6	change_training_job
23	Can delete training_job	6	delete_training_job
24	Can view training_job	6	view_training_job
25	Can add cluster node	7	add_clusternode
26	Can change cluster node	7	change_clusternode
27	Can delete cluster node	7	delete_clusternode
28	Can view cluster node	7	view_clusternode
29	Can add log entry	8	add_logentry
30	Can change log entry	8	change_logentry
31	Can delete log entry	8	delete_logentry
32	Can view log entry	8	view_logentry
33	Can add permission	9	add_permission
34	Can change permission	9	change_permission
35	Can delete permission	9	delete_permission
36	Can view permission	9	view_permission
37	Can add group	10	add_group
38	Can change group	10	change_group
39	Can delete group	10	delete_group
40	Can view group	10	view_group
41	Can add user	11	add_user
42	Can change user	11	change_user
43	Can delete user	11	delete_user
44	Can view user	11	view_user
45	Can add content type	12	add_contenttype
46	Can change content type	12	change_contenttype
47	Can delete content type	12	delete_contenttype
48	Can view content type	12	view_contenttype
49	Can add session	13	add_session
50	Can change session	13	change_session
51	Can delete session	13	delete_session
52	Can view session	13	view_session
53	Can add trained model	14	add_trainedmodel
54	Can change trained model	14	change_trainedmodel
55	Can delete trained model	14	delete_trainedmodel
56	Can view trained model	14	view_trainedmodel
57	Can add dataset	15	add_dataset
58	Can change dataset	15	change_dataset
59	Can delete dataset	15	delete_dataset
60	Can view dataset	15	view_dataset
61	Can add chart type	16	add_charttype
62	Can change chart type	16	change_charttype
63	Can delete chart type	16	delete_charttype
64	Can view chart type	16	view_charttype
65	Can add chart	17	add_chart
66	Can change chart	17	change_chart
67	Can delete chart	17	delete_chart
68	Can view chart	17	view_chart
69	Can add Scheduled task	18	add_schedule
70	Can change Scheduled task	18	change_schedule
71	Can delete Scheduled task	18	delete_schedule
72	Can view Scheduled task	18	view_schedule
73	Can add task	19	add_task
74	Can change task	19	change_task
75	Can delete task	19	delete_task
76	Can view task	19	view_task
77	Can add Failed task	20	add_failure
78	Can change Failed task	20	change_failure
79	Can delete Failed task	20	delete_failure
80	Can view Failed task	20	view_failure
81	Can add Successful task	21	add_success
82	Can change Successful task	21	change_success
83	Can delete Successful task	21	delete_success
84	Can view Successful task	21	view_success
85	Can add Queued task	22	add_ormq
86	Can change Queued task	22	change_ormq
87	Can delete Queued task	22	delete_ormq
88	Can view Queued task	22	view_ormq
89	Can add permission	23	add_permission
90	Can change permission	23	change_permission
91	Can delete permission	23	delete_permission
92	Can view permission	23	view_permission
93	Can perform basic operations	23	enduser_basic
\.


--
-- TOC entry 3583 (class 0 OID 16441)
-- Dependencies: 225
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
1	pbkdf2_sha256$216000$yqg22fH3HIf7$lItuvLlJYQCVwcddYa1NOj3FNjmK5U4C2n8EoEgJ2Pc=	\N	t	administrator			alifida86@gmail.com	t	t	2024-02-04 18:19:54+05
3	pbkdf2_sha256$216000$8J1Z4WEml7cf$E1qbBETXTlJTnGsOnacHWgXss8WNgYRQDAA1B5Y93rw=	2024-02-05 08:41:07+05	f	ali				f	f	2024-02-04 19:13:07+05
2	pbkdf2_sha256$216000$EiESHJ7RKD1i$HBZCS860RwReID+0ItrzoIKuR1FiOgi2aCpDij9Jd4A=	2024-09-22 12:41:01.777355+05	t	admin			alifida.86@gmail.com	t	t	2024-02-04 18:20:47+05
4	pbkdf2_sha256$216000$xh8f1Qwz6IwP$p4cDbEpvhuxeoNpNW36Hc1uOcpfsabPVUFHMuTmvRnQ=	2024-09-22 16:35:50.229473+05	f	demo				t	t	2024-09-22 15:53:14+05
\.


--
-- TOC entry 3585 (class 0 OID 16450)
-- Dependencies: 227
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
1	3	1
19	2	1
20	1	1
21	4	2
\.


--
-- TOC entry 3587 (class 0 OID 16457)
-- Dependencies: 229
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
1	3	1
2	3	2
3	3	3
4	3	4
5	3	5
6	3	6
7	3	7
8	3	8
9	3	9
10	3	10
11	3	11
12	3	12
13	3	13
14	3	14
15	3	15
16	3	16
17	3	17
18	3	18
19	3	19
20	3	20
21	3	21
22	3	22
23	3	23
24	3	24
25	3	25
26	3	26
27	3	27
28	3	28
29	3	29
30	3	30
31	3	31
32	3	32
33	3	33
34	3	34
35	3	35
36	3	36
37	3	37
38	3	38
39	3	39
40	3	40
\.


--
-- TOC entry 3589 (class 0 OID 16516)
-- Dependencies: 231
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
1	2024-02-04 19:11:55.758634+05	1	admin	1	[{"added": {}}]	7	2
2	2024-02-04 19:13:08.14419+05	3	ali	1	[{"added": {}}]	8	2
3	2024-02-04 19:13:23.533423+05	3	ali	2	[{"changed": {"fields": ["Groups", "User permissions"]}}]	8	2
4	2024-02-04 19:42:15.284528+05	1	Test	1	[{"added": {}}]	11	2
5	2024-02-04 19:42:22.807469+05	1	Test	2	[]	11	2
6	2024-06-08 15:48:42.643532+05	31	ffffff	2	[{"changed": {"fields": ["Extracted path", "Delete at"]}}]	11	2
7	2024-06-08 15:49:14.991864+05	31	ffffff	2	[{"changed": {"fields": ["Extracted path"]}}]	11	2
8	2024-06-08 15:51:12.592654+05	31	ffffff	2	[{"changed": {"fields": ["Extracted path"]}}]	11	2
9	2024-06-08 15:54:27.614296+05	31	ffffff	2	[{"changed": {"fields": ["Extracted path"]}}]	11	2
10	2024-06-27 16:10:10.153209+05	62	1  fPa1EBSfvc_20240627210919	3		12	2
11	2024-06-27 16:10:15.94843+05	61	1  lyzQ0LwRtp_20240627210328	3		12	2
12	2024-06-27 19:54:13.174741+05	86	mediumsizeTB  C4qhbErAlN_20240628003706	2	[{"changed": {"fields": ["Result"]}}]	12	2
13	2024-06-27 20:13:05.214628+05	88	Single GPU batch 20	2	[{"changed": {"fields": ["Result"]}}]	12	2
14	2024-06-27 20:13:59.115538+05	89	PS batch 2	2	[{"changed": {"fields": ["Started at", "Ended at"]}}]	12	2
15	2024-06-27 20:14:29.963307+05	90	PS batch 20	2	[{"changed": {"fields": ["Started at", "Ended at"]}}]	12	2
16	2024-06-27 20:14:43.070132+05	88	Single GPU batch 20	2	[{"changed": {"fields": ["Started at", "Ended at"]}}]	12	2
17	2024-06-27 20:17:31.62324+05	92	PS batch 20 again	2	[{"changed": {"fields": ["Job name"]}}]	12	2
18	2024-08-07 21:19:09.445685+05	42	TB Tiny Dataset	3		11	2
19	2024-09-01 00:13:36.102542+05	2	admin	2	[{"changed": {"fields": ["Groups"]}}]	11	2
20	2024-09-01 00:13:47.709306+05	1	administrator	2	[{"changed": {"fields": ["Groups"]}}]	11	2
21	2024-09-01 00:13:54.275947+05	3	ali	2	[]	11	2
22	2024-09-22 15:53:14.794241+05	4	demo	1	[{"added": {}}]	11	2
23	2024-09-22 15:54:09.396785+05	2	enduser	1	[{"added": {}}]	10	2
24	2024-09-22 15:54:23.180688+05	2	enduser	2	[{"changed": {"fields": ["Permissions"]}}]	10	2
25	2024-09-22 15:54:34.600611+05	2	enduser	2	[{"changed": {"fields": ["Permissions"]}}]	10	2
26	2024-09-22 15:54:38.862098+05	2	enduser	2	[{"changed": {"fields": ["Permissions"]}}]	10	2
27	2024-09-22 15:54:46.692452+05	2	enduser	2	[{"changed": {"fields": ["Permissions"]}}]	10	2
28	2024-09-22 15:55:15.764676+05	4	demo	2	[{"changed": {"fields": ["Groups"]}}]	11	2
29	2024-09-22 16:03:11.809576+05	1	/home	1	[{"added": {}}]	1	2
30	2024-09-22 16:06:54.757034+05	4	demo	2	[{"changed": {"fields": ["Staff status"]}}]	11	2
31	2024-09-22 16:18:16.886563+05	1	home	2	[{"changed": {"fields": ["Welcome url"]}}]	1	2
\.


--
-- TOC entry 3575 (class 0 OID 16409)
-- Dependencies: 217
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	uac	group_config
2	registration	registrationprofile
3	registration	supervisedregistrationprofile
4	sites	site
5	train	dataset_img
6	train	training_job
7	train	clusternode
8	admin	logentry
9	auth	permission
10	auth	group
11	auth	user
12	contenttypes	contenttype
13	sessions	session
14	train	trainedmodel
15	train	dataset
16	train	charttype
17	train	chart
18	django_q	schedule
19	django_q	task
20	django_q	failure
21	django_q	success
22	django_q	ormq
23	train	permission
\.


--
-- TOC entry 3573 (class 0 OID 16400)
-- Dependencies: 215
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2024-08-17 16:03:12.684229+05
2	auth	0001_initial	2024-08-17 16:03:12.73226+05
3	admin	0001_initial	2024-08-17 16:03:12.806633+05
4	admin	0002_logentry_remove_auto_add	2024-08-17 16:03:12.822782+05
5	admin	0003_logentry_add_action_flag_choices	2024-08-17 16:03:12.827753+05
6	contenttypes	0002_remove_content_type_name	2024-08-17 16:03:12.840055+05
7	auth	0002_alter_permission_name_max_length	2024-08-17 16:03:12.846176+05
8	auth	0003_alter_user_email_max_length	2024-08-17 16:03:12.852508+05
9	auth	0004_alter_user_username_opts	2024-08-17 16:03:12.858239+05
10	auth	0005_alter_user_last_login_null	2024-08-17 16:03:12.86439+05
11	auth	0006_require_contenttypes_0002	2024-08-17 16:03:12.865444+05
12	auth	0007_alter_validators_add_error_messages	2024-08-17 16:03:12.87143+05
13	auth	0008_alter_user_username_max_length	2024-08-17 16:03:12.883864+05
14	auth	0009_alter_user_last_name_max_length	2024-08-17 16:03:12.901113+05
15	auth	0010_alter_group_name_max_length	2024-08-17 16:03:12.909131+05
16	auth	0011_update_proxy_permissions	2024-08-17 16:03:12.915293+05
17	auth	0012_alter_user_first_name_max_length	2024-08-17 16:03:12.921723+05
18	registration	0001_initial	2024-08-17 16:03:12.935721+05
19	registration	0002_registrationprofile_activated	2024-08-17 16:03:12.944188+05
20	registration	0003_migrate_activatedstatus	2024-08-17 16:03:12.952119+05
21	registration	0004_supervisedregistrationprofile	2024-08-17 16:03:12.962524+05
22	registration	0005_activation_key_sha256	2024-08-17 16:03:12.970457+05
23	sessions	0001_initial	2024-08-17 16:03:12.98171+05
24	sites	0001_initial	2024-08-17 16:03:12.995502+05
25	sites	0002_alter_domain_unique	2024-08-17 16:03:13.005635+05
26	train	0001_initial	2024-08-17 16:03:13.023133+05
27	train	0002_auto_20240211_1407	2024-08-17 16:03:13.105254+05
28	train	0003_dataset_img_extracted_path	2024-08-17 16:03:13.123602+05
29	train	0004_clusternode	2024-08-17 16:03:13.130929+05
30	train	0005_training_job_result	2024-08-17 16:03:13.138712+05
31	train	0006_auto_20240808_1525	2024-08-17 16:03:13.152675+05
32	uac	0001_initial	2024-08-17 16:03:13.166189+05
33	train	0007_training_job_parameter_settings	2024-08-17 20:17:53.535295+05
34	train	0008_dataset_trainedmodel	2024-08-31 19:10:13.425335+05
35	train	0009_chart_charttype	2024-08-31 20:10:14.518778+05
36	train	0010_auto_20240907_0905	2024-09-07 09:05:15.509096+05
37	train	0011_auto_20240907_1422	2024-09-07 14:23:07.156585+05
38	train	0012_training_job_training_log_history	2024-09-07 14:28:11.059791+05
39	django_q	0001_initial	2024-09-07 15:39:29.288438+05
40	django_q	0002_auto_20150630_1624	2024-09-07 15:39:29.296417+05
41	django_q	0003_auto_20150708_1326	2024-09-07 15:39:29.310142+05
42	django_q	0004_auto_20150710_1043	2024-09-07 15:39:29.320115+05
43	django_q	0005_auto_20150718_1506	2024-09-07 15:39:29.325101+05
44	django_q	0006_auto_20150805_1817	2024-09-07 15:39:29.331085+05
45	django_q	0007_ormq	2024-09-07 15:39:29.344725+05
46	django_q	0008_auto_20160224_1026	2024-09-07 15:39:29.348695+05
47	django_q	0009_auto_20171009_0915	2024-09-07 15:39:29.360906+05
48	django_q	0010_auto_20200610_0856	2024-09-07 15:39:29.369883+05
49	django_q	0011_auto_20200628_1055	2024-09-07 15:39:29.37507+05
50	django_q	0012_auto_20200702_1608	2024-09-07 15:39:29.377901+05
51	django_q	0013_task_attempt_count	2024-09-07 15:39:29.382882+05
52	django_q	0014_schedule_cluster	2024-09-07 15:39:29.386549+05
53	train	0013_trainedmodel_dataset_type	2024-09-09 22:10:16.546836+05
54	train	0014_auto_20240909_2216	2024-09-09 22:17:12.644111+05
55	train	0015_auto_20240909_2223	2024-09-09 22:24:08.399875+05
56	train	0016_permission	2024-09-22 15:51:41.439573+05
\.


--
-- TOC entry 3616 (class 0 OID 18602)
-- Dependencies: 258
-- Data for Name: django_q_ormq; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_q_ormq (id, key, payload, lock) FROM stdin;
\.


--
-- TOC entry 3613 (class 0 OID 18580)
-- Dependencies: 255
-- Data for Name: django_q_schedule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_q_schedule (id, func, hook, args, kwargs, schedule_type, repeats, next_run, task, name, minutes, cron, cluster) FROM stdin;
\.


--
-- TOC entry 3614 (class 0 OID 18589)
-- Dependencies: 256
-- Data for Name: django_q_task; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_q_task (name, func, hook, args, kwargs, result, started, stopped, success, id, "group", attempt_count) FROM stdin;
delta-ceiling-california-don	train.services.TrainingServiceSingle.start_training	\N	gAWVDwcAAAAAAAB9lCiMCmRhdGFzZXRfaWSUjAIxNZSMBHVzZXKUjBVkamFuZ28uZGIubW9kZWxzLmJhc2WUjA5tb2RlbF91bnBpY2tsZZSTlIwEYXV0aJSMBFVzZXKUhpSFlFKUfZQojAZfc3RhdGWUaASMCk1vZGVsU3RhdGWUk5QpgZR9lCiMBmFkZGluZ5SJjAJkYpSMB2RlZmF1bHSUjAxmaWVsZHNfY2FjaGWUfZR1YowCaWSUSwKMCHBhc3N3b3JklIxOcGJrZGYyX3NoYTI1NiQyMTYwMDAkRWlFU0hKN1JLRDFpJEhCWkNTODYwUndSZUlEKzBJdHJ6b0lLdVIxRmlPZ2kyYUNwRGlqOUpkNEE9lIwKbGFzdF9sb2dpbpSMCGRhdGV0aW1llIwIZGF0ZXRpbWWUk5RDCgfoCQgGMQ4NEEOUjARweXR6lIwEX1VUQ5STlClSlIaUUpSMDGlzX3N1cGVydXNlcpSIjAh1c2VybmFtZZSMBWFkbWlulIwKZmlyc3RfbmFtZZSMAJSMCWxhc3RfbmFtZZRoKYwFZW1haWyUjBRhbGlmaWRhLjg2QGdtYWlsLmNvbZSMCGlzX3N0YWZmlIiMCWlzX2FjdGl2ZZSIjAtkYXRlX2pvaW5lZJRoHUMKB+gCBA0ULwAAAJRoIoaUUpSMD19kamFuZ29fdmVyc2lvbpSMBTMuMS4ylHVijAhzdHJhdGVneZSMClNpbmdsZSBHUFWUjAlhbGdvX25hbWWUjAtEZW5zZU5ldDEyMZSMBmVwb2Noc5SMAjEwlIwKYmF0Y2hfc2l6ZZSMAjMylIwNbGVhcm5pbmdfcmF0ZZSMBTAuMDAxlIwJb3B0aW1pemVylIwEYWRhbZSMDWxvc3NfZnVuY3Rpb26UjBNiaW5hcnlfY3Jvc3NlbnRyb3B5lIwQdmFsaWRhdGlvbl9zcGxpdJSMAzAuMpSMF2Vhcmx5X3N0b3BwaW5nX3BhdGllbmNllIwCMTCUjAxkcm9wb3V0X3JhdGWUjAMwLjWUjAxhdWdtZW50YXRpb26UjAROb25llIwNY2xhc3Nfd2VpZ2h0c5RoKYwLcmFuZG9tX3NlZWSUjAI0MpSMDHRyYWluaW5nX2pvYpRoBowFdHJhaW6UjAxUcmFpbmluZ19qb2KUhpSFlFKUfZQoaA1oDymBlH2UKGgTaBRoFX2UKIwLZGF0YXNldF9pbWeUaAZoT4wLRGF0YXNldF9JTUeUhpSFlFKUfZQoaA1oDymBlH2UKGgVfZRoEoloE2gUdWJoF0sPjAlkYXRhX25hbWWUjA9UQiBUaW55IERhdGFzZXSUjAlkYXRhX3BhdGiUjCMxNTB4MTUwX3RiX2RhdGFzZXRfdGlueV9nUXdvVjdGLnppcJSMDmV4dHJhY3RlZF9wYXRolIxFRTpcd29ya3NwYWNlXHB5dGhvblxkZWVwLWRpc3RyaWJ1dGVcZGVlcGRpc3RyaWJ1dGVcbWVkaWFcdG1wLzE1L3RyYWlulIwOZGF0YV9wYXRoX3Rlc3SUjB1kamFuZ28uZGIubW9kZWxzLmZpZWxkcy5maWxlc5SMCUZpZWxkRmlsZZSTlCmBlH2UKIwEbmFtZZSMKDE1MHgxNTBfdGJfZGF0YXNldF90aW55LXRlc3RfREpKVmV2Wi56aXCUjAZjbG9zZWSUiYwKX2NvbW1pdHRlZJSIjAVfZmlsZZROjAhpbnN0YW5jZZRoXIwFZmllbGSUjBdkamFuZ28uZGIubW9kZWxzLmZpZWxkc5SMC19sb2FkX2ZpZWxklJOUaE9oWYwOZGF0YV9wYXRoX3Rlc3SUh5RSlHVijBNleHRyYWN0ZWRfcGF0aF90ZXN0lIxERTpcd29ya3NwYWNlXHB5dGhvblxkZWVwLWRpc3RyaWJ1dGVcZGVlcGRpc3RyaWJ1dGVcbWVkaWFcdG1wLzE1L3Rlc3SUjAhtZXRhaW5mb5RoKYwMcHJvY2Vzc2VkX2F0lGgdQwoH6AkHBTAKCBv8lGgihpRSlIwJZGVsZXRlX2F0lE6MBnN0YXR1c5RoKYwHdXNlcl9pZJRLAmgzaDR1YmgDaAt1aBKJdWJoF0sxjAhqb2JfbmFtZZSMKlRCIFRpbnkgRGF0YXNldCAgN1Q2Nm1sdUNNSF8yMDI0MDkwODEyMDI1NJSMDmRhdGFzZXRfaW1nX2lklEsPaIKMB1JVTk5JTkeUjApzdGFydGVkX2F0lGgdQwoH6AkIBwI2CdJblGgihpRSlIwIZW5kZWRfYXSUTowEYWxnb5RoOIwHdXNlcl9pZJRLAowScGFyYW1ldGVyX3NldHRpbmdzlGgAjAZyZXN1bHSUTowMdHJhaW5pbmdfbG9nlE6MFHRyYWluaW5nX2xvZ19oaXN0b3J5lE5oM2g0dWJ1hZQu	gAV9lC4=	gAWVJgUAAAAAAABYHwUAAFRyYWluaW5nX2pvYiBtYXRjaGluZyBxdWVyeSBkb2VzIG5vdCBleGlzdC4gOiBUcmFjZWJhY2sgKG1vc3QgcmVjZW50IGNhbGwgbGFzdCk6CiAgRmlsZSAiQzpccHl0aG9uMzgwXGxpYlxzaXRlLXBhY2thZ2VzXGRqYW5nb19xXGNsdXN0ZXIucHkiLCBsaW5lIDQzMiwgaW4gd29ya2VyCiAgICByZXMgPSBmKCp0YXNrWyJhcmdzIl0sICoqdGFza1sia3dhcmdzIl0pCiAgRmlsZSAiRTpcd29ya3NwYWNlXHB5dGhvblxkZWVwLWRpc3RyaWJ1dGVcdHJhaW5cc2VydmljZXNcVHJhaW5pbmdTZXJ2aWNlU2luZ2xlLnB5IiwgbGluZSAxNzEsIGluIHN0YXJ0X3RyYWluaW5nCiAgICBtb2RlbC5maXQodHJhaW5fZ2VuZXJhdG9yLAogIEZpbGUgIkM6XHB5dGhvbjM4MFxsaWJcc2l0ZS1wYWNrYWdlc1x0ZW5zb3JmbG93XHB5dGhvblxrZXJhc1xlbmdpbmVcdHJhaW5pbmcucHkiLCBsaW5lIDExNDUsIGluIGZpdAogICAgY2FsbGJhY2tzLm9uX2Vwb2NoX2VuZChlcG9jaCwgZXBvY2hfbG9ncykKICBGaWxlICJDOlxweXRob24zODBcbGliXHNpdGUtcGFja2FnZXNcdGVuc29yZmxvd1xweXRob25ca2VyYXNcY2FsbGJhY2tzLnB5IiwgbGluZSA0MzIsIGluIG9uX2Vwb2NoX2VuZAogICAgY2FsbGJhY2sub25fZXBvY2hfZW5kKGVwb2NoLCBudW1weV9sb2dzKQogIEZpbGUgIkU6XHdvcmtzcGFjZVxweXRob25cZGVlcC1kaXN0cmlidXRlXHRyYWluXHNlcnZpY2VzXFRyYWluaW5nU2VydmljZVNpbmdsZS5weSIsIGxpbmUgMjcwLCBpbiBvbl9lcG9jaF9lbmQKICAgIHRyYWluaW5nX2pvYiA9IFRyYWluaW5nSm9iREFPLmdldChzZWxmLmpvYl9pZCkKICBGaWxlICJFOlx3b3Jrc3BhY2VccHl0aG9uXGRlZXAtZGlzdHJpYnV0ZVx0cmFpblxkYW9cVHJhaW5pbmdKb2JEQU8ucHkiLCBsaW5lIDIxLCBpbiBnZXQKICAgIHJldHVybiBUcmFpbmluZ19qb2Iub2JqZWN0cy5nZXQoaWQ9am9iX2lkKQogIEZpbGUgIkM6XHB5dGhvbjM4MFxsaWJcc2l0ZS1wYWNrYWdlc1xkamFuZ29cZGJcbW9kZWxzXG1hbmFnZXIucHkiLCBsaW5lIDg1LCBpbiBtYW5hZ2VyX21ldGhvZAogICAgcmV0dXJuIGdldGF0dHIoc2VsZi5nZXRfcXVlcnlzZXQoKSwgbmFtZSkoKmFyZ3MsICoqa3dhcmdzKQogIEZpbGUgIkM6XHB5dGhvbjM4MFxsaWJcc2l0ZS1wYWNrYWdlc1xkamFuZ29cZGJcbW9kZWxzXHF1ZXJ5LnB5IiwgbGluZSA0MjksIGluIGdldAogICAgcmFpc2Ugc2VsZi5tb2RlbC5Eb2VzTm90RXhpc3QoCnRyYWluLm1vZGVscy5UcmFpbmluZ19qb2IuRG9lc05vdEV4aXN0OiBUcmFpbmluZ19qb2IgbWF0Y2hpbmcgcXVlcnkgZG9lcyBub3QgZXhpc3QuCpQu	2024-09-08 12:02:54.657987+05	2024-09-22 13:02:11.985916+05	f	201b474e89fb4c1a946104efdd01f810	\N	1
one-stairway-comet-romeo	train.services.TrainingServiceSingle.start_training	\N	gAWVDgcAAAAAAAB9lCiMCmRhdGFzZXRfaWSUjAIxNpSMBHVzZXKUjBVkamFuZ28uZGIubW9kZWxzLmJhc2WUjA5tb2RlbF91bnBpY2tsZZSTlIwEYXV0aJSMBFVzZXKUhpSFlFKUfZQojAZfc3RhdGWUaASMCk1vZGVsU3RhdGWUk5QpgZR9lCiMBmFkZGluZ5SJjAJkYpSMB2RlZmF1bHSUjAxmaWVsZHNfY2FjaGWUfZR1YowCaWSUSwKMCHBhc3N3b3JklIxOcGJrZGYyX3NoYTI1NiQyMTYwMDAkRWlFU0hKN1JLRDFpJEhCWkNTODYwUndSZUlEKzBJdHJ6b0lLdVIxRmlPZ2kyYUNwRGlqOUpkNEE9lIwKbGFzdF9sb2dpbpSMCGRhdGV0aW1llIwIZGF0ZXRpbWWUk5RDCgfoCRYHKQEL3IuUjARweXR6lIwEX1VUQ5STlClSlIaUUpSMDGlzX3N1cGVydXNlcpSIjAh1c2VybmFtZZSMBWFkbWlulIwKZmlyc3RfbmFtZZSMAJSMCWxhc3RfbmFtZZRoKYwFZW1haWyUjBRhbGlmaWRhLjg2QGdtYWlsLmNvbZSMCGlzX3N0YWZmlIiMCWlzX2FjdGl2ZZSIjAtkYXRlX2pvaW5lZJRoHUMKB+gCBA0ULwAAAJRoIoaUUpSMD19kamFuZ29fdmVyc2lvbpSMBTMuMS4ylHVijAhzdHJhdGVneZSMClNpbmdsZSBHUFWUjAlhbGdvX25hbWWUjAtEZW5zZU5ldDEyMZSMBmVwb2Noc5SMATKUjApiYXRjaF9zaXpllIwCMzKUjA1sZWFybmluZ19yYXRllIwFMC4wMDGUjAlvcHRpbWl6ZXKUjARhZGFtlIwNbG9zc19mdW5jdGlvbpSME2JpbmFyeV9jcm9zc2VudHJvcHmUjBB2YWxpZGF0aW9uX3NwbGl0lIwDMC4ylIwXZWFybHlfc3RvcHBpbmdfcGF0aWVuY2WUjAIxMJSMDGRyb3BvdXRfcmF0ZZSMAzAuNZSMDGF1Z21lbnRhdGlvbpSMBE5vbmWUjA1jbGFzc193ZWlnaHRzlGgpjAtyYW5kb21fc2VlZJSMAjQylIwMdHJhaW5pbmdfam9ilGgGjAV0cmFpbpSMDFRyYWluaW5nX2pvYpSGlIWUUpR9lChoDWgPKYGUfZQoaBNoFGgVfZQojAtkYXRhc2V0X2ltZ5RoBmhPjAtEYXRhc2V0X0lNR5SGlIWUUpR9lChoDWgPKYGUfZQoaBV9lGgSiWgTaBR1YmgXSxCMCWRhdGFfbmFtZZSMD1RCIFRpbnkgRGF0YXNldJSMCWRhdGFfcGF0aJSMIzE1MHgxNTBfdGJfZGF0YXNldF90aW55X3RCaURkcU8uemlwlIwOZXh0cmFjdGVkX3BhdGiUjEVFOlx3b3Jrc3BhY2VccHl0aG9uXGRlZXAtZGlzdHJpYnV0ZVxkZWVwZGlzdHJpYnV0ZVxtZWRpYVx0bXAvMTYvdHJhaW6UjA5kYXRhX3BhdGhfdGVzdJSMHWRqYW5nby5kYi5tb2RlbHMuZmllbGRzLmZpbGVzlIwJRmllbGRGaWxllJOUKYGUfZQojARuYW1llIwoMTUweDE1MF90Yl9kYXRhc2V0X3RpbnktdGVzdF9BblNWcTJpLnppcJSMBmNsb3NlZJSJjApfY29tbWl0dGVklIiMBV9maWxllE6MCGluc3RhbmNllGhcjAVmaWVsZJSMF2RqYW5nby5kYi5tb2RlbHMuZmllbGRzlIwLX2xvYWRfZmllbGSUk5RoT2hZjA5kYXRhX3BhdGhfdGVzdJSHlFKUdWKME2V4dHJhY3RlZF9wYXRoX3Rlc3SUjERFOlx3b3Jrc3BhY2VccHl0aG9uXGRlZXAtZGlzdHJpYnV0ZVxkZWVwZGlzdHJpYnV0ZVxtZWRpYVx0bXAvMTYvdGVzdJSMCG1ldGFpbmZvlGgpjAxwcm9jZXNzZWRfYXSUaB1DCgfoCRYHMCkBaseUaCKGlFKUjAlkZWxldGVfYXSUTowGc3RhdHVzlGgpjAd1c2VyX2lklEsCaDNoNHViaANoC3VoEol1YmgXS1aMCGpvYl9uYW1llIwqVEIgVGlueSBEYXRhc2V0ICBtTzA5UHpFNXlqXzIwMjQwOTIyMTMwMzI3lIwOZGF0YXNldF9pbWdfaWSUSxBogowHUlVOTklOR5SMCnN0YXJ0ZWRfYXSUaB1DCgfoCRYIAxsEoqSUaCKGlFKUjAhlbmRlZF9hdJROjARhbGdvlGg4jAd1c2VyX2lklEsCjBJwYXJhbWV0ZXJfc2V0dGluZ3OUaACMBnJlc3VsdJROjAx0cmFpbmluZ19sb2eUTowUdHJhaW5pbmdfbG9nX2hpc3RvcnmUTmgzaDR1YnWFlC4=	gAV9lC4=	\N	2024-09-22 13:03:27.306044+05	2024-09-22 13:03:48.365284+05	t	b02f6a517f7d43929e59719d64cf6c7b	\N	1
sad-delaware-hotel-pluto	train.services.TrainingServiceSingle.start_training	\N	gAWVIAcAAAAAAAB9lCiMCmRhdGFzZXRfaWSUjAIxNpSMBHVzZXKUjBVkamFuZ28uZGIubW9kZWxzLmJhc2WUjA5tb2RlbF91bnBpY2tsZZSTlIwEYXV0aJSMBFVzZXKUhpSFlFKUfZQojAZfc3RhdGWUaASMCk1vZGVsU3RhdGWUk5QpgZR9lCiMBmFkZGluZ5SJjAJkYpSMB2RlZmF1bHSUjAxmaWVsZHNfY2FjaGWUfZR1YowCaWSUSwKMCHBhc3N3b3JklIxOcGJrZGYyX3NoYTI1NiQyMTYwMDAkRWlFU0hKN1JLRDFpJEhCWkNTODYwUndSZUlEKzBJdHJ6b0lLdVIxRmlPZ2kyYUNwRGlqOUpkNEE9lIwKbGFzdF9sb2dpbpSMCGRhdGV0aW1llIwIZGF0ZXRpbWWUk5RDCgfoCRYHKQEL3IuUjARweXR6lIwEX1VUQ5STlClSlIaUUpSMDGlzX3N1cGVydXNlcpSIjAh1c2VybmFtZZSMBWFkbWlulIwKZmlyc3RfbmFtZZSMAJSMCWxhc3RfbmFtZZRoKYwFZW1haWyUjBRhbGlmaWRhLjg2QGdtYWlsLmNvbZSMCGlzX3N0YWZmlIiMCWlzX2FjdGl2ZZSIjAtkYXRlX2pvaW5lZJRoHUMKB+gCBA0ULwAAAJRoIoaUUpSMD19kamFuZ29fdmVyc2lvbpSMBTMuMS4ylHVijAhzdHJhdGVneZSMClNpbmdsZSBHUFWUjAlhbGdvX25hbWWUjAtEZW5zZU5ldDEyMZSMBmVwb2Noc5SMAjEwlIwKYmF0Y2hfc2l6ZZSMAjMylIwNbGVhcm5pbmdfcmF0ZZSMBTAuMDAxlIwJb3B0aW1pemVylIwEYWRhbZSMDWxvc3NfZnVuY3Rpb26UjBNiaW5hcnlfY3Jvc3NlbnRyb3B5lIwQdmFsaWRhdGlvbl9zcGxpdJSMAzAuMpSMF2Vhcmx5X3N0b3BwaW5nX3BhdGllbmNllIwCMTCUjAxkcm9wb3V0X3JhdGWUjAMwLjWUjAxhdWdtZW50YXRpb26UjAROb25llIwNY2xhc3Nfd2VpZ2h0c5RoKYwLcmFuZG9tX3NlZWSUjAI0MpSMDHRyYWluaW5nX2pvYpRoBowFdHJhaW6UjAxUcmFpbmluZ19qb2KUhpSFlFKUfZQojAZfc3RhdGWUaA8pgZR9lChoE2gUaBV9lCiMC2RhdGFzZXRfaW1nlGgGaE+MC0RhdGFzZXRfSU1HlIaUhZRSlH2UKGgNaA8pgZR9lChoFX2UaBKJaBNoFHViaBdLEIwJZGF0YV9uYW1llIwPVEIgVGlueSBEYXRhc2V0lIwJZGF0YV9wYXRolIwjMTUweDE1MF90Yl9kYXRhc2V0X3RpbnlfdEJpRGRxTy56aXCUjA5leHRyYWN0ZWRfcGF0aJSMRUU6XHdvcmtzcGFjZVxweXRob25cZGVlcC1kaXN0cmlidXRlXGRlZXBkaXN0cmlidXRlXG1lZGlhXHRtcC8xNi90cmFpbpSMDmRhdGFfcGF0aF90ZXN0lIwdZGphbmdvLmRiLm1vZGVscy5maWVsZHMuZmlsZXOUjAlGaWVsZEZpbGWUk5QpgZR9lCiMBG5hbWWUjCgxNTB4MTUwX3RiX2RhdGFzZXRfdGlueS10ZXN0X0FuU1ZxMmkuemlwlIwGY2xvc2VklImMCl9jb21taXR0ZWSUiIwFX2ZpbGWUTowIaW5zdGFuY2WUaF2MBWZpZWxklIwXZGphbmdvLmRiLm1vZGVscy5maWVsZHOUjAtfbG9hZF9maWVsZJSTlGhPaFqMDmRhdGFfcGF0aF90ZXN0lIeUUpR1YowTZXh0cmFjdGVkX3BhdGhfdGVzdJSMREU6XHdvcmtzcGFjZVxweXRob25cZGVlcC1kaXN0cmlidXRlXGRlZXBkaXN0cmlidXRlXG1lZGlhXHRtcC8xNi90ZXN0lIwIbWV0YWluZm+UaCmMDHByb2Nlc3NlZF9hdJRoHUMKB+gJFgcwKQFqx5RoIoaUUpSMCWRlbGV0ZV9hdJROjAZzdGF0dXOUaCmMB3VzZXJfaWSUSwJoM2g0dWJoA2gLdWgSiXVijAJpZJRLV4wIam9iX25hbWWUjCpUQiBUaW55IERhdGFzZXQgIHJacmtSZ2ZWRGhfMjAyNDA5MjIxMzA1NTCUjA5kYXRhc2V0X2ltZ19pZJRLEIwGc3RhdHVzlIwHUlVOTklOR5SMCnN0YXJ0ZWRfYXSUaB1DCgfoCRYIBTIFwieUaCKGlFKUjAhlbmRlZF9hdJROjARhbGdvlGg4jAd1c2VyX2lklEsCjBJwYXJhbWV0ZXJfc2V0dGluZ3OUaACMBnJlc3VsdJROjAx0cmFpbmluZ19sb2eUTowUdHJhaW5pbmdfbG9nX2hpc3RvcnmUTmgzaDR1YnWFlC4=	gAV9lC4=	\N	2024-09-22 13:05:50.379376+05	2024-09-22 13:06:02.759834+05	t	bebef44ae14240d2a3976f04fe241873	\N	1
july-snake-xray-oscar	train.services.TrainingServiceSingle.start_training	\N	gAWVDgcAAAAAAAB9lCiMCmRhdGFzZXRfaWSUjAIxNZSMBHVzZXKUjBVkamFuZ28uZGIubW9kZWxzLmJhc2WUjA5tb2RlbF91bnBpY2tsZZSTlIwEYXV0aJSMBFVzZXKUhpSFlFKUfZQojAZfc3RhdGWUaASMCk1vZGVsU3RhdGWUk5QpgZR9lCiMBmFkZGluZ5SJjAJkYpSMB2RlZmF1bHSUjAxmaWVsZHNfY2FjaGWUfZR1YowCaWSUSwKMCHBhc3N3b3JklIxOcGJrZGYyX3NoYTI1NiQyMTYwMDAkRWlFU0hKN1JLRDFpJEhCWkNTODYwUndSZUlEKzBJdHJ6b0lLdVIxRmlPZ2kyYUNwRGlqOUpkNEE9lIwKbGFzdF9sb2dpbpSMCGRhdGV0aW1llIwIZGF0ZXRpbWWUk5RDCgfoCQgGMQ4NEEOUjARweXR6lIwEX1VUQ5STlClSlIaUUpSMDGlzX3N1cGVydXNlcpSIjAh1c2VybmFtZZSMBWFkbWlulIwKZmlyc3RfbmFtZZSMAJSMCWxhc3RfbmFtZZRoKYwFZW1haWyUjBRhbGlmaWRhLjg2QGdtYWlsLmNvbZSMCGlzX3N0YWZmlIiMCWlzX2FjdGl2ZZSIjAtkYXRlX2pvaW5lZJRoHUMKB+gCBA0ULwAAAJRoIoaUUpSMD19kamFuZ29fdmVyc2lvbpSMBTMuMS4ylHVijAhzdHJhdGVneZSMClNpbmdsZSBHUFWUjAlhbGdvX25hbWWUjAtEZW5zZU5ldDE2OZSMBmVwb2Noc5SMATGUjApiYXRjaF9zaXpllIwCMzKUjA1sZWFybmluZ19yYXRllIwFMC4wMDGUjAlvcHRpbWl6ZXKUjARhZGFtlIwNbG9zc19mdW5jdGlvbpSME2JpbmFyeV9jcm9zc2VudHJvcHmUjBB2YWxpZGF0aW9uX3NwbGl0lIwDMC4ylIwXZWFybHlfc3RvcHBpbmdfcGF0aWVuY2WUjAIxMJSMDGRyb3BvdXRfcmF0ZZSMAzAuNZSMDGF1Z21lbnRhdGlvbpSMBE5vbmWUjA1jbGFzc193ZWlnaHRzlGgpjAtyYW5kb21fc2VlZJSMAjQylIwMdHJhaW5pbmdfam9ilGgGjAV0cmFpbpSMDFRyYWluaW5nX2pvYpSGlIWUUpR9lChoDWgPKYGUfZQoaBNoFGgVfZQojAtkYXRhc2V0X2ltZ5RoBmhPjAtEYXRhc2V0X0lNR5SGlIWUUpR9lChoDWgPKYGUfZQoaBV9lGgSiWgTaBR1YmgXSw+MCWRhdGFfbmFtZZSMD1RCIFRpbnkgRGF0YXNldJSMCWRhdGFfcGF0aJSMIzE1MHgxNTBfdGJfZGF0YXNldF90aW55X2dRd29WN0YuemlwlIwOZXh0cmFjdGVkX3BhdGiUjEVFOlx3b3Jrc3BhY2VccHl0aG9uXGRlZXAtZGlzdHJpYnV0ZVxkZWVwZGlzdHJpYnV0ZVxtZWRpYVx0bXAvMTUvdHJhaW6UjA5kYXRhX3BhdGhfdGVzdJSMHWRqYW5nby5kYi5tb2RlbHMuZmllbGRzLmZpbGVzlIwJRmllbGRGaWxllJOUKYGUfZQojARuYW1llIwoMTUweDE1MF90Yl9kYXRhc2V0X3RpbnktdGVzdF9ESkpWZXZaLnppcJSMBmNsb3NlZJSJjApfY29tbWl0dGVklIiMBV9maWxllE6MCGluc3RhbmNllGhcjAVmaWVsZJSMF2RqYW5nby5kYi5tb2RlbHMuZmllbGRzlIwLX2xvYWRfZmllbGSUk5RoT2hZjA5kYXRhX3BhdGhfdGVzdJSHlFKUdWKME2V4dHJhY3RlZF9wYXRoX3Rlc3SUjERFOlx3b3Jrc3BhY2VccHl0aG9uXGRlZXAtZGlzdHJpYnV0ZVxkZWVwZGlzdHJpYnV0ZVxtZWRpYVx0bXAvMTUvdGVzdJSMCG1ldGFpbmZvlGgpjAxwcm9jZXNzZWRfYXSUaB1DCgfoCQcFMAoIG/yUaCKGlFKUjAlkZWxldGVfYXSUTowGc3RhdHVzlGgpjAd1c2VyX2lklEsCaDNoNHViaANoC3VoEol1YmgXS0qMCGpvYl9uYW1llIwqVEIgVGlueSBEYXRhc2V0ICBOYnFlTEZUNE1zXzIwMjQwOTEwMjEyNjQxlIwOZGF0YXNldF9pbWdfaWSUSw9ogowHUlVOTklOR5SMCnN0YXJ0ZWRfYXSUaB1DCgfoCQoQGikBAP+UaCKGlFKUjAhlbmRlZF9hdJROjARhbGdvlGg4jAd1c2VyX2lklEsCjBJwYXJhbWV0ZXJfc2V0dGluZ3OUaACMBnJlc3VsdJROjAx0cmFpbmluZ19sb2eUTowUdHJhaW5pbmdfbG9nX2hpc3RvcnmUTmgzaDR1YnWFlC4=	gAV9lC4=	gAWVJgUAAAAAAABYHwUAAFRyYWluaW5nX2pvYiBtYXRjaGluZyBxdWVyeSBkb2VzIG5vdCBleGlzdC4gOiBUcmFjZWJhY2sgKG1vc3QgcmVjZW50IGNhbGwgbGFzdCk6CiAgRmlsZSAiQzpccHl0aG9uMzgwXGxpYlxzaXRlLXBhY2thZ2VzXGRqYW5nb19xXGNsdXN0ZXIucHkiLCBsaW5lIDQzMiwgaW4gd29ya2VyCiAgICByZXMgPSBmKCp0YXNrWyJhcmdzIl0sICoqdGFza1sia3dhcmdzIl0pCiAgRmlsZSAiRTpcd29ya3NwYWNlXHB5dGhvblxkZWVwLWRpc3RyaWJ1dGVcdHJhaW5cc2VydmljZXNcVHJhaW5pbmdTZXJ2aWNlU2luZ2xlLnB5IiwgbGluZSAxNzEsIGluIHN0YXJ0X3RyYWluaW5nCiAgICBtb2RlbC5maXQodHJhaW5fZ2VuZXJhdG9yLAogIEZpbGUgIkM6XHB5dGhvbjM4MFxsaWJcc2l0ZS1wYWNrYWdlc1x0ZW5zb3JmbG93XHB5dGhvblxrZXJhc1xlbmdpbmVcdHJhaW5pbmcucHkiLCBsaW5lIDExNDUsIGluIGZpdAogICAgY2FsbGJhY2tzLm9uX2Vwb2NoX2VuZChlcG9jaCwgZXBvY2hfbG9ncykKICBGaWxlICJDOlxweXRob24zODBcbGliXHNpdGUtcGFja2FnZXNcdGVuc29yZmxvd1xweXRob25ca2VyYXNcY2FsbGJhY2tzLnB5IiwgbGluZSA0MzIsIGluIG9uX2Vwb2NoX2VuZAogICAgY2FsbGJhY2sub25fZXBvY2hfZW5kKGVwb2NoLCBudW1weV9sb2dzKQogIEZpbGUgIkU6XHdvcmtzcGFjZVxweXRob25cZGVlcC1kaXN0cmlidXRlXHRyYWluXHNlcnZpY2VzXFRyYWluaW5nU2VydmljZVNpbmdsZS5weSIsIGxpbmUgMjcwLCBpbiBvbl9lcG9jaF9lbmQKICAgIHRyYWluaW5nX2pvYiA9IFRyYWluaW5nSm9iREFPLmdldChzZWxmLmpvYl9pZCkKICBGaWxlICJFOlx3b3Jrc3BhY2VccHl0aG9uXGRlZXAtZGlzdHJpYnV0ZVx0cmFpblxkYW9cVHJhaW5pbmdKb2JEQU8ucHkiLCBsaW5lIDIxLCBpbiBnZXQKICAgIHJldHVybiBUcmFpbmluZ19qb2Iub2JqZWN0cy5nZXQoaWQ9am9iX2lkKQogIEZpbGUgIkM6XHB5dGhvbjM4MFxsaWJcc2l0ZS1wYWNrYWdlc1xkamFuZ29cZGJcbW9kZWxzXG1hbmFnZXIucHkiLCBsaW5lIDg1LCBpbiBtYW5hZ2VyX21ldGhvZAogICAgcmV0dXJuIGdldGF0dHIoc2VsZi5nZXRfcXVlcnlzZXQoKSwgbmFtZSkoKmFyZ3MsICoqa3dhcmdzKQogIEZpbGUgIkM6XHB5dGhvbjM4MFxsaWJcc2l0ZS1wYWNrYWdlc1xkamFuZ29cZGJcbW9kZWxzXHF1ZXJ5LnB5IiwgbGluZSA0MjksIGluIGdldAogICAgcmFpc2Ugc2VsZi5tb2RlbC5Eb2VzTm90RXhpc3QoCnRyYWluLm1vZGVscy5UcmFpbmluZ19qb2IuRG9lc05vdEV4aXN0OiBUcmFpbmluZ19qb2IgbWF0Y2hpbmcgcXVlcnkgZG9lcyBub3QgZXhpc3QuCpQu	2024-09-10 21:26:41.081748+05	2024-09-22 13:01:53.562089+05	f	b97649eb6b1e48f6a25ce5e07007a877	\N	1
happy-wolfram-charlie-utah	train.services.TrainingServiceSingle.start_training	\N	gAWVDwcAAAAAAAB9lCiMCmRhdGFzZXRfaWSUjAIxNpSMBHVzZXKUjBVkamFuZ28uZGIubW9kZWxzLmJhc2WUjA5tb2RlbF91bnBpY2tsZZSTlIwEYXV0aJSMBFVzZXKUhpSFlFKUfZQojAZfc3RhdGWUaASMCk1vZGVsU3RhdGWUk5QpgZR9lCiMBmFkZGluZ5SJjAJkYpSMB2RlZmF1bHSUjAxmaWVsZHNfY2FjaGWUfZR1YowCaWSUSwKMCHBhc3N3b3JklIxOcGJrZGYyX3NoYTI1NiQyMTYwMDAkRWlFU0hKN1JLRDFpJEhCWkNTODYwUndSZUlEKzBJdHJ6b0lLdVIxRmlPZ2kyYUNwRGlqOUpkNEE9lIwKbGFzdF9sb2dpbpSMCGRhdGV0aW1llIwIZGF0ZXRpbWWUk5RDCgfoCRYHKQEL3IuUjARweXR6lIwEX1VUQ5STlClSlIaUUpSMDGlzX3N1cGVydXNlcpSIjAh1c2VybmFtZZSMBWFkbWlulIwKZmlyc3RfbmFtZZSMAJSMCWxhc3RfbmFtZZRoKYwFZW1haWyUjBRhbGlmaWRhLjg2QGdtYWlsLmNvbZSMCGlzX3N0YWZmlIiMCWlzX2FjdGl2ZZSIjAtkYXRlX2pvaW5lZJRoHUMKB+gCBA0ULwAAAJRoIoaUUpSMD19kamFuZ29fdmVyc2lvbpSMBTMuMS4ylHVijAhzdHJhdGVneZSMClNpbmdsZSBHUFWUjAlhbGdvX25hbWWUjAtEZW5zZU5ldDEyMZSMBmVwb2Noc5SMAjEwlIwKYmF0Y2hfc2l6ZZSMAjMylIwNbGVhcm5pbmdfcmF0ZZSMBTAuMDAxlIwJb3B0aW1pemVylIwEYWRhbZSMDWxvc3NfZnVuY3Rpb26UjBNiaW5hcnlfY3Jvc3NlbnRyb3B5lIwQdmFsaWRhdGlvbl9zcGxpdJSMAzAuMpSMF2Vhcmx5X3N0b3BwaW5nX3BhdGllbmNllIwCMTCUjAxkcm9wb3V0X3JhdGWUjAMwLjWUjAxhdWdtZW50YXRpb26UjAROb25llIwNY2xhc3Nfd2VpZ2h0c5RoKYwLcmFuZG9tX3NlZWSUjAI0MpSMDHRyYWluaW5nX2pvYpRoBowFdHJhaW6UjAxUcmFpbmluZ19qb2KUhpSFlFKUfZQoaA1oDymBlH2UKGgTaBRoFX2UKIwLZGF0YXNldF9pbWeUaAZoT4wLRGF0YXNldF9JTUeUhpSFlFKUfZQoaA1oDymBlH2UKGgVfZRoEoloE2gUdWJoF0sQjAlkYXRhX25hbWWUjA9UQiBUaW55IERhdGFzZXSUjAlkYXRhX3BhdGiUjCMxNTB4MTUwX3RiX2RhdGFzZXRfdGlueV90QmlEZHFPLnppcJSMDmV4dHJhY3RlZF9wYXRolIxFRTpcd29ya3NwYWNlXHB5dGhvblxkZWVwLWRpc3RyaWJ1dGVcZGVlcGRpc3RyaWJ1dGVcbWVkaWFcdG1wLzE2L3RyYWlulIwOZGF0YV9wYXRoX3Rlc3SUjB1kamFuZ28uZGIubW9kZWxzLmZpZWxkcy5maWxlc5SMCUZpZWxkRmlsZZSTlCmBlH2UKIwEbmFtZZSMKDE1MHgxNTBfdGJfZGF0YXNldF90aW55LXRlc3RfQW5TVnEyaS56aXCUjAZjbG9zZWSUiYwKX2NvbW1pdHRlZJSIjAVfZmlsZZROjAhpbnN0YW5jZZRoXIwFZmllbGSUjBdkamFuZ28uZGIubW9kZWxzLmZpZWxkc5SMC19sb2FkX2ZpZWxklJOUaE9oWYwOZGF0YV9wYXRoX3Rlc3SUh5RSlHVijBNleHRyYWN0ZWRfcGF0aF90ZXN0lIxERTpcd29ya3NwYWNlXHB5dGhvblxkZWVwLWRpc3RyaWJ1dGVcZGVlcGRpc3RyaWJ1dGVcbWVkaWFcdG1wLzE2L3Rlc3SUjAhtZXRhaW5mb5RoKYwMcHJvY2Vzc2VkX2F0lGgdQwoH6AkWBzApAWrHlGgihpRSlIwJZGVsZXRlX2F0lE6MBnN0YXR1c5RoKYwHdXNlcl9pZJRLAmgzaDR1YmgDaAt1aBKJdWJoF0tYjAhqb2JfbmFtZZSMKlRCIFRpbnkgRGF0YXNldCAgRHRpRnpiNjZxZF8yMDI0MDkyMjEzNTgxNJSMDmRhdGFzZXRfaW1nX2lklEsQaIKMB1JVTk5JTkeUjApzdGFydGVkX2F0lGgdQwoH6AkWCDoODR65lGgihpRSlIwIZW5kZWRfYXSUTowEYWxnb5RoOIwHdXNlcl9pZJRLAowScGFyYW1ldGVyX3NldHRpbmdzlGgAjAZyZXN1bHSUTowMdHJhaW5pbmdfbG9nlE6MFHRyYWluaW5nX2xvZ19oaXN0b3J5lE5oM2g0dWJ1hZQu	gAV9lC4=	\N	2024-09-22 13:58:14.862525+05	2024-09-22 13:58:38.891646+05	t	f6dccab9d6644b00aa03e06c86493711	\N	1
red-muppet-april-mirror	train.services.TrainingServiceSingle.start_training	\N	gAWVIQcAAAAAAAB9lCiMCmRhdGFzZXRfaWSUjAIxNpSMBHVzZXKUjBVkamFuZ28uZGIubW9kZWxzLmJhc2WUjA5tb2RlbF91bnBpY2tsZZSTlIwEYXV0aJSMBFVzZXKUhpSFlFKUfZQojAZfc3RhdGWUaASMCk1vZGVsU3RhdGWUk5QpgZR9lCiMBmFkZGluZ5SJjAJkYpSMB2RlZmF1bHSUjAxmaWVsZHNfY2FjaGWUfZR1YowCaWSUSwKMCHBhc3N3b3JklIxOcGJrZGYyX3NoYTI1NiQyMTYwMDAkRWlFU0hKN1JLRDFpJEhCWkNTODYwUndSZUlEKzBJdHJ6b0lLdVIxRmlPZ2kyYUNwRGlqOUpkNEE9lIwKbGFzdF9sb2dpbpSMCGRhdGV0aW1llIwIZGF0ZXRpbWWUk5RDCgfoCRYHKQEL3IuUjARweXR6lIwEX1VUQ5STlClSlIaUUpSMDGlzX3N1cGVydXNlcpSIjAh1c2VybmFtZZSMBWFkbWlulIwKZmlyc3RfbmFtZZSMAJSMCWxhc3RfbmFtZZRoKYwFZW1haWyUjBRhbGlmaWRhLjg2QGdtYWlsLmNvbZSMCGlzX3N0YWZmlIiMCWlzX2FjdGl2ZZSIjAtkYXRlX2pvaW5lZJRoHUMKB+gCBA0ULwAAAJRoIoaUUpSMD19kamFuZ29fdmVyc2lvbpSMBTMuMS4ylHVijAhzdHJhdGVneZSMClNpbmdsZSBHUFWUjAlhbGdvX25hbWWUjAtEZW5zZU5ldDEyMZSMBmVwb2Noc5SMAzEwMJSMCmJhdGNoX3NpemWUjAIzMpSMDWxlYXJuaW5nX3JhdGWUjAUwLjAwMZSMCW9wdGltaXplcpSMBGFkYW2UjA1sb3NzX2Z1bmN0aW9ulIwTYmluYXJ5X2Nyb3NzZW50cm9weZSMEHZhbGlkYXRpb25fc3BsaXSUjAMwLjKUjBdlYXJseV9zdG9wcGluZ19wYXRpZW5jZZSMAjEwlIwMZHJvcG91dF9yYXRllIwDMC41lIwMYXVnbWVudGF0aW9ulIwETm9uZZSMDWNsYXNzX3dlaWdodHOUaCmMC3JhbmRvbV9zZWVklIwCNDKUjAx0cmFpbmluZ19qb2KUaAaMBXRyYWlulIwMVHJhaW5pbmdfam9ilIaUhZRSlH2UKIwGX3N0YXRllGgPKYGUfZQoaBNoFGgVfZQojAtkYXRhc2V0X2ltZ5RoBmhPjAtEYXRhc2V0X0lNR5SGlIWUUpR9lChoDWgPKYGUfZQoaBV9lGgSiWgTaBR1YmgXSxCMCWRhdGFfbmFtZZSMD1RCIFRpbnkgRGF0YXNldJSMCWRhdGFfcGF0aJSMIzE1MHgxNTBfdGJfZGF0YXNldF90aW55X3RCaURkcU8uemlwlIwOZXh0cmFjdGVkX3BhdGiUjEVFOlx3b3Jrc3BhY2VccHl0aG9uXGRlZXAtZGlzdHJpYnV0ZVxkZWVwZGlzdHJpYnV0ZVxtZWRpYVx0bXAvMTYvdHJhaW6UjA5kYXRhX3BhdGhfdGVzdJSMHWRqYW5nby5kYi5tb2RlbHMuZmllbGRzLmZpbGVzlIwJRmllbGRGaWxllJOUKYGUfZQojARuYW1llIwoMTUweDE1MF90Yl9kYXRhc2V0X3RpbnktdGVzdF9BblNWcTJpLnppcJSMBmNsb3NlZJSJjApfY29tbWl0dGVklIiMBV9maWxllE6MCGluc3RhbmNllGhdjAVmaWVsZJSMF2RqYW5nby5kYi5tb2RlbHMuZmllbGRzlIwLX2xvYWRfZmllbGSUk5RoT2hajA5kYXRhX3BhdGhfdGVzdJSHlFKUdWKME2V4dHJhY3RlZF9wYXRoX3Rlc3SUjERFOlx3b3Jrc3BhY2VccHl0aG9uXGRlZXAtZGlzdHJpYnV0ZVxkZWVwZGlzdHJpYnV0ZVxtZWRpYVx0bXAvMTYvdGVzdJSMCG1ldGFpbmZvlGgpjAxwcm9jZXNzZWRfYXSUaB1DCgfoCRYHMCkBaseUaCKGlFKUjAlkZWxldGVfYXSUTowGc3RhdHVzlGgpjAd1c2VyX2lklEsCaDNoNHViaANoC3VoEol1YowCaWSUS1mMCGpvYl9uYW1llIwqVEIgVGlueSBEYXRhc2V0ICBuV1VVTTdhVk9SXzIwMjQwOTIyMTQxNTE1lIwOZGF0YXNldF9pbWdfaWSUSxCMBnN0YXR1c5SMB1JVTk5JTkeUjApzdGFydGVkX2F0lGgdQwoH6AkWCQ8PB+TPlGgihpRSlIwIZW5kZWRfYXSUTowEYWxnb5RoOIwHdXNlcl9pZJRLAowScGFyYW1ldGVyX3NldHRpbmdzlGgAjAZyZXN1bHSUTowMdHJhaW5pbmdfbG9nlE6MFHRyYWluaW5nX2xvZ19oaXN0b3J5lE5oM2g0dWJ1hZQu	gAV9lC4=	\N	2024-09-22 14:15:15.519321+05	2024-09-22 14:15:27.858342+05	t	2a6342b3f6a14a88b3e666348dce9758	\N	1
robin-ten-glucose-virginia	train.services.TrainingServiceSingle.start_training	\N	gAWVMAcAAAAAAAB9lCiMCmRhdGFzZXRfaWSUjAIxNpSMBHVzZXKUjBVkamFuZ28uZGIubW9kZWxzLmJhc2WUjA5tb2RlbF91bnBpY2tsZZSTlIwEYXV0aJSMBFVzZXKUhpSFlFKUfZQojAZfc3RhdGWUaASMCk1vZGVsU3RhdGWUk5QpgZR9lCiMBmFkZGluZ5SJjAJkYpSMB2RlZmF1bHSUjAxmaWVsZHNfY2FjaGWUfZR1YowCaWSUSwKMCHBhc3N3b3JklIxOcGJrZGYyX3NoYTI1NiQyMTYwMDAkRWlFU0hKN1JLRDFpJEhCWkNTODYwUndSZUlEKzBJdHJ6b0lLdVIxRmlPZ2kyYUNwRGlqOUpkNEE9lIwKbGFzdF9sb2dpbpSMCGRhdGV0aW1llIwIZGF0ZXRpbWWUk5RDCgfoCRYHKQEL3IuUjARweXR6lIwEX1VUQ5STlClSlIaUUpSMDGlzX3N1cGVydXNlcpSIjAh1c2VybmFtZZSMBWFkbWlulIwKZmlyc3RfbmFtZZSMAJSMCWxhc3RfbmFtZZRoKYwFZW1haWyUjBRhbGlmaWRhLjg2QGdtYWlsLmNvbZSMCGlzX3N0YWZmlIiMCWlzX2FjdGl2ZZSIjAtkYXRlX2pvaW5lZJRoHUMKB+gCBA0ULwAAAJRoIoaUUpSMD19kamFuZ29fdmVyc2lvbpSMBTMuMS4ylHVijAhzdHJhdGVneZSMClNpbmdsZSBHUFWUjAlhbGdvX25hbWWUjAtEZW5zZU5ldDEyMZSMBmVwb2Noc5SMAjEwlIwKYmF0Y2hfc2l6ZZSMAjMylIwNbGVhcm5pbmdfcmF0ZZSMBTAuMDAxlIwJb3B0aW1pemVylIwEYWRhbZSMDWxvc3NfZnVuY3Rpb26UjBNiaW5hcnlfY3Jvc3NlbnRyb3B5lIwQdmFsaWRhdGlvbl9zcGxpdJSMAzAuMpSMF2Vhcmx5X3N0b3BwaW5nX3BhdGllbmNllIwCMTCUjAxkcm9wb3V0X3JhdGWUjAMwLjWUjAxhdWdtZW50YXRpb26UjAROb25llIwNY2xhc3Nfd2VpZ2h0c5RoKYwLcmFuZG9tX3NlZWSUjAI0MpSMDHRyYWluaW5nX2pvYpRoBowFdHJhaW6UjAxUcmFpbmluZ19qb2KUhpSFlFKUfZQojAZfc3RhdGWUaA8pgZR9lChoE2gUaBV9lCiMC2RhdGFzZXRfaW1nlGgGaE+MC0RhdGFzZXRfSU1HlIaUhZRSlH2UKGgNaA8pgZR9lChoFX2UaBKJaBNoFHViaBdLEIwJZGF0YV9uYW1llIwPVEIgVGlueSBEYXRhc2V0lIwJZGF0YV9wYXRolIwjMTUweDE1MF90Yl9kYXRhc2V0X3RpbnlfdEJpRGRxTy56aXCUjA5leHRyYWN0ZWRfcGF0aJSMRUU6XHdvcmtzcGFjZVxweXRob25cZGVlcC1kaXN0cmlidXRlXGRlZXBkaXN0cmlidXRlXG1lZGlhXHRtcC8xNi90cmFpbpSMDmRhdGFfcGF0aF90ZXN0lIwdZGphbmdvLmRiLm1vZGVscy5maWVsZHMuZmlsZXOUjAlGaWVsZEZpbGWUk5QpgZR9lCiMBG5hbWWUjCgxNTB4MTUwX3RiX2RhdGFzZXRfdGlueS10ZXN0X0FuU1ZxMmkuemlwlIwGY2xvc2VklImMCl9jb21taXR0ZWSUiIwFX2ZpbGWUTowIaW5zdGFuY2WUaF2MBWZpZWxklIwXZGphbmdvLmRiLm1vZGVscy5maWVsZHOUjAtfbG9hZF9maWVsZJSTlGhPaFqMDmRhdGFfcGF0aF90ZXN0lIeUUpR1YowTZXh0cmFjdGVkX3BhdGhfdGVzdJSMREU6XHdvcmtzcGFjZVxweXRob25cZGVlcC1kaXN0cmlidXRlXGRlZXBkaXN0cmlidXRlXG1lZGlhXHRtcC8xNi90ZXN0lIwIbWV0YWluZm+UaCmMDHByb2Nlc3NlZF9hdJRoHUMKB+gJFgcwKQFqx5RoIoaUUpSMCWRlbGV0ZV9hdJROjAZzdGF0dXOUaCmMB3VzZXJfaWSUSwJoM2g0dWJoA2gLdWgSiXVijAJpZJRLWowIam9iX25hbWWUjCpUQiBUaW55IERhdGFzZXQgIFF3ajVQWG9yclJfMjAyNDA5MjIxNDE5NTaUjA5kYXRhc2V0X2ltZ19pZJRLEIwGc3RhdHVzlIwHUlVOTklOR5SMCnN0YXJ0ZWRfYXSUaB1DCgfoCRYJEzgCbD+UaCKGlFKUjAhlbmRlZF9hdJROjARhbGdvlGg4jAd1c2VyX2lklEsCjBJwYXJhbWV0ZXJfc2V0dGluZ3OUaACMBnJlc3VsdJROjAx0cmFpbmluZ19sb2eUTowUdHJhaW5pbmdfbG9nX2hpc3RvcnmUTowPX2RqYW5nb192ZXJzaW9ulGg0dWJ1hZQu	gAV9lC4=	\N	2024-09-22 14:19:56.15978+05	2024-09-22 14:20:07.629081+05	t	2d3126815a6142a38525ec187fe30d61	\N	1
monkey-berlin-violet-salami	train.services.TrainingServiceSingle.start_training	\N	gAWVMAcAAAAAAAB9lCiMCmRhdGFzZXRfaWSUjAIxNpSMBHVzZXKUjBVkamFuZ28uZGIubW9kZWxzLmJhc2WUjA5tb2RlbF91bnBpY2tsZZSTlIwEYXV0aJSMBFVzZXKUhpSFlFKUfZQojAZfc3RhdGWUaASMCk1vZGVsU3RhdGWUk5QpgZR9lCiMBmFkZGluZ5SJjAJkYpSMB2RlZmF1bHSUjAxmaWVsZHNfY2FjaGWUfZR1YowCaWSUSwKMCHBhc3N3b3JklIxOcGJrZGYyX3NoYTI1NiQyMTYwMDAkRWlFU0hKN1JLRDFpJEhCWkNTODYwUndSZUlEKzBJdHJ6b0lLdVIxRmlPZ2kyYUNwRGlqOUpkNEE9lIwKbGFzdF9sb2dpbpSMCGRhdGV0aW1llIwIZGF0ZXRpbWWUk5RDCgfoCRYHKQEL3IuUjARweXR6lIwEX1VUQ5STlClSlIaUUpSMDGlzX3N1cGVydXNlcpSIjAh1c2VybmFtZZSMBWFkbWlulIwKZmlyc3RfbmFtZZSMAJSMCWxhc3RfbmFtZZRoKYwFZW1haWyUjBRhbGlmaWRhLjg2QGdtYWlsLmNvbZSMCGlzX3N0YWZmlIiMCWlzX2FjdGl2ZZSIjAtkYXRlX2pvaW5lZJRoHUMKB+gCBA0ULwAAAJRoIoaUUpSMD19kamFuZ29fdmVyc2lvbpSMBTMuMS4ylHVijAhzdHJhdGVneZSMClNpbmdsZSBHUFWUjAlhbGdvX25hbWWUjAtEZW5zZU5ldDEyMZSMBmVwb2Noc5SMAjEwlIwKYmF0Y2hfc2l6ZZSMAjMylIwNbGVhcm5pbmdfcmF0ZZSMBTAuMDAxlIwJb3B0aW1pemVylIwEYWRhbZSMDWxvc3NfZnVuY3Rpb26UjBNiaW5hcnlfY3Jvc3NlbnRyb3B5lIwQdmFsaWRhdGlvbl9zcGxpdJSMAzAuMpSMF2Vhcmx5X3N0b3BwaW5nX3BhdGllbmNllIwCMTCUjAxkcm9wb3V0X3JhdGWUjAMwLjWUjAxhdWdtZW50YXRpb26UjAROb25llIwNY2xhc3Nfd2VpZ2h0c5RoKYwLcmFuZG9tX3NlZWSUjAI0MpSMDHRyYWluaW5nX2pvYpRoBowFdHJhaW6UjAxUcmFpbmluZ19qb2KUhpSFlFKUfZQojAZfc3RhdGWUaA8pgZR9lChoE2gUaBV9lCiMC2RhdGFzZXRfaW1nlGgGaE+MC0RhdGFzZXRfSU1HlIaUhZRSlH2UKGgNaA8pgZR9lChoFX2UaBKJaBNoFHViaBdLEIwJZGF0YV9uYW1llIwPVEIgVGlueSBEYXRhc2V0lIwJZGF0YV9wYXRolIwjMTUweDE1MF90Yl9kYXRhc2V0X3RpbnlfdEJpRGRxTy56aXCUjA5leHRyYWN0ZWRfcGF0aJSMRUU6XHdvcmtzcGFjZVxweXRob25cZGVlcC1kaXN0cmlidXRlXGRlZXBkaXN0cmlidXRlXG1lZGlhXHRtcC8xNi90cmFpbpSMDmRhdGFfcGF0aF90ZXN0lIwdZGphbmdvLmRiLm1vZGVscy5maWVsZHMuZmlsZXOUjAlGaWVsZEZpbGWUk5QpgZR9lCiMBG5hbWWUjCgxNTB4MTUwX3RiX2RhdGFzZXRfdGlueS10ZXN0X0FuU1ZxMmkuemlwlIwGY2xvc2VklImMCl9jb21taXR0ZWSUiIwFX2ZpbGWUTowIaW5zdGFuY2WUaF2MBWZpZWxklIwXZGphbmdvLmRiLm1vZGVscy5maWVsZHOUjAtfbG9hZF9maWVsZJSTlGhPaFqMDmRhdGFfcGF0aF90ZXN0lIeUUpR1YowTZXh0cmFjdGVkX3BhdGhfdGVzdJSMREU6XHdvcmtzcGFjZVxweXRob25cZGVlcC1kaXN0cmlidXRlXGRlZXBkaXN0cmlidXRlXG1lZGlhXHRtcC8xNi90ZXN0lIwIbWV0YWluZm+UaCmMDHByb2Nlc3NlZF9hdJRoHUMKB+gJFgcwKQFqx5RoIoaUUpSMCWRlbGV0ZV9hdJROjAZzdGF0dXOUaCmMB3VzZXJfaWSUSwJoM2g0dWJoA2gLdWgSiXVijAJpZJRLW4wIam9iX25hbWWUjCpUQiBUaW55IERhdGFzZXQgIDg0cEdwNWU0Y1FfMjAyNDA5MjIxNDIxMjeUjA5kYXRhc2V0X2ltZ19pZJRLEIwGc3RhdHVzlIwHUlVOTklOR5SMCnN0YXJ0ZWRfYXSUaB1DCgfoCRYJFRsIYwaUaCKGlFKUjAhlbmRlZF9hdJROjARhbGdvlGg4jAd1c2VyX2lklEsCjBJwYXJhbWV0ZXJfc2V0dGluZ3OUaACMBnJlc3VsdJROjAx0cmFpbmluZ19sb2eUTowUdHJhaW5pbmdfbG9nX2hpc3RvcnmUTowPX2RqYW5nb192ZXJzaW9ulGg0dWJ1hZQu	gAV9lC4=	\N	2024-09-22 14:21:27.551631+05	2024-09-22 14:21:39.547665+05	t	a4919531f9134bb59b446050de5780b6	\N	1
crazy-alaska-monkey-minnesota	train.services.TrainingServiceSingle.start_training	\N	gAWVMAcAAAAAAAB9lCiMCmRhdGFzZXRfaWSUjAIxNpSMBHVzZXKUjBVkamFuZ28uZGIubW9kZWxzLmJhc2WUjA5tb2RlbF91bnBpY2tsZZSTlIwEYXV0aJSMBFVzZXKUhpSFlFKUfZQojAZfc3RhdGWUaASMCk1vZGVsU3RhdGWUk5QpgZR9lCiMBmFkZGluZ5SJjAJkYpSMB2RlZmF1bHSUjAxmaWVsZHNfY2FjaGWUfZR1YowCaWSUSwKMCHBhc3N3b3JklIxOcGJrZGYyX3NoYTI1NiQyMTYwMDAkRWlFU0hKN1JLRDFpJEhCWkNTODYwUndSZUlEKzBJdHJ6b0lLdVIxRmlPZ2kyYUNwRGlqOUpkNEE9lIwKbGFzdF9sb2dpbpSMCGRhdGV0aW1llIwIZGF0ZXRpbWWUk5RDCgfoCRYHKQEL3IuUjARweXR6lIwEX1VUQ5STlClSlIaUUpSMDGlzX3N1cGVydXNlcpSIjAh1c2VybmFtZZSMBWFkbWlulIwKZmlyc3RfbmFtZZSMAJSMCWxhc3RfbmFtZZRoKYwFZW1haWyUjBRhbGlmaWRhLjg2QGdtYWlsLmNvbZSMCGlzX3N0YWZmlIiMCWlzX2FjdGl2ZZSIjAtkYXRlX2pvaW5lZJRoHUMKB+gCBA0ULwAAAJRoIoaUUpSMD19kamFuZ29fdmVyc2lvbpSMBTMuMS4ylHVijAhzdHJhdGVneZSMClNpbmdsZSBHUFWUjAlhbGdvX25hbWWUjAtEZW5zZU5ldDEyMZSMBmVwb2Noc5SMAjIwlIwKYmF0Y2hfc2l6ZZSMAjMylIwNbGVhcm5pbmdfcmF0ZZSMBTAuMDAxlIwJb3B0aW1pemVylIwEYWRhbZSMDWxvc3NfZnVuY3Rpb26UjBNiaW5hcnlfY3Jvc3NlbnRyb3B5lIwQdmFsaWRhdGlvbl9zcGxpdJSMAzAuMpSMF2Vhcmx5X3N0b3BwaW5nX3BhdGllbmNllIwCMTCUjAxkcm9wb3V0X3JhdGWUjAMwLjWUjAxhdWdtZW50YXRpb26UjAROb25llIwNY2xhc3Nfd2VpZ2h0c5RoKYwLcmFuZG9tX3NlZWSUjAI0MpSMDHRyYWluaW5nX2pvYpRoBowFdHJhaW6UjAxUcmFpbmluZ19qb2KUhpSFlFKUfZQojAZfc3RhdGWUaA8pgZR9lChoE2gUaBV9lCiMC2RhdGFzZXRfaW1nlGgGaE+MC0RhdGFzZXRfSU1HlIaUhZRSlH2UKGgNaA8pgZR9lChoFX2UaBKJaBNoFHViaBdLEIwJZGF0YV9uYW1llIwPVEIgVGlueSBEYXRhc2V0lIwJZGF0YV9wYXRolIwjMTUweDE1MF90Yl9kYXRhc2V0X3RpbnlfdEJpRGRxTy56aXCUjA5leHRyYWN0ZWRfcGF0aJSMRUU6XHdvcmtzcGFjZVxweXRob25cZGVlcC1kaXN0cmlidXRlXGRlZXBkaXN0cmlidXRlXG1lZGlhXHRtcC8xNi90cmFpbpSMDmRhdGFfcGF0aF90ZXN0lIwdZGphbmdvLmRiLm1vZGVscy5maWVsZHMuZmlsZXOUjAlGaWVsZEZpbGWUk5QpgZR9lCiMBG5hbWWUjCgxNTB4MTUwX3RiX2RhdGFzZXRfdGlueS10ZXN0X0FuU1ZxMmkuemlwlIwGY2xvc2VklImMCl9jb21taXR0ZWSUiIwFX2ZpbGWUTowIaW5zdGFuY2WUaF2MBWZpZWxklIwXZGphbmdvLmRiLm1vZGVscy5maWVsZHOUjAtfbG9hZF9maWVsZJSTlGhPaFqMDmRhdGFfcGF0aF90ZXN0lIeUUpR1YowTZXh0cmFjdGVkX3BhdGhfdGVzdJSMREU6XHdvcmtzcGFjZVxweXRob25cZGVlcC1kaXN0cmlidXRlXGRlZXBkaXN0cmlidXRlXG1lZGlhXHRtcC8xNi90ZXN0lIwIbWV0YWluZm+UaCmMDHByb2Nlc3NlZF9hdJRoHUMKB+gJFgcwKQFqx5RoIoaUUpSMCWRlbGV0ZV9hdJROjAZzdGF0dXOUaCmMB3VzZXJfaWSUSwJoM2g0dWJoA2gLdWgSiXVijAJpZJRLXIwIam9iX25hbWWUjCpUQiBUaW55IERhdGFzZXQgIFByV2Q3SnBGNmhfMjAyNDA5MjIxNDIxNTOUjA5kYXRhc2V0X2ltZ19pZJRLEIwGc3RhdHVzlIwHUlVOTklOR5SMCnN0YXJ0ZWRfYXSUaB1DCgfoCRYJFTUBKDuUaCKGlFKUjAhlbmRlZF9hdJROjARhbGdvlGg4jAd1c2VyX2lklEsCjBJwYXJhbWV0ZXJfc2V0dGluZ3OUaACMBnJlc3VsdJROjAx0cmFpbmluZ19sb2eUTowUdHJhaW5pbmdfbG9nX2hpc3RvcnmUTowPX2RqYW5nb192ZXJzaW9ulGg0dWJ1hZQu	gAV9lC4=	\N	2024-09-22 14:21:53.078827+05	2024-09-22 14:22:08.40417+05	t	f32918ef10894fd5a67ada97bea62bb8	\N	1
tennis-wolfram-north-freddie	train.services.TrainingServiceSingle.start_training	\N	gAWVDwcAAAAAAAB9lCiMCmRhdGFzZXRfaWSUjAIxNpSMBHVzZXKUjBVkamFuZ28uZGIubW9kZWxzLmJhc2WUjA5tb2RlbF91bnBpY2tsZZSTlIwEYXV0aJSMBFVzZXKUhpSFlFKUfZQojAZfc3RhdGWUaASMCk1vZGVsU3RhdGWUk5QpgZR9lCiMBmFkZGluZ5SJjAJkYpSMB2RlZmF1bHSUjAxmaWVsZHNfY2FjaGWUfZR1YowCaWSUSwKMCHBhc3N3b3JklIxOcGJrZGYyX3NoYTI1NiQyMTYwMDAkRWlFU0hKN1JLRDFpJEhCWkNTODYwUndSZUlEKzBJdHJ6b0lLdVIxRmlPZ2kyYUNwRGlqOUpkNEE9lIwKbGFzdF9sb2dpbpSMCGRhdGV0aW1llIwIZGF0ZXRpbWWUk5RDCgfoCRYHKQEL3IuUjARweXR6lIwEX1VUQ5STlClSlIaUUpSMDGlzX3N1cGVydXNlcpSIjAh1c2VybmFtZZSMBWFkbWlulIwKZmlyc3RfbmFtZZSMAJSMCWxhc3RfbmFtZZRoKYwFZW1haWyUjBRhbGlmaWRhLjg2QGdtYWlsLmNvbZSMCGlzX3N0YWZmlIiMCWlzX2FjdGl2ZZSIjAtkYXRlX2pvaW5lZJRoHUMKB+gCBA0ULwAAAJRoIoaUUpSMD19kamFuZ29fdmVyc2lvbpSMBTMuMS4ylHVijAhzdHJhdGVneZSMClNpbmdsZSBHUFWUjAlhbGdvX25hbWWUjAtEZW5zZU5ldDEyMZSMBmVwb2Noc5SMAjMwlIwKYmF0Y2hfc2l6ZZSMAjMylIwNbGVhcm5pbmdfcmF0ZZSMBTAuMDAxlIwJb3B0aW1pemVylIwEYWRhbZSMDWxvc3NfZnVuY3Rpb26UjBNiaW5hcnlfY3Jvc3NlbnRyb3B5lIwQdmFsaWRhdGlvbl9zcGxpdJSMAzAuMpSMF2Vhcmx5X3N0b3BwaW5nX3BhdGllbmNllIwCMTCUjAxkcm9wb3V0X3JhdGWUjAMwLjWUjAxhdWdtZW50YXRpb26UjAROb25llIwNY2xhc3Nfd2VpZ2h0c5RoKYwLcmFuZG9tX3NlZWSUjAI0MpSMDHRyYWluaW5nX2pvYpRoBowFdHJhaW6UjAxUcmFpbmluZ19qb2KUhpSFlFKUfZQoaA1oDymBlH2UKGgTaBRoFX2UKIwLZGF0YXNldF9pbWeUaAZoT4wLRGF0YXNldF9JTUeUhpSFlFKUfZQoaA1oDymBlH2UKGgVfZRoEoloE2gUdWJoF0sQjAlkYXRhX25hbWWUjA9UQiBUaW55IERhdGFzZXSUjAlkYXRhX3BhdGiUjCMxNTB4MTUwX3RiX2RhdGFzZXRfdGlueV90QmlEZHFPLnppcJSMDmV4dHJhY3RlZF9wYXRolIxFRTpcd29ya3NwYWNlXHB5dGhvblxkZWVwLWRpc3RyaWJ1dGVcZGVlcGRpc3RyaWJ1dGVcbWVkaWFcdG1wLzE2L3RyYWlulIwOZGF0YV9wYXRoX3Rlc3SUjB1kamFuZ28uZGIubW9kZWxzLmZpZWxkcy5maWxlc5SMCUZpZWxkRmlsZZSTlCmBlH2UKIwEbmFtZZSMKDE1MHgxNTBfdGJfZGF0YXNldF90aW55LXRlc3RfQW5TVnEyaS56aXCUjAZjbG9zZWSUiYwKX2NvbW1pdHRlZJSIjAVfZmlsZZROjAhpbnN0YW5jZZRoXIwFZmllbGSUjBdkamFuZ28uZGIubW9kZWxzLmZpZWxkc5SMC19sb2FkX2ZpZWxklJOUaE9oWYwOZGF0YV9wYXRoX3Rlc3SUh5RSlHVijBNleHRyYWN0ZWRfcGF0aF90ZXN0lIxERTpcd29ya3NwYWNlXHB5dGhvblxkZWVwLWRpc3RyaWJ1dGVcZGVlcGRpc3RyaWJ1dGVcbWVkaWFcdG1wLzE2L3Rlc3SUjAhtZXRhaW5mb5RoKYwMcHJvY2Vzc2VkX2F0lGgdQwoH6AkWBzApAWrHlGgihpRSlIwJZGVsZXRlX2F0lE6MBnN0YXR1c5RoKYwHdXNlcl9pZJRLAmgzaDR1YmgDaAt1aBKJdWJoF0tdjAhqb2JfbmFtZZSMKlRCIFRpbnkgRGF0YXNldCAgaDZ4aTR1TUdKRl8yMDI0MDkyMjE0MjI0MJSMDmRhdGFzZXRfaW1nX2lklEsQaIKMB1JVTk5JTkeUjApzdGFydGVkX2F0lGgdQwoH6AkWCRYoDr2GlGgihpRSlIwIZW5kZWRfYXSUTowEYWxnb5RoOIwHdXNlcl9pZJRLAowScGFyYW1ldGVyX3NldHRpbmdzlGgAjAZyZXN1bHSUTowMdHJhaW5pbmdfbG9nlE6MFHRyYWluaW5nX2xvZ19oaXN0b3J5lE5oM2g0dWJ1hZQu	gAV9lC4=	\N	2024-09-22 14:22:40.967288+05	2024-09-22 14:23:04.746973+05	t	4a59aa65693447e39c3ad5edba9c2841	\N	1
three-massachusetts-carbon-victor	train.services.TrainingServiceSingle.start_training	\N	gAWVIwcAAAAAAAB9lCiMCmRhdGFzZXRfaWSUjAIxNpSMBHVzZXKUjBVkamFuZ28uZGIubW9kZWxzLmJhc2WUjA5tb2RlbF91bnBpY2tsZZSTlIwEYXV0aJSMBFVzZXKUhpSFlFKUfZQojAZfc3RhdGWUaASMCk1vZGVsU3RhdGWUk5QpgZR9lCiMBmFkZGluZ5SJjAJkYpSMB2RlZmF1bHSUjAxmaWVsZHNfY2FjaGWUfZR1YowCaWSUSwKMCHBhc3N3b3JklIxOcGJrZGYyX3NoYTI1NiQyMTYwMDAkRWlFU0hKN1JLRDFpJEhCWkNTODYwUndSZUlEKzBJdHJ6b0lLdVIxRmlPZ2kyYUNwRGlqOUpkNEE9lIwKbGFzdF9sb2dpbpSMCGRhdGV0aW1llIwIZGF0ZXRpbWWUk5RDCgfoCRYHKQEL3IuUjARweXR6lIwEX1VUQ5STlClSlIaUUpSMDGlzX3N1cGVydXNlcpSIjAh1c2VybmFtZZSMBWFkbWlulIwKZmlyc3RfbmFtZZSMAJSMCWxhc3RfbmFtZZRoKYwFZW1haWyUjBRhbGlmaWRhLjg2QGdtYWlsLmNvbZSMCGlzX3N0YWZmlIiMCWlzX2FjdGl2ZZSIjAtkYXRlX2pvaW5lZJRoHUMKB+gCBA0ULwAAAJRoIoaUUpSMD19kamFuZ29fdmVyc2lvbpSMBTMuMS4ylHVijAhzdHJhdGVneZSMClNpbmdsZSBHUFWUjAlhbGdvX25hbWWUjAtEZW5zZU5ldDEyMZSMBmVwb2Noc5SMAjMwlIwKYmF0Y2hfc2l6ZZSMAjMylIwNbGVhcm5pbmdfcmF0ZZSMCDAuMDAwMDAxlIwJb3B0aW1pemVylIwEYWRhbZSMDWxvc3NfZnVuY3Rpb26UjBNiaW5hcnlfY3Jvc3NlbnRyb3B5lIwQdmFsaWRhdGlvbl9zcGxpdJSMAzAuMpSMF2Vhcmx5X3N0b3BwaW5nX3BhdGllbmNllIwCMTCUjAxkcm9wb3V0X3JhdGWUjAMwLjWUjAxhdWdtZW50YXRpb26UjAROb25llIwNY2xhc3Nfd2VpZ2h0c5RoKYwLcmFuZG9tX3NlZWSUjAI0MpSMDHRyYWluaW5nX2pvYpRoBowFdHJhaW6UjAxUcmFpbmluZ19qb2KUhpSFlFKUfZQojAZfc3RhdGWUaA8pgZR9lChoE2gUaBV9lCiMC2RhdGFzZXRfaW1nlGgGaE+MC0RhdGFzZXRfSU1HlIaUhZRSlH2UKGgNaA8pgZR9lChoFX2UaBKJaBNoFHViaBdLEIwJZGF0YV9uYW1llIwPVEIgVGlueSBEYXRhc2V0lIwJZGF0YV9wYXRolIwjMTUweDE1MF90Yl9kYXRhc2V0X3RpbnlfdEJpRGRxTy56aXCUjA5leHRyYWN0ZWRfcGF0aJSMRUU6XHdvcmtzcGFjZVxweXRob25cZGVlcC1kaXN0cmlidXRlXGRlZXBkaXN0cmlidXRlXG1lZGlhXHRtcC8xNi90cmFpbpSMDmRhdGFfcGF0aF90ZXN0lIwdZGphbmdvLmRiLm1vZGVscy5maWVsZHMuZmlsZXOUjAlGaWVsZEZpbGWUk5QpgZR9lCiMBG5hbWWUjCgxNTB4MTUwX3RiX2RhdGFzZXRfdGlueS10ZXN0X0FuU1ZxMmkuemlwlIwGY2xvc2VklImMCl9jb21taXR0ZWSUiIwFX2ZpbGWUTowIaW5zdGFuY2WUaF2MBWZpZWxklIwXZGphbmdvLmRiLm1vZGVscy5maWVsZHOUjAtfbG9hZF9maWVsZJSTlGhPaFqMDmRhdGFfcGF0aF90ZXN0lIeUUpR1YowTZXh0cmFjdGVkX3BhdGhfdGVzdJSMREU6XHdvcmtzcGFjZVxweXRob25cZGVlcC1kaXN0cmlidXRlXGRlZXBkaXN0cmlidXRlXG1lZGlhXHRtcC8xNi90ZXN0lIwIbWV0YWluZm+UaCmMDHByb2Nlc3NlZF9hdJRoHUMKB+gJFgcwKQFqx5RoIoaUUpSMCWRlbGV0ZV9hdJROjAZzdGF0dXOUaCmMB3VzZXJfaWSUSwJoM2g0dWJoA2gLdWgSiXVijAJpZJRLXowIam9iX25hbWWUjCpUQiBUaW55IERhdGFzZXQgIGtVYXRRYmZkenRfMjAyNDA5MjIxNDI4MTiUjA5kYXRhc2V0X2ltZ19pZJRLEIwGc3RhdHVzlIwHUlVOTklOR5SMCnN0YXJ0ZWRfYXSUaB1DCgfoCRYJHBICWq6UaCKGlFKUjAhlbmRlZF9hdJROjARhbGdvlGg4jAd1c2VyX2lklEsCjBJwYXJhbWV0ZXJfc2V0dGluZ3OUaACMBnJlc3VsdJROjAx0cmFpbmluZ19sb2eUTowUdHJhaW5pbmdfbG9nX2hpc3RvcnmUTmgzaDR1YnWFlC4=	gAV9lC4=	\N	2024-09-22 14:28:18.15624+05	2024-09-22 14:28:36.931898+05	t	5e4734f201e8472887c1f8a1c25fb2c2	\N	1
september-helium-dakota-eight	train.services.TrainingServiceSingle.start_training	\N	gAWVMAcAAAAAAAB9lCiMCmRhdGFzZXRfaWSUjAIxNpSMBHVzZXKUjBVkamFuZ28uZGIubW9kZWxzLmJhc2WUjA5tb2RlbF91bnBpY2tsZZSTlIwEYXV0aJSMBFVzZXKUhpSFlFKUfZQojAZfc3RhdGWUaASMCk1vZGVsU3RhdGWUk5QpgZR9lCiMBmFkZGluZ5SJjAJkYpSMB2RlZmF1bHSUjAxmaWVsZHNfY2FjaGWUfZR1YowCaWSUSwKMCHBhc3N3b3JklIxOcGJrZGYyX3NoYTI1NiQyMTYwMDAkRWlFU0hKN1JLRDFpJEhCWkNTODYwUndSZUlEKzBJdHJ6b0lLdVIxRmlPZ2kyYUNwRGlqOUpkNEE9lIwKbGFzdF9sb2dpbpSMCGRhdGV0aW1llIwIZGF0ZXRpbWWUk5RDCgfoCRYHKQEL3IuUjARweXR6lIwEX1VUQ5STlClSlIaUUpSMDGlzX3N1cGVydXNlcpSIjAh1c2VybmFtZZSMBWFkbWlulIwKZmlyc3RfbmFtZZSMAJSMCWxhc3RfbmFtZZRoKYwFZW1haWyUjBRhbGlmaWRhLjg2QGdtYWlsLmNvbZSMCGlzX3N0YWZmlIiMCWlzX2FjdGl2ZZSIjAtkYXRlX2pvaW5lZJRoHUMKB+gCBA0ULwAAAJRoIoaUUpSMD19kamFuZ29fdmVyc2lvbpSMBTMuMS4ylHVijAhzdHJhdGVneZSMClNpbmdsZSBHUFWUjAlhbGdvX25hbWWUjAtEZW5zZU5ldDEyMZSMBmVwb2Noc5SMAjEwlIwKYmF0Y2hfc2l6ZZSMAjMylIwNbGVhcm5pbmdfcmF0ZZSMBTAuMDAxlIwJb3B0aW1pemVylIwEYWRhbZSMDWxvc3NfZnVuY3Rpb26UjBNiaW5hcnlfY3Jvc3NlbnRyb3B5lIwQdmFsaWRhdGlvbl9zcGxpdJSMAzAuMpSMF2Vhcmx5X3N0b3BwaW5nX3BhdGllbmNllIwCMTCUjAxkcm9wb3V0X3JhdGWUjAMwLjWUjAxhdWdtZW50YXRpb26UjAROb25llIwNY2xhc3Nfd2VpZ2h0c5RoKYwLcmFuZG9tX3NlZWSUjAI0MpSMDHRyYWluaW5nX2pvYpRoBowFdHJhaW6UjAxUcmFpbmluZ19qb2KUhpSFlFKUfZQojAZfc3RhdGWUaA8pgZR9lChoE2gUaBV9lCiMC2RhdGFzZXRfaW1nlGgGaE+MC0RhdGFzZXRfSU1HlIaUhZRSlH2UKGgNaA8pgZR9lChoFX2UaBKJaBNoFHViaBdLEIwJZGF0YV9uYW1llIwPVEIgVGlueSBEYXRhc2V0lIwJZGF0YV9wYXRolIwjMTUweDE1MF90Yl9kYXRhc2V0X3RpbnlfdEJpRGRxTy56aXCUjA5leHRyYWN0ZWRfcGF0aJSMRUU6XHdvcmtzcGFjZVxweXRob25cZGVlcC1kaXN0cmlidXRlXGRlZXBkaXN0cmlidXRlXG1lZGlhXHRtcC8xNi90cmFpbpSMDmRhdGFfcGF0aF90ZXN0lIwdZGphbmdvLmRiLm1vZGVscy5maWVsZHMuZmlsZXOUjAlGaWVsZEZpbGWUk5QpgZR9lCiMBG5hbWWUjCgxNTB4MTUwX3RiX2RhdGFzZXRfdGlueS10ZXN0X0FuU1ZxMmkuemlwlIwGY2xvc2VklImMCl9jb21taXR0ZWSUiIwFX2ZpbGWUTowIaW5zdGFuY2WUaF2MBWZpZWxklIwXZGphbmdvLmRiLm1vZGVscy5maWVsZHOUjAtfbG9hZF9maWVsZJSTlGhPaFqMDmRhdGFfcGF0aF90ZXN0lIeUUpR1YowTZXh0cmFjdGVkX3BhdGhfdGVzdJSMREU6XHdvcmtzcGFjZVxweXRob25cZGVlcC1kaXN0cmlidXRlXGRlZXBkaXN0cmlidXRlXG1lZGlhXHRtcC8xNi90ZXN0lIwIbWV0YWluZm+UaCmMDHByb2Nlc3NlZF9hdJRoHUMKB+gJFgcwKQFqx5RoIoaUUpSMCWRlbGV0ZV9hdJROjAZzdGF0dXOUaCmMB3VzZXJfaWSUSwJoM2g0dWJoA2gLdWgSiXVijAJpZJRLX4wIam9iX25hbWWUjCpUQiBUaW55IERhdGFzZXQgIE9JVlU2OG9PZlFfMjAyNDA5MjIxNDI5MTCUjA5kYXRhc2V0X2ltZ19pZJRLEIwGc3RhdHVzlIwHUlVOTklOR5SMCnN0YXJ0ZWRfYXSUaB1DCgfoCRYJHQoMteWUaCKGlFKUjAhlbmRlZF9hdJROjARhbGdvlGg4jAd1c2VyX2lklEsCjBJwYXJhbWV0ZXJfc2V0dGluZ3OUaACMBnJlc3VsdJROjAx0cmFpbmluZ19sb2eUTowUdHJhaW5pbmdfbG9nX2hpc3RvcnmUTowPX2RqYW5nb192ZXJzaW9ulGg0dWJ1hZQu	gAV9lC4=	\N	2024-09-22 14:29:10.835278+05	2024-09-22 14:29:22.406644+05	t	9d57616a5c7644328db3d0c160b713ff	\N	1
\.


--
-- TOC entry 3593 (class 0 OID 16570)
-- Dependencies: 235
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
2mg3446exvyw9ijf45vd90ns0bai41zf	.eJxVjEEOwiAQRe_C2hAYCIJL956BzDCDVE2blHbVeHdt0oVu_3vvbyrjurS8dpnzwOqiQJ1-N8LylHEH_MDxPukyjcs8kN4VfdCubxPL63q4fwcNe_vW6I1jLrEYTwDW-BqJY4QSPNmaKEQXDCRHIDEZb4GqGEQ5iwNisur9AdurN-Y:1rWhsX:fygYve6-s5j5Yj9oRrb8ypLjhL9D538yr1nwUSCfFmo	2024-02-18 19:10:09.692763+05
x83suefa8okq41hgeeo12gwhriwk4suc	.eJxVjDkOwjAUBe_iGlneLVPScwbrLw4OIFuKkwpxd4iUAto3M-8lMmxrzdsoS55ZnIUVp98NgR6l7YDv0G5dUm_rMqPcFXnQIa-dy_NyuH8HFUb91tpCIg2ovCsU1eQ0J8fkQ2IiDECWC07IaJ1VXNiYANp7E5mjppjE-wMKujje:1rWuXL:DXazrPEYzfZTC4e-gkCEwe-cEHEOtEUWB-5ZFRUmvwE	2024-02-19 08:41:07.845501+05
f39j9g3yqa4hgsgih7ikdkv1wuojip2d	.eJxVjEEOwiAQRe_C2hAYCIJL956BzDCDVE2blHbVeHdt0oVu_3vvbyrjurS8dpnzwOqiQJ1-N8LylHEH_MDxPukyjcs8kN4VfdCubxPL63q4fwcNe_vW6I1jLrEYTwDW-BqJY4QSPNmaKEQXDCRHIDEZb4GqGEQ5iwNisur9AdurN-Y:1rdBfD:yynHL-ZNMpbvzRO5Jo3KTMHAJ9EFubyplHJlhdrR2gI	2024-03-07 16:11:11.930516+05
rqt6zhzgkoh0pmvii4g2f2lqbua6kfrq	.eJxVjEEOwiAQRe_C2hAYCIJL956BzDCDVE2blHbVeHdt0oVu_3vvbyrjurS8dpnzwOqiQJ1-N8LylHEH_MDxPukyjcs8kN4VfdCubxPL63q4fwcNe_vW6I1jLrEYTwDW-BqJY4QSPNmaKEQXDCRHIDEZb4GqGEQ5iwNisur9AdurN-Y:1rlB9o:QVskUv2etfz15KmSSUKpUJfAFaXcAmDFnTJySbgLaXg	2024-03-29 17:15:48.880666+05
62dxfv8w5vnu3vhba30aut9tusgmhyb9	.eJxVjEEOwiAQRe_C2hAYCIJL956BzDCDVE2blHbVeHdt0oVu_3vvbyrjurS8dpnzwOqiQJ1-N8LylHEH_MDxPukyjcs8kN4VfdCubxPL63q4fwcNe_vW6I1jLrEYTwDW-BqJY4QSPNmaKEQXDCRHIDEZb4GqGEQ5iwNisur9AdurN-Y:1s5mIC:3_8pkf1PkKcvHnW1Wl9dSLqapzH211LRv4cVZhvX0BQ	2024-05-25 12:57:36.256557+05
uyzwzh3ypw5tbj08yrtd6r362rz0is8n	.eJxVjEEOwiAQRe_C2hAYCIJL956BzDCDVE2blHbVeHdt0oVu_3vvbyrjurS8dpnzwOqiQJ1-N8LylHEH_MDxPukyjcs8kN4VfdCubxPL63q4fwcNe_vW6I1jLrEYTwDW-BqJY4QSPNmaKEQXDCRHIDEZb4GqGEQ5iwNisur9AdurN-Y:1s5rPR:qOC-_ve1DpMfjSQCQN64PKQSqNN1wlHDErZnfUeZuRg	2024-05-25 18:25:25.126198+05
hrbn30qx1lwo0fjwrujx6y6bkgp96wec	.eJxVjEEOwiAQRe_C2hAYCIJL956BzDCDVE2blHbVeHdt0oVu_3vvbyrjurS8dpnzwOqiQJ1-N8LylHEH_MDxPukyjcs8kN4VfdCubxPL63q4fwcNe_vW6I1jLrEYTwDW-BqJY4QSPNmaKEQXDCRHIDEZb4GqGEQ5iwNisur9AdurN-Y:1s652v:I3QngTD_MAJzpj16lnuVbfH2JMhmkbwEV__w_dgcbPY	2024-05-26 08:59:05.718557+05
hf0aecvmw8uzhtsj0wwoeezikhv1ywq6	.eJxVjEEOwiAQRe_C2hAYCIJL956BzDCDVE2blHbVeHdt0oVu_3vvbyrjurS8dpnzwOqiQJ1-N8LylHEH_MDxPukyjcs8kN4VfdCubxPL63q4fwcNe_vW6I1jLrEYTwDW-BqJY4QSPNmaKEQXDCRHIDEZb4GqGEQ5iwNisur9AdurN-Y:1sFsHX:iFWpjQt2b6odIamk4V-IZaERDemZAU58GLbFxBm54hY	2024-06-22 09:22:39.788671+05
4iuycdbul4be5olbvxd1fhsj3upc072x	.eJxVjEEOwiAQRe_C2hAYCIJL956BzDCDVE2blHbVeHdt0oVu_3vvbyrjurS8dpnzwOqiQJ1-N8LylHEH_MDxPukyjcs8kN4VfdCubxPL63q4fwcNe_vW6I1jLrEYTwDW-BqJY4QSPNmaKEQXDCRHIDEZb4GqGEQ5iwNisur9AdurN-Y:1sFuT6:jtxVMEh0FvAdU746P5kcofX6diS_rNAEvT0VbSTF5-I	2024-06-22 11:42:44.629065+05
9qdfzme0r2x5ph18z6o6e8xqbmk671r7	.eJxVjEEOwiAQRe_C2hAYCIJL956BzDCDVE2blHbVeHdt0oVu_3vvbyrjurS8dpnzwOqiQJ1-N8LylHEH_MDxPukyjcs8kN4VfdCubxPL63q4fwcNe_vW6I1jLrEYTwDW-BqJY4QSPNmaKEQXDCRHIDEZb4GqGEQ5iwNisur9AdurN-Y:1sFxzy:yeJRhM237ITDm2bInGwiBTTWpWrIavRgXnxAW7735Wk	2024-06-22 15:28:54.316593+05
sxryznjsrvlvw35b8apq84kyfg6napi6	.eJxVjEEOwiAQRe_C2hAYCIJL956BzDCDVE2blHbVeHdt0oVu_3vvbyrjurS8dpnzwOqiQJ1-N8LylHEH_MDxPukyjcs8kN4VfdCubxPL63q4fwcNe_vW6I1jLrEYTwDW-BqJY4QSPNmaKEQXDCRHIDEZb4GqGEQ5iwNisur9AdurN-Y:1sKvfy:ATohA--DRBXXRUgmD6lmRmHwaLxlHKbWt8jlYXS0JKU	2024-07-06 08:00:46.305499+05
n4giahihk1cmmq8pcu4ks08mqdurv0um	.eJxVjEEOwiAQRe_C2hAYCIJL956BzDCDVE2blHbVeHdt0oVu_3vvbyrjurS8dpnzwOqiQJ1-N8LylHEH_MDxPukyjcs8kN4VfdCubxPL63q4fwcNe_vW6I1jLrEYTwDW-BqJY4QSPNmaKEQXDCRHIDEZb4GqGEQ5iwNisur9AdurN-Y:1sMpa4:s3DqME4KxHrTZJouJkIRtXhbUpKDHecROue6R3dDa1s	2024-07-11 13:54:32.111061+05
mc1cq6xymvdkn9jb4h9pb3usvtmae3jt	.eJxVjEEOwiAQRe_C2hAYCIJL956BzDCDVE2blHbVeHdt0oVu_3vvbyrjurS8dpnzwOqiQJ1-N8LylHEH_MDxPukyjcs8kN4VfdCubxPL63q4fwcNe_vW6I1jLrEYTwDW-BqJY4QSPNmaKEQXDCRHIDEZb4GqGEQ5iwNisur9AdurN-Y:1sRpbN:38uIt_W5ReW9w1dKZiX-qP2IZohFPFzTCHnreY2PVgQ	2024-07-25 08:56:33.438135+05
kts57k3rsljvhionsxz4k1qn4osr42kg	.eJxVjEEOwiAQRe_C2hAYCIJL956BzDCDVE2blHbVeHdt0oVu_3vvbyrjurS8dpnzwOqiQJ1-N8LylHEH_MDxPukyjcs8kN4VfdCubxPL63q4fwcNe_vW6I1jLrEYTwDW-BqJY4QSPNmaKEQXDCRHIDEZb4GqGEQ5iwNisur9AdurN-Y:1sSJYM:ZvoW-aEQO1qzAOA3IWGbsQYfl1PZLLoxggBvLjLQUoI	2024-07-26 16:55:26.693861+05
hrf5k2w4wni2zgghm12qo3olblamwyf8	.eJxVjEEOwiAQRe_C2hAYCIJL956BzDCDVE2blHbVeHdt0oVu_3vvbyrjurS8dpnzwOqiQJ1-N8LylHEH_MDxPukyjcs8kN4VfdCubxPL63q4fwcNe_vW6I1jLrEYTwDW-BqJY4QSPNmaKEQXDCRHIDEZb4GqGEQ5iwNisur9AdurN-Y:1sU2nw:y85HfdA9Z8ezuXC075FM5FE5R4Qug90T3Uj_AMVdq-E	2024-07-31 11:26:40.795851+05
2ibyqj9nlacytxd5ccb506jrxxxqrcmg	.eJxVjEEOwiAQRe_C2hAYCIJL956BzDCDVE2blHbVeHdt0oVu_3vvbyrjurS8dpnzwOqiQJ1-N8LylHEH_MDxPukyjcs8kN4VfdCubxPL63q4fwcNe_vW6I1jLrEYTwDW-BqJY4QSPNmaKEQXDCRHIDEZb4GqGEQ5iwNisur9AdurN-Y:1sU3Ej:ZwViyDkj9GSM9BnDSVMnS-AXfP9yz87Fiqt5klq5LPY	2024-07-31 11:54:21.564814+05
0zbxavig7awkhrj92gusqi4gut4adsi0	.eJxVjEEOwiAQRe_C2hAYCIJL956BzDCDVE2blHbVeHdt0oVu_3vvbyrjurS8dpnzwOqiQJ1-N8LylHEH_MDxPukyjcs8kN4VfdCubxPL63q4fwcNe_vW6I1jLrEYTwDW-BqJY4QSPNmaKEQXDCRHIDEZb4GqGEQ5iwNisur9AdurN-Y:1sU66Y:8nwD7Jwy2rset_-9196qEGje6vk1nrYrOFtq9NNS91o	2024-07-31 14:58:06.214125+05
2qvjo7tjf8mquihrtmbsoa5sz1161bs0	.eJxVjEEOwiAQRe_C2hAYCIJL956BzDCDVE2blHbVeHdt0oVu_3vvbyrjurS8dpnzwOqiQJ1-N8LylHEH_MDxPukyjcs8kN4VfdCubxPL63q4fwcNe_vW6I1jLrEYTwDW-BqJY4QSPNmaKEQXDCRHIDEZb4GqGEQ5iwNisur9AdurN-Y:1saXG9:CcZd3oxU0izmrU37JmZfLXRD_5czhsWZTKJ8wvnn30g	2024-08-18 09:10:37.448034+05
83w1yf7o3q9pkxoywb8x84u6yix1zv6h	.eJxVjEEOwiAQRe_C2hAYCIJL956BzDCDVE2blHbVeHdt0oVu_3vvbyrjurS8dpnzwOqiQJ1-N8LylHEH_MDxPukyjcs8kN4VfdCubxPL63q4fwcNe_vW6I1jLrEYTwDW-BqJY4QSPNmaKEQXDCRHIDEZb4GqGEQ5iwNisur9AdurN-Y:1sc53W:00DzHe79YXZNQ8JDnzWD8kuLrkVvm3T_1qTzt9B9_PA	2024-08-22 15:27:58.77675+05
vqf8m76sl1m1udwc0qpzwola7phsnmtq	.eJxVjEEOwiAQRe_C2hAYCIJL956BzDCDVE2blHbVeHdt0oVu_3vvbyrjurS8dpnzwOqiQJ1-N8LylHEH_MDxPukyjcs8kN4VfdCubxPL63q4fwcNe_vW6I1jLrEYTwDW-BqJY4QSPNmaKEQXDCRHIDEZb4GqGEQ5iwNisur9AdurN-Y:1sfHJO:LSWa-1dTs6sPmdU9HXPrLTy2Rx7afqgcR9HeUz2tbIs	2024-08-31 16:09:34.812893+05
zjvwskm2ym2uavr5o6yrt8xuzesax0kl	.eJxVjEEOwiAQRe_C2hAYCIJL956BzDCDVE2blHbVeHdt0oVu_3vvbyrjurS8dpnzwOqiQJ1-N8LylHEH_MDxPukyjcs8kN4VfdCubxPL63q4fwcNe_vW6I1jLrEYTwDW-BqJY4QSPNmaKEQXDCRHIDEZb4GqGEQ5iwNisur9AdurN-Y:1skM3x:BJtNXwJIC_TE0TmO8Os9IRsFIHw7_qgtKxex2K7n8N0	2024-09-14 16:14:37.307454+05
ngy4m7k87e0dwuhvuu70itsaoiyar4vp	.eJxVjEEOwiAQRe_C2hAYCIJL956BzDCDVE2blHbVeHdt0oVu_3vvbyrjurS8dpnzwOqiQJ1-N8LylHEH_MDxPukyjcs8kN4VfdCubxPL63q4fwcNe_vW6I1jLrEYTwDW-BqJY4QSPNmaKEQXDCRHIDEZb4GqGEQ5iwNisur9AdurN-Y:1skTZT:WkP03PQezvKF6IfkvDokLcfHLy___1UAvjCVmMbIcIE	2024-09-15 00:15:39.63652+05
xif4sr0p1mefmfjved5xgulrm7ql2i5l	.eJxVjEEOwiAQRe_C2hAYCIJL956BzDCDVE2blHbVeHdt0oVu_3vvbyrjurS8dpnzwOqiQJ1-N8LylHEH_MDxPukyjcs8kN4VfdCubxPL63q4fwcNe_vW6I1jLrEYTwDW-BqJY4QSPNmaKEQXDCRHIDEZb4GqGEQ5iwNisur9AdurN-Y:1smvWj:i52QvG518afRRdusq9SrmsbSahhU-lrIghe4wyF98F0	2024-09-21 18:30:57.21352+05
w2wbr2rxi2ldgojas4u2lxjncufzrrud	.eJxVjEEOwiAQRe_C2hAYCIJL956BzDCDVE2blHbVeHdt0oVu_3vvbyrjurS8dpnzwOqiQJ1-N8LylHEH_MDxPukyjcs8kN4VfdCubxPL63q4fwcNe_vW6I1jLrEYTwDW-BqJY4QSPNmaKEQXDCRHIDEZb4GqGEQ5iwNisur9AdurN-Y:1snBjW:m0NvmhKU2rAiLwc0R-7QisVfS8qj2MjVVRSDkA4WCOE	2024-09-22 11:49:14.858154+05
1kbqrlszkm0l8hst2qaxbskorvjixhoe	.eJxVjEEOwiAQRe_C2hAYCIJL956BzDCDVE2blHbVeHdt0oVu_3vvbyrjurS8dpnzwOqiQJ1-N8LylHEH_MDxPukyjcs8kN4VfdCubxPL63q4fwcNe_vW6I1jLrEYTwDW-BqJY4QSPNmaKEQXDCRHIDEZb4GqGEQ5iwNisur9AdurN-Y:1ssHDJ:rtUBvjZ9vHPNSSNgG0WWI6nr69kig91DIdz6CEtF1SQ	2024-10-06 12:41:01.780367+05
xqplnevs6hzahw2xk700lq1dgypsp0wy	.eJxVjMsOwiAQRf-FtSE8hqG4dN9vaIYyStVAUtqV8d-VpAtd3ntOzktMtG952huv05LEWYA4_X6R5geXDtKdyq3KuZZtXaLsijxok2NN_Lwc7l8gU8s9qzRcE3DyRBGDBxPQELo0KGeALbGjIXpryVNkxQZBO60wKGb8bvH-ANpXN5c:1ssKsY:APbnl-QVnd2U-Y2szYO8eE1HGLVV30pMHhBLndsMEGw	2024-10-06 16:35:50.231688+05
\.


--
-- TOC entry 3595 (class 0 OID 16580)
-- Dependencies: 237
-- Data for Name: django_site; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_site (id, domain, name) FROM stdin;
1	example.com	example.com
\.


--
-- TOC entry 3591 (class 0 OID 16546)
-- Dependencies: 233
-- Data for Name: registration_registrationprofile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.registration_registrationprofile (id, activation_key, user_id, activated) FROM stdin;
\.


--
-- TOC entry 3592 (class 0 OID 16560)
-- Dependencies: 234
-- Data for Name: registration_supervisedregistrationprofile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.registration_supervisedregistrationprofile (registrationprofile_ptr_id) FROM stdin;
\.


--
-- TOC entry 3611 (class 0 OID 18553)
-- Dependencies: 253
-- Data for Name: train_chart; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.train_chart (id, name, dataset_attribute, data, dataset_id, type_id) FROM stdin;
\.


--
-- TOC entry 3609 (class 0 OID 18544)
-- Dependencies: 251
-- Data for Name: train_charttype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.train_charttype (id, name, type, status, template) FROM stdin;
23	stacked-column (11)	stacked-column	\N	{\r\n "chart":{"height":"auto",   "type":"column"},\r\n "colors":["#ffc107","#17a2b8","#28a745","#dc3545","#c2de24","#32cab4", "#ca329b","#ff93c0"],   \r\n"exporting": {\r\n       "enabled":"true"\r\n       \r\n    },\r\n\r\n"title":{"text":"____TITLE____"},"xAxis":{"categories":____CATEGORIES____},\r\n"yAxis":{"visible":false},"tooltip":{"pointFormat":"<span style='color:{series.color}'>{series.name}</span>: <b>{point.y:.3f}</b><br/>","shared":true},\r\n"plotOptions": {\r\n        "column": {\r\n            "pointPadding": "0.2",\r\n            "borderWidth": "0"\r\n        }\r\n    },\r\n"series":____SERIES____}
31	Line (G) without table	line	\N	{ \r\n"chart":{"height":"500","type":"line"},\r\n"exporting": {\r\n       "enabled":true,\r\n        "showTable": "false"\r\n    },\r\n"colors":____COLORS____,\r\n"title":{"text":"____TITLE____"},"xAxis":{"categories":____CATEGORIES____,"tickmarkPlacement":"off","title":{"enabled":false}},"yAxis":{"visible":true},"tooltip":{"pointFormat":"<span>{series.name}</span>: <b>{point.y:,.0f}</b><br/>","shared":true},"plotOptions":{"area":{"stacking":"normal","lineColor":"#d6a208","lineWidth":1,"marker":{"lineWidth":1,"lineColor":"#d6a208"}}},"series":____SERIES____}
\.


--
-- TOC entry 3601 (class 0 OID 16632)
-- Dependencies: 243
-- Data for Name: train_clusternode; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.train_clusternode (id, node_type, ip_address, port) FROM stdin;
6	ps	192.168.100.112	2223
10	worker	192.168.100.112	2222
\.


--
-- TOC entry 3605 (class 0 OID 18502)
-- Dependencies: 247
-- Data for Name: train_dataset; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.train_dataset (id, description, dataset, dataset_test, process_details, processed_at, metainfo, source_dataset_id_id, user_id) FROM stdin;
33	hearts	datasets/Heart_awiKVTP.csv			2024-09-22 12:42:25.763615+05	{"details": {"total_instances": 287, "total_attributes": 15, "total_missing": 6, "total_weight": 6, "columns": {"Unnamed: 0": {"datatype": "numeric", "min": 17.0, "max": 303.0, "distinct": 287}, "Age": {"datatype": "numeric", "min": 29.0, "max": 77.0, "distinct": 41}, "Sex": {"datatype": "numeric", "min": 0.0, "max": 1.0, "distinct": 2}, "ChestPain": {"datatype": "str", "distinct": 4}, "RestBP": {"datatype": "numeric", "min": 94.0, "max": 200.0, "distinct": 49}, "Chol": {"datatype": "numeric", "min": 126.0, "max": 564.0, "distinct": 150}, "Fbs": {"datatype": "numeric", "min": 0.0, "max": 1.0, "distinct": 2}, "RestECG": {"datatype": "numeric", "min": 0.0, "max": 2.0, "distinct": 3}, "MaxHR": {"datatype": "numeric", "min": 71.0, "max": 202.0, "distinct": 89}, "ExAng": {"datatype": "numeric", "min": 0.0, "max": 1.0, "distinct": 2}, "Oldpeak": {"datatype": "numeric", "min": 0.0, "max": 6.2, "distinct": 37}, "Slope": {"datatype": "numeric", "min": 1.0, "max": 3.0, "distinct": 3}, "Ca": {"datatype": "numeric", "min": 0.0, "max": 3.0, "distinct": 5}, "Thal": {"datatype": "str", "distinct": 4}, "AHD": {"datatype": "str", "distinct": 2}}, "sample": "<table border=\\"1\\" class=\\"dataframe\\">\\n  <thead>\\n    <tr style=\\"text-align: right;\\">\\n      <th>Unnamed: 0</th>\\n      <th>Age</th>\\n      <th>Sex</th>\\n      <th>ChestPain</th>\\n      <th>RestBP</th>\\n      <th>Chol</th>\\n      <th>Fbs</th>\\n      <th>RestECG</th>\\n      <th>MaxHR</th>\\n      <th>ExAng</th>\\n      <th>Oldpeak</th>\\n      <th>Slope</th>\\n      <th>Ca</th>\\n      <th>Thal</th>\\n      <th>AHD</th>\\n    </tr>\\n  </thead>\\n  <tbody>\\n    <tr>\\n      <td>17</td>\\n      <td>48</td>\\n      <td>1</td>\\n      <td>nontypical</td>\\n      <td>110</td>\\n      <td>229</td>\\n      <td>0</td>\\n      <td>0</td>\\n      <td>168</td>\\n      <td>0</td>\\n      <td>1.0</td>\\n      <td>3</td>\\n      <td>0.0</td>\\n      <td>reversable</td>\\n      <td>Yes</td>\\n    </tr>\\n    <tr>\\n      <td>18</td>\\n      <td>54</td>\\n      <td>1</td>\\n      <td>asymptomatic</td>\\n      <td>140</td>\\n      <td>239</td>\\n      <td>0</td>\\n      <td>0</td>\\n      <td>160</td>\\n      <td>0</td>\\n      <td>1.2</td>\\n      <td>1</td>\\n      <td>0.0</td>\\n      <td>normal</td>\\n      <td>No</td>\\n    </tr>\\n    <tr>\\n      <td>19</td>\\n      <td>48</td>\\n      <td>0</td>\\n      <td>nonanginal</td>\\n      <td>130</td>\\n      <td>275</td>\\n      <td>0</td>\\n      <td>0</td>\\n      <td>139</td>\\n      <td>0</td>\\n      <td>0.2</td>\\n      <td>1</td>\\n      <td>0.0</td>\\n      <td>normal</td>\\n      <td>No</td>\\n    </tr>\\n    <tr>\\n      <td>20</td>\\n      <td>49</td>\\n      <td>1</td>\\n      <td>nontypical</td>\\n      <td>130</td>\\n      <td>266</td>\\n      <td>0</td>\\n      <td>0</td>\\n      <td>171</td>\\n      <td>0</td>\\n      <td>0.6</td>\\n      <td>1</td>\\n      <td>0.0</td>\\n      <td>normal</td>\\n      <td>No</td>\\n    </tr>\\n    <tr>\\n      <td>21</td>\\n      <td>64</td>\\n      <td>1</td>\\n      <td>typical</td>\\n      <td>110</td>\\n      <td>211</td>\\n      <td>0</td>\\n      <td>2</td>\\n      <td>144</td>\\n      <td>1</td>\\n      <td>1.8</td>\\n      <td>2</td>\\n      <td>0.0</td>\\n      <td>normal</td>\\n      <td>No</td>\\n    </tr>\\n  </tbody>\\n</table>"}}	\N	2
\.


--
-- TOC entry 3597 (class 0 OID 16590)
-- Dependencies: 239
-- Data for Name: train_dataset_img; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.train_dataset_img (id, data_name, data_path, metainfo, processed_at, delete_at, status, user_id, extracted_path, data_path_test, extracted_path_test) FROM stdin;
16	TB Tiny Dataset	150x150_tb_dataset_tiny_tBiDdqO.zip		2024-09-22 12:48:41.092871+05	\N		2	E:\\workspace\\python\\deep-distribute\\deepdistribute\\media\\tmp/16/train	150x150_tb_dataset_tiny-test_AnSVq2i.zip	E:\\workspace\\python\\deep-distribute\\deepdistribute\\media\\tmp/16/test
\.


--
-- TOC entry 3618 (class 0 OID 52942)
-- Dependencies: 260
-- Data for Name: train_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.train_permission (id, name) FROM stdin;
\.


--
-- TOC entry 3607 (class 0 OID 18511)
-- Dependencies: 249
-- Data for Name: train_trainedmodel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.train_trainedmodel (id, model_file, description, status, created_at, updated_at, key_attributes, class_label, dataset_id, user_id, dataset_img_id) FROM stdin;
897	2\\trained_models\\csv\\33\\BernoulliNB.pkl	BernoulliNB	Deployed	2024-09-22 12:42:59.632396+05	2024-09-22 12:44:24.76346+05	['Age', 'Sex', 'ChestPain', 'RestBP', 'Chol', 'Fbs', 'RestECG', 'MaxHR', 'ExAng', 'Oldpeak', 'Slope', 'Ca', 'Thal']	AHD	33	2	\N
900	2\\trained_models\\images\\16\\DenseNet121.h5	DenseNet121	Deployed	2024-09-22 13:06:01.527207+05	2024-09-22 13:07:27.61031+05		['Normal', 'Tuberculosis']	\N	2	16
901	2\\trained_models\\images\\16\\DenseNet121.h5	DenseNet121	Temp	2024-09-22 13:58:37.521369+05	2024-09-22 13:58:37.521369+05		['Normal', 'Tuberculosis']	\N	2	16
902	2\\trained_models\\images\\16\\DenseNet121.h5	DenseNet121	Temp	2024-09-22 14:15:26.602375+05	2024-09-22 14:15:26.602375+05		['Normal', 'Tuberculosis']	\N	2	16
903	2\\trained_models\\images\\16\\DenseNet121.h5	DenseNet121	Temp	2024-09-22 14:20:06.409702+05	2024-09-22 14:20:06.410699+05		['Normal', 'Tuberculosis']	\N	2	16
904	2\\trained_models\\images\\16\\DenseNet121.h5	DenseNet121	Temp	2024-09-22 14:21:38.30371+05	2024-09-22 14:21:38.30371+05		['Normal', 'Tuberculosis']	\N	2	16
905	2\\trained_models\\images\\16\\DenseNet121.h5	DenseNet121	Temp	2024-09-22 14:22:07.106557+05	2024-09-22 14:22:07.106557+05		['Normal', 'Tuberculosis']	\N	2	16
906	2\\trained_models\\images\\16\\DenseNet121.h5	DenseNet121	Temp	2024-09-22 14:23:03.388539+05	2024-09-22 14:23:03.388539+05		['Normal', 'Tuberculosis']	\N	2	16
907	2\\trained_models\\images\\16\\DenseNet121.h5	DenseNet121	Temp	2024-09-22 14:28:35.668066+05	2024-09-22 14:28:35.668066+05		['Normal', 'Tuberculosis']	\N	2	16
908	2\\trained_models\\images\\16\\DenseNet121.h5	DenseNet121	Temp	2024-09-22 14:29:21.120797+05	2024-09-22 14:29:21.120797+05		['Normal', 'Tuberculosis']	\N	2	16
\.


--
-- TOC entry 3599 (class 0 OID 16610)
-- Dependencies: 241
-- Data for Name: train_training_job; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.train_training_job (id, job_name, status, started_at, ended_at, algo, dataset_img_id, user_id, result, parameter_settings, training_log, training_log_history) FROM stdin;
95	TB Tiny Dataset  OIVU68oOfQ_20240922142910	COMPLETED	2024-09-22 14:29:10.832997+05	2024-09-22 14:29:22.313138+05	DenseNet121	16	2	{"accuracy": 0.6666666865348816, "precision": 0.0, "recall": 0.0, "auc": 0.5, "f1_score": 0.0}	{'dataset_id': '16', 'user': 2, 'strategy': 'Single GPU', 'algo_name': 'DenseNet121', 'epochs': '10', 'batch_size': '32', 'learning_rate': '0.001', 'optimizer': 'adam', 'loss_function': 'binary_crossentropy', 'validation_split': '0.2', 'early_stopping_patience': '10', 'dropout_rate': '0.5', 'augmentation': 'None', 'class_weights': '', 'random_seed': '42'}	{"epoch": 10, "logs": {"loss": 0.30807122588157654, "accuracy": 0.8333333134651184, "precision": 0.0, "recall": 0.0, "auc": 0.9500000476837158, "val_loss": 0.18159599602222443, "val_accuracy": 0.8333333134651184, "val_precision": 0.0, "val_recall": 0.0, "val_auc": 1.0}}	[{"epoch": 1, "logs": {"loss": 0.5238401293754578, "accuracy": 0.75, "precision": 0.25, "recall": 0.25, "auc": 0.7249999642372131, "val_loss": 0.2035205364227295, "val_accuracy": 1.0, "val_precision": 1.0, "val_recall": 1.0, "val_auc": 1.0}}, {"epoch": 2, "logs": {"loss": 0.43946322798728943, "accuracy": 0.7916666865348816, "precision": 0.3333333432674408, "recall": 0.25, "auc": 0.762499988079071, "val_loss": 0.19015248119831085, "val_accuracy": 0.8333333134651184, "val_precision": 0.0, "val_recall": 0.0, "val_auc": 1.0}}, {"epoch": 3, "logs": {"loss": 0.397959440946579, "accuracy": 0.7916666865348816, "precision": 0.0, "recall": 0.0, "auc": 0.8187500238418579, "val_loss": 0.19474071264266968, "val_accuracy": 0.8333333134651184, "val_precision": 0.0, "val_recall": 0.0, "val_auc": 1.0}}, {"epoch": 4, "logs": {"loss": 0.3803289830684662, "accuracy": 0.7916666865348816, "precision": 0.0, "recall": 0.0, "auc": 0.84375, "val_loss": 0.20377343893051147, "val_accuracy": 0.8333333134651184, "val_precision": 0.0, "val_recall": 0.0, "val_auc": 1.0}}, {"epoch": 5, "logs": {"loss": 0.3718246519565582, "accuracy": 0.8333333134651184, "precision": 0.0, "recall": 0.0, "auc": 0.875, "val_loss": 0.21044772863388062, "val_accuracy": 0.8333333134651184, "val_precision": 0.0, "val_recall": 0.0, "val_auc": 1.0}}, {"epoch": 6, "logs": {"loss": 0.36427488923072815, "accuracy": 0.8333333134651184, "precision": 0.0, "recall": 0.0, "auc": 0.887499988079071, "val_loss": 0.21243010461330414, "val_accuracy": 0.8333333134651184, "val_precision": 0.0, "val_recall": 0.0, "val_auc": 1.0}}, {"epoch": 7, "logs": {"loss": 0.3543393611907959, "accuracy": 0.8333333134651184, "precision": 0.0, "recall": 0.0, "auc": 0.9124999642372131, "val_loss": 0.2095937579870224, "val_accuracy": 0.8333333134651184, "val_precision": 0.0, "val_recall": 0.0, "val_auc": 1.0}}, {"epoch": 8, "logs": {"loss": 0.3412703573703766, "accuracy": 0.8333333134651184, "precision": 0.0, "recall": 0.0, "auc": 0.9312499761581421, "val_loss": 0.2027381807565689, "val_accuracy": 0.8333333134651184, "val_precision": 0.0, "val_recall": 0.0, "val_auc": 1.0}}, {"epoch": 9, "logs": {"loss": 0.32552552223205566, "accuracy": 0.8333333134651184, "precision": 0.0, "recall": 0.0, "auc": 0.9375, "val_loss": 0.1930014044046402, "val_accuracy": 0.8333333134651184, "val_precision": 0.0, "val_recall": 0.0, "val_auc": 1.0}}, {"epoch": 10, "logs": {"loss": 0.30807122588157654, "accuracy": 0.8333333134651184, "precision": 0.0, "recall": 0.0, "auc": 0.9500000476837158, "val_loss": 0.18159599602222443, "val_accuracy": 0.8333333134651184, "val_precision": 0.0, "val_recall": 0.0, "val_auc": 1.0}}]
\.


--
-- TOC entry 3603 (class 0 OID 16641)
-- Dependencies: 245
-- Data for Name: uac_group_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.uac_group_config (id, welcome_url, group_id) FROM stdin;
1	home	2
\.


--
-- TOC entry 3648 (class 0 OID 0)
-- Dependencies: 220
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 2, true);


--
-- TOC entry 3649 (class 0 OID 0)
-- Dependencies: 222
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 96, true);


--
-- TOC entry 3650 (class 0 OID 0)
-- Dependencies: 218
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 93, true);


--
-- TOC entry 3651 (class 0 OID 0)
-- Dependencies: 226
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 21, true);


--
-- TOC entry 3652 (class 0 OID 0)
-- Dependencies: 224
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 4, true);


--
-- TOC entry 3653 (class 0 OID 0)
-- Dependencies: 228
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- TOC entry 3654 (class 0 OID 0)
-- Dependencies: 230
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 31, true);


--
-- TOC entry 3655 (class 0 OID 0)
-- Dependencies: 216
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 23, true);


--
-- TOC entry 3656 (class 0 OID 0)
-- Dependencies: 214
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 56, true);


--
-- TOC entry 3657 (class 0 OID 0)
-- Dependencies: 257
-- Name: django_q_ormq_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_q_ormq_id_seq', 36, true);


--
-- TOC entry 3658 (class 0 OID 0)
-- Dependencies: 254
-- Name: django_q_schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_q_schedule_id_seq', 1, false);


--
-- TOC entry 3659 (class 0 OID 0)
-- Dependencies: 236
-- Name: django_site_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_site_id_seq', 1, true);


--
-- TOC entry 3660 (class 0 OID 0)
-- Dependencies: 232
-- Name: registration_registrationprofile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.registration_registrationprofile_id_seq', 1, false);


--
-- TOC entry 3661 (class 0 OID 0)
-- Dependencies: 252
-- Name: train_chart_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.train_chart_id_seq', 1, false);


--
-- TOC entry 3662 (class 0 OID 0)
-- Dependencies: 250
-- Name: train_charttype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.train_charttype_id_seq', 1, false);


--
-- TOC entry 3663 (class 0 OID 0)
-- Dependencies: 242
-- Name: train_clusternode_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.train_clusternode_id_seq', 1, false);


--
-- TOC entry 3664 (class 0 OID 0)
-- Dependencies: 246
-- Name: train_dataset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.train_dataset_id_seq', 33, true);


--
-- TOC entry 3665 (class 0 OID 0)
-- Dependencies: 238
-- Name: train_dataset_img_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.train_dataset_img_id_seq', 16, true);


--
-- TOC entry 3666 (class 0 OID 0)
-- Dependencies: 259
-- Name: train_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.train_permission_id_seq', 1, false);


--
-- TOC entry 3667 (class 0 OID 0)
-- Dependencies: 248
-- Name: train_trainedmodel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.train_trainedmodel_id_seq', 908, true);


--
-- TOC entry 3668 (class 0 OID 0)
-- Dependencies: 240
-- Name: train_training_job_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.train_training_job_id_seq', 95, true);


--
-- TOC entry 3669 (class 0 OID 0)
-- Dependencies: 244
-- Name: uac_group_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.uac_group_config_id_seq', 1, true);


--
-- TOC entry 3327 (class 2606 OID 16543)
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- TOC entry 3332 (class 2606 OID 16473)
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- TOC entry 3335 (class 2606 OID 16439)
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3329 (class 2606 OID 16430)
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- TOC entry 3322 (class 2606 OID 16464)
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- TOC entry 3324 (class 2606 OID 16423)
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- TOC entry 3343 (class 2606 OID 16455)
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- TOC entry 3346 (class 2606 OID 16488)
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- TOC entry 3337 (class 2606 OID 16446)
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- TOC entry 3349 (class 2606 OID 16462)
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3352 (class 2606 OID 16502)
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- TOC entry 3340 (class 2606 OID 16538)
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- TOC entry 3355 (class 2606 OID 16524)
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- TOC entry 3317 (class 2606 OID 16416)
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- TOC entry 3319 (class 2606 OID 16414)
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- TOC entry 3315 (class 2606 OID 16407)
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 3405 (class 2606 OID 18609)
-- Name: django_q_ormq django_q_ormq_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_q_ormq
    ADD CONSTRAINT django_q_ormq_pkey PRIMARY KEY (id);


--
-- TOC entry 3400 (class 2606 OID 18587)
-- Name: django_q_schedule django_q_schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_q_schedule
    ADD CONSTRAINT django_q_schedule_pkey PRIMARY KEY (id);


--
-- TOC entry 3403 (class 2606 OID 18598)
-- Name: django_q_task django_q_task_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_q_task
    ADD CONSTRAINT django_q_task_pkey PRIMARY KEY (id);


--
-- TOC entry 3365 (class 2606 OID 16576)
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- TOC entry 3369 (class 2606 OID 16587)
-- Name: django_site django_site_domain_a2e37b91_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_site
    ADD CONSTRAINT django_site_domain_a2e37b91_uniq UNIQUE (domain);


--
-- TOC entry 3371 (class 2606 OID 16585)
-- Name: django_site django_site_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_site
    ADD CONSTRAINT django_site_pkey PRIMARY KEY (id);


--
-- TOC entry 3358 (class 2606 OID 16551)
-- Name: registration_registrationprofile registration_registrationprofile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registration_registrationprofile
    ADD CONSTRAINT registration_registrationprofile_pkey PRIMARY KEY (id);


--
-- TOC entry 3360 (class 2606 OID 16553)
-- Name: registration_registrationprofile registration_registrationprofile_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registration_registrationprofile
    ADD CONSTRAINT registration_registrationprofile_user_id_key UNIQUE (user_id);


--
-- TOC entry 3362 (class 2606 OID 16564)
-- Name: registration_supervisedregistrationprofile registration_supervisedregistrationprofile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registration_supervisedregistrationprofile
    ADD CONSTRAINT registration_supervisedregistrationprofile_pkey PRIMARY KEY (registrationprofile_ptr_id);


--
-- TOC entry 3397 (class 2606 OID 18560)
-- Name: train_chart train_chart_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.train_chart
    ADD CONSTRAINT train_chart_pkey PRIMARY KEY (id);


--
-- TOC entry 3394 (class 2606 OID 18551)
-- Name: train_charttype train_charttype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.train_charttype
    ADD CONSTRAINT train_charttype_pkey PRIMARY KEY (id);


--
-- TOC entry 3380 (class 2606 OID 16637)
-- Name: train_clusternode train_clusternode_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.train_clusternode
    ADD CONSTRAINT train_clusternode_pkey PRIMARY KEY (id);


--
-- TOC entry 3373 (class 2606 OID 16597)
-- Name: train_dataset_img train_dataset_img_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.train_dataset_img
    ADD CONSTRAINT train_dataset_img_pkey PRIMARY KEY (id);


--
-- TOC entry 3385 (class 2606 OID 18509)
-- Name: train_dataset train_dataset_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.train_dataset
    ADD CONSTRAINT train_dataset_pkey PRIMARY KEY (id);


--
-- TOC entry 3407 (class 2606 OID 52947)
-- Name: train_permission train_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.train_permission
    ADD CONSTRAINT train_permission_pkey PRIMARY KEY (id);


--
-- TOC entry 3391 (class 2606 OID 18518)
-- Name: train_trainedmodel train_trainedmodel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.train_trainedmodel
    ADD CONSTRAINT train_trainedmodel_pkey PRIMARY KEY (id);


--
-- TOC entry 3377 (class 2606 OID 16617)
-- Name: train_training_job train_training_job_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.train_training_job
    ADD CONSTRAINT train_training_job_pkey PRIMARY KEY (id);


--
-- TOC entry 3383 (class 2606 OID 16646)
-- Name: uac_group_config uac_group_config_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uac_group_config
    ADD CONSTRAINT uac_group_config_pkey PRIMARY KEY (id);


--
-- TOC entry 3325 (class 1259 OID 16544)
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- TOC entry 3330 (class 1259 OID 16484)
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- TOC entry 3333 (class 1259 OID 16485)
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- TOC entry 3320 (class 1259 OID 16470)
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- TOC entry 3341 (class 1259 OID 16500)
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- TOC entry 3344 (class 1259 OID 16499)
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- TOC entry 3347 (class 1259 OID 16514)
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- TOC entry 3350 (class 1259 OID 16513)
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- TOC entry 3338 (class 1259 OID 16539)
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- TOC entry 3353 (class 1259 OID 16535)
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- TOC entry 3356 (class 1259 OID 16536)
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- TOC entry 3401 (class 1259 OID 18599)
-- Name: django_q_task_id_32882367_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_q_task_id_32882367_like ON public.django_q_task USING btree (id varchar_pattern_ops);


--
-- TOC entry 3363 (class 1259 OID 16578)
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- TOC entry 3366 (class 1259 OID 16577)
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- TOC entry 3367 (class 1259 OID 16588)
-- Name: django_site_domain_a2e37b91_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_site_domain_a2e37b91_like ON public.django_site USING btree (domain varchar_pattern_ops);


--
-- TOC entry 3395 (class 1259 OID 18571)
-- Name: train_chart_dataset_id_82e1454f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX train_chart_dataset_id_82e1454f ON public.train_chart USING btree (dataset_id);


--
-- TOC entry 3398 (class 1259 OID 18572)
-- Name: train_chart_type_id_823bcdfa; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX train_chart_type_id_823bcdfa ON public.train_chart USING btree (type_id);


--
-- TOC entry 3374 (class 1259 OID 16603)
-- Name: train_dataset_img_user_id_f0f52aad; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX train_dataset_img_user_id_f0f52aad ON public.train_dataset_img USING btree (user_id);


--
-- TOC entry 3386 (class 1259 OID 18529)
-- Name: train_dataset_source_dataset_id_id_190b04e7; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX train_dataset_source_dataset_id_id_190b04e7 ON public.train_dataset USING btree (source_dataset_id_id);


--
-- TOC entry 3387 (class 1259 OID 18530)
-- Name: train_dataset_user_id_793c7b0b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX train_dataset_user_id_793c7b0b ON public.train_dataset USING btree (user_id);


--
-- TOC entry 3388 (class 1259 OID 18541)
-- Name: train_trainedmodel_dataset_id_8d4a44ab; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX train_trainedmodel_dataset_id_8d4a44ab ON public.train_trainedmodel USING btree (dataset_id);


--
-- TOC entry 3389 (class 1259 OID 33172)
-- Name: train_trainedmodel_dataset_img_id_cbb2b55f; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX train_trainedmodel_dataset_img_id_cbb2b55f ON public.train_trainedmodel USING btree (dataset_img_id);


--
-- TOC entry 3392 (class 1259 OID 18542)
-- Name: train_trainedmodel_user_id_b0461349; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX train_trainedmodel_user_id_b0461349 ON public.train_trainedmodel USING btree (user_id);


--
-- TOC entry 3375 (class 1259 OID 16628)
-- Name: train_training_job_dataset_img_id_099728da; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX train_training_job_dataset_img_id_099728da ON public.train_training_job USING btree (dataset_img_id);


--
-- TOC entry 3378 (class 1259 OID 16629)
-- Name: train_training_job_user_id_1526950c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX train_training_job_user_id_1526950c ON public.train_training_job USING btree (user_id);


--
-- TOC entry 3381 (class 1259 OID 16652)
-- Name: uac_group_config_group_id_4eb08854; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX uac_group_config_group_id_4eb08854 ON public.uac_group_config USING btree (group_id);


--
-- TOC entry 3409 (class 2606 OID 16479)
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3410 (class 2606 OID 16474)
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3408 (class 2606 OID 16465)
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3411 (class 2606 OID 16494)
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3412 (class 2606 OID 16489)
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3413 (class 2606 OID 16508)
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3414 (class 2606 OID 16503)
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3415 (class 2606 OID 16525)
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3416 (class 2606 OID 16530)
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3417 (class 2606 OID 16554)
-- Name: registration_registrationprofile registration_registr_user_id_5fcbf725_fk_auth_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registration_registrationprofile
    ADD CONSTRAINT registration_registr_user_id_5fcbf725_fk_auth_user FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3418 (class 2606 OID 16565)
-- Name: registration_supervisedregistrationprofile registration_supervi_registrationprofile__0a59f3b2_fk_registrat; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registration_supervisedregistrationprofile
    ADD CONSTRAINT registration_supervi_registrationprofile__0a59f3b2_fk_registrat FOREIGN KEY (registrationprofile_ptr_id) REFERENCES public.registration_registrationprofile(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3428 (class 2606 OID 18561)
-- Name: train_chart train_chart_dataset_id_82e1454f_fk_train_dataset_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.train_chart
    ADD CONSTRAINT train_chart_dataset_id_82e1454f_fk_train_dataset_id FOREIGN KEY (dataset_id) REFERENCES public.train_dataset(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3429 (class 2606 OID 18566)
-- Name: train_chart train_chart_type_id_823bcdfa_fk_train_charttype_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.train_chart
    ADD CONSTRAINT train_chart_type_id_823bcdfa_fk_train_charttype_id FOREIGN KEY (type_id) REFERENCES public.train_charttype(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3419 (class 2606 OID 16604)
-- Name: train_dataset_img train_dataset_img_user_id_f0f52aad_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.train_dataset_img
    ADD CONSTRAINT train_dataset_img_user_id_f0f52aad_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3423 (class 2606 OID 18519)
-- Name: train_dataset train_dataset_source_dataset_id_id_190b04e7_fk_train_dataset_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.train_dataset
    ADD CONSTRAINT train_dataset_source_dataset_id_id_190b04e7_fk_train_dataset_id FOREIGN KEY (source_dataset_id_id) REFERENCES public.train_dataset(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3424 (class 2606 OID 18524)
-- Name: train_dataset train_dataset_user_id_793c7b0b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.train_dataset
    ADD CONSTRAINT train_dataset_user_id_793c7b0b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3425 (class 2606 OID 33173)
-- Name: train_trainedmodel train_trainedmodel_dataset_id_8d4a44ab_fk_train_dataset_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.train_trainedmodel
    ADD CONSTRAINT train_trainedmodel_dataset_id_8d4a44ab_fk_train_dataset_id FOREIGN KEY (dataset_id) REFERENCES public.train_dataset(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3426 (class 2606 OID 33178)
-- Name: train_trainedmodel train_trainedmodel_dataset_img_id_cbb2b55f_fk_train_dat; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.train_trainedmodel
    ADD CONSTRAINT train_trainedmodel_dataset_img_id_cbb2b55f_fk_train_dat FOREIGN KEY (dataset_img_id) REFERENCES public.train_dataset_img(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3427 (class 2606 OID 18536)
-- Name: train_trainedmodel train_trainedmodel_user_id_b0461349_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.train_trainedmodel
    ADD CONSTRAINT train_trainedmodel_user_id_b0461349_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3420 (class 2606 OID 18574)
-- Name: train_training_job train_training_job_dataset_img_id_099728da_fk_train_dat; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.train_training_job
    ADD CONSTRAINT train_training_job_dataset_img_id_099728da_fk_train_dat FOREIGN KEY (dataset_img_id) REFERENCES public.train_dataset_img(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3421 (class 2606 OID 16623)
-- Name: train_training_job train_training_job_user_id_1526950c_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.train_training_job
    ADD CONSTRAINT train_training_job_user_id_1526950c_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3422 (class 2606 OID 16647)
-- Name: uac_group_config uac_group_config_group_id_4eb08854_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uac_group_config
    ADD CONSTRAINT uac_group_config_group_id_4eb08854_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3625 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO odoo_user;


-- Completed on 2024-09-22 16:43:36

--
-- PostgreSQL database dump complete
--

