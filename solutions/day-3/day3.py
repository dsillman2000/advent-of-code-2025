"""

I got seriously stuck on day 3 part 2 in SQL, so I wrote a Python solution to check my sanity.

To my confusion, the Python solution (implemented the same way as the SQL solution) gave different
results! Comparing every line's solution against the SQL-sourced solution, I could see that various
instances seemed to be disagreeing on 1 or 2 digits.

Ultimate cause: the `row_number()` function in SQL is not guaranteed to preserve the index of list
elements when using `unnest()`. You really need to use the `generate_subscripts()` function to
ensure that the order is preserved. Some indices were getting swapped or moved around (especially
with larger lists, like in "input.txt"), so after I switched to `generate_subscripts()`, the Python
solution matched the SQL solution. Hooray!

"""

from pathlib import Path

EXAMPLE_TXT = Path(__file__).parent / "inputs/day-3/example.txt"
INPUT_TXT = Path(__file__).parent / "inputs/day-3/input.txt"


def split_at_first_max_before(arr: list[int], right_pad: int):
    max_value = max(arr[:-right_pad])
    max_index = arr.index(max_value)
    return max_value, arr[max_index + 1 :]


def recursive_solve(arr: list[int], right_pad: int):
    if right_pad == 0:
        return max(arr)
    max_value, rest = split_at_first_max_before(arr, right_pad)
    ret_val = int(str(max_value) + str(recursive_solve(rest, right_pad - 1)))
    return ret_val


def solve(input_file: Path):
    with input_file.open() as f:
        lines = f.readlines()
        arrs = [[int(l) for l in line.strip()] for line in lines]
    sols = []
    for i, arr in enumerate(arrs, start=1):
        sol = recursive_solve(arr, 11)
        arrstr = "".join(map(str, arr))
        print(f"{i},{arrstr},{sol}")
        sols.append(sol)

    return sum(sols)


if __name__ == "__main__":
    solve(INPUT_TXT)
