with movements as (
    select 
        0 as idx,
        50 as movement
    union all
    select
        (row_number() over ()) as idx,
        replace(
            replace(line, 'L', '-'),
            'R',
            ''
        ) :: int as movement
    from 'inputs/day-1/input.parquet'
),

cumulative_movements as (
    select
        idx,
        sum(movement) over (
            order by idx
            rows between unbounded preceding and current row
        ) as windowed
    from movements
),

normalized_movements as (
    select
        idx,
        if(
            windowed % 100 < 0,
            100 + (windowed % 100),
            windowed % 100
        ) as value
    from cumulative_movements
)

select count(*) as solution
from normalized_movements
where value = 0;