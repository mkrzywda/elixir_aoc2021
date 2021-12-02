defmodule AdventOfCode.Day02 do

  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
    |> Enum.map(fn [command, units] -> {command, String.to_integer(units)} end)
    |> Enum.reduce({0, 0},  fn {"forward", x}, {pos, depth} -> {pos + x, depth}
                             {"down", x}, {pos, depth} -> {pos, depth + x}
                             {"up", x}, {pos, depth} -> {pos, depth - x} end)
    |> Tuple.product()
  end




  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
    |> Enum.map(fn [command, units] -> {command, String.to_integer(units)} end)
    |> Enum.reduce({0, 0, 0},  fn   {"forward", x}, {pos, depth, aim} -> {pos + x, depth + aim * x, aim}
                                    {"down", x}, {pos, depth, aim} -> {pos, depth, aim + x}
                                    {"up", x}, {pos, depth, aim} -> {pos, depth, aim - x} end)
    |> Tuple.delete_at(2)
    |> Tuple.product()

  end


end
