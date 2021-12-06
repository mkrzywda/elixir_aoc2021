defmodule AdventOfCode.Day06 do
  def part1(args) do
    args
      |> String.trim()
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> fish_counter80()
    end

  defp fish_counter80(fish) do
    Enum.reduce(1..80 , fish, fn _, fishes ->
      Enum.map(fishes, fn
        0 -> [6, 8]
        x -> x - 1
      end)
      |> List.flatten()
    end)
    |> Enum.count()
  end

  def part2(args) do
    args
      |> String.trim()
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> Enum.frequencies()
      |> fish_counter256()
      |> Map.values()
      |> Enum.sum()
  end

  defp fish_counter256(fish) do
    Enum.reduce(1..256, fish, fn _, fishes ->
      {zeroes, others} = Map.pop(fishes, 0, 0)
      Enum.reduce(0..8, others, fn 8, acc -> Map.put(acc, 8, zeroes)
                                   6, acc -> Map.put(acc, 6, zeroes + Map.get(others, 7, 0))
                                   remaining, acc -> Map.put(acc, remaining, Map.get(others, remaining + 1, 0)) end)
      end)
  end
end
