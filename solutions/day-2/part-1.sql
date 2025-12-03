with ranges as (
    select
        unnest(string_split(line, ',')) as range
    from 'inputs/day-2/input.parquet'
),

parsed_ranges as (
    select
        split_part(range, '-', 1) :: long as start_id,
        split_part(range, '-', 2) :: long as end_id
    from ranges
),

expanded_ranges as (
    select
        unnest(generate_series(start_id, end_id)) as id
    from parsed_ranges
),

ids_bisected as (
    select
        id,
        floor(id / power(10, floor(log10(id)) - floor(log10(id) * 0.5))) :: int as first_half,
        (id % power(10, floor(log10(id)) - floor(log10(id) * 0.5))) :: int as second_half
    from expanded_ranges
)

select sum(id)
from ids_bisected
where first_half = second_half;