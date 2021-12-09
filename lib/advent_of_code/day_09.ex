defmodule AdventOfCode.Day09 do
  def part1(args) do
   args
   |> String.trim()
    |> String.split("\n")
    |> Enum.with_index(fn line, y ->
      line
      |> String.trim()
      |> String.graphemes()
      |> Enum.with_index(fn height, x ->
        {{x, y}, String.to_integer(height)}
      end)
    end)
    |> List.flatten()
    |> Map.new()
    |> filter_low_points()
    |> Enum.map(fn {_coordinates, height} -> risk_level(height) end)
    |> Enum.sum()
  end

  def risk_level(height) do
    height + 1
  end

  def filter_low_points(height_map) do
    height_map
    |> Enum.filter(fn {coord, height} ->
      height_map
      |> adjacent(coord)
      |> Enum.all?(fn neighbour ->
        height < Map.fetch!(height_map, neighbour)
      end)
    end)
  end

  def adjacent(height_map, {x, y}) do
    Enum.filter([{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}], &Map.has_key?(height_map, &1))
  end


  def part2(args) do
    height_map = args
    |> String.trim()
    |> String.split("\n")
    |> Enum.with_index(fn line, y ->
      line
      |> String.trim()
      |> String.graphemes()
      |> Enum.with_index(fn height, x ->
        {{x, y}, String.to_integer(height)}
      end)
    end)
    |> List.flatten()
    |> Map.new()

    height_map
    |> filter_low_points()
    |> Enum.map(fn {coordinates, _height} -> identify_basin(height_map, coordinates)|> Enum.count() end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  def identify_basin(height_map, coord, seen \\ %MapSet{}) do
    height = Map.fetch!(height_map, coord)

    next_coords =
      height_map
      |> adjacent(coord)
      |> Enum.reject(fn neighbour -> MapSet.member?(seen, neighbour) end)
      |> Enum.filter(fn neighbour ->
        neighbour_height = Map.fetch!(height_map, neighbour)
        neighbour_height > height and neighbour_height < 9
      end)

    case next_coords do
      [] ->
        MapSet.put(seen, coord)

      _ ->
        next_coords
        |> Enum.map(fn neighbour ->
          identify_basin(height_map, neighbour, MapSet.put(seen, coord))
        end)
        |> Enum.reduce(%MapSet{}, fn seen, acc ->
          MapSet.union(seen, acc)
        end)
    end
  end

end
