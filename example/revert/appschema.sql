-- Revert postgrest:appschema from pg

BEGIN;

DROP SCHEMA private;

COMMIT;
