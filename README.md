# pgsql-extra-jsonb-functions

a few extra jsonb functions for

## install

if pgtap installed, it unit-tests
```
pgsql -f index.sql
```

## synopsis

`jsonb_array_from(jsonb)` returns jsonb array, if null an empty array

`from_jsonb(anyelement, jsonb)` treats jsonb as an array, maps and returns set-of anyelement. see to_jsonb(anyelement)

`jsonb_object_assign(dest jsonb, src jsonb...)` returns a merged jsonb object (Object.assign). treats null as {}. useful for default || customer-setting || user-setting. use jsonb_strip_nulls when applicable

`jsonb_object_assign_agg(jsonb)` returns an aggregate merged jsonb object.

