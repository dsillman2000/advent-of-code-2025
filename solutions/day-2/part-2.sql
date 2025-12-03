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

cursors_assigned as (
    select
        id,
        unnest(
            generate_series(1, greatest(1, floor(log10(id))) :: int // 2 + 1)
        ) as each_cursor
    from expanded_ranges
),

calculated_repetitions as (
    select
        id :: text as id_str,
        id_str[:each_cursor] as kernel_str,
        length(id_str) // length(kernel_str) as est_repetitions
    from cursors_assigned
    where 
        length(id_str) % length(kernel_str) = 0
        and length(id_str) > 1
),

pre_solution as (
    select distinct id_str :: long as solution_id
    from calculated_repetitions
    where repeat(kernel_str, est_repetitions) = id_str
)

select sum(solution_id) as solution
from pre_solution;