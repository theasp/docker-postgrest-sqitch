-- Deploy postgrest:anonymous to pg

BEGIN;

CREATE ROLE anonymous;

COMMIT;
