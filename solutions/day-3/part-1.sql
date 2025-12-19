create or replace macro split_at_first_max_before(arr, right_pad) as (
    /*
    Where arr is an array of integers and right pad is an integer index <= arr.length.

    Finds the first element in arr[:-right_pad] with the maximum value in arr[:-right_pad].
    Supposing the corresponding maximum value is M at index i_max, the macro returns

    (M, arr[i_max + 1:])
    */
    with indexed_flattened as (
        select
            unnest(arr) :: int as value,
            generate_subscripts(arr, 1) as idx
    ),
    pad_removed as (
        select
            idx,
            value
        from indexed_flattened
        where idx <= length(arr) - right_pad
    ),
    first_max as (
        select min(idx) as min_idx, value
        from pad_removed
        group by value
        order by value desc
        limit 1
    )
    select (value, arr[min_idx + 1:])
    from first_max
);

with all_rows as (
    select
        row_number() over () as line_idx,
        string_split(line, '') as values
    from 'inputs/day-3/input.parquet'
),

banks as (
    select
        line_idx,
        values,
        split_at_first_max_before(values, 1)[1] :: long as value,
        2 as k,
        split_at_first_max_before(values, 1)[2] as right_banks
    from all_rows
),

maxed_bank as (
    select
        line_idx,
        values,
        10 * value + split_at_first_max_before(right_banks, 0)[1] :: long as value,
        1 as k,
        split_at_first_max_before(right_banks, 0)[2] as right_banks
    from banks
)

select sum(value) as solution
from maxed_bank;
