defmodule AdventOfCode.Day03 do

  def part1(args) do
    {gamma, epsilon} =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(&to_charlist/1)
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&Enum.frequencies/1)
      |> gamma2eps([], [])

      String.to_integer("#{gamma}", 2) * String.to_integer("#{epsilon}", 2)
  end

  defp gamma2eps([], g, e), do: {Enum.reverse(g), Enum.reverse(e)}

  defp gamma2eps([%{48 => a, 49 => b} | r], g, e) when a > b,
    do: gamma2eps(r, [48 | g], [49 | e])

  defp gamma2eps([_a | r], g, e), do: gamma2eps(r, [49 | g], [48 | e])


  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&to_charlist/1)
    |> life_support_rating()

  end

  def co2_scrubber_rating(data) when is_list(data) do
    0..11
    |> Enum.reduce(data, fn _index, [number] -> [number]

      index, numbers ->
        %{?0 => num_zeroes, ?1 => num_ones} =
          numbers
          |> Enum.map(fn number -> Enum.at(number, index) end)
          |> Enum.frequencies()

        if num_zeroes > num_ones, do: Enum.filter(numbers, fn number -> Enum.at(number, index) === ?1 end), else: Enum.filter(numbers, fn number -> Enum.at(number, index) === ?0 end)
    end)
    |> Enum.at(0)
    |> to_string()
    |> String.to_integer(2)
  end

  def life_support_rating(data) do
    oxygen_generator_rating(data) * co2_scrubber_rating(data)
  end


  defp oxygen_generator_rating(data) when is_list(data) do
    0..11
    |> Enum.reduce(data, fn
      _index, [number] ->
        [number]

      index, numbers ->
        %{?0 => num_zeroes, ?1 => num_ones} =
          numbers
          |> Enum.map(fn number -> Enum.at(number, index) end)
          |> Enum.frequencies()

        if num_zeroes > num_ones, do: Enum.filter(numbers, fn number -> Enum.at(number, index) === ?0 end), else: Enum.filter(numbers, fn number -> Enum.at(number, index) === ?1 end)
    end)
    |> Enum.at(0)
    |> to_string()
    |> String.to_integer(2)
  end


end
