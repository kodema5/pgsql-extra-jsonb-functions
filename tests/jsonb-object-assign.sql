begin;
select no_plan();

select ok(
    jsonb_object_assign() = '{}'::jsonb,
    'returns {} when no params')

union all
select ok(
    jsonb_object_assign(null,null) = '{}'::jsonb,
    'merges to nulls into a {}')

union all
select ok(
    jsonb_object_assign('{"a":1}'::jsonb) = '{"a":1}'::jsonb,
    'returns first when no second arg')

union all
select ok(
    jsonb_object_assign('{"a":1}'::jsonb,null) = '{"a":1}'::jsonb,
    'converts null to {}')

union all
select ok(
    jsonb_object_assign(null, '{"a":1}'::jsonb) = '{"a":1}'::jsonb,
    'converts null to {}')

union all
select ok(
    jsonb_object_assign('{"a":1}'::jsonb,'{"b":2}'::jsonb) = '{"a":1, "b":2}'::jsonb,
    'merges 2 jsonb objects')

union all
select ok(
    jsonb_object_assign(
        '{"a":1}'::jsonb,
        '{"b":2}'::jsonb,
        '{"b":3, "c":3}'::jsonb
        ) = '{"a":1, "b":3, "c":3}'::jsonb,
    'merges 2+ jsonb objects')

union all
select ok(
    jsonb_object_assign(
        '{"a":1}'::jsonb,
        '{"b":2}'::jsonb,
        '{"b":3, "c":3}'::jsonb,
        '{"d":4, "e":5}'::jsonb
        ) = '{"a":1, "b":3, "c":3, "d":4, "e":5}'::jsonb,
    'merges 2+ jsonb objects');

select finish();
rollback;
