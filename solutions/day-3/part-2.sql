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

create or replace temp table all_rows as (
    select
        row_number() over () as line_idx,
        string_split(line, '') as values
    from 'inputs/day-3/input.parquet'
);

with recursive all_rows_recursive using key (line_idx) as (
    select
        line_idx,
        values,
        12 as k,
        split_at_first_max_before(values, k - 1)[1] :: long as value,
        split_at_first_max_before(values, k - 1)[2] as right_banks,
    from all_rows
    union
    select
        line_idx,
        values,
        k - 1 as k,
        (value :: string || split_at_first_max_before(right_banks, k - 2)[1] :: string) :: long as value,
        split_at_first_max_before(right_banks, k - 2)[2] as right_banks
    from all_rows_recursive
    where k >= 2
)

select sum(value) as solution
from all_rows_recursive;
