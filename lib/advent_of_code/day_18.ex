defmodule AdventOfCode.Day18 do

  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&Jason.decode!/1)
    |> sum()
    |> magnitude()
  end

  def magnitude([left, right]), do: 3 * magnitude(left) + 2 * magnitude(right)
  def magnitude(num), do: num

  def sum([one]), do: one

  def sum([one, two | rest]) do
    sum([reduce([one, two]) | rest])
  end

  defp reduce(num) do
    if num === explode(num), do: split(explode(num)), else: reduce(explode(num))
  end

  defp split(num) do
    if num === maybe_split(num), do: maybe_split(num), else: reduce(maybe_split(num))
  end

  def explode(num) do
    case maybe_explode(num, 0) do
      {val, _nowhere_to_go} -> val
      val -> val
    end
  end

  defp maybe_explode([left, right], level) when level == 4 do
    {0, {left, right}}
  end

  defp maybe_explode([left, right], level) do
    with {:left, ^left} <- {:left, maybe_explode(left, level + 1)},
         {:right, ^right} <- {:right, maybe_explode(right, level + 1)} do
      [left, right]
    else
      {:left, {val, {move_left, move_right}}} ->
        {[val, add_to_left(right, move_right)], {move_left, nil}}

      {:right, {val, {move_left, move_right}}} ->
        {[add_to_right(left, move_left), val], {nil, move_right}}
    end
  end

  defp maybe_explode(num, _level) when is_integer(num), do: num

  defp add_to_left(val, nil), do: val
  defp add_to_left([left, right], val), do: [add_to_left(left, val), right]
  defp add_to_left(num, val), do: num + val

  defp add_to_right(val, nil), do: val
  defp add_to_right([left, right], val), do: [left, add_to_right(right, val)]
  defp add_to_right(num, val), do: num + val


  def maybe_split([left, right]) do
    with {:left, ^left} <- {:left, maybe_split(left)},
         {:right, ^right} <- {:right, maybe_split(right)} do
      [left, right]
    else
      {:left, new_left} -> [new_left, right]
      {:right, new_right} -> [left, new_right]
    end
  end

  def maybe_split(num) when num >= 10, do: [floor(num / 2), ceil(num / 2)]
  def maybe_split(num), do: num


  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&Jason.decode!/1)
    |> permutations(2)
    |> Enum.map(fn pair -> pair |> reduce() |> magnitude() end)
    |> Enum.max()
  end


  def permutations([], _), do: [[]]
  def permutations(_list, 0), do: [[]]

  def permutations(list, k) do
    for head <- list, tail <- permutations(list -- [head], k - 1), do: [head | tail]
  end

end
