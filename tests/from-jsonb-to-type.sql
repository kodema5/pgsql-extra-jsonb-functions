begin;
select no_plan();

select ok((from_jsonb(
    null::information_schema.columns,
    jsonb_object(array['table_name', 'abc'])))
    .table_name = 'abc',
    'can populate a type')

union all

(with foo as (select table_name::text
    from from_jsonb(
        null::information_schema.columns,
        jsonb_build_array(
            jsonb_object(array['table_name', 'abc']),
            jsonb_object(array['table_name', 'xyz'])
        ))),
    arr as (select array_agg(table_name) a
        from foo)
select ok(array_upper(arr.a,1)=2,'can populate array')
    from arr)

union all

select ok((from_jsonb(
    null::information_schema.columns,
    null))
    .table_name isnull,
    'can handle null jsonb');

select finish();
rollback;
