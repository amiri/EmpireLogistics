--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: sqitch; Type: SCHEMA; Schema: -; Owner: el
--

CREATE SCHEMA sqitch;


ALTER SCHEMA sqitch OWNER TO el;

--
-- Name: SCHEMA sqitch; Type: COMMENT; Schema: -; Owner: el
--

COMMENT ON SCHEMA sqitch IS 'Sqitch database deployment metadata v1.0.';


--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO postgres;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


SET search_path = public, pg_catalog;

--
-- Name: account_type; Type: TYPE; Schema: public; Owner: el
--

CREATE TYPE account_type AS ENUM (
    'itemized',
    'non-itemized',
    'other'
);


ALTER TYPE public.account_type OWNER TO el;

--
-- Name: asset_type; Type: TYPE; Schema: public; Owner: el
--

CREATE TYPE asset_type AS ENUM (
    'land',
    'building',
    'automobile',
    'furniture',
    'other'
);


ALTER TYPE public.asset_type OWNER TO el;

--
-- Name: company_type; Type: TYPE; Schema: public; Owner: el
--

CREATE TYPE company_type AS ENUM (
    '3PL',
    'commercial',
    'financial',
    'industrial'
);


ALTER TYPE public.company_type OWNER TO el;

--
-- Name: disbursement_type; Type: TYPE; Schema: public; Owner: el
--

CREATE TYPE disbursement_type AS ENUM (
    'representation',
    'political',
    'contributions',
    'overhead',
    'administration',
    'general',
    'non-itemized',
    'other'
);


ALTER TYPE public.disbursement_type OWNER TO el;

--
-- Name: investment_type; Type: TYPE; Schema: public; Owner: el
--

CREATE TYPE investment_type AS ENUM (
    'marketable securities',
    'other securities',
    'marketable securities cost',
    'marketable securities book value',
    'other securities cost',
    'other securities book value',
    'other'
);


ALTER TYPE public.investment_type OWNER TO el;

--
-- Name: labor_organization_type; Type: TYPE; Schema: public; Owner: el
--

CREATE TYPE labor_organization_type AS ENUM (
    'federation',
    'union',
    'hybrid',
    'reform',
    'local',
    'unaffiliated',
    'other'
);


ALTER TYPE public.labor_organization_type OWNER TO el;

--
-- Name: loan_type; Type: TYPE; Schema: public; Owner: el
--

CREATE TYPE loan_type AS ENUM (
    'itemized',
    'non-itemized',
    'other'
);


ALTER TYPE public.loan_type OWNER TO el;

--
-- Name: object_type; Type: TYPE; Schema: public; Owner: el
--

CREATE TYPE object_type AS ENUM (
    'address',
    'company',
    'company_address',
    'company_nlrb_decision',
    'company_osha_citation',
    'company_port',
    'company_rail_node',
    'company_warehouse',
    'edit_history',
    'edit_history_field',
    'labor_organization',
    'labor_organization_account_payable',
    'labor_organization_account_receivable',
    'labor_organization_address',
    'labor_organization_affiliation',
    'labor_organization_benefit_disbursement',
    'labor_organization_fixed_asset',
    'labor_organization_general_disbursement',
    'labor_organization_investment_asset',
    'labor_organization_investment_purchase',
    'labor_organization_loan_payable',
    'labor_organization_loan_receivable',
    'labor_organization_membership',
    'labor_organization_nlrb_decision',
    'labor_organization_officer_disbursement',
    'labor_organization_osha_citation',
    'labor_organization_other_asset',
    'labor_organization_other_liability',
    'labor_organization_other_receipt',
    'labor_organization_payee',
    'labor_organization_payee_address',
    'labor_organization_port',
    'labor_organization_rail_node',
    'labor_organization_sale_receipt',
    'labor_organization_total_asset',
    'labor_organization_total_disbursement',
    'labor_organization_total_liability',
    'labor_organization_total_receipt',
    'labor_organization_warehouse',
    'labor_organization_work_stoppage',
    'media',
    'nlrb_decision',
    'osha_citation',
    'port',
    'port_address',
    'port_depth_feet',
    'port_depth_meters',
    'port_drydock',
    'port_harbor_size',
    'port_harbor_type',
    'port_repair',
    'port_shelter',
    'port_tonnage',
    'port_vessel_size',
    'port_work_stoppage',
    'rail_density',
    'rail_interline',
    'rail_line',
    'rail_line_class',
    'rail_line_work_stoppage',
    'rail_military',
    'rail_node',
    'rail_node_work_stoppage',
    'rail_ownership',
    'rail_passenger',
    'rail_signal',
    'rail_status',
    'rail_subdivision',
    'rail_subdivision_state',
    'rail_track_gauge',
    'rail_track_grade',
    'rail_track_type',
    'role',
    'state',
    'topology',
    'user',
    'user_role',
    'walmart',
    'warehouse',
    'warehouse_address',
    'warehouse_type',
    'warehouse_walmart',
    'warehouse_work_stoppage',
    'work_stoppage'
);


ALTER TYPE public.object_type OWNER TO el;

--
-- Name: payee_type; Type: TYPE; Schema: public; Owner: el
--

CREATE TYPE payee_type AS ENUM (
    'payee',
    'payer'
);


ALTER TYPE public.payee_type OWNER TO el;

--
-- Name: warehouse_status; Type: TYPE; Schema: public; Owner: el
--

CREATE TYPE warehouse_status AS ENUM (
    'open',
    'closed'
);


ALTER TYPE public.warehouse_status OWNER TO el;

--
-- Name: update_timestamp(); Type: FUNCTION; Schema: public; Owner: el
--

CREATE FUNCTION update_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF (NEW != OLD) THEN
        NEW.update_time = CURRENT_TIMESTAMP;
        RETURN NEW;
    END IF;
    RETURN OLD;
END;
$$;


ALTER FUNCTION public.update_timestamp() OWNER TO el;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: address; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE address (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    street_address text,
    city text,
    state text,
    postal_code text,
    country text
);


ALTER TABLE public.address OWNER TO el;

--
-- Name: address_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.address_id_seq OWNER TO el;

--
-- Name: address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE address_id_seq OWNED BY address.id;


--
-- Name: company; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE company (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    name text,
    company_type company_type,
    description text
);


ALTER TABLE public.company OWNER TO el;

--
-- Name: company_address; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE company_address (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    company integer NOT NULL,
    address integer NOT NULL
);


ALTER TABLE public.company_address OWNER TO el;

--
-- Name: company_address_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE company_address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.company_address_id_seq OWNER TO el;

--
-- Name: company_address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE company_address_id_seq OWNED BY company_address.id;


--
-- Name: company_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE company_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.company_id_seq OWNER TO el;

--
-- Name: company_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE company_id_seq OWNED BY company.id;


--
-- Name: company_nlrb_decision; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE company_nlrb_decision (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    company integer NOT NULL,
    nlrb_decision integer NOT NULL
);


ALTER TABLE public.company_nlrb_decision OWNER TO el;

--
-- Name: company_nlrb_decision_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE company_nlrb_decision_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.company_nlrb_decision_id_seq OWNER TO el;

--
-- Name: company_nlrb_decision_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE company_nlrb_decision_id_seq OWNED BY company_nlrb_decision.id;


--
-- Name: company_osha_citation; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE company_osha_citation (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    company integer NOT NULL,
    osha_citation integer NOT NULL
);


ALTER TABLE public.company_osha_citation OWNER TO el;

--
-- Name: company_osha_citation_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE company_osha_citation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.company_osha_citation_id_seq OWNER TO el;

--
-- Name: company_osha_citation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE company_osha_citation_id_seq OWNED BY company_osha_citation.id;


--
-- Name: company_port; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE company_port (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    company integer NOT NULL,
    port integer NOT NULL
);


ALTER TABLE public.company_port OWNER TO el;

--
-- Name: company_port_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE company_port_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.company_port_id_seq OWNER TO el;

--
-- Name: company_port_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE company_port_id_seq OWNED BY company_port.id;


--
-- Name: company_rail_node; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE company_rail_node (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    company integer NOT NULL,
    rail_node integer NOT NULL
);


ALTER TABLE public.company_rail_node OWNER TO el;

--
-- Name: company_rail_node_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE company_rail_node_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.company_rail_node_id_seq OWNER TO el;

--
-- Name: company_rail_node_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE company_rail_node_id_seq OWNED BY company_rail_node.id;


--
-- Name: company_warehouse; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE company_warehouse (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    company integer NOT NULL,
    warehouse integer NOT NULL
);


ALTER TABLE public.company_warehouse OWNER TO el;

--
-- Name: company_warehouse_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE company_warehouse_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.company_warehouse_id_seq OWNER TO el;

--
-- Name: company_warehouse_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE company_warehouse_id_seq OWNED BY company_warehouse.id;


--
-- Name: edit_history; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE edit_history (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    object_type object_type NOT NULL,
    object integer NOT NULL,
    "user" integer NOT NULL,
    notes text
);


ALTER TABLE public.edit_history OWNER TO el;

--
-- Name: edit_history_field; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE edit_history_field (
    edit_history integer NOT NULL,
    field text NOT NULL,
    original_value text,
    new_value text
);


ALTER TABLE public.edit_history_field OWNER TO el;

--
-- Name: edit_history_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE edit_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.edit_history_id_seq OWNER TO el;

--
-- Name: edit_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE edit_history_id_seq OWNED BY edit_history.id;


--
-- Name: labor_organization; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE labor_organization (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    name text,
    usdol_filing_number integer,
    abbreviation text,
    date_established date,
    url text,
    organization_type labor_organization_type DEFAULT 'union'::labor_organization_type NOT NULL,
    local_prefix text,
    local_suffix text,
    local_type text,
    local_number text,
    description text
);


ALTER TABLE public.labor_organization OWNER TO el;

--
-- Name: labor_organization_account_payable; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE labor_organization_account_payable (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    labor_organization integer NOT NULL,
    year integer NOT NULL,
    account_type account_type,
    liquidated integer,
    name text,
    past_due_90 integer,
    past_due_180 integer,
    total integer
);


ALTER TABLE public.labor_organization_account_payable OWNER TO el;

--
-- Name: labor_organization_account_payable_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE labor_organization_account_payable_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.labor_organization_account_payable_id_seq OWNER TO el;

--
-- Name: labor_organization_account_payable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE labor_organization_account_payable_id_seq OWNED BY labor_organization_account_payable.id;


--
-- Name: labor_organization_account_receivable; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE labor_organization_account_receivable (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    labor_organization integer NOT NULL,
    year integer NOT NULL,
    account_type account_type,
    liquidated integer,
    name text,
    past_due_90 integer,
    past_due_180 integer,
    total integer
);


ALTER TABLE public.labor_organization_account_receivable OWNER TO el;

--
-- Name: labor_organization_account_receivable_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE labor_organization_account_receivable_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.labor_organization_account_receivable_id_seq OWNER TO el;

--
-- Name: labor_organization_account_receivable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE labor_organization_account_receivable_id_seq OWNED BY labor_organization_account_receivable.id;


--
-- Name: labor_organization_address; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE labor_organization_address (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    labor_organization integer NOT NULL,
    address integer NOT NULL,
    year integer NOT NULL
);


ALTER TABLE public.labor_organization_address OWNER TO el;

--
-- Name: labor_organization_address_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE labor_organization_address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.labor_organization_address_id_seq OWNER TO el;

--
-- Name: labor_organization_address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE labor_organization_address_id_seq OWNED BY labor_organization_address.id;


--
-- Name: labor_organization_affiliation; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE labor_organization_affiliation (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    child integer NOT NULL,
    parent integer NOT NULL,
    year integer,
    CONSTRAINT labor_organization_affiliation_check CHECK ((child <> parent))
);


ALTER TABLE public.labor_organization_affiliation OWNER TO el;

--
-- Name: labor_organization_affiliation_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE labor_organization_affiliation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.labor_organization_affiliation_id_seq OWNER TO el;

--
-- Name: labor_organization_affiliation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE labor_organization_affiliation_id_seq OWNED BY labor_organization_affiliation.id;


--
-- Name: labor_organization_benefit_disbursement; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE labor_organization_benefit_disbursement (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    labor_organization integer NOT NULL,
    year integer NOT NULL,
    amount integer,
    description text,
    paid_to text
);


ALTER TABLE public.labor_organization_benefit_disbursement OWNER TO el;

--
-- Name: labor_organization_benefit_disbursement_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE labor_organization_benefit_disbursement_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.labor_organization_benefit_disbursement_id_seq OWNER TO el;

--
-- Name: labor_organization_benefit_disbursement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE labor_organization_benefit_disbursement_id_seq OWNED BY labor_organization_benefit_disbursement.id;


--
-- Name: labor_organization_fixed_asset; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE labor_organization_fixed_asset (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    labor_organization integer NOT NULL,
    year integer NOT NULL,
    asset_type asset_type,
    book_value integer,
    cost_basis integer,
    depreciation integer,
    description text,
    value integer
);


ALTER TABLE public.labor_organization_fixed_asset OWNER TO el;

--
-- Name: labor_organization_fixed_asset_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE labor_organization_fixed_asset_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.labor_organization_fixed_asset_id_seq OWNER TO el;

--
-- Name: labor_organization_fixed_asset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE labor_organization_fixed_asset_id_seq OWNED BY labor_organization_fixed_asset.id;


--
-- Name: labor_organization_general_disbursement; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE labor_organization_general_disbursement (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    labor_organization integer NOT NULL,
    year integer NOT NULL,
    amount integer,
    disbursement_date date,
    disbursement_type disbursement_type,
    payee integer NOT NULL,
    purpose text
);


ALTER TABLE public.labor_organization_general_disbursement OWNER TO el;

--
-- Name: labor_organization_general_disbursement_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE labor_organization_general_disbursement_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.labor_organization_general_disbursement_id_seq OWNER TO el;

--
-- Name: labor_organization_general_disbursement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE labor_organization_general_disbursement_id_seq OWNED BY labor_organization_general_disbursement.id;


--
-- Name: labor_organization_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE labor_organization_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.labor_organization_id_seq OWNER TO el;

--
-- Name: labor_organization_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE labor_organization_id_seq OWNED BY labor_organization.id;


--
-- Name: labor_organization_investment_asset; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE labor_organization_investment_asset (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    labor_organization integer NOT NULL,
    year integer NOT NULL,
    amount integer,
    investment_type investment_type,
    name text
);


ALTER TABLE public.labor_organization_investment_asset OWNER TO el;

--
-- Name: labor_organization_investment_asset_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE labor_organization_investment_asset_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.labor_organization_investment_asset_id_seq OWNER TO el;

--
-- Name: labor_organization_investment_asset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE labor_organization_investment_asset_id_seq OWNED BY labor_organization_investment_asset.id;


--
-- Name: labor_organization_investment_purchase; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE labor_organization_investment_purchase (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    labor_organization integer NOT NULL,
    year integer NOT NULL,
    book_value integer,
    cash_paid integer,
    cost integer,
    description text,
    investment_type investment_type
);


ALTER TABLE public.labor_organization_investment_purchase OWNER TO el;

--
-- Name: labor_organization_investment_purchase_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE labor_organization_investment_purchase_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.labor_organization_investment_purchase_id_seq OWNER TO el;

--
-- Name: labor_organization_investment_purchase_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE labor_organization_investment_purchase_id_seq OWNED BY labor_organization_investment_purchase.id;


--
-- Name: labor_organization_loan_payable; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE labor_organization_loan_payable (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    labor_organization integer NOT NULL,
    year integer NOT NULL,
    cash_repayment integer,
    loans_obtained integer,
    loans_owed_end integer,
    loans_owed_start integer,
    non_cash_repayment integer,
    source text
);


ALTER TABLE public.labor_organization_loan_payable OWNER TO el;

--
-- Name: labor_organization_loan_payable_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE labor_organization_loan_payable_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.labor_organization_loan_payable_id_seq OWNER TO el;

--
-- Name: labor_organization_loan_payable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE labor_organization_loan_payable_id_seq OWNED BY labor_organization_loan_payable.id;


--
-- Name: labor_organization_loan_receivable; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE labor_organization_loan_receivable (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    labor_organization integer NOT NULL,
    year integer NOT NULL,
    cash_repayments integer,
    loan_type loan_type,
    name text,
    new_loan_amount integer,
    non_cash_repayments integer,
    outstanding_end_amount integer,
    outstanding_start_amount integer,
    purpose text,
    security text,
    terms text
);


ALTER TABLE public.labor_organization_loan_receivable OWNER TO el;

--
-- Name: labor_organization_loan_receivable_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE labor_organization_loan_receivable_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.labor_organization_loan_receivable_id_seq OWNER TO el;

