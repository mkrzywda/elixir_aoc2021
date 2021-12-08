defmodule AdventOfCode.Day08 do

# number => count segments
@seg_map %{
  1 => 2,
  2 => 5,
  3 => 5,
  4 => 4,
  5 => 5,
  6 => 6,
  7 => 3,
  8 => 7,
  9 => 6}


  def part1(args) do
    input =
      args
      |> String.trim()
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line |> String.split(" | ") |> Enum.map(&String.split(&1, " ")) end)

    digits_appearing(input, [1, 4, 7, 8])
  end

defp digits_appearing(input, numbers), do: digits_appearing(input, numbers, 0)
defp digits_appearing([], _numbers, acc), do: acc
defp digits_appearing([[_, h] | t], numbers, acc), do: digits_appearing(t, numbers, acc + seg_with(h, numbers))

defp seg_with(l, numbers), do: num_with(l, Enum.map(numbers, &@seg_map[&1]))
defp num_with(l, lengths), do: l |> Enum.filter(&(String.length(&1) in lengths)) |> Enum.count()

  def part2(args) do
    input =
      args
      |> String.trim()
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line |> String.split(" | ") |> Enum.map(&String.split(&1, " ")) end)

    sum_connection_seqs(input)
  end

  def sum_connection_seqs(list), do: sum_connection_seqs(list, [])
  def sum_connection_seqs([], acc), do: Enum.sum(acc)
  def sum_connection_seqs([h | t], acc), do: sum_connection_seqs(t, [output_of(h) | acc])

  defp output_of([data, out]) do
    out
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.map(&identify_number_from_seg(&1, filter(data)))
    |> Enum.join("")
    |> String.to_integer()
  end

  defp filter(inputs) do
    in1 = parser(inputs, 2)
    in4 = parser(inputs, 4)
    in7 = parser(inputs, 3)
    in8 = parser(inputs, 7)

    {in7 -- in1, in4 -- in1, (in8 -- in7) -- in4}
  end

  defp parser(input, len) do
    input
    |> Enum.filter(&(String.length(&1) == len))
    |> Enum.at(0)
    |> String.split("", trim: true)
  end

  defp identify_number_from_seg(s, {f1, f2, f3}) do
    cond do
      is_len?(s, 2) -> 1
      is_len?(s, 4) -> 4
      is_len?(s, 3) -> 7
      is_len?(s, 7) -> 8
      is_len?(s, 5) && matches?(s, f1) && matches?(s, f3) -> 2
      is_len?(s, 5) && matches?(s, f1) && matches?(s, f2) -> 5
      is_len?(s, 5) -> 3
      is_len?(s, 6) && matches?(s, f2) && !matches?(s, f3) -> 9
      is_len?(s, 6) && matches?(s, f1) && !matches?(s, f2) -> 0
      true -> 6
    end
  end

  defp matches?(input, sides), do: Enum.all?(sides, &(&1 in input))
  defp is_len?(input, len), do: Enum.count(input) == len
end
