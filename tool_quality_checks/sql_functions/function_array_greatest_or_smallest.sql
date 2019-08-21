CREATE OR REPLACE FUNCTION array_greatest(anyarray)
RETURNS anyelement LANGUAGE SQL AS $$
SELECT max(x) FROM unnest($1) x;
$$;

CREATE OR REPLACE FUNCTION array_smallest(anyarray)
RETURNS anyelement LANGUAGE SQL AS $$
SELECT min(x) FROM unnest($1) x;
$$;