--
-- Name: labor_organization_loan_receivable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE labor_organization_loan_receivable_id_seq OWNED BY labor_organization_loan_receivable.id;


--
-- Name: labor_organization_membership; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE labor_organization_membership (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    labor_organization integer NOT NULL,
    year integer NOT NULL,
    members integer NOT NULL
);


ALTER TABLE public.labor_organization_membership OWNER TO el;

--
-- Name: labor_organization_membership_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE labor_organization_membership_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.labor_organization_membership_id_seq OWNER TO el;

--
-- Name: labor_organization_membership_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE labor_organization_membership_id_seq OWNED BY labor_organization_membership.id;


--
-- Name: labor_organization_nlrb_decision; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE labor_organization_nlrb_decision (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    labor_organization integer NOT NULL,
    nlrb_decision integer NOT NULL
);


ALTER TABLE public.labor_organization_nlrb_decision OWNER TO el;

--
-- Name: labor_organization_nlrb_decision_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE labor_organization_nlrb_decision_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.labor_organization_nlrb_decision_id_seq OWNER TO el;

--
-- Name: labor_organization_nlrb_decision_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE labor_organization_nlrb_decision_id_seq OWNED BY labor_organization_nlrb_decision.id;


--
-- Name: labor_organization_officer_disbursement; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE labor_organization_officer_disbursement (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    labor_organization integer NOT NULL,
    year integer NOT NULL,
    first_name text,
    middle_name text,
    last_name text,
    title text,
    administration_percent integer,
    contributions_percent integer,
    general_overhead_percent integer,
    gross_salary integer,
    political_percent integer,
    representation_percent integer,
    total integer
);


ALTER TABLE public.labor_organization_officer_disbursement OWNER TO el;

--
-- Name: labor_organization_officer_disbursement_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE labor_organization_officer_disbursement_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.labor_organization_officer_disbursement_id_seq OWNER TO el;

--
-- Name: labor_organization_officer_disbursement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE labor_organization_officer_disbursement_id_seq OWNED BY labor_organization_officer_disbursement.id;


--
-- Name: labor_organization_osha_citation; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE labor_organization_osha_citation (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    labor_organization integer NOT NULL,
    osha_citation integer NOT NULL
);


ALTER TABLE public.labor_organization_osha_citation OWNER TO el;

--
-- Name: labor_organization_osha_citation_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE labor_organization_osha_citation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.labor_organization_osha_citation_id_seq OWNER TO el;

--
-- Name: labor_organization_osha_citation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE labor_organization_osha_citation_id_seq OWNED BY labor_organization_osha_citation.id;


--
-- Name: labor_organization_other_asset; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE labor_organization_other_asset (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    labor_organization integer NOT NULL,
    year integer NOT NULL,
    book_value integer,
    description text,
    value integer
);


ALTER TABLE public.labor_organization_other_asset OWNER TO el;

--
-- Name: labor_organization_other_asset_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE labor_organization_other_asset_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.labor_organization_other_asset_id_seq OWNER TO el;

--
-- Name: labor_organization_other_asset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE labor_organization_other_asset_id_seq OWNED BY labor_organization_other_asset.id;


--
-- Name: labor_organization_other_liability; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE labor_organization_other_liability (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    labor_organization integer NOT NULL,
    year integer NOT NULL,
    amount integer,
    description text
);


ALTER TABLE public.labor_organization_other_liability OWNER TO el;

--
-- Name: labor_organization_other_liability_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE labor_organization_other_liability_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.labor_organization_other_liability_id_seq OWNER TO el;

--
-- Name: labor_organization_other_liability_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE labor_organization_other_liability_id_seq OWNED BY labor_organization_other_liability.id;


--
-- Name: labor_organization_other_receipt; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE labor_organization_other_receipt (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    labor_organization integer NOT NULL,
    year integer NOT NULL,
    amount integer,
    receipt_date date,
    payee integer NOT NULL,
    purpose text
);


ALTER TABLE public.labor_organization_other_receipt OWNER TO el;

--
-- Name: labor_organization_other_receipt_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE labor_organization_other_receipt_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.labor_organization_other_receipt_id_seq OWNER TO el;

--
-- Name: labor_organization_other_receipt_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE labor_organization_other_receipt_id_seq OWNED BY labor_organization_other_receipt.id;


--
-- Name: labor_organization_payee; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE labor_organization_payee (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    labor_organization integer NOT NULL,
    year integer NOT NULL,
    name text NOT NULL,
    payee_type payee_type,
    payment_type text,
    amount integer,
    usdol_payee_id integer
);


ALTER TABLE public.labor_organization_payee OWNER TO el;

--
-- Name: labor_organization_payee_address; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE labor_organization_payee_address (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    labor_organization_payee integer NOT NULL,
    address integer NOT NULL,
    year integer NOT NULL
);


ALTER TABLE public.labor_organization_payee_address OWNER TO el;

--
-- Name: labor_organization_payee_address_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE labor_organization_payee_address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.labor_organization_payee_address_id_seq OWNER TO el;

--
-- Name: labor_organization_payee_address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE labor_organization_payee_address_id_seq OWNED BY labor_organization_payee_address.id;


--
-- Name: labor_organization_payee_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE labor_organization_payee_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.labor_organization_payee_id_seq OWNER TO el;

--
-- Name: labor_organization_payee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE labor_organization_payee_id_seq OWNED BY labor_organization_payee.id;


--
-- Name: labor_organization_port; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE labor_organization_port (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    labor_organization integer NOT NULL,
    port integer NOT NULL
);


ALTER TABLE public.labor_organization_port OWNER TO el;

--
-- Name: labor_organization_port_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE labor_organization_port_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.labor_organization_port_id_seq OWNER TO el;

--
-- Name: labor_organization_port_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE labor_organization_port_id_seq OWNED BY labor_organization_port.id;


--
-- Name: labor_organization_rail_node; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE labor_organization_rail_node (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    labor_organization integer NOT NULL,
    rail_node integer NOT NULL
);


ALTER TABLE public.labor_organization_rail_node OWNER TO el;

--
-- Name: labor_organization_rail_node_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE labor_organization_rail_node_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.labor_organization_rail_node_id_seq OWNER TO el;

--
-- Name: labor_organization_rail_node_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE labor_organization_rail_node_id_seq OWNED BY labor_organization_rail_node.id;


--
-- Name: labor_organization_sale_receipt; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE labor_organization_sale_receipt (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    labor_organization integer NOT NULL,
    year integer NOT NULL,
    amount_received integer,
    book_value integer,
    cost integer,
    description text,
    gross_sales_price integer
);


ALTER TABLE public.labor_organization_sale_receipt OWNER TO el;

--
-- Name: labor_organization_sale_receipt_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE labor_organization_sale_receipt_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.labor_organization_sale_receipt_id_seq OWNER TO el;

--
-- Name: labor_organization_sale_receipt_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE labor_organization_sale_receipt_id_seq OWNED BY labor_organization_sale_receipt.id;


--
-- Name: labor_organization_total_asset; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE labor_organization_total_asset (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    labor_organization integer NOT NULL,
    year integer NOT NULL,
    accounts_receivable_end integer,
    accounts_receivable_start integer,
    cash_end integer,
    cash_start integer,
    fixed_assets_end integer,
    fixed_assets_start integer,
    investments_end integer,
    investments_start integer,
    loans_receivable_end integer,
    loans_receivable_start integer,
    other_assets_end integer,
    other_assets_start integer,
    other_investments_book_value integer,
    other_investments_cost integer,
    securities_book_value integer,
    securities_cost integer,
    total_start integer,
    treasuries_end integer,
    treasuries_start integer
);


ALTER TABLE public.labor_organization_total_asset OWNER TO el;

--
-- Name: labor_organization_total_asset_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE labor_organization_total_asset_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.labor_organization_total_asset_id_seq OWNER TO el;

--
-- Name: labor_organization_total_asset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE labor_organization_total_asset_id_seq OWNED BY labor_organization_total_asset.id;


--
-- Name: labor_organization_total_disbursement; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE labor_organization_total_disbursement (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    labor_organization integer NOT NULL,
    year integer NOT NULL,
    administration integer,
    affiliates integer,
    benefits integer,
    contributions integer,
    education integer,
    employee_salaries integer,
    employees_total integer,
    fees integer,
    general_overhead integer,
    investments integer,
    loans_made integer,
    loans_paid integer,
    members integer,
    officer_administration integer,
    officer_salaries integer,
    officers_total integer,
    office_supplies integer,
    other integer,
    other_contributions integer,
    other_general_overhead integer,
    other_political integer,
    other_representation integer,
    other_union_administration integer,
    per_capita_tax integer,
    political integer,
    professional_services integer,
    representation integer,
    strike_benefits integer,
    taxes integer,
    union_administration integer,
    withheld integer,
    withheld_not_disbursed integer
);


ALTER TABLE public.labor_organization_total_disbursement OWNER TO el;

--
-- Name: labor_organization_total_disbursement_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE labor_organization_total_disbursement_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.labor_organization_total_disbursement_id_seq OWNER TO el;

--
-- Name: labor_organization_total_disbursement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE labor_organization_total_disbursement_id_seq OWNED BY labor_organization_total_disbursement.id;


--
-- Name: labor_organization_total_liability; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE labor_organization_total_liability (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    labor_organization integer NOT NULL,
    year integer NOT NULL,
    accounts_payable_end integer,
    accounts_payable_start integer,
    loans_payable_end integer,
    loans_payable_start integer,
    mortgages_payable_end integer,
    mortgages_payable_start integer,
    other_liabilities_end integer,
    other_liabilities_start integer,
    total_start integer
);


ALTER TABLE public.labor_organization_total_liability OWNER TO el;

--
-- Name: labor_organization_total_liability_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE labor_organization_total_liability_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.labor_organization_total_liability_id_seq OWNER TO el;

--
-- Name: labor_organization_total_liability_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE labor_organization_total_liability_id_seq OWNED BY labor_organization_total_liability.id;


--
-- Name: labor_organization_total_receipt; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE labor_organization_total_receipt (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    labor_organization integer NOT NULL,
    year integer NOT NULL,
    affiliates integer,
    all_other_receipts integer,
    dividends integer,
    dues integer,
    fees integer,
    interest integer,
    investments integer,
    loans_made integer,
    loans_taken integer,
    members integer,
    office_supplies integer,
    other_receipts integer,
    rents integer,
    tax integer
);


ALTER TABLE public.labor_organization_total_receipt OWNER TO el;

--
-- Name: labor_organization_total_receipt_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE labor_organization_total_receipt_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.labor_organization_total_receipt_id_seq OWNER TO el;

--
-- Name: labor_organization_total_receipt_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE labor_organization_total_receipt_id_seq OWNED BY labor_organization_total_receipt.id;


--
-- Name: labor_organization_warehouse; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE labor_organization_warehouse (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    labor_organization integer NOT NULL,
    warehouse integer NOT NULL
);


ALTER TABLE public.labor_organization_warehouse OWNER TO el;

--
-- Name: labor_organization_warehouse_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE labor_organization_warehouse_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.labor_organization_warehouse_id_seq OWNER TO el;

--
-- Name: labor_organization_warehouse_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE labor_organization_warehouse_id_seq OWNED BY labor_organization_warehouse.id;


--
-- Name: labor_organization_work_stoppage; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE labor_organization_work_stoppage (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    labor_organization integer NOT NULL,
    work_stoppage integer NOT NULL
);


ALTER TABLE public.labor_organization_work_stoppage OWNER TO el;

--
-- Name: labor_organization_work_stoppage_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE labor_organization_work_stoppage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.labor_organization_work_stoppage_id_seq OWNER TO el;

--
-- Name: labor_organization_work_stoppage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE labor_organization_work_stoppage_id_seq OWNED BY labor_organization_work_stoppage.id;


--
-- Name: media; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE media (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    url text NOT NULL,
    mime_type text NOT NULL,
    width integer NOT NULL,
    height integer NOT NULL,
    caption text,
    alt text,
    description text
);


ALTER TABLE public.media OWNER TO el;

--
-- Name: media_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE media_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.media_id_seq OWNER TO el;

--
-- Name: media_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE media_id_seq OWNED BY media.id;


--
-- Name: nlrb_decision; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE nlrb_decision (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    citation_number text NOT NULL,
    case_number text NOT NULL,
    issuance_date date NOT NULL,
    url text NOT NULL
);


ALTER TABLE public.nlrb_decision OWNER TO el;

--
-- Name: nlrb_decision_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE nlrb_decision_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nlrb_decision_id_seq OWNER TO el;

--
-- Name: nlrb_decision_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE nlrb_decision_id_seq OWNED BY nlrb_decision.id;


--
-- Name: osha_citation; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE osha_citation (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    inspection_number text NOT NULL,
    issuance_date date NOT NULL,
    url text NOT NULL
);


ALTER TABLE public.osha_citation OWNER TO el;

--
-- Name: osha_citation_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE osha_citation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.osha_citation_id_seq OWNER TO el;

--
-- Name: osha_citation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE osha_citation_id_seq OWNED BY osha_citation.id;


--
-- Name: port; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE port (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    port_name text,
    country text,
    harbor_size text,
    harbor_type text,
    shelter text,
    entry_tide_restriction boolean,
    entry_swell_restriction boolean,
    entry_ice_restriction boolean,
    entry_other_restriction boolean,
    overhead_limits boolean,
    channel_depth text,
    anchor_depth text,
    cargo_pier_depth text,
    oil_terminal_depth text,
    tide_range integer,
    max_vessel_size text,
    good_holding_ground boolean,
    turning_basin boolean,
    first_port_of_entry boolean,
    us_representative boolean,
    eta_message boolean,
    pilotage_required boolean,
    pilotage_available boolean,
    pilotage_local_assistance boolean,
    pilotage_advisable boolean,
    tugs_can_salvage boolean,
    tugs_can_assist boolean,
    quarantine_pratique_required boolean,
    quarantine_sscc_certification_required boolean,
    quarantine_other_required boolean,
    comm_phone boolean,
    comm_fax boolean,
    comm_radio boolean,
    comm_vhf boolean,
    comm_air boolean,
    comm_rail boolean,
    load_offload_wharf boolean,
    load_offload_anchor boolean,
    load_offload_medium_moor boolean,
    load_offload_beach_moor boolean,
    load_offload_ice_moor boolean,
    medical_facilities boolean,
    garbage_disposal boolean,
    degaussing_available boolean,
    dirty_ballast boolean,
    fixed_cranes boolean,
    mobile_cranes boolean,
    floating_cranes boolean,
    cranes_lift_100_tons boolean,
    cranes_lift_50_100_tons boolean,
    cranes_lift_25_49_tons boolean,
    cranes_lift_0_24_tons boolean,
    longshore_services boolean,
    electrical_services boolean,
    steam_services boolean,
    navigation_equipment_services boolean,
    electrical_repair_services boolean,
    supplies_provisions boolean,
    supplies_water boolean,
    supplies_fuel_oil boolean,
    supplies_diesel_oil boolean,
    supplies_deck boolean,
    supplies_engine boolean,
    repairs text,
    drydock text,
    railway text,
    latitude double precision,
    longitude double precision,
    geometry geometry(Point,900913)
);


ALTER TABLE public.port OWNER TO el;

--
-- Name: port_address; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE port_address (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    port integer NOT NULL,
    address integer NOT NULL
);


ALTER TABLE public.port_address OWNER TO el;

--
-- Name: port_address_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE port_address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.port_address_id_seq OWNER TO el;

--
-- Name: port_address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE port_address_id_seq OWNED BY port_address.id;


--
-- Name: port_depth_feet; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE port_depth_feet (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    name text NOT NULL,
    detail text NOT NULL
);


ALTER TABLE public.port_depth_feet OWNER TO el;

--
-- Name: port_depth_feet_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE port_depth_feet_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.port_depth_feet_id_seq OWNER TO el;

--
-- Name: port_depth_feet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE port_depth_feet_id_seq OWNED BY port_depth_feet.id;


--
-- Name: port_depth_meters; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE port_depth_meters (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    name text NOT NULL,
    detail text NOT NULL
);


ALTER TABLE public.port_depth_meters OWNER TO el;

--
-- Name: port_depth_meters_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE port_depth_meters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.port_depth_meters_id_seq OWNER TO el;

--
-- Name: port_depth_meters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE port_depth_meters_id_seq OWNED BY port_depth_meters.id;


--
-- Name: port_drydock; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE port_drydock (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    name text NOT NULL,
    detail text NOT NULL
);


ALTER TABLE public.port_drydock OWNER TO el;

--
-- Name: port_drydock_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE port_drydock_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.port_drydock_id_seq OWNER TO el;

