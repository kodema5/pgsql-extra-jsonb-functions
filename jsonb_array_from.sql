
-- ensures it returns jsonb-array
--
create or replace function jsonb_array_from(
    js jsonb
) returns jsonb as $$
    select case
    when jsonb_typeof(js) = 'array' then js
    when js is null then '[]'::jsonb
    else (jsonb_build_array(js))
    end
$$ language sql;

