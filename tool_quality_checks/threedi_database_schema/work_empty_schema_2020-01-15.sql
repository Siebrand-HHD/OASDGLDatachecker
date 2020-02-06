--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.24
-- Dumped by pg_dump version 12.1

-- Started on 2020-01-15 15:13:29

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
-- TOC entry 10 (class 2615 OID 20827)
-- Name: topology; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA topology;


--
-- TOC entry 2 (class 3079 OID 19541)
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- TOC entry 4154 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- TOC entry 3 (class 3079 OID 20828)
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- TOC entry 4155 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


--
-- TOC entry 1473 (class 1255 OID 16430156)
-- Name: count_node(anyarray, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.count_node(anyarray, node_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
                DECLARE
                  table_name text;
                  sel_count integer;
                  counter integer;
                BEGIN
                counter := 0;
                FOREACH table_name IN ARRAY $1
                LOOP
                  RAISE NOTICE 'processing table %',table_name;
                  EXECUTE format('
                 SELECT COUNT(*) FROM %I AS x
                    WHERE x.connection_node_start_id = %L
                    OR x.connection_node_end_id = %L'
                      , table_name, $2, $2)
                     INTO sel_count;
                  RAISE NOTICE 'counted % appearences of
                     connection_node_id % ', sel_count, $2;
                  counter := counter + sel_count;
                  IF counter > 1 THEN
                 EXIT;
                  END IF;
                END LOOP;
                RETURN counter;
                END
                $_$;


--
-- TOC entry 1476 (class 1255 OID 16430221)
-- Name: format_input_str(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.format_input_str() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
                BEGIN
                    -- make sure the name field is nicely formated
                    NEW.name := LOWER(REPLACE(NEW.name, ' ', '_'));
                    RETURN NEW;
                END;
            $$;


--
-- TOC entry 1475 (class 1255 OID 16430202)
-- Name: geom_to_grid(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.geom_to_grid() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
                BEGIN
                    -- Check that the geomtry we want to snap is valid
                    IF ST_IsValid(NEW.the_geom) = 'f' THEN
                        RAISE EXCEPTION 'invalid geometry, cannot be snaped to grid';
                    END IF;

                    -- snap the geometry to a grid (precision is 1mm)
                    NEW.the_geom := ST_SnapToGrid(NEW.the_geom, 0, 0, 0.001, 0.001);

                    RETURN NEW;
                END;
            $$;


--
-- TOC entry 1419 (class 1255 OID 16430152)
-- Name: intersects_channel(public.geometry, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.intersects_channel(x_sec_geom public.geometry, x_sec_channel_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
        DECLARE
          result integer;
        BEGIN
            SELECT COUNT(*)::integer FROM v2_channel AS c
            WHERE ($2 = c.id)
            AND
            (ST_Intersects(c.the_geom, $1))
            INTO result;
            IF result > 0 THEN
               UPDATE
                  v2_channel
               SET
                  the_geom = ST_LineMerge(
                     ST_Union(
                        ST_Line_Substring(v2_channel.the_geom, 0, ST_Line_Locate_Point(v2_channel.the_geom, $1)),
                        ST_Line_Substring(v2_channel.the_geom, ST_Line_Locate_Point(v2_channel.the_geom, $1), 1)
                     ))
                WHERE ($2 = v2_channel.id);
            END IF;
            return result;
        END
        $_$;


--
-- TOC entry 1369 (class 1255 OID 16430149)
-- Name: intersects_connection_node(public.geometry, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.intersects_connection_node(channel_geom public.geometry, channel_start_id integer, channel_end_id integer) RETURNS integer
    LANGUAGE sql STABLE
    AS $_$
                SELECT COUNT(*)::integer FROM v2_connection_nodes AS c
                  WHERE
                    ($2 = c.id OR $3 = c.id)
                  AND
                    (ST_Intersects(c.the_geom, ST_StartPoint($1))
                      OR
                     ST_Intersects(c.the_geom, ST_EndPoint($1)))
              $_$;


--
-- TOC entry 1474 (class 1255 OID 16430158)
-- Name: on_channel(integer, public.geometry); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.on_channel(channel_pk integer, pnt_geom public.geometry) RETURNS integer
    LANGUAGE sql STABLE
    AS $_$
           SELECT COUNT(*)::integer FROM v2_channel AS c
           WHERE  c.id = $1
           AND ST_Intersects(c.the_geom, $2);
           $_$;


--
-- TOC entry 209 (class 1259 OID 16428192)
-- Name: boundary_line; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.boundary_line (
    postgres_pk integer,
    display_name character varying(255) NOT NULL,
    timeseries text,
    boundary_type integer,
    inp_id integer NOT NULL,
    the_geom public.geometry(LineString,28992)
);


--
-- TOC entry 210 (class 1259 OID 16428200)
-- Name: boundary_point; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.boundary_point (
    postgres_pk integer,
    display_name character varying(255) NOT NULL,
    channel_id integer,
    timeseries text,
    boundary_node integer,
    boundary_type integer,
    inp_id integer NOT NULL
);


--
-- TOC entry 200 (class 1259 OID 16428135)
-- Name: bridge; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bridge (
    display_name character varying(255) NOT NULL,
    channel_id integer,
    ground_level_upstream double precision,
    ground_level_downstream double precision,
    length double precision,
    category integer,
    bedfriction_type integer,
    bedfriction double precision,
    width double precision,
    height double precision,
    angle double precision,
    code character varying(255),
    inp_id integer NOT NULL,
    the_geom public.geometry(Point,28992)
);


--
-- TOC entry 195 (class 1259 OID 16428095)
-- Name: channel; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.channel (
    display_name character varying(255),
    code character varying(100),
    type integer,
    boundary integer,
    category integer,
    dist_calc_points integer,
    bank_level double precision,
    inp_id integer NOT NULL,
    the_geom public.geometry(LineString,28992)
);


--
-- TOC entry 206 (class 1259 OID 16428173)
-- Name: cross_section; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cross_section (
    channel_id integer,
    definition_id integer,
    bottom_level double precision,
    friction_type integer,
    friction_value double precision,
    inp_id integer NOT NULL,
    the_geom public.geometry(Point,28992)
);


--
-- TOC entry 205 (class 1259 OID 16428164)
-- Name: cross_section_definition; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cross_section_definition (
    id integer NOT NULL,
    shape integer,
    width character varying(255),
    diameter double precision,
    level character varying(255),
    y character varying(255),
    z character varying(255),
    closed boolean,
    height double precision
);


--
-- TOC entry 204 (class 1259 OID 16428162)
-- Name: cross_section_definition_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cross_section_definition_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4156 (class 0 OID 0)
-- Dependencies: 204
-- Name: cross_section_definition_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cross_section_definition_id_seq OWNED BY public.cross_section_definition.id;


--
-- TOC entry 198 (class 1259 OID 16428119)
-- Name: culvert; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.culvert (
    display_name character varying(255) NOT NULL,
    channel_id integer,
    ground_level_upstream double precision,
    ground_level_downstream double precision,
    length double precision,
    allowed_flow_dir integer,
    category integer,
    inletlosscoeff double precision,
    outletlosscoeff double precision,
    bedfriction_type integer,
    bedfriction double precision,
    initial_valve_opening double precision,
    relative_opening character varying(255),
    reduction_factor character varying(255),
    shape integer,
    width double precision,
    diameter double precision,
    height double precision,
    angle double precision,
    type character varying(255),
    code character varying(255),
    inp_id integer NOT NULL,
    the_geom public.geometry(Point,28992)
);


--
-- TOC entry 215 (class 1259 OID 16428240)
-- Name: floodfill; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.floodfill (
    id integer NOT NULL,
    waterlevel double precision,
    the_geom public.geometry(Point,28992)
);


--
-- TOC entry 214 (class 1259 OID 16428238)
-- Name: floodfill_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.floodfill_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4157 (class 0 OID 0)
-- Dependencies: 214
-- Name: floodfill_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.floodfill_id_seq OWNED BY public.floodfill.id;


--
-- TOC entry 221 (class 1259 OID 16428379)
-- Name: global_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.global_settings (
    id integer NOT NULL,
    has_sewerage boolean NOT NULL,
    has_rural boolean NOT NULL,
    has_interflow boolean NOT NULL,
    use_2d_flow integer,
    name character varying(128),
    sim_time_step double precision,
    output_time_step double precision,
    nr_timesteps integer,
    start_time timestamp with time zone,
    grid_space double precision,
    dist_calc_points double precision,
    kmax integer,
    bath_delta double precision,
    bath_max double precision,
    guess_dams integer,
    integration_method integer,
    max_nonlin_iterations integer,
    convergence_eps double precision,
    table_step_size double precision,
    max_degree integer,
    use_of_cg integer,
    use_of_nested_newton integer,
    num_pred_cor integer,
    flooding_threshold double precision,
    open_link_check integer,
    min_reach_length double precision,
    advection_1d integer,
    advection_2d integer,
    priceman_slot integer,
    dem_file character varying(255),
    frict_type integer,
    frict_coef double precision,
    frict_coef_file character varying(255),
    water_level_ini_type integer,
    initial_waterlevel double precision,
    initial_waterlevel_file character varying(255),
    num_layers integer,
    evaporation integer,
    max_interception double precision,
    max_interception_file character varying(255),
    interception_ini_type integer,
    interception_ini double precision,
    interception_ini_file character varying(255),
    infiltration_rate double precision,
    infiltration_rate_file character varying(255),
    moisture_content integer,
    ground_layer_elevation double precision,
    ground_layer_elevation_absolute integer,
    ground_water_level_ini double precision,
    ground_water_level_ini_file character varying(255),
    soil_type_file character varying(255),
    crop_type_file character varying(255),
    hydraulic_conductivity_x double precision,
    hydraulic_conductivity_y double precision,
    hydraulic_conductivity_file character varying(255),
    hydraulic_conductivity_file_x character varying(255),
    hydraulic_conductivity_file_y character varying(255),
    river_resistance double precision,
    river_resistance_file character varying(255),
    seepage character varying(255),
    porosity_layer_thickness double precision,
    porosity double precision,
    impervious_layer_elevation double precision,
    manhole_storage_area double precision
);


--
-- TOC entry 220 (class 1259 OID 16428377)
-- Name: global_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.global_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4158 (class 0 OID 0)
-- Dependencies: 220
-- Name: global_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.global_settings_id_seq OWNED BY public.global_settings.id;


--
-- TOC entry 213 (class 1259 OID 16428218)
-- Name: grid_refinement; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.grid_refinement (
    id integer NOT NULL,
    display_name character varying(255) NOT NULL,
    refinement_level integer,
    the_geom public.geometry(LineString,28992)
);


--
-- TOC entry 212 (class 1259 OID 16428216)
-- Name: grid_refinement_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.grid_refinement_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4159 (class 0 OID 0)
-- Dependencies: 212
-- Name: grid_refinement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.grid_refinement_id_seq OWNED BY public.grid_refinement.id;


--
-- TOC entry 202 (class 1259 OID 16428145)
-- Name: initial_waterlevel; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.initial_waterlevel (
    id integer NOT NULL,
    waterlevel double precision,
    the_geom public.geometry(Polygon,28992),
    waterlevel_summer double precision,
    waterlevel_winter double precision
);


--
-- TOC entry 201 (class 1259 OID 16428143)
-- Name: initial_waterlevel_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.initial_waterlevel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4160 (class 0 OID 0)
-- Dependencies: 201
-- Name: initial_waterlevel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.initial_waterlevel_id_seq OWNED BY public.initial_waterlevel.id;


--
-- TOC entry 211 (class 1259 OID 16428208)
-- Name: lateral; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."lateral" (
    postgres_pk integer,
    display_name character varying(255) NOT NULL,
    channel_id integer,
    timeseries text,
    inp_id integer NOT NULL,
    the_geom public.geometry(Point,28992)
);


--
-- TOC entry 203 (class 1259 OID 16428154)
-- Name: levee; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.levee (
    display_name character varying(255) NOT NULL,
    crest_level double precision,
    inp_id integer NOT NULL,
    the_geom public.geometry(LineString,28992)
);


--
-- TOC entry 223 (class 1259 OID 16428691)
-- Name: levee_chk; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.levee_chk (
    id integer NOT NULL,
    chk_original_pk integer NOT NULL,
    chk_original_geom public.geometry(Geometry,28992),
    chk_name character varying(255) NOT NULL,
    chk_ini character varying(255),
    chk_diff double precision,
    chk_msg character varying(255),
    display_name character varying(255) NOT NULL,
    crest_level double precision,
    the_geom public.geometry(LineString,28992)
);


--
-- TOC entry 222 (class 1259 OID 16428689)
-- Name: levee_chk_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.levee_chk_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4161 (class 0 OID 0)
-- Dependencies: 222
-- Name: levee_chk_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.levee_chk_id_seq OWNED BY public.levee_chk.id;


--
-- TOC entry 208 (class 1259 OID 16428183)
-- Name: manhole_2d; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.manhole_2d (
    id integer NOT NULL,
    type integer,
    discharge double precision,
    the_geom public.geometry(Point,28992)
);


--
-- TOC entry 207 (class 1259 OID 16428181)
-- Name: manhole_2d_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.manhole_2d_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4162 (class 0 OID 0)
-- Dependencies: 207
-- Name: manhole_2d_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.manhole_2d_id_seq OWNED BY public.manhole_2d.id;


--
-- TOC entry 199 (class 1259 OID 16428127)
-- Name: orifice; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.orifice (
    display_name character varying(255) NOT NULL,
    channel_id integer,
    crest_width double precision,
    crest_level double precision,
    opening_level double precision,
    contraction_coeff double precision,
    lat_contr_coeff double precision,
    allowed_flow_dir integer,
    category integer,
    negative_flow_limit double precision,
    positive_flow_limit double precision,
    flow_type integer,
    shape character varying(4),
    angle double precision,
    start_point_id integer,
    end_point_id integer,
    connection_serial integer,
    type character varying(255),
    code character varying(255),
    inp_id integer NOT NULL,
    the_geom public.geometry(Point,28992)
);


--
-- TOC entry 224 (class 1259 OID 16428739)
-- Name: potential_cross_section; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.potential_cross_section (
    inp_id integer NOT NULL,
    channel_id integer,
    definition_id integer,
    bottom_level double precision,
    friction_type integer,
    friction_value double precision,
    the_geom public.geometry(Point,28992)
);


--
-- TOC entry 219 (class 1259 OID 16428368)
-- Name: pumped_drainage_area; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pumped_drainage_area (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    code character varying(100) NOT NULL,
    the_geom public.geometry(Polygon,28992) NOT NULL
);


--
-- TOC entry 218 (class 1259 OID 16428366)
-- Name: pumped_drainage_area_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pumped_drainage_area_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4163 (class 0 OID 0)
-- Dependencies: 218
-- Name: pumped_drainage_area_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pumped_drainage_area_id_seq OWNED BY public.pumped_drainage_area.id;


--
-- TOC entry 196 (class 1259 OID 16428103)
-- Name: pumpstation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pumpstation (
    display_name character varying(255) NOT NULL,
    channel_id integer,
    allowed_flow_dir integer,
    capacity double precision,
    start_level_suction_side double precision,
    stop_level_suction_side double precision,
    start_level_delivery_side double precision,
    stop_level_delivery_side double precision,
    category integer,
    head character varying(255),
    reduction_factor character varying(255),
    angle double precision,
    start_point_id integer,
    end_point_id integer,
    connection_serial integer,
    type character varying(255),
    code character varying(255),
    inp_id integer NOT NULL,
    the_geom public.geometry(Point,28992)
);


--
-- TOC entry 217 (class 1259 OID 16428251)
-- Name: settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.settings (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    water_level_ini_type integer,
    interception_ini_type integer,
    max_interception double precision,
    grid_space integer,
    kmax integer,
    bath_delta double precision,
    bath_max double precision,
    guess_dams integer,
    water_level_ini double precision,
    integration_method integer,
    max_nonlin_iterations integer,
    num_pred_cor integer,
    convergence_eps double precision,
    flooding_threshold double precision,
    open_link_check integer,
    advection integer,
    priceman_slot integer,
    frict_type integer,
    frict_coef double precision,
    num_layers integer,
    ground_layer_elevation double precision,
    ground_layer_elevation_absolute integer,
    ground_water_level_ini double precision,
    ground_water_level_ini_file character varying(255),
    moisture_content integer,
    hydr_cond_x double precision,
    hydr_cond_y double precision,
    sim_time_step integer,
    start_time timestamp with time zone,
    evaporation integer,
    initial_waterlevel_file character varying(255),
    dem_file character varying(255),
    max_interception_file character varying(255),
    frict_coef_file character varying(255),
    infiltration_rate_file character varying(255),
    soil_type_file character varying(255),
    crop_type_file character varying(255),
    hydraulic_conductivity_file character varying(255),
    hydraulic_conductivity_file_x character varying(255),
    hydraulic_conductivity_file_y character varying(255),
    interception_ini_file character varying(255),
    river_resistance_file character varying(255),
    interception_ini double precision,
    seepage_file character varying(255)
);


--
-- TOC entry 216 (class 1259 OID 16428249)
-- Name: settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4164 (class 0 OID 0)
-- Dependencies: 216
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.settings_id_seq OWNED BY public.settings.id;


--
-- TOC entry 194 (class 1259 OID 16428080)
-- Name: south_migrationhistory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.south_migrationhistory (
    id integer NOT NULL,
    app_name character varying(255) NOT NULL,
    migration character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


--
-- TOC entry 193 (class 1259 OID 16428078)
-- Name: south_migrationhistory_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.south_migrationhistory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4165 (class 0 OID 0)
-- Dependencies: 193
-- Name: south_migrationhistory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.south_migrationhistory_id_seq OWNED BY public.south_migrationhistory.id;


--
-- TOC entry 230 (class 1259 OID 16429122)
-- Name: v2_1d_boundary_conditions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_1d_boundary_conditions (
    id integer NOT NULL,
    connection_node_id integer NOT NULL,
    boundary_type integer,
    timeseries text,
    CONSTRAINT boundary_must_have_only_one_connection CHECK ((public.count_node(ARRAY['v2_channel'::text, 'v2_weir'::text, 'v2_orifice'::text, 'v2_culvert'::text, 'v2_pipe'::text, 'v2_pumpstation'::text], connection_node_id) = 1))
);


--
-- TOC entry 229 (class 1259 OID 16429120)
-- Name: v2_1d_boundary_conditions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_1d_boundary_conditions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4166 (class 0 OID 0)
-- Dependencies: 229
-- Name: v2_1d_boundary_conditions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_1d_boundary_conditions_id_seq OWNED BY public.v2_1d_boundary_conditions.id;


--
-- TOC entry 240 (class 1259 OID 16429213)
-- Name: v2_1d_lateral; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_1d_lateral (
    id integer NOT NULL,
    connection_node_id integer NOT NULL,
    timeseries text
);


--
-- TOC entry 239 (class 1259 OID 16429211)
-- Name: v2_1d_lateral_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_1d_lateral_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4167 (class 0 OID 0)
-- Dependencies: 239
-- Name: v2_1d_lateral_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_1d_lateral_id_seq OWNED BY public.v2_1d_lateral.id;


--
-- TOC entry 264 (class 1259 OID 16429471)
-- Name: v2_2d_boundary_conditions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_2d_boundary_conditions (
    id integer NOT NULL,
    display_name character varying(255) NOT NULL,
    timeseries text,
    boundary_type integer,
    the_geom public.geometry(LineString,28992)
);


--
-- TOC entry 263 (class 1259 OID 16429469)
-- Name: v2_2d_boundary_conditions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_2d_boundary_conditions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4168 (class 0 OID 0)
-- Dependencies: 263
-- Name: v2_2d_boundary_conditions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_2d_boundary_conditions_id_seq OWNED BY public.v2_2d_boundary_conditions.id;


--
-- TOC entry 254 (class 1259 OID 16429386)
-- Name: v2_2d_lateral; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_2d_lateral (
    id integer NOT NULL,
    type integer,
    the_geom public.geometry(Point,28992),
    timeseries text
);


--
-- TOC entry 253 (class 1259 OID 16429384)
-- Name: v2_2d_lateral_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_2d_lateral_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4169 (class 0 OID 0)
-- Dependencies: 253
-- Name: v2_2d_lateral_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_2d_lateral_id_seq OWNED BY public.v2_2d_lateral.id;


--
-- TOC entry 274 (class 1259 OID 16429572)
-- Name: v2_aggregation_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_aggregation_settings (
    id integer NOT NULL,
    global_settings_id integer,
    var_name character varying(100) NOT NULL,
    flow_variable character varying(100),
    aggregation_method character varying(100) NOT NULL,
    aggregation_in_space boolean NOT NULL,
    timestep integer NOT NULL,
    CONSTRAINT aggregate_method CHECK (((aggregation_method)::text = ANY ((ARRAY['med'::character varying, 'max'::character varying, 'cum_negative'::character varying, 'duration_negative'::character varying, 'cum_positive'::character varying, 'min'::character varying, 'duration_positive'::character varying, 'cum'::character varying, 'avg'::character varying])::text[]))),
    CONSTRAINT aggregate_var CHECK ((((flow_variable)::text = ANY ((ARRAY['max_timestep'::character varying, 'vol_2D_groundwater_sum'::character varying, 'vol_2D_rain'::character varying, 'min_timestep'::character varying, 'vol_2D_lateral'::character varying, 'surface_source_sink_discharge'::character varying, 'flow_velocity'::character varying, 'leakage'::character varying, 'vol_pumps_drained'::character varying, 'interception'::character varying, 'vol_2D_sum'::character varying, 'max_surface_grid'::character varying, 'vol_1D_lateral'::character varying, 'vol_inflow_bounds'::character varying, 'init_2D_volume'::character varying, 'wet_cross-section'::character varying, 'pump_discharge'::character varying, 'rain'::character varying, 'volume'::character varying, 'vol_1D_rain'::character varying, 'init_1D_volume'::character varying, 'discharge'::character varying, 'sum_2D_infil'::character varying, 'lateral_discharge'::character varying, 'waterlevel'::character varying, 'vol_1D_sum'::character varying, 'simple_infiltration'::character varying, 'wet_surface'::character varying, 'vol_outflow_bounds'::character varying])::text[])) OR (((flow_variable IS NULL) OR ((flow_variable)::text = ''::text)) AND ((var_name)::text = ANY ((ARRAY['max_timestep'::character varying, 'vol_2D_groundwater_sum'::character varying, 'vol_2D_rain'::character varying, 'min_timestep'::character varying, 'vol_2D_lateral'::character varying, 'surface_source_sink_discharge'::character varying, 'flow_velocity'::character varying, 'leakage'::character varying, 'vol_pumps_drained'::character varying, 'interception'::character varying, 'vol_2D_sum'::character varying, 'max_surface_grid'::character varying, 'vol_1D_lateral'::character varying, 'vol_inflow_bounds'::character varying, 'init_2D_volume'::character varying, 'wet_cross-section'::character varying, 'pump_discharge'::character varying, 'rain'::character varying, 'volume'::character varying, 'vol_1D_rain'::character varying, 'init_1D_volume'::character varying, 'discharge'::character varying, 'sum_2D_infil'::character varying, 'lateral_discharge'::character varying, 'waterlevel'::character varying, 'vol_1D_sum'::character varying, 'simple_infiltration'::character varying, 'wet_surface'::character varying, 'vol_outflow_bounds'::character varying])::text[])))))
);


--
-- TOC entry 273 (class 1259 OID 16429570)
-- Name: v2_aggregation_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_aggregation_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4170 (class 0 OID 0)
-- Dependencies: 273
-- Name: v2_aggregation_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_aggregation_settings_id_seq OWNED BY public.v2_aggregation_settings.id;


--
-- TOC entry 276 (class 1259 OID 16429595)
-- Name: v2_calculation_point; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_calculation_point (
    id integer NOT NULL,
    content_type_id integer NOT NULL,
    user_ref character varying(80) NOT NULL,
    calc_type integer NOT NULL,
    the_geom public.geometry(Point,28992) NOT NULL
);


--
-- TOC entry 275 (class 1259 OID 16429593)
-- Name: v2_calculation_point_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_calculation_point_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4171 (class 0 OID 0)
-- Dependencies: 275
-- Name: v2_calculation_point_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_calculation_point_id_seq OWNED BY public.v2_calculation_point.id;


--
-- TOC entry 234 (class 1259 OID 16429154)
-- Name: v2_channel; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_channel (
    id integer NOT NULL,
    display_name character varying(255) NOT NULL,
    code character varying(100) NOT NULL,
    calculation_type integer,
    dist_calc_points double precision,
    zoom_category integer,
    the_geom public.geometry(LineString,28992) NOT NULL,
    connection_node_start_id integer,
    connection_node_end_id integer,
    CONSTRAINT has_two_connection_nodes CHECK ((public.intersects_connection_node(the_geom, connection_node_start_id, connection_node_end_id) = 2))
);


--
-- TOC entry 233 (class 1259 OID 16429152)
-- Name: v2_channel_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_channel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4172 (class 0 OID 0)
-- Dependencies: 233
-- Name: v2_channel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_channel_id_seq OWNED BY public.v2_channel.id;


--
-- TOC entry 278 (class 1259 OID 16429607)
-- Name: v2_connected_pnt; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_connected_pnt (
    id integer NOT NULL,
    exchange_level double precision,
    calculation_pnt_id integer NOT NULL,
    levee_id integer,
    the_geom public.geometry(Point,28992) NOT NULL
);


--
-- TOC entry 277 (class 1259 OID 16429605)
-- Name: v2_connected_pnt_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_connected_pnt_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4173 (class 0 OID 0)
-- Dependencies: 277
-- Name: v2_connected_pnt_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_connected_pnt_id_seq OWNED BY public.v2_connected_pnt.id;


--
-- TOC entry 228 (class 1259 OID 16429109)
-- Name: v2_connection_nodes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_connection_nodes (
    id integer NOT NULL,
    storage_area double precision,
    initial_waterlevel double precision,
    the_geom public.geometry(Point,28992) NOT NULL,
    the_geom_linestring public.geometry(LineString,28992),
    code character varying(100) NOT NULL
);


--
-- TOC entry 227 (class 1259 OID 16429107)
-- Name: v2_connection_nodes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_connection_nodes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4174 (class 0 OID 0)
-- Dependencies: 227
-- Name: v2_connection_nodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_connection_nodes_id_seq OWNED BY public.v2_connection_nodes.id;


--
-- TOC entry 288 (class 1259 OID 16429917)
-- Name: v2_control; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_control (
    id integer NOT NULL,
    control_group_id integer,
    control_type character varying(15),
    control_id integer,
    measure_group_id integer,
    start character varying(50),
    "end" character varying(50),
    measure_frequency integer
);


--
-- TOC entry 296 (class 1259 OID 16429967)
-- Name: v2_control_delta; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_control_delta (
    id integer NOT NULL,
    measure_variable character varying(50),
    measure_delta double precision,
    measure_dt double precision,
    action_type character varying(50),
    action_value character varying(50),
    action_time double precision,
    target_type character varying(100),
    target_id integer
);


--
-- TOC entry 295 (class 1259 OID 16429965)
-- Name: v2_control_delta_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_control_delta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4175 (class 0 OID 0)
-- Dependencies: 295
-- Name: v2_control_delta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_control_delta_id_seq OWNED BY public.v2_control_delta.id;


--
-- TOC entry 280 (class 1259 OID 16429713)
-- Name: v2_control_group; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_control_group (
    id integer NOT NULL,
    name character varying(100),
    description text
);


--
-- TOC entry 279 (class 1259 OID 16429711)
-- Name: v2_control_group_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_control_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4176 (class 0 OID 0)
-- Dependencies: 279
-- Name: v2_control_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_control_group_id_seq OWNED BY public.v2_control_group.id;


--
-- TOC entry 287 (class 1259 OID 16429915)
-- Name: v2_control_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_control_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4177 (class 0 OID 0)
-- Dependencies: 287
-- Name: v2_control_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_control_id_seq OWNED BY public.v2_control.id;


--
-- TOC entry 286 (class 1259 OID 16429874)
-- Name: v2_control_measure_group; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_control_measure_group (
    id integer NOT NULL
);


--
-- TOC entry 285 (class 1259 OID 16429872)
-- Name: v2_control_measure_group_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_control_measure_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4178 (class 0 OID 0)
-- Dependencies: 285
-- Name: v2_control_measure_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_control_measure_group_id_seq OWNED BY public.v2_control_measure_group.id;


--
-- TOC entry 290 (class 1259 OID 16429937)
-- Name: v2_control_measure_map; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_control_measure_map (
    id integer NOT NULL,
    measure_group_id integer,
    object_type character varying(100),
    object_id integer,
    weight numeric(3,2)
);


--
-- TOC entry 289 (class 1259 OID 16429935)
-- Name: v2_control_measure_map_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_control_measure_map_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4179 (class 0 OID 0)
-- Dependencies: 289
-- Name: v2_control_measure_map_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_control_measure_map_id_seq OWNED BY public.v2_control_measure_map.id;


--
-- TOC entry 292 (class 1259 OID 16429951)
-- Name: v2_control_memory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_control_memory (
    id integer NOT NULL,
    measure_variable character varying(50),
    upper_threshold double precision,
    lower_threshold double precision,
    action_type character varying(50),
    action_value character varying(50),
    target_type character varying(100),
    target_id integer,
    is_active boolean NOT NULL,
    is_inverse boolean NOT NULL
);


--
-- TOC entry 291 (class 1259 OID 16429949)
-- Name: v2_control_memory_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_control_memory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4180 (class 0 OID 0)
-- Dependencies: 291
-- Name: v2_control_memory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_control_memory_id_seq OWNED BY public.v2_control_memory.id;


--
-- TOC entry 294 (class 1259 OID 16429959)
-- Name: v2_control_pid; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_control_pid (
    id integer NOT NULL,
    measure_variable character varying(50),
    setpoint double precision,
    kp double precision,
    ki double precision,
    kd double precision,
    action_type character varying(50),
    target_type character varying(100),
    target_id integer,
    target_upper_limit character varying(50),
    target_lower_limit character varying(50)
);


--
-- TOC entry 293 (class 1259 OID 16429957)
-- Name: v2_control_pid_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_control_pid_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4181 (class 0 OID 0)
-- Dependencies: 293
-- Name: v2_control_pid_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_control_pid_id_seq OWNED BY public.v2_control_pid.id;


--
-- TOC entry 284 (class 1259 OID 16429857)
-- Name: v2_control_table; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_control_table (
    id integer NOT NULL,
    action_table text,
    action_type character varying(50),
    measure_variable character varying(50),
    measure_operator character varying(2),
    target_type character varying(100),
    target_id integer
);


--
-- TOC entry 283 (class 1259 OID 16429855)
-- Name: v2_control_table_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_control_table_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4182 (class 0 OID 0)
-- Dependencies: 283
-- Name: v2_control_table_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_control_table_id_seq OWNED BY public.v2_control_table.id;


--
-- TOC entry 298 (class 1259 OID 16429975)
-- Name: v2_control_timed; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_control_timed (
    id integer NOT NULL,
    action_type character varying(50),
    action_table text,
    target_type character varying(100),
    target_id integer
);


--
-- TOC entry 297 (class 1259 OID 16429973)
-- Name: v2_control_timed_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_control_timed_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4183 (class 0 OID 0)
-- Dependencies: 297
-- Name: v2_control_timed_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_control_timed_id_seq OWNED BY public.v2_control_timed.id;


--
-- TOC entry 236 (class 1259 OID 16429178)
-- Name: v2_cross_section_definition; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_cross_section_definition (
    id integer NOT NULL,
    shape integer,
    width character varying(255),
    height character varying(255),
    code character varying(100) NOT NULL
);


--
-- TOC entry 235 (class 1259 OID 16429176)
-- Name: v2_cross_section_definition_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_cross_section_definition_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4184 (class 0 OID 0)
-- Dependencies: 235
-- Name: v2_cross_section_definition_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_cross_section_definition_id_seq OWNED BY public.v2_cross_section_definition.id;


--
-- TOC entry 238 (class 1259 OID 16429189)
-- Name: v2_cross_section_location; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_cross_section_location (
    id integer NOT NULL,
    channel_id integer,
    definition_id integer,
    reference_level double precision,
    friction_type integer,
    friction_value double precision,
    bank_level double precision,
    the_geom public.geometry(Point,28992),
    code character varying(100) NOT NULL,
    CONSTRAINT lies_on_channel_vertex CHECK ((public.intersects_channel(the_geom, channel_id) = 1))
);


--
-- TOC entry 237 (class 1259 OID 16429187)
-- Name: v2_cross_section_location_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_cross_section_location_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4185 (class 0 OID 0)
-- Dependencies: 237
-- Name: v2_cross_section_location_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_cross_section_location_id_seq OWNED BY public.v2_cross_section_location.id;


--
-- TOC entry 322 (class 1259 OID 16430192)
-- Name: v2_cross_section_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v2_cross_section_view AS
 SELECT def.id AS def_id,
    def.shape AS def_shape,
    def.width AS def_width,
    def.height AS def_height,
    def.code AS def_code,
    l.id AS l_id,
    l.channel_id AS l_channel_id,
    l.definition_id AS l_definition_id,
    l.reference_level AS l_reference_level,
    l.friction_type AS l_friction_type,
    l.friction_value AS l_friction_value,
    l.bank_level AS l_bank_level,
    l.code AS l_code,
    l.the_geom,
    ch.id AS ch_id,
    ch.display_name AS ch_display_name,
    ch.code AS ch_code,
    ch.calculation_type AS ch_calculation_type,
    ch.dist_calc_points AS ch_dist_calc_points,
    ch.zoom_category AS ch_zoom_category,
    ch.connection_node_start_id AS ch_connection_node_start_id,
    ch.connection_node_end_id AS ch_connection_node_end_id
   FROM public.v2_cross_section_definition def,
    public.v2_cross_section_location l,
    public.v2_channel ch
  WHERE ((l.definition_id = def.id) AND (l.channel_id = ch.id));


--
-- TOC entry 252 (class 1259 OID 16429338)
-- Name: v2_culvert; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_culvert (
    id integer NOT NULL,
    display_name character varying(255) NOT NULL,
    code character varying(100) NOT NULL,
    calculation_type integer,
    friction_value double precision,
    friction_type integer,
    dist_calc_points double precision,
    zoom_category integer,
    cross_section_definition_id integer,
    discharge_coefficient_positive double precision NOT NULL,
    discharge_coefficient_negative double precision NOT NULL,
    invert_level_start_point double precision,
    invert_level_end_point double precision,
    the_geom public.geometry(LineString,28992) NOT NULL,
    connection_node_start_id integer,
    connection_node_end_id integer,
    CONSTRAINT has_two_connection_nodes CHECK ((public.intersects_connection_node(the_geom, connection_node_start_id, connection_node_end_id) = 2))
);


--
-- TOC entry 251 (class 1259 OID 16429336)
-- Name: v2_culvert_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_culvert_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4186 (class 0 OID 0)
-- Dependencies: 251
-- Name: v2_culvert_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_culvert_id_seq OWNED BY public.v2_culvert.id;


--
-- TOC entry 323 (class 1259 OID 16430197)
-- Name: v2_culvert_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v2_culvert_view AS
 SELECT cul.id AS cul_id,
    cul.display_name AS cul_display_name,
    cul.code AS cul_code,
    cul.calculation_type AS cul_calculation_type,
    cul.friction_value AS cul_friction_value,
    cul.friction_type AS cul_friction_type,
    cul.dist_calc_points AS cul_dist_calc_points,
    cul.zoom_category AS cul_zoom_category,
    cul.cross_section_definition_id AS cul_cross_section_definition_id,
    cul.discharge_coefficient_positive AS cul_discharge_coefficient_positive,
    cul.discharge_coefficient_negative AS cul_discharge_coefficient_negative,
    cul.invert_level_start_point AS cul_invert_level_start_point,
    cul.invert_level_end_point AS cul_invert_level_end_point,
    cul.the_geom,
    cul.connection_node_start_id AS cul_connection_node_start_id,
    cul.connection_node_end_id AS cul_connection_node_end_id,
    def.id AS def_id,
    def.shape AS def_shape,
    def.width AS def_width,
    def.height AS def_height,
    def.code AS def_code
   FROM public.v2_culvert cul,
    public.v2_cross_section_definition def
  WHERE (cul.cross_section_definition_id = def.id);


--
-- TOC entry 282 (class 1259 OID 16429845)
-- Name: v2_dem_average_area; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_dem_average_area (
    id integer NOT NULL,
    the_geom public.geometry(Polygon,28992)
);


--
-- TOC entry 281 (class 1259 OID 16429843)
-- Name: v2_dem_average_area_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_dem_average_area_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4187 (class 0 OID 0)
-- Dependencies: 281
-- Name: v2_dem_average_area_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_dem_average_area_id_seq OWNED BY public.v2_dem_average_area.id;


--
-- TOC entry 260 (class 1259 OID 16429433)
-- Name: v2_floodfill; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_floodfill (
    id integer NOT NULL,
    waterlevel double precision,
    the_geom public.geometry(Point,28992)
);


--
-- TOC entry 259 (class 1259 OID 16429431)
-- Name: v2_floodfill_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_floodfill_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4188 (class 0 OID 0)
-- Dependencies: 259
-- Name: v2_floodfill_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_floodfill_id_seq OWNED BY public.v2_floodfill.id;


--
-- TOC entry 256 (class 1259 OID 16429410)
-- Name: v2_global_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_global_settings (
    id integer NOT NULL,
    use_2d_flow boolean NOT NULL,
    use_1d_flow boolean NOT NULL,
    manhole_storage_area double precision,
    name character varying(128),
    sim_time_step double precision NOT NULL,
    output_time_step double precision,
    nr_timesteps integer NOT NULL,
    start_time timestamp with time zone,
    start_date date NOT NULL,
    grid_space double precision NOT NULL,
    dist_calc_points double precision NOT NULL,
    kmax integer NOT NULL,
    guess_dams integer,
    table_step_size double precision NOT NULL,
    flooding_threshold double precision NOT NULL,
    advection_1d integer NOT NULL,
    advection_2d integer NOT NULL,
    dem_file character varying(255),
    frict_type integer,
    frict_coef double precision NOT NULL,
    frict_coef_file character varying(255),
    water_level_ini_type integer,
    initial_waterlevel double precision NOT NULL,
    initial_waterlevel_file character varying(255),
    interception_global double precision,
    interception_file character varying(255),
    dem_obstacle_detection boolean NOT NULL,
    dem_obstacle_height double precision,
    embedded_cutoff_threshold double precision,
    epsg_code integer,
    timestep_plus boolean NOT NULL,
    max_angle_1d_advection double precision,
    minimum_sim_time_step double precision,
    maximum_sim_time_step double precision,
    frict_avg integer NOT NULL,
    wind_shielding_file character varying(255),
    control_group_id integer,
    numerical_settings_id integer NOT NULL,
    use_0d_inflow integer NOT NULL,
    table_step_size_1d double precision,
    table_step_size_volume_2d double precision,
    use_2d_rain integer NOT NULL,
    initial_groundwater_level double precision,
    initial_groundwater_level_file character varying(255),
    initial_groundwater_level_type integer,
    groundwater_settings_id integer,
    simple_infiltration_settings_id integer,
    interflow_settings_id integer
);


--
-- TOC entry 255 (class 1259 OID 16429408)
-- Name: v2_global_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_global_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4189 (class 0 OID 0)
-- Dependencies: 255
-- Name: v2_global_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_global_settings_id_seq OWNED BY public.v2_global_settings.id;


--
-- TOC entry 258 (class 1259 OID 16429421)
-- Name: v2_grid_refinement; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_grid_refinement (
    id integer NOT NULL,
    display_name character varying(255) NOT NULL,
    refinement_level integer,
    the_geom public.geometry(LineString,28992),
    code character varying(100) NOT NULL
);


--
-- TOC entry 308 (class 1259 OID 16430078)
-- Name: v2_grid_refinement_area; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_grid_refinement_area (
    id integer NOT NULL,
    display_name character varying(255) NOT NULL,
    refinement_level integer,
    code character varying(100) NOT NULL,
    the_geom public.geometry(Polygon,28992)
);


--
-- TOC entry 307 (class 1259 OID 16430076)
-- Name: v2_grid_refinement_area_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_grid_refinement_area_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4190 (class 0 OID 0)
-- Dependencies: 307
-- Name: v2_grid_refinement_area_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_grid_refinement_area_id_seq OWNED BY public.v2_grid_refinement_area.id;


--
-- TOC entry 257 (class 1259 OID 16429419)
-- Name: v2_grid_refinement_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_grid_refinement_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4191 (class 0 OID 0)
-- Dependencies: 257
-- Name: v2_grid_refinement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_grid_refinement_id_seq OWNED BY public.v2_grid_refinement.id;


--
-- TOC entry 310 (class 1259 OID 16430090)
-- Name: v2_groundwater; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_groundwater (
    id integer NOT NULL,
    groundwater_impervious_layer_level double precision,
    groundwater_impervious_layer_level_file character varying(255),
    groundwater_impervious_layer_level_type integer,
    phreatic_storage_capacity double precision,
    phreatic_storage_capacity_file character varying(255),
    phreatic_storage_capacity_type integer,
    equilibrium_infiltration_rate double precision,
    equilibrium_infiltration_rate_file character varying(255),
    equilibrium_infiltration_rate_type integer,
    initial_infiltration_rate double precision,
    initial_infiltration_rate_file character varying(255),
    initial_infiltration_rate_type integer,
    infiltration_decay_period double precision,
    infiltration_decay_period_file character varying(255),
    infiltration_decay_period_type integer,
    groundwater_hydro_connectivity double precision,
    groundwater_hydro_connectivity_file character varying(255),
    groundwater_hydro_connectivity_type integer,
    display_name character varying(255),
    leakage double precision,
    leakage_file character varying(255)
);


--
-- TOC entry 309 (class 1259 OID 16430088)
-- Name: v2_groundwater_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_groundwater_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4192 (class 0 OID 0)
-- Dependencies: 309
-- Name: v2_groundwater_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_groundwater_id_seq OWNED BY public.v2_groundwater.id;


--
-- TOC entry 244 (class 1259 OID 16429256)
-- Name: v2_impervious_surface; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_impervious_surface (
    id integer NOT NULL,
    display_name character varying(255) NOT NULL,
    code character varying(100) NOT NULL,
    surface_class character varying(128) NOT NULL,
    surface_sub_class character varying(128),
    surface_inclination character varying(64) NOT NULL,
    zoom_category integer,
    nr_of_inhabitants double precision,
    dry_weather_flow double precision,
    area double precision,
    the_geom public.geometry(Polygon,28992)
);


--
-- TOC entry 272 (class 1259 OID 16429533)
-- Name: v2_impervious_surface_map; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_impervious_surface_map (
    id integer NOT NULL,
    impervious_surface_id integer,
    connection_node_id integer NOT NULL,
    percentage double precision
);


--
-- TOC entry 319 (class 1259 OID 16430178)
-- Name: v2_imp_surface_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v2_imp_surface_view AS
 SELECT isurfmap.id AS isurfmap_id,
    isurfmap.impervious_surface_id AS isurfmap_impervious_surface_id,
    isurfmap.connection_node_id AS isurfmap_connection_node_id,
    isurfmap.percentage AS isurfmap_percentage,
    public.st_makeline(public.st_centroid(isurf.the_geom), connection_node.the_geom) AS the_geom
   FROM public.v2_impervious_surface isurf,
    public.v2_connection_nodes connection_node,
    public.v2_impervious_surface_map isurfmap
  WHERE ((isurfmap.connection_node_id = connection_node.id) AND (isurfmap.impervious_surface_id = isurf.id));


--
-- TOC entry 243 (class 1259 OID 16429254)
-- Name: v2_impervious_surface_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_impervious_surface_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4193 (class 0 OID 0)
-- Dependencies: 243
-- Name: v2_impervious_surface_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_impervious_surface_id_seq OWNED BY public.v2_impervious_surface.id;


--
-- TOC entry 271 (class 1259 OID 16429531)
-- Name: v2_impervious_surface_map_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_impervious_surface_map_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4194 (class 0 OID 0)
-- Dependencies: 271
-- Name: v2_impervious_surface_map_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_impervious_surface_map_id_seq OWNED BY public.v2_impervious_surface_map.id;


--
-- TOC entry 314 (class 1259 OID 16430112)
-- Name: v2_interflow; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_interflow (
    id integer NOT NULL,
    interflow_type integer NOT NULL,
    porosity double precision,
    porosity_file character varying(255),
    porosity_layer_thickness double precision,
    impervious_layer_elevation double precision,
    hydraulic_conductivity double precision,
    hydraulic_conductivity_file character varying(255),
    display_name character varying(255)
);


--
-- TOC entry 313 (class 1259 OID 16430110)
-- Name: v2_interflow_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_interflow_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4195 (class 0 OID 0)
-- Dependencies: 313
-- Name: v2_interflow_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_interflow_id_seq OWNED BY public.v2_interflow.id;


--
-- TOC entry 268 (class 1259 OID 16429509)
-- Name: v2_levee; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_levee (
    id integer NOT NULL,
    crest_level double precision,
    the_geom public.geometry(LineString,28992),
    material integer,
    max_breach_depth double precision,
    code character varying(100) NOT NULL
);


--
-- TOC entry 267 (class 1259 OID 16429507)
-- Name: v2_levee_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_levee_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4196 (class 0 OID 0)
-- Dependencies: 267
-- Name: v2_levee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_levee_id_seq OWNED BY public.v2_levee.id;


--
-- TOC entry 232 (class 1259 OID 16429140)
-- Name: v2_manhole; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_manhole (
    id integer NOT NULL,
    display_name character varying(255) NOT NULL,
    code character varying(100) NOT NULL,
    connection_node_id integer NOT NULL,
    shape character varying(4),
    width double precision,
    length double precision,
    manhole_indicator integer,
    calculation_type integer,
    bottom_level double precision,
    surface_level double precision,
    drain_level double precision,
    sediment_level double precision,
    zoom_category integer
);


--
-- TOC entry 231 (class 1259 OID 16429138)
-- Name: v2_manhole_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_manhole_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4197 (class 0 OID 0)
-- Dependencies: 231
-- Name: v2_manhole_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_manhole_id_seq OWNED BY public.v2_manhole.id;


--
-- TOC entry 317 (class 1259 OID 16430169)
-- Name: v2_manhole_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v2_manhole_view AS
 SELECT manh.id AS manh_id,
    manh.display_name AS manh_display_name,
    manh.code AS manh_code,
    manh.connection_node_id AS manh_connection_node_id,
    manh.shape AS manh_shape,
    manh.width AS manh_width,
    manh.length AS manh_length,
    manh.manhole_indicator AS manh_manhole_indicator,
    manh.calculation_type AS manh_calculation_type,
    manh.bottom_level AS manh_bottom_level,
    manh.surface_level AS manh_surface_level,
    manh.drain_level AS manh_drain_level,
    manh.sediment_level AS manh_sediment_level,
    manh.zoom_category AS manh_zoom_category,
    node.id AS node_id,
    node.storage_area AS node_storage_area,
    node.initial_waterlevel AS node_initial_waterlevel,
    node.code AS node_code,
    node.the_geom,
    node.the_geom_linestring AS node_the_geom_linestring
   FROM public.v2_manhole manh,
    public.v2_connection_nodes node
  WHERE (manh.connection_node_id = node.id);


--
-- TOC entry 300 (class 1259 OID 16429986)
-- Name: v2_numerical_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_numerical_settings (
    id integer NOT NULL,
    cfl_strictness_factor_1d double precision,
    cfl_strictness_factor_2d double precision,
    convergence_cg double precision,
    convergence_eps double precision,
    flow_direction_threshold double precision,
    frict_shallow_water_correction integer,
    general_numerical_threshold double precision,
    integration_method integer,
    limiter_grad_1d integer,
    limiter_grad_2d integer,
    limiter_slope_crossectional_area_2d integer,
    limiter_slope_friction_2d integer,
    max_nonlin_iterations integer,
    max_degree integer NOT NULL,
    minimum_friction_velocity double precision,
    minimum_surface_area double precision,
    precon_cg integer,
    preissmann_slot double precision,
    pump_implicit_ratio double precision,
    thin_water_layer_definition double precision,
    use_of_cg integer NOT NULL,
    use_of_nested_newton integer NOT NULL
);


--
-- TOC entry 299 (class 1259 OID 16429984)
-- Name: v2_numerical_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_numerical_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4198 (class 0 OID 0)
-- Dependencies: 299
-- Name: v2_numerical_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_numerical_settings_id_seq OWNED BY public.v2_numerical_settings.id;


--
-- TOC entry 270 (class 1259 OID 16429521)
-- Name: v2_obstacle; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_obstacle (
    id integer NOT NULL,
    crest_level double precision,
    the_geom public.geometry(LineString,28992),
    code character varying(100) NOT NULL
);


--
-- TOC entry 269 (class 1259 OID 16429519)
-- Name: v2_obstacle_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_obstacle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4199 (class 0 OID 0)
-- Dependencies: 269
-- Name: v2_obstacle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_obstacle_id_seq OWNED BY public.v2_obstacle.id;


--
-- TOC entry 246 (class 1259 OID 16429280)
-- Name: v2_orifice; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_orifice (
    id integer NOT NULL,
    display_name character varying(255) NOT NULL,
    code character varying(100) NOT NULL,
    crest_level double precision,
    sewerage boolean NOT NULL,
    cross_section_definition_id integer,
    friction_value double precision,
    friction_type integer,
    discharge_coefficient_positive double precision,
    discharge_coefficient_negative double precision,
    zoom_category integer,
    crest_type integer,
    connection_node_start_id integer,
    connection_node_end_id integer
);


--
-- TOC entry 245 (class 1259 OID 16429278)
-- Name: v2_orifice_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_orifice_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4200 (class 0 OID 0)
-- Dependencies: 245
-- Name: v2_orifice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_orifice_id_seq OWNED BY public.v2_orifice.id;


--
-- TOC entry 316 (class 1259 OID 16430164)
-- Name: v2_orifice_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v2_orifice_view AS
 SELECT orf.id AS orf_id,
    orf.display_name AS orf_display_name,
    orf.code AS orf_code,
    orf.crest_level AS orf_crest_level,
    orf.sewerage AS orf_sewerage,
    orf.cross_section_definition_id AS orf_cross_section_definition_id,
    orf.friction_value AS orf_friction_value,
    orf.friction_type AS orf_friction_type,
    orf.discharge_coefficient_positive AS orf_discharge_coefficient_positive,
    orf.discharge_coefficient_negative AS orf_discharge_coefficient_negative,
    orf.zoom_category AS orf_zoom_category,
    orf.crest_type AS orf_crest_type,
    orf.connection_node_start_id AS orf_connection_node_start_id,
    orf.connection_node_end_id AS orf_connection_node_end_id,
    def.id AS def_id,
    def.shape AS def_shape,
    def.width AS def_width,
    def.height AS def_height,
    def.code AS def_code,
    public.st_makeline(start_node.the_geom, end_node.the_geom) AS the_geom
   FROM public.v2_orifice orf,
    public.v2_cross_section_definition def,
    public.v2_connection_nodes start_node,
    public.v2_connection_nodes end_node
  WHERE (((orf.connection_node_start_id = start_node.id) AND (orf.connection_node_end_id = end_node.id)) AND (orf.cross_section_definition_id = def.id));


--
-- TOC entry 242 (class 1259 OID 16429230)
-- Name: v2_pipe; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_pipe (
    id integer NOT NULL,
    display_name character varying(255) NOT NULL,
    code character varying(100) NOT NULL,
    profile_num integer,
    sewerage_type integer,
    calculation_type integer,
    invert_level_start_point double precision,
    invert_level_end_point double precision,
    cross_section_definition_id integer,
    friction_value double precision,
    friction_type integer,
    dist_calc_points double precision,
    material integer,
    original_length double precision,
    zoom_category integer,
    connection_node_start_id integer,
    connection_node_end_id integer
);


--
-- TOC entry 241 (class 1259 OID 16429228)
-- Name: v2_pipe_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_pipe_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4201 (class 0 OID 0)
-- Dependencies: 241
-- Name: v2_pipe_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_pipe_id_seq OWNED BY public.v2_pipe.id;


--
-- TOC entry 320 (class 1259 OID 16430182)
-- Name: v2_pipe_map_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v2_pipe_map_view AS
 SELECT DISTINCT ON (isurfmap.impervious_surface_id) isurf.id AS isurf_id,
    isurf.display_name AS isurf_display_name,
    isurf.code AS isurf_code,
    isurf.surface_class AS isurf_surface_class,
    isurf.surface_sub_class AS isurf_surface_sub_class,
    isurf.surface_inclination AS isurf_surface_inclination,
    isurf.zoom_category AS isurf_zoom_category,
    isurf.nr_of_inhabitants AS isurf_nr_of_inhabitants,
    isurf.dry_weather_flow AS isurf_dry_weather_flow,
    isurf.area AS isurf_area,
    public.st_makeline(public.st_centroid(isurf.the_geom), connection_node.the_geom) AS the_geom
   FROM public.v2_impervious_surface isurf,
    public.v2_connection_nodes connection_node,
    public.v2_impervious_surface_map isurfmap,
    public.v2_pipe p
  WHERE (((isurfmap.connection_node_id = connection_node.id) AND (isurfmap.impervious_surface_id = isurf.id)) AND ((isurfmap.connection_node_id = p.connection_node_start_id) OR (isurfmap.connection_node_id = p.connection_node_end_id)))
  ORDER BY isurfmap.impervious_surface_id, public.st_distance(connection_node.the_geom, isurf.the_geom);


--
-- TOC entry 318 (class 1259 OID 16430173)
-- Name: v2_pipe_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v2_pipe_view AS
 SELECT pipe.id AS pipe_id,
    pipe.display_name AS pipe_display_name,
    pipe.code AS pipe_code,
    pipe.profile_num AS pipe_profile_num,
    pipe.sewerage_type AS pipe_sewerage_type,
    pipe.calculation_type AS pipe_calculation_type,
    pipe.invert_level_start_point AS pipe_invert_level_start_point,
    pipe.invert_level_end_point AS pipe_invert_level_end_point,
    pipe.cross_section_definition_id AS pipe_cross_section_definition_id,
    pipe.friction_value AS pipe_friction_value,
    pipe.friction_type AS pipe_friction_type,
    pipe.dist_calc_points AS pipe_dist_calc_points,
    pipe.material AS pipe_material,
    pipe.original_length AS pipe_original_length,
    pipe.zoom_category AS pipe_zoom_category,
    pipe.connection_node_start_id AS pipe_connection_node_start_id,
    pipe.connection_node_end_id AS pipe_connection_node_end_id,
    def.id AS def_id,
    def.shape AS def_shape,
    def.width AS def_width,
    def.height AS def_height,
    def.code AS def_code,
    public.st_makeline(start_node.the_geom, end_node.the_geom) AS the_geom
   FROM public.v2_pipe pipe,
    public.v2_cross_section_definition def,
    public.v2_connection_nodes start_node,
    public.v2_connection_nodes end_node
  WHERE (((pipe.connection_node_start_id = start_node.id) AND (pipe.connection_node_end_id = end_node.id)) AND (pipe.cross_section_definition_id = def.id));


--
-- TOC entry 250 (class 1259 OID 16429326)
-- Name: v2_pumped_drainage_area; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_pumped_drainage_area (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    code character varying(100) NOT NULL,
    the_geom public.geometry(Polygon,28992) NOT NULL
);


--
-- TOC entry 249 (class 1259 OID 16429324)
-- Name: v2_pumped_drainage_area_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_pumped_drainage_area_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4202 (class 0 OID 0)
-- Dependencies: 249
-- Name: v2_pumped_drainage_area_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_pumped_drainage_area_id_seq OWNED BY public.v2_pumped_drainage_area.id;


--
-- TOC entry 248 (class 1259 OID 16429306)
-- Name: v2_pumpstation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_pumpstation (
    id integer NOT NULL,
    display_name character varying(255) NOT NULL,
    code character varying(100) NOT NULL,
    classification integer,
    sewerage boolean NOT NULL,
    start_level double precision,
    lower_stop_level double precision,
    upper_stop_level double precision,
    capacity double precision,
    zoom_category integer,
    connection_node_start_id integer,
    connection_node_end_id integer,
    type integer
);


--
-- TOC entry 247 (class 1259 OID 16429304)
-- Name: v2_pumpstation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_pumpstation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4203 (class 0 OID 0)
-- Dependencies: 247
-- Name: v2_pumpstation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_pumpstation_id_seq OWNED BY public.v2_pumpstation.id;


--
-- TOC entry 315 (class 1259 OID 16430160)
-- Name: v2_pumpstation_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v2_pumpstation_view AS
 SELECT pump.id AS pump_id,
    pump.display_name AS pump_display_name,
    pump.code AS pump_code,
    pump.classification AS pump_classification,
    pump.type AS pump_type,
    pump.sewerage AS pump_sewerage,
    pump.start_level AS pump_start_level,
    pump.lower_stop_level AS pump_lower_stop_level,
    pump.upper_stop_level AS pump_upper_stop_level,
    pump.capacity AS pump_capacity,
    pump.zoom_category AS pump_zoom_category,
    pump.connection_node_start_id AS pump_connection_node_start_id,
    pump.connection_node_end_id AS pump_connection_node_end_id,
    public.st_makeline(start_node.the_geom, end_node.the_geom) AS the_geom
   FROM public.v2_pumpstation pump,
    public.v2_connection_nodes start_node,
    public.v2_connection_nodes end_node
  WHERE ((pump.connection_node_start_id = start_node.id) AND (pump.connection_node_end_id = end_node.id));


--
-- TOC entry 312 (class 1259 OID 16430101)
-- Name: v2_simple_infiltration; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_simple_infiltration (
    id integer NOT NULL,
    infiltration_rate double precision NOT NULL,
    infiltration_rate_file character varying(255),
    infiltration_surface_option integer,
    max_infiltration_capacity_file text,
    display_name character varying(255)
);


--
-- TOC entry 311 (class 1259 OID 16430099)
-- Name: v2_simple_infiltration_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_simple_infiltration_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4204 (class 0 OID 0)
-- Dependencies: 311
-- Name: v2_simple_infiltration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_simple_infiltration_id_seq OWNED BY public.v2_simple_infiltration.id;


--
-- TOC entry 304 (class 1259 OID 16430024)
-- Name: v2_surface; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_surface (
    id integer NOT NULL,
    display_name character varying(255) NOT NULL,
    code character varying(100) NOT NULL,
    zoom_category integer,
    nr_of_inhabitants double precision,
    dry_weather_flow double precision,
    function character varying(64),
    area double precision,
    surface_parameters_id integer,
    the_geom public.geometry(Polygon,28992)
);


--
-- TOC entry 303 (class 1259 OID 16430022)
-- Name: v2_surface_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_surface_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4205 (class 0 OID 0)
-- Dependencies: 303
-- Name: v2_surface_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_surface_id_seq OWNED BY public.v2_surface.id;


--
-- TOC entry 306 (class 1259 OID 16430035)
-- Name: v2_surface_map; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_surface_map (
    id integer NOT NULL,
    surface_type character varying(40),
    surface_id integer,
    connection_node_id integer NOT NULL,
    percentage double precision
);


--
-- TOC entry 305 (class 1259 OID 16430033)
-- Name: v2_surface_map_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_surface_map_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4206 (class 0 OID 0)
-- Dependencies: 305
-- Name: v2_surface_map_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_surface_map_id_seq OWNED BY public.v2_surface_map.id;


--
-- TOC entry 302 (class 1259 OID 16430016)
-- Name: v2_surface_parameters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_surface_parameters (
    id integer NOT NULL,
    outflow_delay double precision NOT NULL,
    surface_layer_thickness double precision NOT NULL,
    infiltration boolean NOT NULL,
    max_infiltration_capacity double precision NOT NULL,
    min_infiltration_capacity double precision NOT NULL,
    infiltration_decay_constant double precision NOT NULL,
    infiltration_recovery_constant double precision NOT NULL
);


--
-- TOC entry 301 (class 1259 OID 16430014)
-- Name: v2_surface_parameters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_surface_parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4207 (class 0 OID 0)
-- Dependencies: 301
-- Name: v2_surface_parameters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_surface_parameters_id_seq OWNED BY public.v2_surface_parameters.id;


--
-- TOC entry 262 (class 1259 OID 16429445)
-- Name: v2_weir; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_weir (
    id integer NOT NULL,
    display_name character varying(255) NOT NULL,
    code character varying(100) NOT NULL,
    crest_level double precision,
    crest_type integer,
    cross_section_definition_id integer,
    sewerage boolean NOT NULL,
    discharge_coefficient_positive double precision,
    discharge_coefficient_negative double precision,
    external boolean,
    zoom_category integer,
    friction_value double precision,
    friction_type integer,
    connection_node_start_id integer,
    connection_node_end_id integer
);


--
-- TOC entry 261 (class 1259 OID 16429443)
-- Name: v2_weir_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_weir_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4208 (class 0 OID 0)
-- Dependencies: 261
-- Name: v2_weir_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_weir_id_seq OWNED BY public.v2_weir.id;


--
-- TOC entry 321 (class 1259 OID 16430187)
-- Name: v2_weir_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v2_weir_view AS
 SELECT weir.id AS weir_id,
    weir.display_name AS weir_display_name,
    weir.code AS weir_code,
    weir.crest_level AS weir_crest_level,
    weir.crest_type AS weir_crest_type,
    weir.cross_section_definition_id AS weir_cross_section_definition_id,
    weir.sewerage AS weir_sewerage,
    weir.discharge_coefficient_positive AS weir_discharge_coefficient_positive,
    weir.discharge_coefficient_negative AS weir_discharge_coefficient_negative,
    weir.external AS weir_external,
    weir.zoom_category AS weir_zoom_category,
    weir.friction_value AS weir_friction_value,
    weir.friction_type AS weir_friction_type,
    weir.connection_node_start_id AS weir_connection_node_start_id,
    weir.connection_node_end_id AS weir_connection_node_end_id,
    def.id AS def_id,
    def.shape AS def_shape,
    def.width AS def_width,
    def.height AS def_height,
    def.code AS def_code,
    public.st_makeline(start_node.the_geom, end_node.the_geom) AS the_geom
   FROM public.v2_weir weir,
    public.v2_cross_section_definition def,
    public.v2_connection_nodes start_node,
    public.v2_connection_nodes end_node
  WHERE (((weir.connection_node_start_id = start_node.id) AND (weir.connection_node_end_id = end_node.id)) AND (weir.cross_section_definition_id = def.id));


--
-- TOC entry 266 (class 1259 OID 16429491)
-- Name: v2_windshielding; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.v2_windshielding (
    id integer NOT NULL,
    channel_id integer,
    north double precision,
    northeast double precision,
    east double precision,
    southeast double precision,
    south double precision,
    southwest double precision,
    west double precision,
    northwest double precision,
    the_geom public.geometry(Point,28992),
    CONSTRAINT must_be_on_channel CHECK ((public.on_channel(channel_id, the_geom) = 1))
);


--
-- TOC entry 265 (class 1259 OID 16429489)
-- Name: v2_windshielding_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.v2_windshielding_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4209 (class 0 OID 0)
-- Dependencies: 265
-- Name: v2_windshielding_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.v2_windshielding_id_seq OWNED BY public.v2_windshielding.id;


--
-- TOC entry 197 (class 1259 OID 16428111)
-- Name: weir; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.weir (
    display_name character varying(255) NOT NULL,
    channel_id integer,
    crest_width double precision,
    crest_level double precision,
    allowed_flow_dir integer,
    discharge_coeff double precision,
    lat_dis_coeff double precision,
    category integer,
    angle double precision,
    type character varying(255),
    code character varying(255),
    inp_id integer NOT NULL,
    the_geom public.geometry(Point,28992)
);


--
-- TOC entry 226 (class 1259 OID 16429083)
-- Name: wind; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wind (
    id integer NOT NULL,
    "time" integer,
    windspeed double precision,
    winddirection double precision,
    drag_coeffictient double precision
);


--
-- TOC entry 225 (class 1259 OID 16429081)
-- Name: wind_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.wind_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4210 (class 0 OID 0)
-- Dependencies: 225
-- Name: wind_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.wind_id_seq OWNED BY public.wind.id;


--
-- TOC entry 3673 (class 2604 OID 16428167)
-- Name: cross_section_definition id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cross_section_definition ALTER COLUMN id SET DEFAULT nextval('public.cross_section_definition_id_seq'::regclass);


--
-- TOC entry 3676 (class 2604 OID 16428243)
-- Name: floodfill id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.floodfill ALTER COLUMN id SET DEFAULT nextval('public.floodfill_id_seq'::regclass);


--
-- TOC entry 3679 (class 2604 OID 16428382)
-- Name: global_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.global_settings ALTER COLUMN id SET DEFAULT nextval('public.global_settings_id_seq'::regclass);


--
-- TOC entry 3675 (class 2604 OID 16428221)
-- Name: grid_refinement id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grid_refinement ALTER COLUMN id SET DEFAULT nextval('public.grid_refinement_id_seq'::regclass);


--
-- TOC entry 3672 (class 2604 OID 16428148)
-- Name: initial_waterlevel id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.initial_waterlevel ALTER COLUMN id SET DEFAULT nextval('public.initial_waterlevel_id_seq'::regclass);


--
-- TOC entry 3680 (class 2604 OID 16428694)
-- Name: levee_chk id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.levee_chk ALTER COLUMN id SET DEFAULT nextval('public.levee_chk_id_seq'::regclass);


--
-- TOC entry 3674 (class 2604 OID 16428186)
-- Name: manhole_2d id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manhole_2d ALTER COLUMN id SET DEFAULT nextval('public.manhole_2d_id_seq'::regclass);


--
-- TOC entry 3678 (class 2604 OID 16428371)
-- Name: pumped_drainage_area id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pumped_drainage_area ALTER COLUMN id SET DEFAULT nextval('public.pumped_drainage_area_id_seq'::regclass);


--
-- TOC entry 3677 (class 2604 OID 16428254)
-- Name: settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings ALTER COLUMN id SET DEFAULT nextval('public.settings_id_seq'::regclass);


--
-- TOC entry 3671 (class 2604 OID 16428083)
-- Name: south_migrationhistory id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.south_migrationhistory ALTER COLUMN id SET DEFAULT nextval('public.south_migrationhistory_id_seq'::regclass);


--
-- TOC entry 3683 (class 2604 OID 16429125)
-- Name: v2_1d_boundary_conditions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_1d_boundary_conditions ALTER COLUMN id SET DEFAULT nextval('public.v2_1d_boundary_conditions_id_seq'::regclass);


--
-- TOC entry 3691 (class 2604 OID 16429216)
-- Name: v2_1d_lateral id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_1d_lateral ALTER COLUMN id SET DEFAULT nextval('public.v2_1d_lateral_id_seq'::regclass);


--
-- TOC entry 3704 (class 2604 OID 16429474)
-- Name: v2_2d_boundary_conditions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_2d_boundary_conditions ALTER COLUMN id SET DEFAULT nextval('public.v2_2d_boundary_conditions_id_seq'::regclass);


--
-- TOC entry 3699 (class 2604 OID 16429389)
-- Name: v2_2d_lateral id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_2d_lateral ALTER COLUMN id SET DEFAULT nextval('public.v2_2d_lateral_id_seq'::regclass);


--
-- TOC entry 3710 (class 2604 OID 16429575)
-- Name: v2_aggregation_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_aggregation_settings ALTER COLUMN id SET DEFAULT nextval('public.v2_aggregation_settings_id_seq'::regclass);


--
-- TOC entry 3713 (class 2604 OID 16429598)
-- Name: v2_calculation_point id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_calculation_point ALTER COLUMN id SET DEFAULT nextval('public.v2_calculation_point_id_seq'::regclass);


--
-- TOC entry 3686 (class 2604 OID 16429157)
-- Name: v2_channel id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_channel ALTER COLUMN id SET DEFAULT nextval('public.v2_channel_id_seq'::regclass);


--
-- TOC entry 3714 (class 2604 OID 16429610)
-- Name: v2_connected_pnt id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_connected_pnt ALTER COLUMN id SET DEFAULT nextval('public.v2_connected_pnt_id_seq'::regclass);


--
-- TOC entry 3682 (class 2604 OID 16429112)
-- Name: v2_connection_nodes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_connection_nodes ALTER COLUMN id SET DEFAULT nextval('public.v2_connection_nodes_id_seq'::regclass);


--
-- TOC entry 3719 (class 2604 OID 16429920)
-- Name: v2_control id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_control ALTER COLUMN id SET DEFAULT nextval('public.v2_control_id_seq'::regclass);


--
-- TOC entry 3723 (class 2604 OID 16429970)
-- Name: v2_control_delta id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_control_delta ALTER COLUMN id SET DEFAULT nextval('public.v2_control_delta_id_seq'::regclass);


--
-- TOC entry 3715 (class 2604 OID 16429716)
-- Name: v2_control_group id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_control_group ALTER COLUMN id SET DEFAULT nextval('public.v2_control_group_id_seq'::regclass);


--
-- TOC entry 3718 (class 2604 OID 16429877)
-- Name: v2_control_measure_group id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_control_measure_group ALTER COLUMN id SET DEFAULT nextval('public.v2_control_measure_group_id_seq'::regclass);


--
-- TOC entry 3720 (class 2604 OID 16429940)
-- Name: v2_control_measure_map id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_control_measure_map ALTER COLUMN id SET DEFAULT nextval('public.v2_control_measure_map_id_seq'::regclass);


--
-- TOC entry 3721 (class 2604 OID 16429954)
-- Name: v2_control_memory id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_control_memory ALTER COLUMN id SET DEFAULT nextval('public.v2_control_memory_id_seq'::regclass);


--
-- TOC entry 3722 (class 2604 OID 16429962)
-- Name: v2_control_pid id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_control_pid ALTER COLUMN id SET DEFAULT nextval('public.v2_control_pid_id_seq'::regclass);


--
-- TOC entry 3717 (class 2604 OID 16429860)
-- Name: v2_control_table id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_control_table ALTER COLUMN id SET DEFAULT nextval('public.v2_control_table_id_seq'::regclass);


--
-- TOC entry 3724 (class 2604 OID 16429978)
-- Name: v2_control_timed id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_control_timed ALTER COLUMN id SET DEFAULT nextval('public.v2_control_timed_id_seq'::regclass);


--
-- TOC entry 3688 (class 2604 OID 16429181)
-- Name: v2_cross_section_definition id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_cross_section_definition ALTER COLUMN id SET DEFAULT nextval('public.v2_cross_section_definition_id_seq'::regclass);


--
-- TOC entry 3689 (class 2604 OID 16429192)
-- Name: v2_cross_section_location id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_cross_section_location ALTER COLUMN id SET DEFAULT nextval('public.v2_cross_section_location_id_seq'::regclass);


--
-- TOC entry 3697 (class 2604 OID 16429341)
-- Name: v2_culvert id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_culvert ALTER COLUMN id SET DEFAULT nextval('public.v2_culvert_id_seq'::regclass);


--
-- TOC entry 3716 (class 2604 OID 16429848)
-- Name: v2_dem_average_area id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_dem_average_area ALTER COLUMN id SET DEFAULT nextval('public.v2_dem_average_area_id_seq'::regclass);


--
-- TOC entry 3702 (class 2604 OID 16429436)
-- Name: v2_floodfill id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_floodfill ALTER COLUMN id SET DEFAULT nextval('public.v2_floodfill_id_seq'::regclass);


--
-- TOC entry 3700 (class 2604 OID 16429413)
-- Name: v2_global_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_global_settings ALTER COLUMN id SET DEFAULT nextval('public.v2_global_settings_id_seq'::regclass);


--
-- TOC entry 3701 (class 2604 OID 16429424)
-- Name: v2_grid_refinement id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_grid_refinement ALTER COLUMN id SET DEFAULT nextval('public.v2_grid_refinement_id_seq'::regclass);


--
-- TOC entry 3729 (class 2604 OID 16430081)
-- Name: v2_grid_refinement_area id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_grid_refinement_area ALTER COLUMN id SET DEFAULT nextval('public.v2_grid_refinement_area_id_seq'::regclass);


--
-- TOC entry 3730 (class 2604 OID 16430093)
-- Name: v2_groundwater id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_groundwater ALTER COLUMN id SET DEFAULT nextval('public.v2_groundwater_id_seq'::regclass);


--
-- TOC entry 3693 (class 2604 OID 16429259)
-- Name: v2_impervious_surface id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_impervious_surface ALTER COLUMN id SET DEFAULT nextval('public.v2_impervious_surface_id_seq'::regclass);


--
-- TOC entry 3709 (class 2604 OID 16429536)
-- Name: v2_impervious_surface_map id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_impervious_surface_map ALTER COLUMN id SET DEFAULT nextval('public.v2_impervious_surface_map_id_seq'::regclass);


--
-- TOC entry 3732 (class 2604 OID 16430115)
-- Name: v2_interflow id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_interflow ALTER COLUMN id SET DEFAULT nextval('public.v2_interflow_id_seq'::regclass);


--
-- TOC entry 3707 (class 2604 OID 16429512)
-- Name: v2_levee id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_levee ALTER COLUMN id SET DEFAULT nextval('public.v2_levee_id_seq'::regclass);


--
-- TOC entry 3685 (class 2604 OID 16429143)
-- Name: v2_manhole id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_manhole ALTER COLUMN id SET DEFAULT nextval('public.v2_manhole_id_seq'::regclass);


--
-- TOC entry 3725 (class 2604 OID 16429989)
-- Name: v2_numerical_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_numerical_settings ALTER COLUMN id SET DEFAULT nextval('public.v2_numerical_settings_id_seq'::regclass);


--
-- TOC entry 3708 (class 2604 OID 16429524)
-- Name: v2_obstacle id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_obstacle ALTER COLUMN id SET DEFAULT nextval('public.v2_obstacle_id_seq'::regclass);


--
-- TOC entry 3694 (class 2604 OID 16429283)
-- Name: v2_orifice id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_orifice ALTER COLUMN id SET DEFAULT nextval('public.v2_orifice_id_seq'::regclass);


--
-- TOC entry 3692 (class 2604 OID 16429233)
-- Name: v2_pipe id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_pipe ALTER COLUMN id SET DEFAULT nextval('public.v2_pipe_id_seq'::regclass);


--
-- TOC entry 3696 (class 2604 OID 16429329)
-- Name: v2_pumped_drainage_area id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_pumped_drainage_area ALTER COLUMN id SET DEFAULT nextval('public.v2_pumped_drainage_area_id_seq'::regclass);


--
-- TOC entry 3695 (class 2604 OID 16429309)
-- Name: v2_pumpstation id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_pumpstation ALTER COLUMN id SET DEFAULT nextval('public.v2_pumpstation_id_seq'::regclass);


--
-- TOC entry 3731 (class 2604 OID 16430104)
-- Name: v2_simple_infiltration id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_simple_infiltration ALTER COLUMN id SET DEFAULT nextval('public.v2_simple_infiltration_id_seq'::regclass);


--
-- TOC entry 3727 (class 2604 OID 16430027)
-- Name: v2_surface id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_surface ALTER COLUMN id SET DEFAULT nextval('public.v2_surface_id_seq'::regclass);


--
-- TOC entry 3728 (class 2604 OID 16430038)
-- Name: v2_surface_map id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_surface_map ALTER COLUMN id SET DEFAULT nextval('public.v2_surface_map_id_seq'::regclass);


--
-- TOC entry 3726 (class 2604 OID 16430019)
-- Name: v2_surface_parameters id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_surface_parameters ALTER COLUMN id SET DEFAULT nextval('public.v2_surface_parameters_id_seq'::regclass);


--
-- TOC entry 3703 (class 2604 OID 16429448)
-- Name: v2_weir id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_weir ALTER COLUMN id SET DEFAULT nextval('public.v2_weir_id_seq'::regclass);


--
-- TOC entry 3705 (class 2604 OID 16429494)
-- Name: v2_windshielding id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_windshielding ALTER COLUMN id SET DEFAULT nextval('public.v2_windshielding_id_seq'::regclass);


--
-- TOC entry 3681 (class 2604 OID 16429086)
-- Name: wind id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wind ALTER COLUMN id SET DEFAULT nextval('public.wind_id_seq'::regclass);


--
-- TOC entry 3775 (class 2606 OID 16428199)
-- Name: boundary_line boundary_line_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.boundary_line
    ADD CONSTRAINT boundary_line_pkey PRIMARY KEY (inp_id);


--
-- TOC entry 3779 (class 2606 OID 16428207)
-- Name: boundary_point boundary_point_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.boundary_point
    ADD CONSTRAINT boundary_point_pkey PRIMARY KEY (inp_id);


--
-- TOC entry 3756 (class 2606 OID 16428142)
-- Name: bridge bridge_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bridge
    ADD CONSTRAINT bridge_pkey PRIMARY KEY (inp_id);


--
-- TOC entry 3736 (class 2606 OID 16428102)
-- Name: channel channel_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.channel
    ADD CONSTRAINT channel_pkey PRIMARY KEY (inp_id);


--
-- TOC entry 3765 (class 2606 OID 16428172)
-- Name: cross_section_definition cross_section_definition_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cross_section_definition
    ADD CONSTRAINT cross_section_definition_pkey PRIMARY KEY (id);


--
-- TOC entry 3769 (class 2606 OID 16428180)
-- Name: cross_section cross_section_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cross_section
    ADD CONSTRAINT cross_section_pkey PRIMARY KEY (inp_id);


--
-- TOC entry 3748 (class 2606 OID 16428126)
-- Name: culvert culvert_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.culvert
    ADD CONSTRAINT culvert_pkey PRIMARY KEY (inp_id);


--
-- TOC entry 3788 (class 2606 OID 16428248)
-- Name: floodfill floodfill_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.floodfill
    ADD CONSTRAINT floodfill_pkey PRIMARY KEY (id);


--
-- TOC entry 3796 (class 2606 OID 16428387)
-- Name: global_settings global_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.global_settings
    ADD CONSTRAINT global_settings_pkey PRIMARY KEY (id);


--
-- TOC entry 3785 (class 2606 OID 16428226)
-- Name: grid_refinement grid_refinement_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.grid_refinement
    ADD CONSTRAINT grid_refinement_pkey PRIMARY KEY (id);


--
-- TOC entry 3759 (class 2606 OID 16428153)
-- Name: initial_waterlevel initial_waterlevel_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.initial_waterlevel
    ADD CONSTRAINT initial_waterlevel_pkey PRIMARY KEY (id);


--
-- TOC entry 3782 (class 2606 OID 16428215)
-- Name: lateral lateral_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."lateral"
    ADD CONSTRAINT lateral_pkey PRIMARY KEY (inp_id);


--
-- TOC entry 3799 (class 2606 OID 16428699)
-- Name: levee_chk levee_chk_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.levee_chk
    ADD CONSTRAINT levee_chk_pkey PRIMARY KEY (id);


--
-- TOC entry 3762 (class 2606 OID 16428161)
-- Name: levee levee_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.levee
    ADD CONSTRAINT levee_pkey PRIMARY KEY (inp_id);


--
-- TOC entry 3772 (class 2606 OID 16428191)
-- Name: manhole_2d manhole_2d_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manhole_2d
    ADD CONSTRAINT manhole_2d_pkey PRIMARY KEY (id);


--
-- TOC entry 3752 (class 2606 OID 16428134)
-- Name: orifice orifice_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orifice
    ADD CONSTRAINT orifice_pkey PRIMARY KEY (inp_id);


--
-- TOC entry 3804 (class 2606 OID 16428746)
-- Name: potential_cross_section potential_cross_section_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.potential_cross_section
    ADD CONSTRAINT potential_cross_section_pkey PRIMARY KEY (inp_id);


--
-- TOC entry 3793 (class 2606 OID 16428376)
-- Name: pumped_drainage_area pumped_drainage_area_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pumped_drainage_area
    ADD CONSTRAINT pumped_drainage_area_pkey PRIMARY KEY (id);


--
-- TOC entry 3740 (class 2606 OID 16428110)
-- Name: pumpstation pumpstation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pumpstation
    ADD CONSTRAINT pumpstation_pkey PRIMARY KEY (inp_id);


--
-- TOC entry 3791 (class 2606 OID 16428259)
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- TOC entry 3734 (class 2606 OID 16428088)
-- Name: south_migrationhistory south_migrationhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.south_migrationhistory
    ADD CONSTRAINT south_migrationhistory_pkey PRIMARY KEY (id);


--
-- TOC entry 3813 (class 2606 OID 16430155)
-- Name: v2_1d_boundary_conditions unique_connection_node; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_1d_boundary_conditions
    ADD CONSTRAINT unique_connection_node UNIQUE (connection_node_id);


--
-- TOC entry 3815 (class 2606 OID 16429132)
-- Name: v2_1d_boundary_conditions v2_1d_boundary_conditions_connection_node_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_1d_boundary_conditions
    ADD CONSTRAINT v2_1d_boundary_conditions_connection_node_id_key UNIQUE (connection_node_id);


--
-- TOC entry 3817 (class 2606 OID 16429130)
-- Name: v2_1d_boundary_conditions v2_1d_boundary_conditions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_1d_boundary_conditions
    ADD CONSTRAINT v2_1d_boundary_conditions_pkey PRIMARY KEY (id);


--
-- TOC entry 3837 (class 2606 OID 16429221)
-- Name: v2_1d_lateral v2_1d_lateral_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_1d_lateral
    ADD CONSTRAINT v2_1d_lateral_pkey PRIMARY KEY (id);


--
-- TOC entry 3888 (class 2606 OID 16429479)
-- Name: v2_2d_boundary_conditions v2_2d_boundary_conditions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_2d_boundary_conditions
    ADD CONSTRAINT v2_2d_boundary_conditions_pkey PRIMARY KEY (id);


--
-- TOC entry 3865 (class 2606 OID 16429394)
-- Name: v2_2d_lateral v2_2d_lateral_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_2d_lateral
    ADD CONSTRAINT v2_2d_lateral_pkey PRIMARY KEY (id);


--
-- TOC entry 3906 (class 2606 OID 16429577)
-- Name: v2_aggregation_settings v2_aggregation_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_aggregation_settings
    ADD CONSTRAINT v2_aggregation_settings_pkey PRIMARY KEY (id);


--
-- TOC entry 3908 (class 2606 OID 16429603)
-- Name: v2_calculation_point v2_calculation_point_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_calculation_point
    ADD CONSTRAINT v2_calculation_point_pkey PRIMARY KEY (id);


--
-- TOC entry 3826 (class 2606 OID 16429162)
-- Name: v2_channel v2_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_channel
    ADD CONSTRAINT v2_channel_pkey PRIMARY KEY (id);


--
-- TOC entry 3913 (class 2606 OID 16429615)
-- Name: v2_connected_pnt v2_connected_pnt_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_connected_pnt
    ADD CONSTRAINT v2_connected_pnt_pkey PRIMARY KEY (id);


--
-- TOC entry 3809 (class 2606 OID 16429117)
-- Name: v2_connection_nodes v2_connection_nodes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_connection_nodes
    ADD CONSTRAINT v2_connection_nodes_pkey PRIMARY KEY (id);


--
-- TOC entry 3936 (class 2606 OID 16429972)
-- Name: v2_control_delta v2_control_delta_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_control_delta
    ADD CONSTRAINT v2_control_delta_pkey PRIMARY KEY (id);


--
-- TOC entry 3916 (class 2606 OID 16429718)
-- Name: v2_control_group v2_control_group_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_control_group
    ADD CONSTRAINT v2_control_group_pkey PRIMARY KEY (id);


--
-- TOC entry 3923 (class 2606 OID 16429879)
-- Name: v2_control_measure_group v2_control_measure_group_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_control_measure_group
    ADD CONSTRAINT v2_control_measure_group_pkey PRIMARY KEY (id);


--
-- TOC entry 3930 (class 2606 OID 16429942)
-- Name: v2_control_measure_map v2_control_measure_map_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_control_measure_map
    ADD CONSTRAINT v2_control_measure_map_pkey PRIMARY KEY (id);


--
-- TOC entry 3932 (class 2606 OID 16429956)
-- Name: v2_control_memory v2_control_memory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_control_memory
    ADD CONSTRAINT v2_control_memory_pkey PRIMARY KEY (id);


--
-- TOC entry 3934 (class 2606 OID 16429964)
-- Name: v2_control_pid v2_control_pid_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_control_pid
    ADD CONSTRAINT v2_control_pid_pkey PRIMARY KEY (id);


--
-- TOC entry 3927 (class 2606 OID 16429922)
-- Name: v2_control v2_control_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_control
    ADD CONSTRAINT v2_control_pkey PRIMARY KEY (id);


--
-- TOC entry 3921 (class 2606 OID 16429865)
-- Name: v2_control_table v2_control_table_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_control_table
    ADD CONSTRAINT v2_control_table_pkey PRIMARY KEY (id);


--
-- TOC entry 3938 (class 2606 OID 16429983)
-- Name: v2_control_timed v2_control_timed_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_control_timed
    ADD CONSTRAINT v2_control_timed_pkey PRIMARY KEY (id);


--
-- TOC entry 3829 (class 2606 OID 16429186)
-- Name: v2_cross_section_definition v2_cross_section_definition_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_cross_section_definition
    ADD CONSTRAINT v2_cross_section_definition_pkey PRIMARY KEY (id);


--
-- TOC entry 3833 (class 2606 OID 16429197)
-- Name: v2_cross_section_location v2_cross_section_location_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_cross_section_location
    ADD CONSTRAINT v2_cross_section_location_pkey PRIMARY KEY (id);


--
-- TOC entry 3862 (class 2606 OID 16429346)
-- Name: v2_culvert v2_culvert_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_culvert
    ADD CONSTRAINT v2_culvert_pkey PRIMARY KEY (id);


--
-- TOC entry 3918 (class 2606 OID 16429853)
-- Name: v2_dem_average_area v2_dem_average_area_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_dem_average_area
    ADD CONSTRAINT v2_dem_average_area_pkey PRIMARY KEY (id);


--
-- TOC entry 3880 (class 2606 OID 16429441)
-- Name: v2_floodfill v2_floodfill_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_floodfill
    ADD CONSTRAINT v2_floodfill_pkey PRIMARY KEY (id);


--
-- TOC entry 3871 (class 2606 OID 16429560)
-- Name: v2_global_settings v2_global_settings_name_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_global_settings
    ADD CONSTRAINT v2_global_settings_name_uniq UNIQUE (name);


--
-- TOC entry 3874 (class 2606 OID 16429418)
-- Name: v2_global_settings v2_global_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_global_settings
    ADD CONSTRAINT v2_global_settings_pkey PRIMARY KEY (id);


--
-- TOC entry 3951 (class 2606 OID 16430086)
-- Name: v2_grid_refinement_area v2_grid_refinement_area_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_grid_refinement_area
    ADD CONSTRAINT v2_grid_refinement_area_pkey PRIMARY KEY (id);


--
-- TOC entry 3877 (class 2606 OID 16429429)
-- Name: v2_grid_refinement v2_grid_refinement_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_grid_refinement
    ADD CONSTRAINT v2_grid_refinement_pkey PRIMARY KEY (id);


--
-- TOC entry 3954 (class 2606 OID 16430098)
-- Name: v2_groundwater v2_groundwater_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_groundwater
    ADD CONSTRAINT v2_groundwater_pkey PRIMARY KEY (id);


--
-- TOC entry 3903 (class 2606 OID 16429538)
-- Name: v2_impervious_surface_map v2_impervious_surface_map_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_impervious_surface_map
    ADD CONSTRAINT v2_impervious_surface_map_pkey PRIMARY KEY (id);


--
-- TOC entry 3844 (class 2606 OID 16429264)
-- Name: v2_impervious_surface v2_impervious_surface_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_impervious_surface
    ADD CONSTRAINT v2_impervious_surface_pkey PRIMARY KEY (id);


--
-- TOC entry 3958 (class 2606 OID 16430120)
-- Name: v2_interflow v2_interflow_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_interflow
    ADD CONSTRAINT v2_interflow_pkey PRIMARY KEY (id);


--
-- TOC entry 3895 (class 2606 OID 16429517)
-- Name: v2_levee v2_levee_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_levee
    ADD CONSTRAINT v2_levee_pkey PRIMARY KEY (id);


--
-- TOC entry 3820 (class 2606 OID 16429693)
-- Name: v2_manhole v2_manhole_connection_node_id_uniq; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_manhole
    ADD CONSTRAINT v2_manhole_connection_node_id_uniq UNIQUE (connection_node_id);


--
-- TOC entry 3822 (class 2606 OID 16429145)
-- Name: v2_manhole v2_manhole_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_manhole
    ADD CONSTRAINT v2_manhole_pkey PRIMARY KEY (id);


--
-- TOC entry 3940 (class 2606 OID 16429991)
-- Name: v2_numerical_settings v2_numerical_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_numerical_settings
    ADD CONSTRAINT v2_numerical_settings_pkey PRIMARY KEY (id);


--
-- TOC entry 3898 (class 2606 OID 16429529)
-- Name: v2_obstacle v2_obstacle_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_obstacle
    ADD CONSTRAINT v2_obstacle_pkey PRIMARY KEY (id);


--
-- TOC entry 3850 (class 2606 OID 16429285)
-- Name: v2_orifice v2_orifice_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_orifice
    ADD CONSTRAINT v2_orifice_pkey PRIMARY KEY (id);


--
-- TOC entry 3842 (class 2606 OID 16429235)
-- Name: v2_pipe v2_pipe_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_pipe
    ADD CONSTRAINT v2_pipe_pkey PRIMARY KEY (id);


--
-- TOC entry 3856 (class 2606 OID 16429334)
-- Name: v2_pumped_drainage_area v2_pumped_drainage_area_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_pumped_drainage_area
    ADD CONSTRAINT v2_pumped_drainage_area_pkey PRIMARY KEY (id);


--
-- TOC entry 3854 (class 2606 OID 16429311)
-- Name: v2_pumpstation v2_pumpstation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_pumpstation
    ADD CONSTRAINT v2_pumpstation_pkey PRIMARY KEY (id);


--
-- TOC entry 3956 (class 2606 OID 16430109)
-- Name: v2_simple_infiltration v2_simple_infiltration_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_simple_infiltration
    ADD CONSTRAINT v2_simple_infiltration_pkey PRIMARY KEY (id);


--
-- TOC entry 3949 (class 2606 OID 16430040)
-- Name: v2_surface_map v2_surface_map_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_surface_map
    ADD CONSTRAINT v2_surface_map_pkey PRIMARY KEY (id);


--
-- TOC entry 3942 (class 2606 OID 16430021)
-- Name: v2_surface_parameters v2_surface_parameters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_surface_parameters
    ADD CONSTRAINT v2_surface_parameters_pkey PRIMARY KEY (id);


--
-- TOC entry 3944 (class 2606 OID 16430032)
-- Name: v2_surface v2_surface_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_surface
    ADD CONSTRAINT v2_surface_pkey PRIMARY KEY (id);


--
-- TOC entry 3886 (class 2606 OID 16429450)
-- Name: v2_weir v2_weir_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_weir
    ADD CONSTRAINT v2_weir_pkey PRIMARY KEY (id);


--
-- TOC entry 3892 (class 2606 OID 16429499)
-- Name: v2_windshielding v2_windshielding_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_windshielding
    ADD CONSTRAINT v2_windshielding_pkey PRIMARY KEY (id);


--
-- TOC entry 3744 (class 2606 OID 16428118)
-- Name: weir weir_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.weir
    ADD CONSTRAINT weir_pkey PRIMARY KEY (inp_id);


--
-- TOC entry 3807 (class 2606 OID 16429088)
-- Name: wind wind_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wind
    ADD CONSTRAINT wind_pkey PRIMARY KEY (id);


--
-- TOC entry 3776 (class 1259 OID 16428451)
-- Name: boundary_line_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX boundary_line_the_geom_id ON public.boundary_line USING gist (the_geom);


--
-- TOC entry 3777 (class 1259 OID 16428457)
-- Name: boundary_point_channel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX boundary_point_channel_id ON public.boundary_point USING btree (channel_id);


--
-- TOC entry 3754 (class 1259 OID 16428433)
-- Name: bridge_channel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bridge_channel_id ON public.bridge USING btree (channel_id);


--
-- TOC entry 3757 (class 1259 OID 16428434)
-- Name: bridge_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX bridge_the_geom_id ON public.bridge USING gist (the_geom);


--
-- TOC entry 3737 (class 1259 OID 16428399)
-- Name: channel_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX channel_the_geom_id ON public.channel USING gist (the_geom);


--
-- TOC entry 3766 (class 1259 OID 16428442)
-- Name: cross_section_channel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cross_section_channel_id ON public.cross_section USING btree (channel_id);


--
-- TOC entry 3767 (class 1259 OID 16428448)
-- Name: cross_section_definition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cross_section_definition_id ON public.cross_section USING btree (definition_id);


--
-- TOC entry 3770 (class 1259 OID 16428449)
-- Name: cross_section_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cross_section_the_geom_id ON public.cross_section USING gist (the_geom);


--
-- TOC entry 3746 (class 1259 OID 16428419)
-- Name: culvert_channel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX culvert_channel_id ON public.culvert USING btree (channel_id);


--
-- TOC entry 3749 (class 1259 OID 16428420)
-- Name: culvert_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX culvert_the_geom_id ON public.culvert USING gist (the_geom);


--
-- TOC entry 3789 (class 1259 OID 16428466)
-- Name: floodfill_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX floodfill_the_geom_id ON public.floodfill USING gist (the_geom);


--
-- TOC entry 3786 (class 1259 OID 16428465)
-- Name: grid_refinement_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX grid_refinement_the_geom_id ON public.grid_refinement USING gist (the_geom);


--
-- TOC entry 3760 (class 1259 OID 16428435)
-- Name: initial_waterlevel_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX initial_waterlevel_the_geom_id ON public.initial_waterlevel USING gist (the_geom);


--
-- TOC entry 3780 (class 1259 OID 16428463)
-- Name: lateral_channel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX lateral_channel_id ON public."lateral" USING btree (channel_id);


--
-- TOC entry 3783 (class 1259 OID 16428464)
-- Name: lateral_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX lateral_the_geom_id ON public."lateral" USING gist (the_geom);


--
-- TOC entry 3797 (class 1259 OID 16428700)
-- Name: levee_chk_chk_original_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX levee_chk_chk_original_geom_id ON public.levee_chk USING gist (chk_original_geom);


--
-- TOC entry 3800 (class 1259 OID 16428701)
-- Name: levee_chk_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX levee_chk_the_geom_id ON public.levee_chk USING gist (the_geom);


--
-- TOC entry 3763 (class 1259 OID 16428436)
-- Name: levee_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX levee_the_geom_id ON public.levee USING gist (the_geom);


--
-- TOC entry 3773 (class 1259 OID 16428450)
-- Name: manhole_2d_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX manhole_2d_the_geom_id ON public.manhole_2d USING gist (the_geom);


--
-- TOC entry 3750 (class 1259 OID 16428426)
-- Name: orifice_channel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX orifice_channel_id ON public.orifice USING btree (channel_id);


--
-- TOC entry 3753 (class 1259 OID 16428427)
-- Name: orifice_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX orifice_the_geom_id ON public.orifice USING gist (the_geom);


--
-- TOC entry 3801 (class 1259 OID 16428752)
-- Name: potential_cross_section_channel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX potential_cross_section_channel_id ON public.potential_cross_section USING btree (channel_id);


--
-- TOC entry 3802 (class 1259 OID 16428758)
-- Name: potential_cross_section_definition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX potential_cross_section_definition_id ON public.potential_cross_section USING btree (definition_id);


--
-- TOC entry 3805 (class 1259 OID 16428759)
-- Name: potential_cross_section_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX potential_cross_section_the_geom_id ON public.potential_cross_section USING gist (the_geom);


--
-- TOC entry 3794 (class 1259 OID 16428561)
-- Name: pumped_drainage_area_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pumped_drainage_area_the_geom_id ON public.pumped_drainage_area USING gist (the_geom);


--
-- TOC entry 3738 (class 1259 OID 16428405)
-- Name: pumpstation_channel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pumpstation_channel_id ON public.pumpstation USING btree (channel_id);


--
-- TOC entry 3741 (class 1259 OID 16428406)
-- Name: pumpstation_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pumpstation_the_geom_id ON public.pumpstation USING gist (the_geom);


--
-- TOC entry 3835 (class 1259 OID 16429227)
-- Name: v2_1d_lateral_connection_node_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_1d_lateral_connection_node_id ON public.v2_1d_lateral USING btree (connection_node_id);


--
-- TOC entry 3889 (class 1259 OID 16429480)
-- Name: v2_2d_boundary_conditions_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_2d_boundary_conditions_the_geom_id ON public.v2_2d_boundary_conditions USING gist (the_geom);


--
-- TOC entry 3866 (class 1259 OID 16429395)
-- Name: v2_2d_lateral_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_2d_lateral_the_geom_id ON public.v2_2d_lateral USING gist (the_geom);


--
-- TOC entry 3904 (class 1259 OID 16429583)
-- Name: v2_aggregation_settings_global_settings_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_aggregation_settings_global_settings_id ON public.v2_aggregation_settings USING btree (global_settings_id);


--
-- TOC entry 3909 (class 1259 OID 16429604)
-- Name: v2_calculation_point_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_calculation_point_the_geom_id ON public.v2_calculation_point USING gist (the_geom);


--
-- TOC entry 3823 (class 1259 OID 16429175)
-- Name: v2_channel_connection_node_end_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_channel_connection_node_end_id ON public.v2_channel USING btree (connection_node_end_id);


--
-- TOC entry 3824 (class 1259 OID 16429169)
-- Name: v2_channel_connection_node_start_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_channel_connection_node_start_id ON public.v2_channel USING btree (connection_node_start_id);


--
-- TOC entry 3827 (class 1259 OID 16429163)
-- Name: v2_channel_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_channel_the_geom_id ON public.v2_channel USING gist (the_geom);


--
-- TOC entry 3910 (class 1259 OID 16429621)
-- Name: v2_connected_pnt_calculation_pnt_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_connected_pnt_calculation_pnt_id ON public.v2_connected_pnt USING btree (calculation_pnt_id);


--
-- TOC entry 3911 (class 1259 OID 16429627)
-- Name: v2_connected_pnt_levee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_connected_pnt_levee_id ON public.v2_connected_pnt USING btree (levee_id);


--
-- TOC entry 3914 (class 1259 OID 16429628)
-- Name: v2_connected_pnt_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_connected_pnt_the_geom_id ON public.v2_connected_pnt USING gist (the_geom);


--
-- TOC entry 3810 (class 1259 OID 16429118)
-- Name: v2_connection_nodes_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_connection_nodes_the_geom_id ON public.v2_connection_nodes USING gist (the_geom);


--
-- TOC entry 3811 (class 1259 OID 16429119)
-- Name: v2_connection_nodes_the_geom_linestring_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_connection_nodes_the_geom_linestring_id ON public.v2_connection_nodes USING gist (the_geom_linestring);


--
-- TOC entry 3924 (class 1259 OID 16429928)
-- Name: v2_control_control_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_control_control_group_id ON public.v2_control USING btree (control_group_id);


--
-- TOC entry 3925 (class 1259 OID 16429934)
-- Name: v2_control_measure_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_control_measure_group_id ON public.v2_control USING btree (measure_group_id);


--
-- TOC entry 3928 (class 1259 OID 16429948)
-- Name: v2_control_measure_map_measure_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_control_measure_map_measure_group_id ON public.v2_control_measure_map USING btree (measure_group_id);


--
-- TOC entry 3830 (class 1259 OID 16429203)
-- Name: v2_cross_section_location_channel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_cross_section_location_channel_id ON public.v2_cross_section_location USING btree (channel_id);


--
-- TOC entry 3831 (class 1259 OID 16429209)
-- Name: v2_cross_section_location_definition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_cross_section_location_definition_id ON public.v2_cross_section_location USING btree (definition_id);


--
-- TOC entry 3834 (class 1259 OID 16429210)
-- Name: v2_cross_section_location_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_cross_section_location_the_geom_id ON public.v2_cross_section_location USING gist (the_geom);


--
-- TOC entry 3858 (class 1259 OID 16429365)
-- Name: v2_culvert_connection_node_end_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_culvert_connection_node_end_id ON public.v2_culvert USING btree (connection_node_end_id);


--
-- TOC entry 3859 (class 1259 OID 16429359)
-- Name: v2_culvert_connection_node_start_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_culvert_connection_node_start_id ON public.v2_culvert USING btree (connection_node_start_id);


--
-- TOC entry 3860 (class 1259 OID 16429352)
-- Name: v2_culvert_cross_section_definition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_culvert_cross_section_definition_id ON public.v2_culvert USING btree (cross_section_definition_id);


--
-- TOC entry 3863 (class 1259 OID 16429353)
-- Name: v2_culvert_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_culvert_the_geom_id ON public.v2_culvert USING gist (the_geom);


--
-- TOC entry 3919 (class 1259 OID 16429854)
-- Name: v2_dem_average_area_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_dem_average_area_the_geom_id ON public.v2_dem_average_area USING gist (the_geom);


--
-- TOC entry 3881 (class 1259 OID 16429442)
-- Name: v2_floodfill_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_floodfill_the_geom_id ON public.v2_floodfill USING gist (the_geom);


--
-- TOC entry 3867 (class 1259 OID 16429911)
-- Name: v2_global_settings_control_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_global_settings_control_group_id ON public.v2_global_settings USING btree (control_group_id);


--
-- TOC entry 3868 (class 1259 OID 16430126)
-- Name: v2_global_settings_groundwater_settings_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_global_settings_groundwater_settings_id ON public.v2_global_settings USING btree (groundwater_settings_id);


--
-- TOC entry 3869 (class 1259 OID 16430138)
-- Name: v2_global_settings_interflow_settings_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_global_settings_interflow_settings_id ON public.v2_global_settings USING btree (interflow_settings_id);


--
-- TOC entry 3872 (class 1259 OID 16429998)
-- Name: v2_global_settings_numerical_settings_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_global_settings_numerical_settings_id ON public.v2_global_settings USING btree (numerical_settings_id);


--
-- TOC entry 3875 (class 1259 OID 16430132)
-- Name: v2_global_settings_simple_infiltration_settings_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_global_settings_simple_infiltration_settings_id ON public.v2_global_settings USING btree (simple_infiltration_settings_id);


--
-- TOC entry 3952 (class 1259 OID 16430087)
-- Name: v2_grid_refinement_area_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_grid_refinement_area_the_geom_id ON public.v2_grid_refinement_area USING gist (the_geom);


--
-- TOC entry 3878 (class 1259 OID 16429430)
-- Name: v2_grid_refinement_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_grid_refinement_the_geom_id ON public.v2_grid_refinement USING gist (the_geom);


--
-- TOC entry 3900 (class 1259 OID 16429550)
-- Name: v2_impervious_surface_map_connection_node_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_impervious_surface_map_connection_node_id ON public.v2_impervious_surface_map USING btree (connection_node_id);


--
-- TOC entry 3901 (class 1259 OID 16429544)
-- Name: v2_impervious_surface_map_impervious_surface_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_impervious_surface_map_impervious_surface_id ON public.v2_impervious_surface_map USING btree (impervious_surface_id);


--
-- TOC entry 3845 (class 1259 OID 16429277)
-- Name: v2_impervious_surface_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_impervious_surface_the_geom_id ON public.v2_impervious_surface USING gist (the_geom);


--
-- TOC entry 3896 (class 1259 OID 16429518)
-- Name: v2_levee_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_levee_the_geom_id ON public.v2_levee USING gist (the_geom);


--
-- TOC entry 3818 (class 1259 OID 16429151)
-- Name: v2_manhole_connection_node_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_manhole_connection_node_id ON public.v2_manhole USING btree (connection_node_id);


--
-- TOC entry 3899 (class 1259 OID 16429530)
-- Name: v2_obstacle_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_obstacle_the_geom_id ON public.v2_obstacle USING gist (the_geom);


--
-- TOC entry 3846 (class 1259 OID 16429303)
-- Name: v2_orifice_connection_node_end_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_orifice_connection_node_end_id ON public.v2_orifice USING btree (connection_node_end_id);


--
-- TOC entry 3847 (class 1259 OID 16429297)
-- Name: v2_orifice_connection_node_start_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_orifice_connection_node_start_id ON public.v2_orifice USING btree (connection_node_start_id);


--
-- TOC entry 3848 (class 1259 OID 16429291)
-- Name: v2_orifice_cross_section_definition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_orifice_cross_section_definition_id ON public.v2_orifice USING btree (cross_section_definition_id);


--
-- TOC entry 3838 (class 1259 OID 16429253)
-- Name: v2_pipe_connection_node_end_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_pipe_connection_node_end_id ON public.v2_pipe USING btree (connection_node_end_id);


--
-- TOC entry 3839 (class 1259 OID 16429247)
-- Name: v2_pipe_connection_node_start_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_pipe_connection_node_start_id ON public.v2_pipe USING btree (connection_node_start_id);


--
-- TOC entry 3840 (class 1259 OID 16429241)
-- Name: v2_pipe_cross_section_definition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_pipe_cross_section_definition_id ON public.v2_pipe USING btree (cross_section_definition_id);


--
-- TOC entry 3857 (class 1259 OID 16429335)
-- Name: v2_pumped_drainage_area_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_pumped_drainage_area_the_geom_id ON public.v2_pumped_drainage_area USING gist (the_geom);


--
-- TOC entry 3851 (class 1259 OID 16429323)
-- Name: v2_pumpstation_connection_node_end_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_pumpstation_connection_node_end_id ON public.v2_pumpstation USING btree (connection_node_end_id);


--
-- TOC entry 3852 (class 1259 OID 16429317)
-- Name: v2_pumpstation_connection_node_start_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_pumpstation_connection_node_start_id ON public.v2_pumpstation USING btree (connection_node_start_id);


--
-- TOC entry 3947 (class 1259 OID 16430053)
-- Name: v2_surface_map_connection_node_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_surface_map_connection_node_id ON public.v2_surface_map USING btree (connection_node_id);


--
-- TOC entry 3945 (class 1259 OID 16430046)
-- Name: v2_surface_surface_parameters_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_surface_surface_parameters_id ON public.v2_surface USING btree (surface_parameters_id);


--
-- TOC entry 3946 (class 1259 OID 16430047)
-- Name: v2_surface_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_surface_the_geom_id ON public.v2_surface USING gist (the_geom);


--
-- TOC entry 3882 (class 1259 OID 16429468)
-- Name: v2_weir_connection_node_end_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_weir_connection_node_end_id ON public.v2_weir USING btree (connection_node_end_id);


--
-- TOC entry 3883 (class 1259 OID 16429462)
-- Name: v2_weir_connection_node_start_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_weir_connection_node_start_id ON public.v2_weir USING btree (connection_node_start_id);


--
-- TOC entry 3884 (class 1259 OID 16429456)
-- Name: v2_weir_cross_section_definition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_weir_cross_section_definition_id ON public.v2_weir USING btree (cross_section_definition_id);


--
-- TOC entry 3890 (class 1259 OID 16429505)
-- Name: v2_windshielding_channel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_windshielding_channel_id ON public.v2_windshielding USING btree (channel_id);


--
-- TOC entry 3893 (class 1259 OID 16429506)
-- Name: v2_windshielding_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX v2_windshielding_the_geom_id ON public.v2_windshielding USING gist (the_geom);


--
-- TOC entry 3742 (class 1259 OID 16428412)
-- Name: weir_channel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX weir_channel_id ON public.weir USING btree (channel_id);


--
-- TOC entry 3745 (class 1259 OID 16428413)
-- Name: weir_the_geom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX weir_the_geom_id ON public.weir USING gist (the_geom);


--
-- TOC entry 4014 (class 2620 OID 16430222)
-- Name: v2_global_settings format_input_str; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER format_input_str BEFORE INSERT OR UPDATE ON public.v2_global_settings FOR EACH ROW EXECUTE PROCEDURE public.format_input_str();


--
-- TOC entry 4017 (class 2620 OID 16430204)
-- Name: v2_2d_boundary_conditions geom_to_grid; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER geom_to_grid BEFORE INSERT OR UPDATE ON public.v2_2d_boundary_conditions FOR EACH ROW EXECUTE PROCEDURE public.geom_to_grid();


--
-- TOC entry 4013 (class 2620 OID 16430219)
-- Name: v2_2d_lateral geom_to_grid; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER geom_to_grid BEFORE INSERT OR UPDATE ON public.v2_2d_lateral FOR EACH ROW EXECUTE PROCEDURE public.geom_to_grid();


--
-- TOC entry 4021 (class 2620 OID 16430210)
-- Name: v2_calculation_point geom_to_grid; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER geom_to_grid BEFORE INSERT OR UPDATE ON public.v2_calculation_point FOR EACH ROW EXECUTE PROCEDURE public.geom_to_grid();


--
-- TOC entry 4008 (class 2620 OID 16430215)
-- Name: v2_channel geom_to_grid; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER geom_to_grid BEFORE INSERT OR UPDATE ON public.v2_channel FOR EACH ROW EXECUTE PROCEDURE public.geom_to_grid();


--
-- TOC entry 4022 (class 2620 OID 16430214)
-- Name: v2_connected_pnt geom_to_grid; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER geom_to_grid BEFORE INSERT OR UPDATE ON public.v2_connected_pnt FOR EACH ROW EXECUTE PROCEDURE public.geom_to_grid();


--
-- TOC entry 4007 (class 2620 OID 16430212)
-- Name: v2_connection_nodes geom_to_grid; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER geom_to_grid BEFORE INSERT OR UPDATE ON public.v2_connection_nodes FOR EACH ROW EXECUTE PROCEDURE public.geom_to_grid();


--
-- TOC entry 4009 (class 2620 OID 16430218)
-- Name: v2_cross_section_location geom_to_grid; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER geom_to_grid BEFORE INSERT OR UPDATE ON public.v2_cross_section_location FOR EACH ROW EXECUTE PROCEDURE public.geom_to_grid();


--
-- TOC entry 4012 (class 2620 OID 16430203)
-- Name: v2_culvert geom_to_grid; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER geom_to_grid BEFORE INSERT OR UPDATE ON public.v2_culvert FOR EACH ROW EXECUTE PROCEDURE public.geom_to_grid();


--
-- TOC entry 4023 (class 2620 OID 16430208)
-- Name: v2_dem_average_area geom_to_grid; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER geom_to_grid BEFORE INSERT OR UPDATE ON public.v2_dem_average_area FOR EACH ROW EXECUTE PROCEDURE public.geom_to_grid();


--
-- TOC entry 4016 (class 2620 OID 16430205)
-- Name: v2_floodfill geom_to_grid; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER geom_to_grid BEFORE INSERT OR UPDATE ON public.v2_floodfill FOR EACH ROW EXECUTE PROCEDURE public.geom_to_grid();


--
-- TOC entry 4015 (class 2620 OID 16430217)
-- Name: v2_grid_refinement geom_to_grid; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER geom_to_grid BEFORE INSERT OR UPDATE ON public.v2_grid_refinement FOR EACH ROW EXECUTE PROCEDURE public.geom_to_grid();


--
-- TOC entry 4025 (class 2620 OID 16430216)
-- Name: v2_grid_refinement_area geom_to_grid; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER geom_to_grid BEFORE INSERT OR UPDATE ON public.v2_grid_refinement_area FOR EACH ROW EXECUTE PROCEDURE public.geom_to_grid();


--
-- TOC entry 4010 (class 2620 OID 16430206)
-- Name: v2_impervious_surface geom_to_grid; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER geom_to_grid BEFORE INSERT OR UPDATE ON public.v2_impervious_surface FOR EACH ROW EXECUTE PROCEDURE public.geom_to_grid();


--
-- TOC entry 4019 (class 2620 OID 16430220)
-- Name: v2_levee geom_to_grid; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER geom_to_grid BEFORE INSERT OR UPDATE ON public.v2_levee FOR EACH ROW EXECUTE PROCEDURE public.geom_to_grid();


--
-- TOC entry 4020 (class 2620 OID 16430207)
-- Name: v2_obstacle geom_to_grid; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER geom_to_grid BEFORE INSERT OR UPDATE ON public.v2_obstacle FOR EACH ROW EXECUTE PROCEDURE public.geom_to_grid();


--
-- TOC entry 4011 (class 2620 OID 16430209)
-- Name: v2_pumped_drainage_area geom_to_grid; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER geom_to_grid BEFORE INSERT OR UPDATE ON public.v2_pumped_drainage_area FOR EACH ROW EXECUTE PROCEDURE public.geom_to_grid();


--
-- TOC entry 4024 (class 2620 OID 16430213)
-- Name: v2_surface geom_to_grid; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER geom_to_grid BEFORE INSERT OR UPDATE ON public.v2_surface FOR EACH ROW EXECUTE PROCEDURE public.geom_to_grid();


--
-- TOC entry 4018 (class 2620 OID 16430211)
-- Name: v2_windshielding geom_to_grid; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER geom_to_grid BEFORE INSERT OR UPDATE ON public.v2_windshielding FOR EACH ROW EXECUTE PROCEDURE public.geom_to_grid();


--
-- TOC entry 4000 (class 2606 OID 16429616)
-- Name: v2_connected_pnt calculation_pnt_id_refs_id_3a23ca39; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_connected_pnt
    ADD CONSTRAINT calculation_pnt_id_refs_id_3a23ca39 FOREIGN KEY (calculation_pnt_id) REFERENCES public.v2_calculation_point(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3974 (class 2606 OID 16429198)
-- Name: v2_cross_section_location channel_id_refs_id_0941f88e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_cross_section_location
    ADD CONSTRAINT channel_id_refs_id_0941f88e FOREIGN KEY (channel_id) REFERENCES public.v2_channel(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3996 (class 2606 OID 16429500)
-- Name: v2_windshielding channel_id_refs_id_79d66cdb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_windshielding
    ADD CONSTRAINT channel_id_refs_id_79d66cdb FOREIGN KEY (channel_id) REFERENCES public.v2_channel(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3967 (class 2606 OID 16428458)
-- Name: lateral channel_id_refs_inp_id_021d0d2d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."lateral"
    ADD CONSTRAINT channel_id_refs_inp_id_021d0d2d FOREIGN KEY (channel_id) REFERENCES public.channel(inp_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3968 (class 2606 OID 16428747)
-- Name: potential_cross_section channel_id_refs_inp_id_035f7b0c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.potential_cross_section
    ADD CONSTRAINT channel_id_refs_inp_id_035f7b0c FOREIGN KEY (channel_id) REFERENCES public.channel(inp_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3961 (class 2606 OID 16428414)
-- Name: culvert channel_id_refs_inp_id_08a42a1d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.culvert
    ADD CONSTRAINT channel_id_refs_inp_id_08a42a1d FOREIGN KEY (channel_id) REFERENCES public.channel(inp_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3963 (class 2606 OID 16428428)
-- Name: bridge channel_id_refs_inp_id_0d66e3d1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bridge
    ADD CONSTRAINT channel_id_refs_inp_id_0d66e3d1 FOREIGN KEY (channel_id) REFERENCES public.channel(inp_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3966 (class 2606 OID 16428452)
-- Name: boundary_point channel_id_refs_inp_id_3549ade6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.boundary_point
    ADD CONSTRAINT channel_id_refs_inp_id_3549ade6 FOREIGN KEY (channel_id) REFERENCES public.channel(inp_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3962 (class 2606 OID 16428421)
-- Name: orifice channel_id_refs_inp_id_4e45471a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orifice
    ADD CONSTRAINT channel_id_refs_inp_id_4e45471a FOREIGN KEY (channel_id) REFERENCES public.channel(inp_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3964 (class 2606 OID 16428437)
-- Name: cross_section channel_id_refs_inp_id_4fdf6b85; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cross_section
    ADD CONSTRAINT channel_id_refs_inp_id_4fdf6b85 FOREIGN KEY (channel_id) REFERENCES public.channel(inp_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3960 (class 2606 OID 16428407)
-- Name: weir channel_id_refs_inp_id_5e3bf5bc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.weir
    ADD CONSTRAINT channel_id_refs_inp_id_5e3bf5bc FOREIGN KEY (channel_id) REFERENCES public.channel(inp_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3959 (class 2606 OID 16428400)
-- Name: pumpstation channel_id_refs_inp_id_c97fd515; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pumpstation
    ADD CONSTRAINT channel_id_refs_inp_id_c97fd515 FOREIGN KEY (channel_id) REFERENCES public.channel(inp_id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3982 (class 2606 OID 16429298)
-- Name: v2_orifice connection_node_end_id_refs_id_014ee229; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_orifice
    ADD CONSTRAINT connection_node_end_id_refs_id_014ee229 FOREIGN KEY (connection_node_end_id) REFERENCES public.v2_connection_nodes(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3987 (class 2606 OID 16429360)
-- Name: v2_culvert connection_node_end_id_refs_id_35ee1270; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_culvert
    ADD CONSTRAINT connection_node_end_id_refs_id_35ee1270 FOREIGN KEY (connection_node_end_id) REFERENCES public.v2_connection_nodes(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3973 (class 2606 OID 16429170)
-- Name: v2_channel connection_node_end_id_refs_id_395a4016; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_channel
    ADD CONSTRAINT connection_node_end_id_refs_id_395a4016 FOREIGN KEY (connection_node_end_id) REFERENCES public.v2_connection_nodes(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3979 (class 2606 OID 16429248)
-- Name: v2_pipe connection_node_end_id_refs_id_a9965429; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_pipe
    ADD CONSTRAINT connection_node_end_id_refs_id_a9965429 FOREIGN KEY (connection_node_end_id) REFERENCES public.v2_connection_nodes(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3984 (class 2606 OID 16429318)
-- Name: v2_pumpstation connection_node_end_id_refs_id_b2beccef; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_pumpstation
    ADD CONSTRAINT connection_node_end_id_refs_id_b2beccef FOREIGN KEY (connection_node_end_id) REFERENCES public.v2_connection_nodes(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3995 (class 2606 OID 16429463)
-- Name: v2_weir connection_node_end_id_refs_id_f40dbf77; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_weir
    ADD CONSTRAINT connection_node_end_id_refs_id_f40dbf77 FOREIGN KEY (connection_node_end_id) REFERENCES public.v2_connection_nodes(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3970 (class 2606 OID 16429133)
-- Name: v2_1d_boundary_conditions connection_node_id_refs_id_0a6435e0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_1d_boundary_conditions
    ADD CONSTRAINT connection_node_id_refs_id_0a6435e0 FOREIGN KEY (connection_node_id) REFERENCES public.v2_connection_nodes(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4006 (class 2606 OID 16430048)
-- Name: v2_surface_map connection_node_id_refs_id_114a184b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_surface_map
    ADD CONSTRAINT connection_node_id_refs_id_114a184b FOREIGN KEY (connection_node_id) REFERENCES public.v2_connection_nodes(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3971 (class 2606 OID 16429146)
-- Name: v2_manhole connection_node_id_refs_id_4f81516d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_manhole
    ADD CONSTRAINT connection_node_id_refs_id_4f81516d FOREIGN KEY (connection_node_id) REFERENCES public.v2_connection_nodes(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3976 (class 2606 OID 16429222)
-- Name: v2_1d_lateral connection_node_id_refs_id_55d2df40; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_1d_lateral
    ADD CONSTRAINT connection_node_id_refs_id_55d2df40 FOREIGN KEY (connection_node_id) REFERENCES public.v2_connection_nodes(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3998 (class 2606 OID 16429545)
-- Name: v2_impervious_surface_map connection_node_id_refs_id_c500d603; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_impervious_surface_map
    ADD CONSTRAINT connection_node_id_refs_id_c500d603 FOREIGN KEY (connection_node_id) REFERENCES public.v2_connection_nodes(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3981 (class 2606 OID 16429292)
-- Name: v2_orifice connection_node_start_id_refs_id_014ee229; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_orifice
    ADD CONSTRAINT connection_node_start_id_refs_id_014ee229 FOREIGN KEY (connection_node_start_id) REFERENCES public.v2_connection_nodes(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3986 (class 2606 OID 16429354)
-- Name: v2_culvert connection_node_start_id_refs_id_35ee1270; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_culvert
    ADD CONSTRAINT connection_node_start_id_refs_id_35ee1270 FOREIGN KEY (connection_node_start_id) REFERENCES public.v2_connection_nodes(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3972 (class 2606 OID 16429164)
-- Name: v2_channel connection_node_start_id_refs_id_395a4016; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_channel
    ADD CONSTRAINT connection_node_start_id_refs_id_395a4016 FOREIGN KEY (connection_node_start_id) REFERENCES public.v2_connection_nodes(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3978 (class 2606 OID 16429242)
-- Name: v2_pipe connection_node_start_id_refs_id_a9965429; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_pipe
    ADD CONSTRAINT connection_node_start_id_refs_id_a9965429 FOREIGN KEY (connection_node_start_id) REFERENCES public.v2_connection_nodes(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3983 (class 2606 OID 16429312)
-- Name: v2_pumpstation connection_node_start_id_refs_id_b2beccef; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_pumpstation
    ADD CONSTRAINT connection_node_start_id_refs_id_b2beccef FOREIGN KEY (connection_node_start_id) REFERENCES public.v2_connection_nodes(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3994 (class 2606 OID 16429457)
-- Name: v2_weir connection_node_start_id_refs_id_f40dbf77; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_weir
    ADD CONSTRAINT connection_node_start_id_refs_id_f40dbf77 FOREIGN KEY (connection_node_start_id) REFERENCES public.v2_connection_nodes(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3988 (class 2606 OID 16429906)
-- Name: v2_global_settings control_group_id_refs_id_d0f4e2d1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_global_settings
    ADD CONSTRAINT control_group_id_refs_id_d0f4e2d1 FOREIGN KEY (control_group_id) REFERENCES public.v2_control_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4002 (class 2606 OID 16429923)
-- Name: v2_control control_group_id_refs_id_d891225c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_control
    ADD CONSTRAINT control_group_id_refs_id_d891225c FOREIGN KEY (control_group_id) REFERENCES public.v2_control_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3980 (class 2606 OID 16429286)
-- Name: v2_orifice cross_section_definition_id_refs_id_10f5522f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_orifice
    ADD CONSTRAINT cross_section_definition_id_refs_id_10f5522f FOREIGN KEY (cross_section_definition_id) REFERENCES public.v2_cross_section_definition(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3977 (class 2606 OID 16429236)
-- Name: v2_pipe cross_section_definition_id_refs_id_3168ade8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_pipe
    ADD CONSTRAINT cross_section_definition_id_refs_id_3168ade8 FOREIGN KEY (cross_section_definition_id) REFERENCES public.v2_cross_section_definition(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3993 (class 2606 OID 16429451)
-- Name: v2_weir cross_section_definition_id_refs_id_52de4c23; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_weir
    ADD CONSTRAINT cross_section_definition_id_refs_id_52de4c23 FOREIGN KEY (cross_section_definition_id) REFERENCES public.v2_cross_section_definition(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3985 (class 2606 OID 16429347)
-- Name: v2_culvert cross_section_definition_id_refs_id_8e4efefc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_culvert
    ADD CONSTRAINT cross_section_definition_id_refs_id_8e4efefc FOREIGN KEY (cross_section_definition_id) REFERENCES public.v2_cross_section_definition(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3969 (class 2606 OID 16428753)
-- Name: potential_cross_section definition_id_refs_id_6f3a135e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.potential_cross_section
    ADD CONSTRAINT definition_id_refs_id_6f3a135e FOREIGN KEY (definition_id) REFERENCES public.cross_section_definition(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3975 (class 2606 OID 16429204)
-- Name: v2_cross_section_location definition_id_refs_id_a1746ea0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_cross_section_location
    ADD CONSTRAINT definition_id_refs_id_a1746ea0 FOREIGN KEY (definition_id) REFERENCES public.v2_cross_section_definition(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3965 (class 2606 OID 16428443)
-- Name: cross_section definition_id_refs_id_bbd5eeea; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cross_section
    ADD CONSTRAINT definition_id_refs_id_bbd5eeea FOREIGN KEY (definition_id) REFERENCES public.cross_section_definition(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3999 (class 2606 OID 16429578)
-- Name: v2_aggregation_settings global_settings_id_refs_id_295daf41; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_aggregation_settings
    ADD CONSTRAINT global_settings_id_refs_id_295daf41 FOREIGN KEY (global_settings_id) REFERENCES public.v2_global_settings(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3990 (class 2606 OID 16430121)
-- Name: v2_global_settings groundwater_settings_id_refs_id_300ed996; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_global_settings
    ADD CONSTRAINT groundwater_settings_id_refs_id_300ed996 FOREIGN KEY (groundwater_settings_id) REFERENCES public.v2_groundwater(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3997 (class 2606 OID 16429539)
-- Name: v2_impervious_surface_map impervious_surface_id_refs_id_001c234b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_impervious_surface_map
    ADD CONSTRAINT impervious_surface_id_refs_id_001c234b FOREIGN KEY (impervious_surface_id) REFERENCES public.v2_impervious_surface(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3992 (class 2606 OID 16430133)
-- Name: v2_global_settings interflow_settings_id_refs_id_79a59d6a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_global_settings
    ADD CONSTRAINT interflow_settings_id_refs_id_79a59d6a FOREIGN KEY (interflow_settings_id) REFERENCES public.v2_interflow(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4001 (class 2606 OID 16429622)
-- Name: v2_connected_pnt levee_id_refs_id_2e565295; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_connected_pnt
    ADD CONSTRAINT levee_id_refs_id_2e565295 FOREIGN KEY (levee_id) REFERENCES public.v2_levee(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4003 (class 2606 OID 16429929)
-- Name: v2_control measure_group_id_refs_id_36a28871; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_control
    ADD CONSTRAINT measure_group_id_refs_id_36a28871 FOREIGN KEY (measure_group_id) REFERENCES public.v2_control_measure_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4004 (class 2606 OID 16429943)
-- Name: v2_control_measure_map measure_group_id_refs_id_7deb88a7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_control_measure_map
    ADD CONSTRAINT measure_group_id_refs_id_7deb88a7 FOREIGN KEY (measure_group_id) REFERENCES public.v2_control_measure_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3989 (class 2606 OID 16429999)
-- Name: v2_global_settings numerical_settings_id_refs_id_4154bad2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_global_settings
    ADD CONSTRAINT numerical_settings_id_refs_id_4154bad2 FOREIGN KEY (numerical_settings_id) REFERENCES public.v2_numerical_settings(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 3991 (class 2606 OID 16430127)
-- Name: v2_global_settings simple_infiltration_settings_id_refs_id_ac3bb32b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_global_settings
    ADD CONSTRAINT simple_infiltration_settings_id_refs_id_ac3bb32b FOREIGN KEY (simple_infiltration_settings_id) REFERENCES public.v2_simple_infiltration(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4005 (class 2606 OID 16430041)
-- Name: v2_surface surface_parameters_id_refs_id_d2471b65; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.v2_surface
    ADD CONSTRAINT surface_parameters_id_refs_id_d2471b65 FOREIGN KEY (surface_parameters_id) REFERENCES public.v2_surface_parameters(id) DEFERRABLE INITIALLY DEFERRED;


-- Completed on 2020-01-15 15:13:51

--
-- PostgreSQL database dump complete
--