--
-- Name: port_drydock_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE port_drydock_id_seq OWNED BY port_drydock.id;


--
-- Name: port_harbor_size; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE port_harbor_size (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    name text NOT NULL,
    detail text NOT NULL
);


ALTER TABLE public.port_harbor_size OWNER TO el;

--
-- Name: port_harbor_size_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE port_harbor_size_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.port_harbor_size_id_seq OWNER TO el;

--
-- Name: port_harbor_size_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE port_harbor_size_id_seq OWNED BY port_harbor_size.id;


--
-- Name: port_harbor_type; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE port_harbor_type (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    name text NOT NULL,
    detail text NOT NULL
);


ALTER TABLE public.port_harbor_type OWNER TO el;

--
-- Name: port_harbor_type_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE port_harbor_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.port_harbor_type_id_seq OWNER TO el;

--
-- Name: port_harbor_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE port_harbor_type_id_seq OWNED BY port_harbor_type.id;


--
-- Name: port_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE port_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.port_id_seq OWNER TO el;

--
-- Name: port_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE port_id_seq OWNED BY port.id;


--
-- Name: port_repair; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE port_repair (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    name text NOT NULL,
    detail text NOT NULL
);


ALTER TABLE public.port_repair OWNER TO el;

--
-- Name: port_repair_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE port_repair_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.port_repair_id_seq OWNER TO el;

--
-- Name: port_repair_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE port_repair_id_seq OWNED BY port_repair.id;


--
-- Name: port_shelter; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE port_shelter (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    name text NOT NULL,
    detail text NOT NULL
);


ALTER TABLE public.port_shelter OWNER TO el;

--
-- Name: port_shelter_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE port_shelter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.port_shelter_id_seq OWNER TO el;

--
-- Name: port_shelter_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE port_shelter_id_seq OWNED BY port_shelter.id;


--
-- Name: port_tonnage; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE port_tonnage (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    port integer NOT NULL,
    year integer NOT NULL,
    domestic_tonnage integer,
    foreign_tonnage integer,
    import_tonnage integer,
    export_tonnage integer,
    total_tonnage integer
);


ALTER TABLE public.port_tonnage OWNER TO el;

--
-- Name: port_tonnage_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE port_tonnage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.port_tonnage_id_seq OWNER TO el;

--
-- Name: port_tonnage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE port_tonnage_id_seq OWNED BY port_tonnage.id;


--
-- Name: port_vessel_size; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE port_vessel_size (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    name text NOT NULL,
    detail text NOT NULL
);


ALTER TABLE public.port_vessel_size OWNER TO el;

--
-- Name: port_vessel_size_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE port_vessel_size_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.port_vessel_size_id_seq OWNER TO el;

--
-- Name: port_vessel_size_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE port_vessel_size_id_seq OWNED BY port_vessel_size.id;


--
-- Name: port_work_stoppage; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE port_work_stoppage (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    port integer NOT NULL,
    work_stoppage integer NOT NULL
);


ALTER TABLE public.port_work_stoppage OWNER TO el;

--
-- Name: port_work_stoppage_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE port_work_stoppage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.port_work_stoppage_id_seq OWNER TO el;

--
-- Name: port_work_stoppage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE port_work_stoppage_id_seq OWNED BY port_work_stoppage.id;


--
-- Name: rail_density; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE rail_density (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    name integer NOT NULL,
    detail text NOT NULL
);


ALTER TABLE public.rail_density OWNER TO el;

--
-- Name: rail_density_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE rail_density_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rail_density_id_seq OWNER TO el;

--
-- Name: rail_density_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE rail_density_id_seq OWNED BY rail_density.id;


--
-- Name: rail_interline; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE rail_interline (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    interline_id_number integer,
    forwarding_node text,
    receiving_node text,
    forwarding_node_owner text,
    receiving_node_owner text,
    junction_code text,
    impedance integer,
    description text,
    geometry geometry
);


ALTER TABLE public.rail_interline OWNER TO el;

--
-- Name: rail_interline_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE rail_interline_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rail_interline_id_seq OWNER TO el;

--
-- Name: rail_interline_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE rail_interline_id_seq OWNED BY rail_interline.id;


--
-- Name: rail_line; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE rail_line (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    link_id text,
    route_id text,
    miles double precision,
    direction text,
    track_type text,
    grade text,
    gauge text,
    status text,
    passenger text,
    military_subsystem text,
    signal_system text,
    traffic_density text,
    line_class text,
    a_junction text,
    b_junction text,
    subdivision text,
    owner1 text,
    owner2 text,
    trackage_rights1 text,
    trackage_rights2 text,
    trackage_rights3 text,
    geometry geometry
);


ALTER TABLE public.rail_line OWNER TO el;

--
-- Name: rail_line_class; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE rail_line_class (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    name text NOT NULL,
    detail text NOT NULL
);


ALTER TABLE public.rail_line_class OWNER TO el;

--
-- Name: rail_line_class_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE rail_line_class_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rail_line_class_id_seq OWNER TO el;

--
-- Name: rail_line_class_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE rail_line_class_id_seq OWNED BY rail_line_class.id;


--
-- Name: rail_line_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE rail_line_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rail_line_id_seq OWNER TO el;

--
-- Name: rail_line_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE rail_line_id_seq OWNED BY rail_line.id;


--
-- Name: rail_line_work_stoppage; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE rail_line_work_stoppage (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    rail_line integer NOT NULL,
    work_stoppage integer NOT NULL
);


ALTER TABLE public.rail_line_work_stoppage OWNER TO el;

--
-- Name: rail_line_work_stoppage_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE rail_line_work_stoppage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rail_line_work_stoppage_id_seq OWNER TO el;

--
-- Name: rail_line_work_stoppage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE rail_line_work_stoppage_id_seq OWNED BY rail_line_work_stoppage.id;


--
-- Name: rail_military; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE rail_military (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    name text NOT NULL,
    detail text NOT NULL
);


ALTER TABLE public.rail_military OWNER TO el;

--
-- Name: rail_military_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE rail_military_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rail_military_id_seq OWNER TO el;

--
-- Name: rail_military_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE rail_military_id_seq OWNED BY rail_military.id;


--
-- Name: rail_node; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE rail_node (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    junction_id integer,
    name text,
    incident_links integer,
    latitude double precision,
    longitude double precision,
    geometry geometry(Point,900913)
);


ALTER TABLE public.rail_node OWNER TO el;

--
-- Name: rail_node_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE rail_node_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rail_node_id_seq OWNER TO el;

--
-- Name: rail_node_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE rail_node_id_seq OWNED BY rail_node.id;


--
-- Name: rail_node_work_stoppage; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE rail_node_work_stoppage (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    rail_node integer NOT NULL,
    work_stoppage integer NOT NULL
);


ALTER TABLE public.rail_node_work_stoppage OWNER TO el;

--
-- Name: rail_node_work_stoppage_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE rail_node_work_stoppage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rail_node_work_stoppage_id_seq OWNER TO el;

--
-- Name: rail_node_work_stoppage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE rail_node_work_stoppage_id_seq OWNED BY rail_node_work_stoppage.id;


--
-- Name: rail_ownership; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE rail_ownership (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    aar_code integer,
    name text,
    family text,
    history text,
    flag text,
    reporting_mark text
);


ALTER TABLE public.rail_ownership OWNER TO el;

--
-- Name: rail_ownership_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE rail_ownership_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rail_ownership_id_seq OWNER TO el;

--
-- Name: rail_ownership_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE rail_ownership_id_seq OWNED BY rail_ownership.id;


--
-- Name: rail_passenger; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE rail_passenger (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    name text NOT NULL,
    detail text NOT NULL
);


ALTER TABLE public.rail_passenger OWNER TO el;

--
-- Name: rail_passenger_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE rail_passenger_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rail_passenger_id_seq OWNER TO el;

--
-- Name: rail_passenger_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE rail_passenger_id_seq OWNED BY rail_passenger.id;


--
-- Name: rail_signal; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE rail_signal (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    name text NOT NULL,
    detail text NOT NULL
);


ALTER TABLE public.rail_signal OWNER TO el;

--
-- Name: rail_signal_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE rail_signal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rail_signal_id_seq OWNER TO el;

--
-- Name: rail_signal_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE rail_signal_id_seq OWNED BY rail_signal.id;


--
-- Name: rail_status; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE rail_status (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    name text NOT NULL,
    detail text NOT NULL
);


ALTER TABLE public.rail_status OWNER TO el;

--
-- Name: rail_status_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE rail_status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rail_status_id_seq OWNER TO el;

--
-- Name: rail_status_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE rail_status_id_seq OWNED BY rail_status.id;


--
-- Name: rail_subdivision; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE rail_subdivision (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    name text,
    full_name text,
    wmark text,
    subdivision_type text,
    comments text
);


ALTER TABLE public.rail_subdivision OWNER TO el;

--
-- Name: rail_subdivision_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE rail_subdivision_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rail_subdivision_id_seq OWNER TO el;

--
-- Name: rail_subdivision_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE rail_subdivision_id_seq OWNED BY rail_subdivision.id;


--
-- Name: rail_subdivision_state; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE rail_subdivision_state (
    subdivision integer NOT NULL,
    state integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone
);


ALTER TABLE public.rail_subdivision_state OWNER TO el;

--
-- Name: rail_track_gauge; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE rail_track_gauge (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    name text NOT NULL,
    detail text NOT NULL
);


ALTER TABLE public.rail_track_gauge OWNER TO el;

--
-- Name: rail_track_gauge_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE rail_track_gauge_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rail_track_gauge_id_seq OWNER TO el;

--
-- Name: rail_track_gauge_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE rail_track_gauge_id_seq OWNED BY rail_track_gauge.id;


--
-- Name: rail_track_grade; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE rail_track_grade (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    name text NOT NULL,
    detail text NOT NULL
);


ALTER TABLE public.rail_track_grade OWNER TO el;

--
-- Name: rail_track_grade_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE rail_track_grade_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rail_track_grade_id_seq OWNER TO el;

--
-- Name: rail_track_grade_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE rail_track_grade_id_seq OWNED BY rail_track_grade.id;


--
-- Name: rail_track_type; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE rail_track_type (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    name text NOT NULL,
    detail text NOT NULL
);


ALTER TABLE public.rail_track_type OWNER TO el;

--
-- Name: rail_track_type_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE rail_track_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.rail_track_type_id_seq OWNER TO el;

--
-- Name: rail_track_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE rail_track_type_id_seq OWNED BY rail_track_type.id;


--
-- Name: raw_port; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE raw_port (
    gid integer NOT NULL,
    index_no double precision,
    region_no double precision,
    port_name character varying(254),
    country character varying(254),
    latitude double precision,
    longitude double precision,
    lat_deg double precision,
    lat_min double precision,
    lat_hemi character varying(254),
    long_deg double precision,
    long_min double precision,
    long_hemi character varying(254),
    pub character varying(254),
    chart character varying(254),
    harborsize character varying(254),
    harbortype character varying(254),
    shelter character varying(254),
    entry_tide character varying(254),
    entryswell character varying(254),
    entry_ice character varying(254),
    entryother character varying(254),
    overhd_lim character varying(254),
    chan_depth character varying(254),
    anch_depth character varying(254),
    cargodepth character varying(254),
    oil_depth character varying(254),
    tide_range double precision,
    max_vessel character varying(254),
    holdground character varying(254),
    turn_basin character varying(254),
    portofentr character varying(254),
    us_rep character varying(254),
    etamessage character varying(254),
    pilot_reqd character varying(254),
    pilotavail character varying(254),
    loc_assist character varying(254),
    pilotadvsd character varying(254),
    tugsalvage character varying(254),
    tug_assist character varying(254),
    pratique character varying(254),
    sscc_cert character varying(254),
    quar_other character varying(254),
    comm_phone character varying(254),
    comm_fax character varying(254),
    comm_radio character varying(254),
    comm_vhf character varying(254),
    comm_air character varying(254),
    comm_rail character varying(254),
    cargowharf character varying(254),
    cargo_anch character varying(254),
    cargmdmoor character varying(254),
    carbchmoor character varying(254),
    caricemoor character varying(254),
    med_facil character varying(254),
    garbage character varying(254),
    degauss character varying(254),
    drtyballst character varying(254),
    cranefixed character varying(254),
    cranemobil character varying(254),
    cranefloat character varying(254),
    lift_100_ character varying(254),
    lift50_100 character varying(254),
    lift_25_49 character varying(254),
    lift_0_24 character varying(254),
    longshore character varying(254),
    electrical character varying(254),
    serv_steam character varying(254),
    nav_equip character varying(254),
    elecrepair character varying(254),
    provisions character varying(254),
    water character varying(254),
    fuel_oil character varying(254),
    diesel character varying(254),
    decksupply character varying(254),
    eng_supply character varying(254),
    repaircode character varying(254),
    drydock character varying(254),
    railway character varying(254),
    geom geometry(Point,900913)
);


ALTER TABLE public.raw_port OWNER TO el;

--
-- Name: raw_port_gid_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE raw_port_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.raw_port_gid_seq OWNER TO el;

--
-- Name: raw_port_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE raw_port_gid_seq OWNED BY raw_port.gid;


--
-- Name: raw_rail_interline; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE raw_rail_interline (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry(LineString,900914),
    nameb character varying,
    id character varying,
    impedance character varying,
    iidq character varying,
    namea character varying,
    name character varying,
    iidname character varying,
    wtrm character varying,
    ija character varying,
    alias character varying,
    wa character varying,
    ijb character varying,
    wb character varying,
    ityp character varying
);


ALTER TABLE public.raw_rail_interline OWNER TO el;

--
-- Name: raw_rail_interline_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE raw_rail_interline_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.raw_rail_interline_ogc_fid_seq OWNER TO el;

--
-- Name: raw_rail_interline_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE raw_rail_interline_ogc_fid_seq OWNED BY raw_rail_interline.ogc_fid;


--
-- Name: raw_rail_line; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE raw_rail_line (
    gid integer NOT NULL,
    alid character varying(8),
    rtid character varying(13),
    qaux character varying(30),
    miles double precision,
    dirctn character varying(2),
    entrk double precision,
    emlc double precision,
    mlc character varying(1),
    trktyp character varying(1),
    grade character varying(1),
    gauge character varying(1),
    status character varying(1),
    pasngr character varying(1),
    milit character varying(1),
    signal character varying(1),
    densty character varying(1),
    lsrc character varying(1),
    lupdat character varying(1),
    ja integer,
    jb integer,
    sb character varying(4),
    lineid character varying(4),
    w1 character varying(4),
    w2 character varying(4),
    t1 character varying(4),
    t2 character varying(4),
    t3 character varying(4),
    old1 character varying(4),
    geom geometry(MultiLineString,900913)
);


ALTER TABLE public.raw_rail_line OWNER TO el;

--
-- Name: raw_rail_line_gid_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE raw_rail_line_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.raw_rail_line_gid_seq OWNER TO el;

--
-- Name: raw_rail_line_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE raw_rail_line_gid_seq OWNED BY raw_rail_line.gid;


--
-- Name: raw_rail_node; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE raw_rail_node (
    gid integer NOT NULL,
    jid integer,
    jturn character varying(1),
    astate character varying(2),
    jname character varying(24),
    incid smallint,
    splc character varying(6),
    geom geometry(Point,900913)
);


ALTER TABLE public.raw_rail_node OWNER TO el;

--
-- Name: raw_rail_node_gid_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE raw_rail_node_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.raw_rail_node_gid_seq OWNER TO el;

--
-- Name: raw_rail_node_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE raw_rail_node_gid_seq OWNED BY raw_rail_node.gid;


--
-- Name: role; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE role (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    name text NOT NULL
);


ALTER TABLE public.role OWNER TO el;

--
-- Name: role_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.role_id_seq OWNER TO el;

--
-- Name: role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE role_id_seq OWNED BY role.id;


--
-- Name: session; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE session (
    id character varying(72) NOT NULL,
    session_data text,
    expires integer
);


ALTER TABLE public.session OWNER TO el;

--
-- Name: state; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE state (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    abbreviation text,
    name text
);


ALTER TABLE public.state OWNER TO el;

--
-- Name: state_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE state_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.state_id_seq OWNER TO el;

--
-- Name: state_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE state_id_seq OWNED BY state.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE "user" (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    email text NOT NULL,
    nickname text NOT NULL,
    password text NOT NULL,
    description text,
    notes text
);


ALTER TABLE public."user" OWNER TO el;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO el;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE user_id_seq OWNED BY "user".id;


--
-- Name: user_role; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE user_role (
    "user" integer NOT NULL,
    role integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone
);


ALTER TABLE public.user_role OWNER TO el;

