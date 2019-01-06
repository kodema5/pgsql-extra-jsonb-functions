-- there is to_jsonb(anyelement), so..

create or replace function from_jsonb(
    t anyelement,
    js jsonb)
returns setof anyelement as $$
    select jsonb_populate_record(t, foo.a)
    from (select jsonb_array_elements(
        jsonb_array_from(coalesce(js, '{}'::jsonb))
    ) a) as foo
$$ language sql;
