defmodule AdventOfCode.Day05 do
  def part1(args) do
    input_parser(args)
    |> Enum.map(&calculate_points(&1, :no_diagonals))
    |> List.flatten()
    |> Enum.reject(fn point -> point == [] end)
    |> Enum.frequencies()
    |> Enum.filter(fn {_point, freq} -> freq >= 2 end)
    |> Enum.count()
  end

  def input_parser(input) do
    String.split(input, ~r"[^0-9]", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(4)
    |> Enum.map(fn [x1  , y1, x2, y2] -> [{x1, y1}, {x2, y2}] end)
  end

  def calculate_points([{x,y1},{x,y2}], _) do
    for y <- y1..y2, do: {x, y}
  end

  def calculate_points([{x1,y},{x2,y}], _) do
    for x <- x1..x2, do: {x, y}
  end

  def calculate_points([{x1, y1}, {x2, y2}], :with_diagonals) do
    x = x1..x2
    y = y1..y2
    Enum.zip(x, y)
  end

  def calculate_points(_, :no_diagonals), do: []

  def part2(args) do
    input_parser(args)
    |> Enum.map(&calculate_points(&1, :with_diagonals))
    |> List.flatten()
    |> Enum.reject(fn point -> point == [] end)
    |> Enum.frequencies()
    |> Enum.filter(fn {_point, freq} -> freq >= 2 end)
    |> Enum.count()
  end
end