--
-- Name: walmart; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE walmart (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    walmart_id text
);


ALTER TABLE public.walmart OWNER TO el;

--
-- Name: walmart_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE walmart_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.walmart_id_seq OWNER TO el;

--
-- Name: walmart_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE walmart_id_seq OWNED BY walmart.id;


--
-- Name: warehouse; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE warehouse (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    name text,
    description text,
    status warehouse_status,
    area integer,
    date_opened date,
    latitude double precision,
    longitude double precision,
    geometry geometry(Point,900913),
    owner integer
);


ALTER TABLE public.warehouse OWNER TO el;

--
-- Name: warehouse_address; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE warehouse_address (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    warehouse integer NOT NULL,
    address integer NOT NULL
);


ALTER TABLE public.warehouse_address OWNER TO el;

--
-- Name: warehouse_address_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE warehouse_address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.warehouse_address_id_seq OWNER TO el;

--
-- Name: warehouse_address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE warehouse_address_id_seq OWNED BY warehouse_address.id;


--
-- Name: warehouse_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE warehouse_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.warehouse_id_seq OWNER TO el;

--
-- Name: warehouse_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE warehouse_id_seq OWNED BY warehouse.id;


--
-- Name: warehouse_owner; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE warehouse_owner (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    name text NOT NULL
);


ALTER TABLE public.warehouse_owner OWNER TO el;

--
-- Name: warehouse_owner_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE warehouse_owner_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.warehouse_owner_id_seq OWNER TO el;

--
-- Name: warehouse_owner_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE warehouse_owner_id_seq OWNED BY warehouse_owner.id;


--
-- Name: warehouse_type; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE warehouse_type (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    name text
);


ALTER TABLE public.warehouse_type OWNER TO el;

--
-- Name: warehouse_type_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE warehouse_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.warehouse_type_id_seq OWNER TO el;

--
-- Name: warehouse_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE warehouse_type_id_seq OWNED BY warehouse_type.id;


--
-- Name: warehouse_walmart; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE warehouse_walmart (
    warehouse integer NOT NULL,
    walmart integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone
);


ALTER TABLE public.warehouse_walmart OWNER TO el;

--
-- Name: warehouse_work_stoppage; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE warehouse_work_stoppage (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    warehouse integer NOT NULL,
    work_stoppage integer NOT NULL
);


ALTER TABLE public.warehouse_work_stoppage OWNER TO el;

--
-- Name: warehouse_work_stoppage_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE warehouse_work_stoppage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.warehouse_work_stoppage_id_seq OWNER TO el;

--
-- Name: warehouse_work_stoppage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE warehouse_work_stoppage_id_seq OWNED BY warehouse_work_stoppage.id;


--
-- Name: work_stoppage; Type: TABLE; Schema: public; Owner: el; Tablespace: 
--

CREATE TABLE work_stoppage (
    id integer NOT NULL,
    create_time timestamp with time zone DEFAULT now() NOT NULL,
    update_time timestamp with time zone DEFAULT now() NOT NULL,
    delete_time timestamp with time zone,
    start_date date NOT NULL,
    end_date date,
    description text
);


ALTER TABLE public.work_stoppage OWNER TO el;

--
-- Name: work_stoppage_id_seq; Type: SEQUENCE; Schema: public; Owner: el
--

CREATE SEQUENCE work_stoppage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.work_stoppage_id_seq OWNER TO el;

--
-- Name: work_stoppage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: el
--

ALTER SEQUENCE work_stoppage_id_seq OWNED BY work_stoppage.id;


SET search_path = sqitch, pg_catalog;

--
-- Name: changes; Type: TABLE; Schema: sqitch; Owner: el; Tablespace: 
--

CREATE TABLE changes (
    change_id text NOT NULL,
    change text NOT NULL,
    project text NOT NULL,
    note text DEFAULT ''::text NOT NULL,
    committed_at timestamp with time zone DEFAULT clock_timestamp() NOT NULL,
    committer_name text NOT NULL,
    committer_email text NOT NULL,
    planned_at timestamp with time zone NOT NULL,
    planner_name text NOT NULL,
    planner_email text NOT NULL
);


ALTER TABLE sqitch.changes OWNER TO el;

--
-- Name: TABLE changes; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON TABLE changes IS 'Tracks the changes currently deployed to the database.';


--
-- Name: COLUMN changes.change_id; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN changes.change_id IS 'Change primary key.';


--
-- Name: COLUMN changes.change; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN changes.change IS 'Name of a deployed change.';


--
-- Name: COLUMN changes.project; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN changes.project IS 'Name of the Sqitch project to which the change belongs.';


--
-- Name: COLUMN changes.note; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN changes.note IS 'Description of the change.';


--
-- Name: COLUMN changes.committed_at; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN changes.committed_at IS 'Date the change was deployed.';


--
-- Name: COLUMN changes.committer_name; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN changes.committer_name IS 'Name of the user who deployed the change.';


--
-- Name: COLUMN changes.committer_email; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN changes.committer_email IS 'Email address of the user who deployed the change.';


--
-- Name: COLUMN changes.planned_at; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN changes.planned_at IS 'Date the change was added to the plan.';


--
-- Name: COLUMN changes.planner_name; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN changes.planner_name IS 'Name of the user who planed the change.';


--
-- Name: COLUMN changes.planner_email; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN changes.planner_email IS 'Email address of the user who planned the change.';


--
-- Name: dependencies; Type: TABLE; Schema: sqitch; Owner: el; Tablespace: 
--

CREATE TABLE dependencies (
    change_id text NOT NULL,
    type text NOT NULL,
    dependency text NOT NULL,
    dependency_id text,
    CONSTRAINT dependencies_check CHECK ((((type = 'require'::text) AND (dependency_id IS NOT NULL)) OR ((type = 'conflict'::text) AND (dependency_id IS NULL))))
);


ALTER TABLE sqitch.dependencies OWNER TO el;

--
-- Name: TABLE dependencies; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON TABLE dependencies IS 'Tracks the currently satisfied dependencies.';


--
-- Name: COLUMN dependencies.change_id; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN dependencies.change_id IS 'ID of the depending change.';


--
-- Name: COLUMN dependencies.type; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN dependencies.type IS 'Type of dependency.';


--
-- Name: COLUMN dependencies.dependency; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN dependencies.dependency IS 'Dependency name.';


--
-- Name: COLUMN dependencies.dependency_id; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN dependencies.dependency_id IS 'Change ID the dependency resolves to.';


--
-- Name: events; Type: TABLE; Schema: sqitch; Owner: el; Tablespace: 
--

CREATE TABLE events (
    event text NOT NULL,
    change_id text NOT NULL,
    change text NOT NULL,
    project text NOT NULL,
    note text DEFAULT ''::text NOT NULL,
    requires text[] DEFAULT '{}'::text[] NOT NULL,
    conflicts text[] DEFAULT '{}'::text[] NOT NULL,
    tags text[] DEFAULT '{}'::text[] NOT NULL,
    committed_at timestamp with time zone DEFAULT clock_timestamp() NOT NULL,
    committer_name text NOT NULL,
    committer_email text NOT NULL,
    planned_at timestamp with time zone NOT NULL,
    planner_name text NOT NULL,
    planner_email text NOT NULL,
    CONSTRAINT events_event_check CHECK ((event = ANY (ARRAY['deploy'::text, 'revert'::text, 'fail'::text])))
);


ALTER TABLE sqitch.events OWNER TO el;

--
-- Name: TABLE events; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON TABLE events IS 'Contains full history of all deployment events.';


--
-- Name: COLUMN events.event; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN events.event IS 'Type of event.';


--
-- Name: COLUMN events.change_id; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN events.change_id IS 'Change ID.';


--
-- Name: COLUMN events.change; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN events.change IS 'Change name.';


--
-- Name: COLUMN events.project; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN events.project IS 'Name of the Sqitch project to which the change belongs.';


--
-- Name: COLUMN events.note; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN events.note IS 'Description of the change.';


--
-- Name: COLUMN events.requires; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN events.requires IS 'Array of the names of required changes.';


--
-- Name: COLUMN events.conflicts; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN events.conflicts IS 'Array of the names of conflicting changes.';


--
-- Name: COLUMN events.tags; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN events.tags IS 'Tags associated with the change.';


--
-- Name: COLUMN events.committed_at; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN events.committed_at IS 'Date the event was committed.';


--
-- Name: COLUMN events.committer_name; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN events.committer_name IS 'Name of the user who committed the event.';


--
-- Name: COLUMN events.committer_email; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN events.committer_email IS 'Email address of the user who committed the event.';


--
-- Name: COLUMN events.planned_at; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN events.planned_at IS 'Date the event was added to the plan.';


--
-- Name: COLUMN events.planner_name; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN events.planner_name IS 'Name of the user who planed the change.';


--
-- Name: COLUMN events.planner_email; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN events.planner_email IS 'Email address of the user who plan planned the change.';


--
-- Name: projects; Type: TABLE; Schema: sqitch; Owner: el; Tablespace: 
--

CREATE TABLE projects (
    project text NOT NULL,
    uri text,
    created_at timestamp with time zone DEFAULT clock_timestamp() NOT NULL,
    creator_name text NOT NULL,
    creator_email text NOT NULL
);


ALTER TABLE sqitch.projects OWNER TO el;

--
-- Name: TABLE projects; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON TABLE projects IS 'Sqitch projects deployed to this database.';


--
-- Name: COLUMN projects.project; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN projects.project IS 'Unique Name of a project.';


--
-- Name: COLUMN projects.uri; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN projects.uri IS 'Optional project URI';


--
-- Name: COLUMN projects.created_at; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN projects.created_at IS 'Date the project was added to the database.';


--
-- Name: COLUMN projects.creator_name; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN projects.creator_name IS 'Name of the user who added the project.';


--
-- Name: COLUMN projects.creator_email; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN projects.creator_email IS 'Email address of the user who added the project.';


--
-- Name: tags; Type: TABLE; Schema: sqitch; Owner: el; Tablespace: 
--

CREATE TABLE tags (
    tag_id text NOT NULL,
    tag text NOT NULL,
    project text NOT NULL,
    change_id text NOT NULL,
    note text DEFAULT ''::text NOT NULL,
    committed_at timestamp with time zone DEFAULT clock_timestamp() NOT NULL,
    committer_name text NOT NULL,
    committer_email text NOT NULL,
    planned_at timestamp with time zone NOT NULL,
    planner_name text NOT NULL,
    planner_email text NOT NULL
);


ALTER TABLE sqitch.tags OWNER TO el;

--
-- Name: TABLE tags; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON TABLE tags IS 'Tracks the tags currently applied to the database.';


--
-- Name: COLUMN tags.tag_id; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN tags.tag_id IS 'Tag primary key.';


--
-- Name: COLUMN tags.tag; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN tags.tag IS 'Project-unique tag name.';


--
-- Name: COLUMN tags.project; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN tags.project IS 'Name of the Sqitch project to which the tag belongs.';


--
-- Name: COLUMN tags.change_id; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN tags.change_id IS 'ID of last change deployed before the tag was applied.';


--
-- Name: COLUMN tags.note; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN tags.note IS 'Description of the tag.';


--
-- Name: COLUMN tags.committed_at; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN tags.committed_at IS 'Date the tag was applied to the database.';


--
-- Name: COLUMN tags.committer_name; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN tags.committer_name IS 'Name of the user who applied the tag.';


--
-- Name: COLUMN tags.committer_email; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN tags.committer_email IS 'Email address of the user who applied the tag.';


--
-- Name: COLUMN tags.planned_at; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN tags.planned_at IS 'Date the tag was added to the plan.';


--
-- Name: COLUMN tags.planner_name; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN tags.planner_name IS 'Name of the user who planed the tag.';


--
-- Name: COLUMN tags.planner_email; Type: COMMENT; Schema: sqitch; Owner: el
--

COMMENT ON COLUMN tags.planner_email IS 'Email address of the user who planned the tag.';


