select exists (select 1 from pg_available_extensions where name='pgtap') as has_pgtap
\gset
\if :has_pgtap

\ir from-jsonb-to-type.sql
\ir jsonb-functions-notes.sql
\ir jsonb-object-assign.sql

\endif