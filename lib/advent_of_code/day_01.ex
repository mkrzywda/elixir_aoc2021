defmodule AdventOfCode.Day01 do
  def part1(args) do
    args
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [current, next] -> next > current end)
  end

  def part2(args) do
    args
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&Enum.sum/1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [current, next] -> next > current end)
  end

end
