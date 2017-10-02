-- Revert postgrest:anonymous from pg

BEGIN;

DROP ROLE anonymous;

COMMIT;
