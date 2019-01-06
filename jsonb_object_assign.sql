-- mimics js Object.assign

create or replace function jsonb_object_assign(
    a jsonb default null,
    b jsonb default null)
returns jsonb as $$
    select coalesce(a, '{}'::jsonb)
        || coalesce(b, '{}'::jsonb)
$$ language sql;


-- there is jsonb_agg to make jsonb-array

drop aggregate if exists jsonb_object_assign_agg(jsonb);
create aggregate jsonb_object_assign_agg(jsonb) (
    sfunc = jsonb_object_assign,
    stype = jsonb,
    initcond = '{}'
);

create or replace function jsonb_object_assign(
    variadic arr jsonb[])
returns jsonb as $$
    select jsonb_object_assign_agg(a)
    from unnest(arr) a;
$$ language sql;
