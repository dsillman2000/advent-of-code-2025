with movements as (
    -- select 
    --     0 as idx,
    --     50 as movement
    -- union all
    select
        (row_number() over ()) as idx,
        replace(
            replace(line, 'L', '-'),
            'R',
            ''
        ) :: int as movement
    from 'inputs/day-1/input.parquet'
),

tick_arrays as (
    select
        idx,
        repeat(if(movement < 0, [-1], [1]), abs(movement)) as movement_array
    from movements
),

exploded_ticks as (
    select
        0 as idx,
        50 as tick
    union all
    select
        idx,
        unnest(movement_array) as tick
    from tick_arrays
),

cumulative_movements as (
    select
        idx,
        sum(tick) over (
            order by idx
            rows between unbounded preceding and current row
        ) as windowed
    from exploded_ticks
)

select count(*) as solution
from cumulative_movements
where (windowed % 100) = 0;