SET search_path = public, pg_catalog;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY address ALTER COLUMN id SET DEFAULT nextval('address_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY company ALTER COLUMN id SET DEFAULT nextval('company_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY company_address ALTER COLUMN id SET DEFAULT nextval('company_address_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY company_nlrb_decision ALTER COLUMN id SET DEFAULT nextval('company_nlrb_decision_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY company_osha_citation ALTER COLUMN id SET DEFAULT nextval('company_osha_citation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY company_port ALTER COLUMN id SET DEFAULT nextval('company_port_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY company_rail_node ALTER COLUMN id SET DEFAULT nextval('company_rail_node_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY company_warehouse ALTER COLUMN id SET DEFAULT nextval('company_warehouse_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY edit_history ALTER COLUMN id SET DEFAULT nextval('edit_history_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization ALTER COLUMN id SET DEFAULT nextval('labor_organization_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_account_payable ALTER COLUMN id SET DEFAULT nextval('labor_organization_account_payable_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_account_receivable ALTER COLUMN id SET DEFAULT nextval('labor_organization_account_receivable_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_address ALTER COLUMN id SET DEFAULT nextval('labor_organization_address_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_affiliation ALTER COLUMN id SET DEFAULT nextval('labor_organization_affiliation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_benefit_disbursement ALTER COLUMN id SET DEFAULT nextval('labor_organization_benefit_disbursement_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_fixed_asset ALTER COLUMN id SET DEFAULT nextval('labor_organization_fixed_asset_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_general_disbursement ALTER COLUMN id SET DEFAULT nextval('labor_organization_general_disbursement_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_investment_asset ALTER COLUMN id SET DEFAULT nextval('labor_organization_investment_asset_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_investment_purchase ALTER COLUMN id SET DEFAULT nextval('labor_organization_investment_purchase_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_loan_payable ALTER COLUMN id SET DEFAULT nextval('labor_organization_loan_payable_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_loan_receivable ALTER COLUMN id SET DEFAULT nextval('labor_organization_loan_receivable_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_membership ALTER COLUMN id SET DEFAULT nextval('labor_organization_membership_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_nlrb_decision ALTER COLUMN id SET DEFAULT nextval('labor_organization_nlrb_decision_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_officer_disbursement ALTER COLUMN id SET DEFAULT nextval('labor_organization_officer_disbursement_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_osha_citation ALTER COLUMN id SET DEFAULT nextval('labor_organization_osha_citation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_other_asset ALTER COLUMN id SET DEFAULT nextval('labor_organization_other_asset_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_other_liability ALTER COLUMN id SET DEFAULT nextval('labor_organization_other_liability_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_other_receipt ALTER COLUMN id SET DEFAULT nextval('labor_organization_other_receipt_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_payee ALTER COLUMN id SET DEFAULT nextval('labor_organization_payee_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_payee_address ALTER COLUMN id SET DEFAULT nextval('labor_organization_payee_address_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_port ALTER COLUMN id SET DEFAULT nextval('labor_organization_port_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_rail_node ALTER COLUMN id SET DEFAULT nextval('labor_organization_rail_node_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_sale_receipt ALTER COLUMN id SET DEFAULT nextval('labor_organization_sale_receipt_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_total_asset ALTER COLUMN id SET DEFAULT nextval('labor_organization_total_asset_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_total_disbursement ALTER COLUMN id SET DEFAULT nextval('labor_organization_total_disbursement_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_total_liability ALTER COLUMN id SET DEFAULT nextval('labor_organization_total_liability_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_total_receipt ALTER COLUMN id SET DEFAULT nextval('labor_organization_total_receipt_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_warehouse ALTER COLUMN id SET DEFAULT nextval('labor_organization_warehouse_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_work_stoppage ALTER COLUMN id SET DEFAULT nextval('labor_organization_work_stoppage_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY media ALTER COLUMN id SET DEFAULT nextval('media_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY nlrb_decision ALTER COLUMN id SET DEFAULT nextval('nlrb_decision_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY osha_citation ALTER COLUMN id SET DEFAULT nextval('osha_citation_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY port ALTER COLUMN id SET DEFAULT nextval('port_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY port_address ALTER COLUMN id SET DEFAULT nextval('port_address_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY port_depth_feet ALTER COLUMN id SET DEFAULT nextval('port_depth_feet_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY port_depth_meters ALTER COLUMN id SET DEFAULT nextval('port_depth_meters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY port_drydock ALTER COLUMN id SET DEFAULT nextval('port_drydock_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY port_harbor_size ALTER COLUMN id SET DEFAULT nextval('port_harbor_size_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY port_harbor_type ALTER COLUMN id SET DEFAULT nextval('port_harbor_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY port_repair ALTER COLUMN id SET DEFAULT nextval('port_repair_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY port_shelter ALTER COLUMN id SET DEFAULT nextval('port_shelter_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY port_tonnage ALTER COLUMN id SET DEFAULT nextval('port_tonnage_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY port_vessel_size ALTER COLUMN id SET DEFAULT nextval('port_vessel_size_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY port_work_stoppage ALTER COLUMN id SET DEFAULT nextval('port_work_stoppage_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY rail_density ALTER COLUMN id SET DEFAULT nextval('rail_density_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY rail_interline ALTER COLUMN id SET DEFAULT nextval('rail_interline_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY rail_line ALTER COLUMN id SET DEFAULT nextval('rail_line_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY rail_line_class ALTER COLUMN id SET DEFAULT nextval('rail_line_class_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY rail_line_work_stoppage ALTER COLUMN id SET DEFAULT nextval('rail_line_work_stoppage_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY rail_military ALTER COLUMN id SET DEFAULT nextval('rail_military_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY rail_node ALTER COLUMN id SET DEFAULT nextval('rail_node_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY rail_node_work_stoppage ALTER COLUMN id SET DEFAULT nextval('rail_node_work_stoppage_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY rail_ownership ALTER COLUMN id SET DEFAULT nextval('rail_ownership_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY rail_passenger ALTER COLUMN id SET DEFAULT nextval('rail_passenger_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY rail_signal ALTER COLUMN id SET DEFAULT nextval('rail_signal_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY rail_status ALTER COLUMN id SET DEFAULT nextval('rail_status_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY rail_subdivision ALTER COLUMN id SET DEFAULT nextval('rail_subdivision_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY rail_track_gauge ALTER COLUMN id SET DEFAULT nextval('rail_track_gauge_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY rail_track_grade ALTER COLUMN id SET DEFAULT nextval('rail_track_grade_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY rail_track_type ALTER COLUMN id SET DEFAULT nextval('rail_track_type_id_seq'::regclass);


--
-- Name: gid; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY raw_port ALTER COLUMN gid SET DEFAULT nextval('raw_port_gid_seq'::regclass);


--
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY raw_rail_interline ALTER COLUMN ogc_fid SET DEFAULT nextval('raw_rail_interline_ogc_fid_seq'::regclass);


--
-- Name: gid; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY raw_rail_line ALTER COLUMN gid SET DEFAULT nextval('raw_rail_line_gid_seq'::regclass);


--
-- Name: gid; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY raw_rail_node ALTER COLUMN gid SET DEFAULT nextval('raw_rail_node_gid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY role ALTER COLUMN id SET DEFAULT nextval('role_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY state ALTER COLUMN id SET DEFAULT nextval('state_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('user_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY walmart ALTER COLUMN id SET DEFAULT nextval('walmart_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY warehouse ALTER COLUMN id SET DEFAULT nextval('warehouse_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY warehouse_address ALTER COLUMN id SET DEFAULT nextval('warehouse_address_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY warehouse_owner ALTER COLUMN id SET DEFAULT nextval('warehouse_owner_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY warehouse_type ALTER COLUMN id SET DEFAULT nextval('warehouse_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY warehouse_work_stoppage ALTER COLUMN id SET DEFAULT nextval('warehouse_work_stoppage_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: el
--

ALTER TABLE ONLY work_stoppage ALTER COLUMN id SET DEFAULT nextval('work_stoppage_id_seq'::regclass);


--
-- Name: address_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY address
    ADD CONSTRAINT address_pkey PRIMARY KEY (id);


--
-- Name: company_address_company_address_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY company_address
    ADD CONSTRAINT company_address_company_address_key UNIQUE (company, address);


--
-- Name: company_address_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY company_address
    ADD CONSTRAINT company_address_pkey PRIMARY KEY (id);


--
-- Name: company_nlrb_decision_company_nlrb_decision_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY company_nlrb_decision
    ADD CONSTRAINT company_nlrb_decision_company_nlrb_decision_key UNIQUE (company, nlrb_decision);


--
-- Name: company_nlrb_decision_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY company_nlrb_decision
    ADD CONSTRAINT company_nlrb_decision_pkey PRIMARY KEY (id);


--
-- Name: company_osha_citation_company_osha_citation_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY company_osha_citation
    ADD CONSTRAINT company_osha_citation_company_osha_citation_key UNIQUE (company, osha_citation);


--
-- Name: company_osha_citation_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY company_osha_citation
    ADD CONSTRAINT company_osha_citation_pkey PRIMARY KEY (id);


--
-- Name: company_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY company
    ADD CONSTRAINT company_pkey PRIMARY KEY (id);


--
-- Name: company_port_company_port_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY company_port
    ADD CONSTRAINT company_port_company_port_key UNIQUE (company, port);


--
-- Name: company_port_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY company_port
    ADD CONSTRAINT company_port_pkey PRIMARY KEY (id);


--
-- Name: company_rail_node_company_rail_node_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY company_rail_node
    ADD CONSTRAINT company_rail_node_company_rail_node_key UNIQUE (company, rail_node);


--
-- Name: company_rail_node_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY company_rail_node
    ADD CONSTRAINT company_rail_node_pkey PRIMARY KEY (id);


--
-- Name: company_warehouse_company_warehouse_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY company_warehouse
    ADD CONSTRAINT company_warehouse_company_warehouse_key UNIQUE (company, warehouse);


--
-- Name: company_warehouse_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY company_warehouse
    ADD CONSTRAINT company_warehouse_pkey PRIMARY KEY (id);


--
-- Name: edit_history_field_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY edit_history_field
    ADD CONSTRAINT edit_history_field_pkey PRIMARY KEY (edit_history, field);


--
-- Name: edit_history_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY edit_history
    ADD CONSTRAINT edit_history_pkey PRIMARY KEY (id);


--
-- Name: labor_organization_account_pa_labor_organization_year_accou_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_account_payable
    ADD CONSTRAINT labor_organization_account_pa_labor_organization_year_accou_key UNIQUE (labor_organization, year, account_type, liquidated, name, past_due_90, past_due_180, total);


--
-- Name: labor_organization_account_payable_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_account_payable
    ADD CONSTRAINT labor_organization_account_payable_pkey PRIMARY KEY (id);


--
-- Name: labor_organization_account_re_labor_organization_year_accou_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_account_receivable
    ADD CONSTRAINT labor_organization_account_re_labor_organization_year_accou_key UNIQUE (labor_organization, year, account_type, liquidated, name, past_due_90, past_due_180, total);


--
-- Name: labor_organization_account_receivable_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_account_receivable
    ADD CONSTRAINT labor_organization_account_receivable_pkey PRIMARY KEY (id);


--
-- Name: labor_organization_address_labor_organization_address_year_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_address
    ADD CONSTRAINT labor_organization_address_labor_organization_address_year_key UNIQUE (labor_organization, address, year);


--
-- Name: labor_organization_address_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_address
    ADD CONSTRAINT labor_organization_address_pkey PRIMARY KEY (id);


--
-- Name: labor_organization_affiliation_child_parent_year_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_affiliation
    ADD CONSTRAINT labor_organization_affiliation_child_parent_year_key UNIQUE (child, parent, year);


--
-- Name: labor_organization_affiliation_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_affiliation
    ADD CONSTRAINT labor_organization_affiliation_pkey PRIMARY KEY (id);


--
-- Name: labor_organization_benefit_di_labor_organization_year_amoun_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_benefit_disbursement
    ADD CONSTRAINT labor_organization_benefit_di_labor_organization_year_amoun_key UNIQUE (labor_organization, year, amount, description, paid_to);


--
-- Name: labor_organization_benefit_disbursement_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_benefit_disbursement
    ADD CONSTRAINT labor_organization_benefit_disbursement_pkey PRIMARY KEY (id);


--
-- Name: labor_organization_fixed_asse_labor_organization_year_asset_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_fixed_asset
    ADD CONSTRAINT labor_organization_fixed_asse_labor_organization_year_asset_key UNIQUE (labor_organization, year, asset_type, book_value, cost_basis, depreciation, description, value);


--
-- Name: labor_organization_fixed_asset_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_fixed_asset
    ADD CONSTRAINT labor_organization_fixed_asset_pkey PRIMARY KEY (id);


--
-- Name: labor_organization_general_di_labor_organization_year_amoun_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_general_disbursement
    ADD CONSTRAINT labor_organization_general_di_labor_organization_year_amoun_key UNIQUE (labor_organization, year, amount, disbursement_date, payee, purpose);


--
-- Name: labor_organization_general_disbursement_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_general_disbursement
    ADD CONSTRAINT labor_organization_general_disbursement_pkey PRIMARY KEY (id);


--
-- Name: labor_organization_investment_asset_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_investment_asset
    ADD CONSTRAINT labor_organization_investment_asset_pkey PRIMARY KEY (id);


--
-- Name: labor_organization_investment_labor_organization_year_amoun_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_investment_asset
    ADD CONSTRAINT labor_organization_investment_labor_organization_year_amoun_key UNIQUE (labor_organization, year, amount, investment_type, name);


--
-- Name: labor_organization_investment_labor_organization_year_book__key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_investment_purchase
    ADD CONSTRAINT labor_organization_investment_labor_organization_year_book__key UNIQUE (labor_organization, year, book_value, cash_paid, cost, description, investment_type);


--
-- Name: labor_organization_investment_purchase_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_investment_purchase
    ADD CONSTRAINT labor_organization_investment_purchase_pkey PRIMARY KEY (id);


--
-- Name: labor_organization_loan_payab_labor_organization_year_cash__key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_loan_payable
    ADD CONSTRAINT labor_organization_loan_payab_labor_organization_year_cash__key UNIQUE (labor_organization, year, cash_repayment, loans_obtained, loans_owed_end, loans_owed_start, non_cash_repayment, source);


--
-- Name: labor_organization_loan_payable_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_loan_payable
    ADD CONSTRAINT labor_organization_loan_payable_pkey PRIMARY KEY (id);


--
-- Name: labor_organization_loan_recei_labor_organization_year_name__key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_loan_receivable
    ADD CONSTRAINT labor_organization_loan_recei_labor_organization_year_name__key UNIQUE (labor_organization, year, name, new_loan_amount, non_cash_repayments, outstanding_end_amount, outstanding_start_amount, purpose, security, terms);


--
-- Name: labor_organization_loan_receivable_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_loan_receivable
    ADD CONSTRAINT labor_organization_loan_receivable_pkey PRIMARY KEY (id);


--
-- Name: labor_organization_membership_labor_organization_year_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_membership
    ADD CONSTRAINT labor_organization_membership_labor_organization_year_key UNIQUE (labor_organization, year);


--
-- Name: labor_organization_membership_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_membership
    ADD CONSTRAINT labor_organization_membership_pkey PRIMARY KEY (id);


--
-- Name: labor_organization_name_usdol_filing_number_abbreviation_or_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization
    ADD CONSTRAINT labor_organization_name_usdol_filing_number_abbreviation_or_key UNIQUE (name, usdol_filing_number, abbreviation, organization_type, local_prefix, local_suffix, local_type, local_number, description);


--
-- Name: labor_organization_nlrb_decis_labor_organization_nlrb_decis_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_nlrb_decision
    ADD CONSTRAINT labor_organization_nlrb_decis_labor_organization_nlrb_decis_key UNIQUE (labor_organization, nlrb_decision);


--
-- Name: labor_organization_nlrb_decision_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_nlrb_decision
    ADD CONSTRAINT labor_organization_nlrb_decision_pkey PRIMARY KEY (id);


--
-- Name: labor_organization_officer_di_labor_organization_year_first_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_officer_disbursement
    ADD CONSTRAINT labor_organization_officer_di_labor_organization_year_first_key UNIQUE (labor_organization, year, first_name, last_name, total);


--
-- Name: labor_organization_officer_disbursement_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_officer_disbursement
    ADD CONSTRAINT labor_organization_officer_disbursement_pkey PRIMARY KEY (id);


--
-- Name: labor_organization_osha_citat_labor_organization_osha_citat_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_osha_citation
    ADD CONSTRAINT labor_organization_osha_citat_labor_organization_osha_citat_key UNIQUE (labor_organization, osha_citation);


--
-- Name: labor_organization_osha_citation_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_osha_citation
    ADD CONSTRAINT labor_organization_osha_citation_pkey PRIMARY KEY (id);


--
-- Name: labor_organization_other_asse_labor_organization_year_book__key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_other_asset
    ADD CONSTRAINT labor_organization_other_asse_labor_organization_year_book__key UNIQUE (labor_organization, year, book_value, description, value);


--
-- Name: labor_organization_other_asset_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_other_asset
    ADD CONSTRAINT labor_organization_other_asset_pkey PRIMARY KEY (id);


--
-- Name: labor_organization_other_liab_labor_organization_year_amoun_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_other_liability
    ADD CONSTRAINT labor_organization_other_liab_labor_organization_year_amoun_key UNIQUE (labor_organization, year, amount, description);


--
-- Name: labor_organization_other_liability_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_other_liability
    ADD CONSTRAINT labor_organization_other_liability_pkey PRIMARY KEY (id);


--
-- Name: labor_organization_other_rece_labor_organization_year_amoun_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_other_receipt
    ADD CONSTRAINT labor_organization_other_rece_labor_organization_year_amoun_key UNIQUE (labor_organization, year, amount, receipt_date, payee, purpose);


--
-- Name: labor_organization_other_receipt_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_other_receipt
    ADD CONSTRAINT labor_organization_other_receipt_pkey PRIMARY KEY (id);


--
-- Name: labor_organization_payee_addr_labor_organization_payee_addr_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_payee_address
    ADD CONSTRAINT labor_organization_payee_addr_labor_organization_payee_addr_key UNIQUE (labor_organization_payee, address, year);


--
-- Name: labor_organization_payee_address_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_payee_address
    ADD CONSTRAINT labor_organization_payee_address_pkey PRIMARY KEY (id);


--
-- Name: labor_organization_payee_labor_organization_year_usdol_paye_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_payee
    ADD CONSTRAINT labor_organization_payee_labor_organization_year_usdol_paye_key UNIQUE (labor_organization, year, usdol_payee_id, name);


--
-- Name: labor_organization_payee_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_payee
    ADD CONSTRAINT labor_organization_payee_pkey PRIMARY KEY (id);


--
-- Name: labor_organization_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization
    ADD CONSTRAINT labor_organization_pkey PRIMARY KEY (id);


--
-- Name: labor_organization_port_labor_organization_port_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_port
    ADD CONSTRAINT labor_organization_port_labor_organization_port_key UNIQUE (labor_organization, port);


--
-- Name: labor_organization_port_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_port
    ADD CONSTRAINT labor_organization_port_pkey PRIMARY KEY (id);


--
-- Name: labor_organization_rail_node_labor_organization_rail_node_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_rail_node
    ADD CONSTRAINT labor_organization_rail_node_labor_organization_rail_node_key UNIQUE (labor_organization, rail_node);


--
-- Name: labor_organization_rail_node_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_rail_node
    ADD CONSTRAINT labor_organization_rail_node_pkey PRIMARY KEY (id);


--
-- Name: labor_organization_sale_recei_labor_organization_year_amoun_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_sale_receipt
    ADD CONSTRAINT labor_organization_sale_recei_labor_organization_year_amoun_key UNIQUE (labor_organization, year, amount_received, book_value, cost, description);


--
-- Name: labor_organization_sale_receipt_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_sale_receipt
    ADD CONSTRAINT labor_organization_sale_receipt_pkey PRIMARY KEY (id);


--
-- Name: labor_organization_total_asset_labor_organization_year_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_total_asset
    ADD CONSTRAINT labor_organization_total_asset_labor_organization_year_key UNIQUE (labor_organization, year);


--
-- Name: labor_organization_total_asset_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_total_asset
    ADD CONSTRAINT labor_organization_total_asset_pkey PRIMARY KEY (id);


--
-- Name: labor_organization_total_disburseme_labor_organization_year_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_total_disbursement
    ADD CONSTRAINT labor_organization_total_disburseme_labor_organization_year_key UNIQUE (labor_organization, year);


--
-- Name: labor_organization_total_disbursement_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_total_disbursement
    ADD CONSTRAINT labor_organization_total_disbursement_pkey PRIMARY KEY (id);


--
-- Name: labor_organization_total_liability_labor_organization_year_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_total_liability
    ADD CONSTRAINT labor_organization_total_liability_labor_organization_year_key UNIQUE (labor_organization, year);


--
-- Name: labor_organization_total_liability_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_total_liability
    ADD CONSTRAINT labor_organization_total_liability_pkey PRIMARY KEY (id);


--
-- Name: labor_organization_total_receipt_labor_organization_year_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_total_receipt
    ADD CONSTRAINT labor_organization_total_receipt_labor_organization_year_key UNIQUE (labor_organization, year);


--
-- Name: labor_organization_total_receipt_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_total_receipt
    ADD CONSTRAINT labor_organization_total_receipt_pkey PRIMARY KEY (id);


--
-- Name: labor_organization_warehouse_labor_organization_warehouse_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_warehouse
    ADD CONSTRAINT labor_organization_warehouse_labor_organization_warehouse_key UNIQUE (labor_organization, warehouse);


--
-- Name: labor_organization_warehouse_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_warehouse
    ADD CONSTRAINT labor_organization_warehouse_pkey PRIMARY KEY (id);


--
-- Name: labor_organization_work_stopp_labor_organization_work_stopp_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_work_stoppage
    ADD CONSTRAINT labor_organization_work_stopp_labor_organization_work_stopp_key UNIQUE (labor_organization, work_stoppage);


--
-- Name: labor_organization_work_stoppage_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY labor_organization_work_stoppage
    ADD CONSTRAINT labor_organization_work_stoppage_pkey PRIMARY KEY (id);


--
-- Name: media_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY media
    ADD CONSTRAINT media_pkey PRIMARY KEY (id);


--
-- Name: nlrb_decision_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY nlrb_decision
    ADD CONSTRAINT nlrb_decision_pkey PRIMARY KEY (id);


--
-- Name: osha_citation_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY osha_citation
    ADD CONSTRAINT osha_citation_pkey PRIMARY KEY (id);


--
-- Name: port_address_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY port_address
    ADD CONSTRAINT port_address_pkey PRIMARY KEY (id);


--
-- Name: port_address_port_address_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY port_address
    ADD CONSTRAINT port_address_port_address_key UNIQUE (port, address);


--
-- Name: port_depth_feet_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY port_depth_feet
    ADD CONSTRAINT port_depth_feet_pkey PRIMARY KEY (id);


--
-- Name: port_depth_meters_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY port_depth_meters
    ADD CONSTRAINT port_depth_meters_pkey PRIMARY KEY (id);


--
-- Name: port_drydock_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY port_drydock
    ADD CONSTRAINT port_drydock_pkey PRIMARY KEY (id);


--
-- Name: port_harbor_size_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY port_harbor_size
    ADD CONSTRAINT port_harbor_size_pkey PRIMARY KEY (id);


--
-- Name: port_harbor_type_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY port_harbor_type
    ADD CONSTRAINT port_harbor_type_pkey PRIMARY KEY (id);


--
-- Name: port_name_lat_lon; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY port
    ADD CONSTRAINT port_name_lat_lon UNIQUE (port_name, latitude, longitude);


--
-- Name: port_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY port
    ADD CONSTRAINT port_pkey PRIMARY KEY (id);


--
-- Name: port_repair_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY port_repair
    ADD CONSTRAINT port_repair_pkey PRIMARY KEY (id);


--
-- Name: port_shelter_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY port_shelter
    ADD CONSTRAINT port_shelter_pkey PRIMARY KEY (id);


--
-- Name: port_tonnage_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY port_tonnage
    ADD CONSTRAINT port_tonnage_pkey PRIMARY KEY (id);


--
-- Name: port_tonnage_port_year_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY port_tonnage
    ADD CONSTRAINT port_tonnage_port_year_key UNIQUE (port, year);


--
-- Name: port_vessel_size_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY port_vessel_size
    ADD CONSTRAINT port_vessel_size_pkey PRIMARY KEY (id);


--
-- Name: port_work_stoppage_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY port_work_stoppage
    ADD CONSTRAINT port_work_stoppage_pkey PRIMARY KEY (id);


--
-- Name: port_work_stoppage_port_work_stoppage_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY port_work_stoppage
    ADD CONSTRAINT port_work_stoppage_port_work_stoppage_key UNIQUE (port, work_stoppage);


--
-- Name: rail_density_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY rail_density
    ADD CONSTRAINT rail_density_pkey PRIMARY KEY (id);


--
-- Name: rail_interline_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY rail_interline
    ADD CONSTRAINT rail_interline_pkey PRIMARY KEY (id);


--
-- Name: rail_line_class_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY rail_line_class
    ADD CONSTRAINT rail_line_class_pkey PRIMARY KEY (id);


--
-- Name: rail_line_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY rail_line
    ADD CONSTRAINT rail_line_pkey PRIMARY KEY (id);


--
-- Name: rail_line_work_stoppage_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY rail_line_work_stoppage
    ADD CONSTRAINT rail_line_work_stoppage_pkey PRIMARY KEY (id);


--
-- Name: rail_line_work_stoppage_rail_line_work_stoppage_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY rail_line_work_stoppage
    ADD CONSTRAINT rail_line_work_stoppage_rail_line_work_stoppage_key UNIQUE (rail_line, work_stoppage);


--
-- Name: rail_military_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY rail_military
    ADD CONSTRAINT rail_military_pkey PRIMARY KEY (id);


--
-- Name: rail_node_name_lat_lon; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY rail_node
    ADD CONSTRAINT rail_node_name_lat_lon UNIQUE (name, latitude, longitude);


--
-- Name: rail_node_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY rail_node
    ADD CONSTRAINT rail_node_pkey PRIMARY KEY (id);


--
-- Name: rail_node_work_stoppage_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY rail_node_work_stoppage
    ADD CONSTRAINT rail_node_work_stoppage_pkey PRIMARY KEY (id);


--
-- Name: rail_node_work_stoppage_rail_node_work_stoppage_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY rail_node_work_stoppage
    ADD CONSTRAINT rail_node_work_stoppage_rail_node_work_stoppage_key UNIQUE (rail_node, work_stoppage);


--
-- Name: rail_ownership_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY rail_ownership
    ADD CONSTRAINT rail_ownership_pkey PRIMARY KEY (id);


--
-- Name: rail_passenger_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY rail_passenger
    ADD CONSTRAINT rail_passenger_pkey PRIMARY KEY (id);


--
-- Name: rail_signal_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY rail_signal
    ADD CONSTRAINT rail_signal_pkey PRIMARY KEY (id);


--
-- Name: rail_status_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY rail_status
    ADD CONSTRAINT rail_status_pkey PRIMARY KEY (id);


--
-- Name: rail_subdivision_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY rail_subdivision
    ADD CONSTRAINT rail_subdivision_pkey PRIMARY KEY (id);


--
-- Name: rail_subdivision_state_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY rail_subdivision_state
    ADD CONSTRAINT rail_subdivision_state_pkey PRIMARY KEY (subdivision, state);


--
-- Name: rail_track_gauge_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY rail_track_gauge
    ADD CONSTRAINT rail_track_gauge_pkey PRIMARY KEY (id);


--
-- Name: rail_track_grade_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY rail_track_grade
    ADD CONSTRAINT rail_track_grade_pkey PRIMARY KEY (id);


--
-- Name: rail_track_type_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY rail_track_type
    ADD CONSTRAINT rail_track_type_pkey PRIMARY KEY (id);


--
-- Name: raw_port_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY raw_port
    ADD CONSTRAINT raw_port_pkey PRIMARY KEY (gid);


--
-- Name: raw_rail_interline_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY raw_rail_interline
    ADD CONSTRAINT raw_rail_interline_pkey PRIMARY KEY (ogc_fid);


--
-- Name: raw_rail_line_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY raw_rail_line
    ADD CONSTRAINT raw_rail_line_pkey PRIMARY KEY (gid);


--
-- Name: raw_rail_node_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY raw_rail_node
    ADD CONSTRAINT raw_rail_node_pkey PRIMARY KEY (gid);


--
-- Name: role_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);


--
-- Name: session_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY session
    ADD CONSTRAINT session_pkey PRIMARY KEY (id);


--
-- Name: state_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY state
    ADD CONSTRAINT state_pkey PRIMARY KEY (id);


--
-- Name: user_email_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_email_key UNIQUE (email);


--
-- Name: user_nickname_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_nickname_key UNIQUE (nickname);


--
-- Name: user_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: user_role_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY user_role
    ADD CONSTRAINT user_role_pkey PRIMARY KEY ("user", role);


--
-- Name: walmart_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY walmart
    ADD CONSTRAINT walmart_pkey PRIMARY KEY (id);


--
-- Name: warehouse_address_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY warehouse_address
    ADD CONSTRAINT warehouse_address_pkey PRIMARY KEY (id);


--
-- Name: warehouse_address_warehouse_address_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY warehouse_address
    ADD CONSTRAINT warehouse_address_warehouse_address_key UNIQUE (warehouse, address);


--
-- Name: warehouse_name_lat_lon; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY warehouse
    ADD CONSTRAINT warehouse_name_lat_lon UNIQUE (name, latitude, longitude);


--
-- Name: warehouse_owner_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY warehouse_owner
    ADD CONSTRAINT warehouse_owner_pkey PRIMARY KEY (id);


--
-- Name: warehouse_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY warehouse
    ADD CONSTRAINT warehouse_pkey PRIMARY KEY (id);


--
-- Name: warehouse_type_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY warehouse_type
    ADD CONSTRAINT warehouse_type_pkey PRIMARY KEY (id);


--
-- Name: warehouse_walmart_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY warehouse_walmart
    ADD CONSTRAINT warehouse_walmart_pkey PRIMARY KEY (warehouse, walmart);


--
-- Name: warehouse_work_stoppage_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY warehouse_work_stoppage
    ADD CONSTRAINT warehouse_work_stoppage_pkey PRIMARY KEY (id);


--
-- Name: warehouse_work_stoppage_warehouse_work_stoppage_key; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY warehouse_work_stoppage
    ADD CONSTRAINT warehouse_work_stoppage_warehouse_work_stoppage_key UNIQUE (warehouse, work_stoppage);


--
-- Name: work_stoppage_pkey; Type: CONSTRAINT; Schema: public; Owner: el; Tablespace: 
--

ALTER TABLE ONLY work_stoppage
    ADD CONSTRAINT work_stoppage_pkey PRIMARY KEY (id);


SET search_path = sqitch, pg_catalog;

--
-- Name: changes_pkey; Type: CONSTRAINT; Schema: sqitch; Owner: el; Tablespace: 
--

ALTER TABLE ONLY changes
    ADD CONSTRAINT changes_pkey PRIMARY KEY (change_id);


--
-- Name: dependencies_pkey; Type: CONSTRAINT; Schema: sqitch; Owner: el; Tablespace: 
--

ALTER TABLE ONLY dependencies
    ADD CONSTRAINT dependencies_pkey PRIMARY KEY (change_id, dependency);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: sqitch; Owner: el; Tablespace: 
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (change_id, committed_at);


--
-- Name: projects_pkey; Type: CONSTRAINT; Schema: sqitch; Owner: el; Tablespace: 
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (project);


--
-- Name: projects_uri_key; Type: CONSTRAINT; Schema: sqitch; Owner: el; Tablespace: 
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_uri_key UNIQUE (uri);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: sqitch; Owner: el; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (tag_id);


--
-- Name: tags_project_tag_key; Type: CONSTRAINT; Schema: sqitch; Owner: el; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_project_tag_key UNIQUE (project, tag);


SET search_path = public, pg_catalog;

--
-- Name: address_city_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX address_city_idx ON address USING btree (city);


--
-- Name: address_country_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX address_country_idx ON address USING btree (country);


--
-- Name: address_postal_code_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX address_postal_code_idx ON address USING btree (postal_code);


--
-- Name: address_state_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX address_state_idx ON address USING btree (state);


--
-- Name: address_street_address_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX address_street_address_idx ON address USING btree (street_address);


--
-- Name: company_address_address_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX company_address_address_idx ON company_address USING btree (address);


--
-- Name: company_address_company_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX company_address_company_idx ON company_address USING btree (company);


--
-- Name: company_company_type_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX company_company_type_idx ON company USING btree (company_type);


--
-- Name: company_name_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX company_name_idx ON company USING btree (name);


--
-- Name: company_nlrb_decision_company_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX company_nlrb_decision_company_idx ON company_nlrb_decision USING btree (company);


--
-- Name: company_nlrb_decision_nlrb_decision_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX company_nlrb_decision_nlrb_decision_idx ON company_nlrb_decision USING btree (nlrb_decision);


--
-- Name: company_osha_citation_company_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX company_osha_citation_company_idx ON company_osha_citation USING btree (company);


--
-- Name: company_osha_citation_osha_citation_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX company_osha_citation_osha_citation_idx ON company_osha_citation USING btree (osha_citation);


--
-- Name: company_port_company_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX company_port_company_idx ON company_port USING btree (company);


--
-- Name: company_port_port_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX company_port_port_idx ON company_port USING btree (port);


--
-- Name: company_rail_node_company_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX company_rail_node_company_idx ON company_rail_node USING btree (company);


--
-- Name: company_rail_node_rail_node_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX company_rail_node_rail_node_idx ON company_rail_node USING btree (rail_node);


--
-- Name: company_warehouse_company_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX company_warehouse_company_idx ON company_warehouse USING btree (company);


--
-- Name: company_warehouse_warehouse_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX company_warehouse_warehouse_idx ON company_warehouse USING btree (warehouse);


--
-- Name: edit_history_field_edit_history_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX edit_history_field_edit_history_idx ON edit_history_field USING btree (edit_history);


--
-- Name: edit_history_field_field_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX edit_history_field_field_idx ON edit_history_field USING btree (field);


--
-- Name: edit_history_object_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX edit_history_object_idx ON edit_history USING btree (object);


--
-- Name: edit_history_object_type_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX edit_history_object_type_idx ON edit_history USING btree (object_type);


--
-- Name: edit_history_object_type_object_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX edit_history_object_type_object_idx ON edit_history USING btree (object_type, object);


--
-- Name: edit_history_user_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX edit_history_user_idx ON edit_history USING btree ("user");


--
-- Name: labor_organization_abbreviation_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_abbreviation_idx ON labor_organization USING btree (abbreviation);


--
-- Name: labor_organization_account_payable_labor_organization_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_account_payable_labor_organization_idx ON labor_organization_account_payable USING btree (labor_organization);


--
-- Name: labor_organization_account_receivable_labor_organization_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_account_receivable_labor_organization_idx ON labor_organization_account_receivable USING btree (labor_organization);


--
-- Name: labor_organization_address_address_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_address_address_idx ON labor_organization_address USING btree (address);


--
-- Name: labor_organization_address_labor_organization_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_address_labor_organization_idx ON labor_organization_address USING btree (labor_organization);


--
-- Name: labor_organization_affiliation_child_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_affiliation_child_idx ON labor_organization_affiliation USING btree (child);


--
-- Name: labor_organization_affiliation_parent_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_affiliation_parent_idx ON labor_organization_affiliation USING btree (parent);


--
-- Name: labor_organization_benefit_disbursement_labor_organization_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_benefit_disbursement_labor_organization_idx ON labor_organization_benefit_disbursement USING btree (labor_organization);


--
-- Name: labor_organization_fixed_asset_labor_organization_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_fixed_asset_labor_organization_idx ON labor_organization_fixed_asset USING btree (labor_organization);


--
-- Name: labor_organization_general_disbursement_labor_organization_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_general_disbursement_labor_organization_idx ON labor_organization_general_disbursement USING btree (labor_organization);


--
-- Name: labor_organization_general_disbursement_payee_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_general_disbursement_payee_idx ON labor_organization_general_disbursement USING btree (payee);


--
-- Name: labor_organization_investment_asset_labor_organization_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_investment_asset_labor_organization_idx ON labor_organization_investment_asset USING btree (labor_organization);


--
-- Name: labor_organization_investment_purchase_labor_organization_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_investment_purchase_labor_organization_idx ON labor_organization_investment_purchase USING btree (labor_organization);


--
-- Name: labor_organization_loan_payable_labor_organization_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_loan_payable_labor_organization_idx ON labor_organization_loan_payable USING btree (labor_organization);


--
-- Name: labor_organization_loan_receivable_labor_organization_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_loan_receivable_labor_organization_idx ON labor_organization_loan_receivable USING btree (labor_organization);


--
-- Name: labor_organization_membership_labor_organization_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_membership_labor_organization_idx ON labor_organization_membership USING btree (labor_organization);


--
-- Name: labor_organization_name_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_name_idx ON labor_organization USING btree (name);


--
-- Name: labor_organization_nlrb_decision_labor_organization_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_nlrb_decision_labor_organization_idx ON labor_organization_nlrb_decision USING btree (labor_organization);


--
-- Name: labor_organization_nlrb_decision_nlrb_decision_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_nlrb_decision_nlrb_decision_idx ON labor_organization_nlrb_decision USING btree (nlrb_decision);


--
-- Name: labor_organization_officer_disbursement_labor_organization_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_officer_disbursement_labor_organization_idx ON labor_organization_officer_disbursement USING btree (labor_organization);


--
-- Name: labor_organization_organization_type_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_organization_type_idx ON labor_organization USING btree (organization_type);


--
-- Name: labor_organization_osha_citation_labor_organization_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_osha_citation_labor_organization_idx ON labor_organization_osha_citation USING btree (labor_organization);


--
-- Name: labor_organization_osha_citation_osha_citation_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_osha_citation_osha_citation_idx ON labor_organization_osha_citation USING btree (osha_citation);


--
-- Name: labor_organization_other_asset_labor_organization_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_other_asset_labor_organization_idx ON labor_organization_other_asset USING btree (labor_organization);


--
-- Name: labor_organization_other_liability_labor_organization_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_other_liability_labor_organization_idx ON labor_organization_other_liability USING btree (labor_organization);


--
-- Name: labor_organization_other_receipt_labor_organization_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_other_receipt_labor_organization_idx ON labor_organization_other_receipt USING btree (labor_organization);


--
-- Name: labor_organization_other_receipt_payee_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_other_receipt_payee_idx ON labor_organization_other_receipt USING btree (payee);


--
-- Name: labor_organization_payee_address_address_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_payee_address_address_idx ON labor_organization_payee_address USING btree (address);


--
-- Name: labor_organization_payee_address_labor_organization_payee_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_payee_address_labor_organization_payee_idx ON labor_organization_payee_address USING btree (labor_organization_payee);


--
-- Name: labor_organization_payee_labor_organization_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_payee_labor_organization_idx ON labor_organization_payee USING btree (labor_organization);


--
-- Name: labor_organization_payee_name_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_payee_name_idx ON labor_organization_payee USING btree (name);


--
-- Name: labor_organization_payee_payee_type_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_payee_payee_type_idx ON labor_organization_payee USING btree (payee_type);


--
-- Name: labor_organization_port_labor_organization_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_port_labor_organization_idx ON labor_organization_port USING btree (labor_organization);


--
-- Name: labor_organization_port_port_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_port_port_idx ON labor_organization_port USING btree (port);


--
-- Name: labor_organization_rail_node_labor_organization_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_rail_node_labor_organization_idx ON labor_organization_rail_node USING btree (labor_organization);


--
-- Name: labor_organization_rail_node_rail_node_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_rail_node_rail_node_idx ON labor_organization_rail_node USING btree (rail_node);


--
-- Name: labor_organization_sale_receipt_labor_organization_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_sale_receipt_labor_organization_idx ON labor_organization_sale_receipt USING btree (labor_organization);


--
-- Name: labor_organization_total_asset_labor_organization_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_total_asset_labor_organization_idx ON labor_organization_total_asset USING btree (labor_organization);


--
-- Name: labor_organization_total_disbursement_labor_organization_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_total_disbursement_labor_organization_idx ON labor_organization_total_disbursement USING btree (labor_organization);


--
-- Name: labor_organization_total_liability_labor_organization_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_total_liability_labor_organization_idx ON labor_organization_total_liability USING btree (labor_organization);


--
-- Name: labor_organization_total_receipt_labor_organization_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_total_receipt_labor_organization_idx ON labor_organization_total_receipt USING btree (labor_organization);


--
-- Name: labor_organization_usdol_filing_number_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_usdol_filing_number_idx ON labor_organization USING btree (usdol_filing_number);


--
-- Name: labor_organization_warehouse_labor_organization_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_warehouse_labor_organization_idx ON labor_organization_warehouse USING btree (labor_organization);


--
-- Name: labor_organization_warehouse_warehouse_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_warehouse_warehouse_idx ON labor_organization_warehouse USING btree (warehouse);


--
-- Name: labor_organization_work_stoppage_labor_organization_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_work_stoppage_labor_organization_idx ON labor_organization_work_stoppage USING btree (labor_organization);


--
-- Name: labor_organization_work_stoppage_work_stoppage_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX labor_organization_work_stoppage_work_stoppage_idx ON labor_organization_work_stoppage USING btree (work_stoppage);


--
-- Name: nlrb_decision_citation_number_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX nlrb_decision_citation_number_idx ON nlrb_decision USING btree (citation_number);


--
-- Name: osha_citation_inspection_number_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX osha_citation_inspection_number_idx ON osha_citation USING btree (inspection_number);


--
-- Name: port_address_address_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX port_address_address_idx ON port_address USING btree (address);


--
-- Name: port_address_port_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX port_address_port_idx ON port_address USING btree (port);


--
-- Name: port_country_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX port_country_idx ON port USING btree (country);


--
-- Name: port_depth_feet_name_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX port_depth_feet_name_idx ON port_depth_feet USING btree (name);


--
-- Name: port_depth_meters_name_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX port_depth_meters_name_idx ON port_depth_meters USING btree (name);


--
-- Name: port_drydock_name_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX port_drydock_name_idx ON port_drydock USING btree (name);


--
-- Name: port_harbor_size_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX port_harbor_size_idx ON port USING btree (harbor_size);


--
-- Name: port_harbor_size_name_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX port_harbor_size_name_idx ON port_harbor_size USING btree (name);


--
-- Name: port_harbor_type_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX port_harbor_type_idx ON port USING btree (harbor_type);


--
-- Name: port_harbor_type_name_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX port_harbor_type_name_idx ON port_harbor_type USING btree (name);


--
-- Name: port_port_name_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX port_port_name_idx ON port USING btree (port_name);


--
-- Name: port_repair_name_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX port_repair_name_idx ON port_repair USING btree (name);


--
-- Name: port_shelter_name_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX port_shelter_name_idx ON port_shelter USING btree (name);


--
-- Name: port_tonnage_port_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX port_tonnage_port_idx ON port_tonnage USING btree (port);


--
-- Name: port_vessel_size_name_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX port_vessel_size_name_idx ON port_vessel_size USING btree (name);


--
-- Name: port_work_stoppage_port_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX port_work_stoppage_port_idx ON port_work_stoppage USING btree (port);


--
-- Name: port_work_stoppage_work_stoppage_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX port_work_stoppage_work_stoppage_idx ON port_work_stoppage USING btree (work_stoppage);


--
-- Name: rail_density_name_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX rail_density_name_idx ON rail_density USING btree (name);


--
-- Name: rail_line_class_name_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX rail_line_class_name_idx ON rail_line_class USING btree (name);


--
-- Name: rail_line_work_stoppage_rail_line_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX rail_line_work_stoppage_rail_line_idx ON rail_line_work_stoppage USING btree (rail_line);


--
-- Name: rail_line_work_stoppage_work_stoppage_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX rail_line_work_stoppage_work_stoppage_idx ON rail_line_work_stoppage USING btree (work_stoppage);


--
-- Name: rail_military_name_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX rail_military_name_idx ON rail_military USING btree (name);


--
-- Name: rail_node_work_stoppage_rail_node_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX rail_node_work_stoppage_rail_node_idx ON rail_node_work_stoppage USING btree (rail_node);


--
-- Name: rail_node_work_stoppage_work_stoppage_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX rail_node_work_stoppage_work_stoppage_idx ON rail_node_work_stoppage USING btree (work_stoppage);


--
-- Name: rail_ownership_aar_code_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX rail_ownership_aar_code_idx ON rail_ownership USING btree (aar_code);


--
-- Name: rail_ownership_name_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX rail_ownership_name_idx ON rail_ownership USING btree (name);


--
-- Name: rail_ownership_reporting_mark_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX rail_ownership_reporting_mark_idx ON rail_ownership USING btree (reporting_mark);


--
-- Name: rail_passenger_name_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX rail_passenger_name_idx ON rail_passenger USING btree (name);


--
-- Name: rail_signal_name_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX rail_signal_name_idx ON rail_signal USING btree (name);


--
-- Name: rail_status_name_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX rail_status_name_idx ON rail_status USING btree (name);


--
-- Name: rail_subdivision_name_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX rail_subdivision_name_idx ON rail_subdivision USING btree (name);


--
-- Name: rail_subdivision_state_state_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX rail_subdivision_state_state_idx ON rail_subdivision_state USING btree (state);


--
-- Name: rail_subdivision_state_subdivision_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX rail_subdivision_state_subdivision_idx ON rail_subdivision_state USING btree (subdivision);


--
-- Name: rail_subdivision_wmark_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX rail_subdivision_wmark_idx ON rail_subdivision USING btree (wmark);


--
-- Name: rail_track_gauge_name_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX rail_track_gauge_name_idx ON rail_track_gauge USING btree (name);


--
-- Name: rail_track_grade_name_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX rail_track_grade_name_idx ON rail_track_grade USING btree (name);


--
-- Name: rail_track_type_name_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX rail_track_type_name_idx ON rail_track_type USING btree (name);


--
-- Name: raw_port_geom_gist; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX raw_port_geom_gist ON raw_port USING gist (geom);


--
-- Name: raw_rail_interline_geom_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX raw_rail_interline_geom_idx ON raw_rail_interline USING gist (wkb_geometry);


--
-- Name: raw_rail_line_geom_gist; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX raw_rail_line_geom_gist ON raw_rail_line USING gist (geom);


--
-- Name: raw_rail_node_geom_gist; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX raw_rail_node_geom_gist ON raw_rail_node USING gist (geom);


--
-- Name: state_abbreviation_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX state_abbreviation_idx ON state USING btree (abbreviation);


--
-- Name: state_name_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX state_name_idx ON state USING btree (name);


--
-- Name: user_role_role_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX user_role_role_idx ON user_role USING btree (role);


--
-- Name: user_role_user_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX user_role_user_idx ON user_role USING btree ("user");


--
-- Name: warehouse_address_address_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX warehouse_address_address_idx ON warehouse_address USING btree (address);


--
-- Name: warehouse_address_warehouse_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX warehouse_address_warehouse_idx ON warehouse_address USING btree (warehouse);


--
-- Name: warehouse_name_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX warehouse_name_idx ON warehouse USING btree (name);


--
-- Name: warehouse_status_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX warehouse_status_idx ON warehouse USING btree (status);


--
-- Name: warehouse_type_name_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX warehouse_type_name_idx ON warehouse_type USING btree (name);


--
-- Name: warehouse_walmart_walmart_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX warehouse_walmart_walmart_idx ON warehouse_walmart USING btree (walmart);


--
-- Name: warehouse_walmart_warehouse_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX warehouse_walmart_warehouse_idx ON warehouse_walmart USING btree (warehouse);


--
-- Name: warehouse_warehouse_owner; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX warehouse_warehouse_owner ON warehouse USING btree (owner);


--
-- Name: warehouse_work_stoppage_warehouse_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX warehouse_work_stoppage_warehouse_idx ON warehouse_work_stoppage USING btree (warehouse);


--
-- Name: warehouse_work_stoppage_work_stoppage_idx; Type: INDEX; Schema: public; Owner: el; Tablespace: 
--

CREATE INDEX warehouse_work_stoppage_work_stoppage_idx ON warehouse_work_stoppage USING btree (work_stoppage);


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON "user" FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON address FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON company FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON company_address FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON company_nlrb_decision FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON company_osha_citation FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON company_port FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON company_rail_node FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON company_warehouse FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON edit_history FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON edit_history_field FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON labor_organization FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON labor_organization_account_payable FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON labor_organization_account_receivable FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON labor_organization_address FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON labor_organization_affiliation FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON labor_organization_benefit_disbursement FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON labor_organization_fixed_asset FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON labor_organization_general_disbursement FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON labor_organization_investment_asset FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON labor_organization_investment_purchase FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON labor_organization_loan_payable FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON labor_organization_loan_receivable FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON labor_organization_membership FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON labor_organization_nlrb_decision FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON labor_organization_officer_disbursement FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON labor_organization_osha_citation FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON labor_organization_other_asset FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON labor_organization_other_liability FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON labor_organization_other_receipt FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON labor_organization_payee FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON labor_organization_payee_address FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON labor_organization_port FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON labor_organization_rail_node FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON labor_organization_sale_receipt FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON labor_organization_total_asset FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON labor_organization_total_disbursement FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON labor_organization_total_liability FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON labor_organization_total_receipt FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON labor_organization_warehouse FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON labor_organization_work_stoppage FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON media FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON nlrb_decision FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON osha_citation FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON port FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON port_address FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON port_depth_feet FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON port_depth_meters FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON port_drydock FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON port_harbor_size FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON port_harbor_type FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON port_repair FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON port_shelter FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON port_tonnage FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON port_vessel_size FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON port_work_stoppage FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON rail_density FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON rail_interline FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON rail_line FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON rail_line_class FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON rail_line_work_stoppage FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON rail_military FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON rail_node FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON rail_node_work_stoppage FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON rail_ownership FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON rail_passenger FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON rail_signal FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON rail_status FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON rail_subdivision FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON rail_subdivision_state FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON rail_track_gauge FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON rail_track_grade FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON rail_track_type FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON role FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON state FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON user_role FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON walmart FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON warehouse FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON warehouse_address FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON warehouse_type FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON warehouse_walmart FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON warehouse_work_stoppage FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: update_time; Type: TRIGGER; Schema: public; Owner: el
--

CREATE TRIGGER update_time BEFORE UPDATE ON work_stoppage FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


--
-- Name: company_address_address_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY company_address
    ADD CONSTRAINT company_address_address_fkey FOREIGN KEY (address) REFERENCES address(id) ON DELETE CASCADE;


--
-- Name: company_address_company_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY company_address
    ADD CONSTRAINT company_address_company_fkey FOREIGN KEY (company) REFERENCES company(id) ON DELETE CASCADE;


--
-- Name: company_nlrb_decision_company_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY company_nlrb_decision
    ADD CONSTRAINT company_nlrb_decision_company_fkey FOREIGN KEY (company) REFERENCES company(id) ON DELETE CASCADE;


--
-- Name: company_nlrb_decision_nlrb_decision_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY company_nlrb_decision
    ADD CONSTRAINT company_nlrb_decision_nlrb_decision_fkey FOREIGN KEY (nlrb_decision) REFERENCES nlrb_decision(id) ON DELETE CASCADE;


--
-- Name: company_osha_citation_company_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY company_osha_citation
    ADD CONSTRAINT company_osha_citation_company_fkey FOREIGN KEY (company) REFERENCES company(id) ON DELETE CASCADE;


--
-- Name: company_osha_citation_osha_citation_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY company_osha_citation
    ADD CONSTRAINT company_osha_citation_osha_citation_fkey FOREIGN KEY (osha_citation) REFERENCES osha_citation(id) ON DELETE CASCADE;


--
-- Name: company_port_company_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY company_port
    ADD CONSTRAINT company_port_company_fkey FOREIGN KEY (company) REFERENCES company(id) ON DELETE CASCADE;


--
-- Name: company_port_port_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY company_port
    ADD CONSTRAINT company_port_port_fkey FOREIGN KEY (port) REFERENCES port(id) ON DELETE CASCADE;


--
-- Name: company_rail_node_company_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY company_rail_node
    ADD CONSTRAINT company_rail_node_company_fkey FOREIGN KEY (company) REFERENCES company(id) ON DELETE CASCADE;


--
-- Name: company_rail_node_rail_node_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY company_rail_node
    ADD CONSTRAINT company_rail_node_rail_node_fkey FOREIGN KEY (rail_node) REFERENCES rail_node(id) ON DELETE CASCADE;


--
-- Name: company_warehouse_company_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY company_warehouse
    ADD CONSTRAINT company_warehouse_company_fkey FOREIGN KEY (company) REFERENCES company(id) ON DELETE CASCADE;


--
-- Name: company_warehouse_warehouse_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY company_warehouse
    ADD CONSTRAINT company_warehouse_warehouse_fkey FOREIGN KEY (warehouse) REFERENCES warehouse(id) ON DELETE CASCADE;


--
-- Name: edit_history_field_edit_history_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY edit_history_field
    ADD CONSTRAINT edit_history_field_edit_history_fkey FOREIGN KEY (edit_history) REFERENCES edit_history(id);


--
-- Name: labor_organization_account_payable_labor_organization_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_account_payable
    ADD CONSTRAINT labor_organization_account_payable_labor_organization_fkey FOREIGN KEY (labor_organization) REFERENCES labor_organization(id) ON DELETE CASCADE;


--
-- Name: labor_organization_account_receivable_labor_organization_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_account_receivable
    ADD CONSTRAINT labor_organization_account_receivable_labor_organization_fkey FOREIGN KEY (labor_organization) REFERENCES labor_organization(id) ON DELETE CASCADE;


--
-- Name: labor_organization_address_address_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_address
    ADD CONSTRAINT labor_organization_address_address_fkey FOREIGN KEY (address) REFERENCES address(id) ON DELETE CASCADE;


--
-- Name: labor_organization_address_labor_organization_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_address
    ADD CONSTRAINT labor_organization_address_labor_organization_fkey FOREIGN KEY (labor_organization) REFERENCES labor_organization(id) ON DELETE CASCADE;


--
-- Name: labor_organization_affiliation_child_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_affiliation
    ADD CONSTRAINT labor_organization_affiliation_child_fkey FOREIGN KEY (child) REFERENCES labor_organization(id) ON DELETE CASCADE;


--
-- Name: labor_organization_affiliation_parent_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_affiliation
    ADD CONSTRAINT labor_organization_affiliation_parent_fkey FOREIGN KEY (parent) REFERENCES labor_organization(id) ON DELETE CASCADE;


--
-- Name: labor_organization_benefit_disbursement_labor_organization_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_benefit_disbursement
    ADD CONSTRAINT labor_organization_benefit_disbursement_labor_organization_fkey FOREIGN KEY (labor_organization) REFERENCES labor_organization(id) ON DELETE CASCADE;


--
-- Name: labor_organization_fixed_asset_labor_organization_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_fixed_asset
    ADD CONSTRAINT labor_organization_fixed_asset_labor_organization_fkey FOREIGN KEY (labor_organization) REFERENCES labor_organization(id) ON DELETE CASCADE;


--
-- Name: labor_organization_general_disbursement_labor_organization_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_general_disbursement
    ADD CONSTRAINT labor_organization_general_disbursement_labor_organization_fkey FOREIGN KEY (labor_organization) REFERENCES labor_organization(id) ON DELETE CASCADE;


--
-- Name: labor_organization_general_disbursement_payee_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_general_disbursement
    ADD CONSTRAINT labor_organization_general_disbursement_payee_fkey FOREIGN KEY (payee) REFERENCES labor_organization_payee(id) ON DELETE CASCADE;


--
-- Name: labor_organization_investment_asset_labor_organization_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_investment_asset
    ADD CONSTRAINT labor_organization_investment_asset_labor_organization_fkey FOREIGN KEY (labor_organization) REFERENCES labor_organization(id) ON DELETE CASCADE;


--
-- Name: labor_organization_investment_purchase_labor_organization_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_investment_purchase
    ADD CONSTRAINT labor_organization_investment_purchase_labor_organization_fkey FOREIGN KEY (labor_organization) REFERENCES labor_organization(id) ON DELETE CASCADE;


--
-- Name: labor_organization_loan_payable_labor_organization_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_loan_payable
    ADD CONSTRAINT labor_organization_loan_payable_labor_organization_fkey FOREIGN KEY (labor_organization) REFERENCES labor_organization(id) ON DELETE CASCADE;


--
-- Name: labor_organization_loan_receivable_labor_organization_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_loan_receivable
    ADD CONSTRAINT labor_organization_loan_receivable_labor_organization_fkey FOREIGN KEY (labor_organization) REFERENCES labor_organization(id) ON DELETE CASCADE;


--
-- Name: labor_organization_membership_labor_organization_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_membership
    ADD CONSTRAINT labor_organization_membership_labor_organization_fkey FOREIGN KEY (labor_organization) REFERENCES labor_organization(id) ON DELETE CASCADE;


--
-- Name: labor_organization_nlrb_decision_labor_organization_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_nlrb_decision
    ADD CONSTRAINT labor_organization_nlrb_decision_labor_organization_fkey FOREIGN KEY (labor_organization) REFERENCES labor_organization(id) ON DELETE CASCADE;


--
-- Name: labor_organization_nlrb_decision_nlrb_decision_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_nlrb_decision
    ADD CONSTRAINT labor_organization_nlrb_decision_nlrb_decision_fkey FOREIGN KEY (nlrb_decision) REFERENCES nlrb_decision(id) ON DELETE CASCADE;


--
-- Name: labor_organization_officer_disbursement_labor_organization_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_officer_disbursement
    ADD CONSTRAINT labor_organization_officer_disbursement_labor_organization_fkey FOREIGN KEY (labor_organization) REFERENCES labor_organization(id) ON DELETE CASCADE;


--
-- Name: labor_organization_osha_citation_labor_organization_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_osha_citation
    ADD CONSTRAINT labor_organization_osha_citation_labor_organization_fkey FOREIGN KEY (labor_organization) REFERENCES labor_organization(id) ON DELETE CASCADE;


--
-- Name: labor_organization_osha_citation_osha_citation_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_osha_citation
    ADD CONSTRAINT labor_organization_osha_citation_osha_citation_fkey FOREIGN KEY (osha_citation) REFERENCES osha_citation(id) ON DELETE CASCADE;


--
-- Name: labor_organization_other_asset_labor_organization_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_other_asset
    ADD CONSTRAINT labor_organization_other_asset_labor_organization_fkey FOREIGN KEY (labor_organization) REFERENCES labor_organization(id) ON DELETE CASCADE;


--
-- Name: labor_organization_other_liability_labor_organization_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_other_liability
    ADD CONSTRAINT labor_organization_other_liability_labor_organization_fkey FOREIGN KEY (labor_organization) REFERENCES labor_organization(id) ON DELETE CASCADE;


--
-- Name: labor_organization_other_receipt_labor_organization_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_other_receipt
    ADD CONSTRAINT labor_organization_other_receipt_labor_organization_fkey FOREIGN KEY (labor_organization) REFERENCES labor_organization(id) ON DELETE CASCADE;


--
-- Name: labor_organization_other_receipt_payee_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_other_receipt
    ADD CONSTRAINT labor_organization_other_receipt_payee_fkey FOREIGN KEY (payee) REFERENCES labor_organization_payee(id) ON DELETE CASCADE;


--
-- Name: labor_organization_payee_address_address_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_payee_address
    ADD CONSTRAINT labor_organization_payee_address_address_fkey FOREIGN KEY (address) REFERENCES address(id) ON DELETE CASCADE;


--
-- Name: labor_organization_payee_address_labor_organization_payee_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_payee_address
    ADD CONSTRAINT labor_organization_payee_address_labor_organization_payee_fkey FOREIGN KEY (labor_organization_payee) REFERENCES labor_organization_payee(id) ON DELETE CASCADE;


--
-- Name: labor_organization_payee_labor_organization_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_payee
    ADD CONSTRAINT labor_organization_payee_labor_organization_fkey FOREIGN KEY (labor_organization) REFERENCES labor_organization(id) ON DELETE CASCADE;


--
-- Name: labor_organization_port_labor_organization_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_port
    ADD CONSTRAINT labor_organization_port_labor_organization_fkey FOREIGN KEY (labor_organization) REFERENCES labor_organization(id) ON DELETE CASCADE;


--
-- Name: labor_organization_port_port_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_port
    ADD CONSTRAINT labor_organization_port_port_fkey FOREIGN KEY (port) REFERENCES port(id) ON DELETE CASCADE;


--
-- Name: labor_organization_rail_node_labor_organization_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_rail_node
    ADD CONSTRAINT labor_organization_rail_node_labor_organization_fkey FOREIGN KEY (labor_organization) REFERENCES labor_organization(id) ON DELETE CASCADE;


--
-- Name: labor_organization_rail_node_rail_node_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_rail_node
    ADD CONSTRAINT labor_organization_rail_node_rail_node_fkey FOREIGN KEY (rail_node) REFERENCES rail_node(id) ON DELETE CASCADE;


--
-- Name: labor_organization_sale_receipt_labor_organization_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_sale_receipt
    ADD CONSTRAINT labor_organization_sale_receipt_labor_organization_fkey FOREIGN KEY (labor_organization) REFERENCES labor_organization(id) ON DELETE CASCADE;


--
-- Name: labor_organization_total_asset_labor_organization_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_total_asset
    ADD CONSTRAINT labor_organization_total_asset_labor_organization_fkey FOREIGN KEY (labor_organization) REFERENCES labor_organization(id) ON DELETE CASCADE;


--
-- Name: labor_organization_total_disbursement_labor_organization_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_total_disbursement
    ADD CONSTRAINT labor_organization_total_disbursement_labor_organization_fkey FOREIGN KEY (labor_organization) REFERENCES labor_organization(id) ON DELETE CASCADE;


--
-- Name: labor_organization_total_liability_labor_organization_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_total_liability
    ADD CONSTRAINT labor_organization_total_liability_labor_organization_fkey FOREIGN KEY (labor_organization) REFERENCES labor_organization(id) ON DELETE CASCADE;


--
-- Name: labor_organization_total_receipt_labor_organization_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_total_receipt
    ADD CONSTRAINT labor_organization_total_receipt_labor_organization_fkey FOREIGN KEY (labor_organization) REFERENCES labor_organization(id) ON DELETE CASCADE;


--
-- Name: labor_organization_warehouse_labor_organization_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_warehouse
    ADD CONSTRAINT labor_organization_warehouse_labor_organization_fkey FOREIGN KEY (labor_organization) REFERENCES labor_organization(id) ON DELETE CASCADE;


--
-- Name: labor_organization_warehouse_warehouse_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_warehouse
    ADD CONSTRAINT labor_organization_warehouse_warehouse_fkey FOREIGN KEY (warehouse) REFERENCES warehouse(id) ON DELETE CASCADE;


--
-- Name: labor_organization_work_stoppage_labor_organization_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_work_stoppage
    ADD CONSTRAINT labor_organization_work_stoppage_labor_organization_fkey FOREIGN KEY (labor_organization) REFERENCES labor_organization(id) ON DELETE CASCADE;


--
-- Name: labor_organization_work_stoppage_work_stoppage_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY labor_organization_work_stoppage
    ADD CONSTRAINT labor_organization_work_stoppage_work_stoppage_fkey FOREIGN KEY (work_stoppage) REFERENCES work_stoppage(id) ON DELETE CASCADE;


--
-- Name: port_address_address_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY port_address
    ADD CONSTRAINT port_address_address_fkey FOREIGN KEY (address) REFERENCES address(id) ON DELETE CASCADE;


--
-- Name: port_address_port_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY port_address
    ADD CONSTRAINT port_address_port_fkey FOREIGN KEY (port) REFERENCES port(id) ON DELETE CASCADE;


--
-- Name: port_tonnage_port_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY port_tonnage
    ADD CONSTRAINT port_tonnage_port_fkey FOREIGN KEY (port) REFERENCES port(id) ON DELETE CASCADE;


--
-- Name: port_work_stoppage_port_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY port_work_stoppage
    ADD CONSTRAINT port_work_stoppage_port_fkey FOREIGN KEY (port) REFERENCES port(id) ON DELETE CASCADE;


--
-- Name: port_work_stoppage_work_stoppage_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY port_work_stoppage
    ADD CONSTRAINT port_work_stoppage_work_stoppage_fkey FOREIGN KEY (work_stoppage) REFERENCES work_stoppage(id) ON DELETE CASCADE;


--
-- Name: rail_line_work_stoppage_rail_line_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY rail_line_work_stoppage
    ADD CONSTRAINT rail_line_work_stoppage_rail_line_fkey FOREIGN KEY (rail_line) REFERENCES rail_line(id) ON DELETE CASCADE;


--
-- Name: rail_line_work_stoppage_work_stoppage_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY rail_line_work_stoppage
    ADD CONSTRAINT rail_line_work_stoppage_work_stoppage_fkey FOREIGN KEY (work_stoppage) REFERENCES work_stoppage(id) ON DELETE CASCADE;


--
-- Name: rail_node_work_stoppage_rail_node_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY rail_node_work_stoppage
    ADD CONSTRAINT rail_node_work_stoppage_rail_node_fkey FOREIGN KEY (rail_node) REFERENCES rail_node(id) ON DELETE CASCADE;


--
-- Name: rail_node_work_stoppage_work_stoppage_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY rail_node_work_stoppage
    ADD CONSTRAINT rail_node_work_stoppage_work_stoppage_fkey FOREIGN KEY (work_stoppage) REFERENCES work_stoppage(id) ON DELETE CASCADE;


--
-- Name: rail_subdivision_state_state_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY rail_subdivision_state
    ADD CONSTRAINT rail_subdivision_state_state_fkey FOREIGN KEY (state) REFERENCES state(id) ON DELETE CASCADE;


--
-- Name: rail_subdivision_state_subdivision_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY rail_subdivision_state
    ADD CONSTRAINT rail_subdivision_state_subdivision_fkey FOREIGN KEY (subdivision) REFERENCES rail_subdivision(id) ON DELETE CASCADE;


--
-- Name: user_role_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY user_role
    ADD CONSTRAINT user_role_role_fkey FOREIGN KEY (role) REFERENCES role(id) ON DELETE CASCADE;


--
-- Name: user_role_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY user_role
    ADD CONSTRAINT user_role_user_fkey FOREIGN KEY ("user") REFERENCES "user"(id) ON DELETE CASCADE;


--
-- Name: warehouse_address_address_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY warehouse_address
    ADD CONSTRAINT warehouse_address_address_fkey FOREIGN KEY (address) REFERENCES address(id) ON DELETE CASCADE;


--
-- Name: warehouse_address_warehouse_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY warehouse_address
    ADD CONSTRAINT warehouse_address_warehouse_fkey FOREIGN KEY (warehouse) REFERENCES warehouse(id) ON DELETE CASCADE;


--
-- Name: warehouse_owner_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY warehouse
    ADD CONSTRAINT warehouse_owner_fkey FOREIGN KEY (owner) REFERENCES warehouse_owner(id);


--
-- Name: warehouse_walmart_walmart_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY warehouse_walmart
    ADD CONSTRAINT warehouse_walmart_walmart_fkey FOREIGN KEY (walmart) REFERENCES walmart(id) ON DELETE CASCADE;


--
-- Name: warehouse_walmart_warehouse_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY warehouse_walmart
    ADD CONSTRAINT warehouse_walmart_warehouse_fkey FOREIGN KEY (warehouse) REFERENCES warehouse(id) ON DELETE CASCADE;


--
-- Name: warehouse_work_stoppage_warehouse_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY warehouse_work_stoppage
    ADD CONSTRAINT warehouse_work_stoppage_warehouse_fkey FOREIGN KEY (warehouse) REFERENCES warehouse(id) ON DELETE CASCADE;


--
-- Name: warehouse_work_stoppage_work_stoppage_fkey; Type: FK CONSTRAINT; Schema: public; Owner: el
--

ALTER TABLE ONLY warehouse_work_stoppage
    ADD CONSTRAINT warehouse_work_stoppage_work_stoppage_fkey FOREIGN KEY (work_stoppage) REFERENCES work_stoppage(id) ON DELETE CASCADE;


SET search_path = sqitch, pg_catalog;

--
-- Name: changes_project_fkey; Type: FK CONSTRAINT; Schema: sqitch; Owner: el
--

ALTER TABLE ONLY changes
    ADD CONSTRAINT changes_project_fkey FOREIGN KEY (project) REFERENCES projects(project) ON UPDATE CASCADE;


--
-- Name: dependencies_change_id_fkey; Type: FK CONSTRAINT; Schema: sqitch; Owner: el
--

ALTER TABLE ONLY dependencies
    ADD CONSTRAINT dependencies_change_id_fkey FOREIGN KEY (change_id) REFERENCES changes(change_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: dependencies_dependency_id_fkey; Type: FK CONSTRAINT; Schema: sqitch; Owner: el
--

ALTER TABLE ONLY dependencies
    ADD CONSTRAINT dependencies_dependency_id_fkey FOREIGN KEY (dependency_id) REFERENCES changes(change_id) ON UPDATE CASCADE;


--
-- Name: events_project_fkey; Type: FK CONSTRAINT; Schema: sqitch; Owner: el
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_project_fkey FOREIGN KEY (project) REFERENCES projects(project) ON UPDATE CASCADE;


--
-- Name: tags_change_id_fkey; Type: FK CONSTRAINT; Schema: sqitch; Owner: el
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_change_id_fkey FOREIGN KEY (change_id) REFERENCES changes(change_id) ON UPDATE CASCADE;


--
-- Name: tags_project_fkey; Type: FK CONSTRAINT; Schema: sqitch; Owner: el
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_project_fkey FOREIGN KEY (project) REFERENCES projects(project) ON UPDATE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

