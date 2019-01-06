-- https://www.postgresql.org/docs/10/functions-json.html

begin;
select no_plan();

-- to_jsonb, jsonb_agg, jsonb_array_length
(with js_array as (
        select jsonb_agg(to_jsonb(a)) b
        from information_schema.tables a),
    cnt as (
        select count(*) c
        from information_schema.tables)
select ok(jsonb_array_length(js_array.b)=cnt.c,
    'how to accumulate json-array')
    from js_array, cnt)

union all

-- jsonb_build_object
select ok(
    (jsonb_build_object('a',1,'b','c')) ->> 'a' = '1'
    , 'can create object')

union all

-- jsonb_strip_nulls for cleaning up data
-- ? operator to check if key
select ok(
    jsonb_strip_nulls(jsonb_build_object('a',1,'b',null)) ? 'b' = false,
    'can remove nulls');


select finish();
rollback;
