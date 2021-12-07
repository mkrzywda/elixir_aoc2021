defmodule AdventOfCode.Day07 do
  def part1(args) do
    args
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> calc_fuel()
  end

  def part2(args) do
    args
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> calc_fuel(:correct)

  end

  defp calc_fuel(crabs_pos) do
    Enum.map(Enum.min(crabs_pos)..Enum.max(crabs_pos), fn final_pos ->
      Enum.reduce(crabs_pos, 0, fn pos, fuel -> abs(final_pos - pos) + fuel end)
    end) |> Enum.min()
  end

  defp calc_fuel(crabs_pos, :correct) do

    Enum.map(Enum.min(crabs_pos)..Enum.max(crabs_pos), fn final_pos ->
      Enum.reduce(crabs_pos, 0, fn pos, fuel -> Integer.floor_div(abs(final_pos - pos) * (abs(final_pos - pos) + 1), 2) + fuel end)
    end) |> Enum.min()
  end
end
