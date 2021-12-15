defmodule AdventOfCode.Day15 do
  def part1(args) do
    args
    |> String.split()
    |> Enum.with_index(fn line, y ->
      line
      |> to_charlist()
      |> Enum.with_index(fn energy, x -> {{x, y}, energy - ?0} end)
    end)
    |> List.flatten()
    |> Map.new()
    |> min_total_risk()

  end

  def graph(risk_map) do
    risk_map
    |> Enum.reduce(Graph.new(), fn {{x, y} = current, risk}, g ->
      [{0, -1}, {0, 1}, {-1, 0}, {1, 0}]
      |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
      |> Enum.filter(fn neighbor -> Map.has_key?(risk_map, neighbor) end)
      |> Enum.reduce(g, fn neighbor, g ->
        Graph.add_edge(g, neighbor, current, weight: risk)
      end)
    end)
  end

  def min_total_risk(risk_map) do
    bottom_right = risk_map
      |> Map.keys()
      |> Enum.max()

    risk_map
    |> graph()
    |> Graph.get_shortest_path({0, 0}, bottom_right)
    |> Enum.map(fn pos -> Map.fetch!(risk_map, pos) end)
    |> Enum.sum()
    |> then(fn sum -> sum - Map.fetch!(risk_map, {0, 0}) end)
  end


  def part2(args) do
    args
    |> String.split()
    |> Enum.with_index(fn line, y ->
      line
      |> to_charlist()
      |> Enum.with_index(fn energy, x -> {{x, y}, energy - ?0} end)
    end)
    |> List.flatten()
    |> Map.new()
    |> expand()
    |> min_total_risk()
  end

  def render(risk_map) do
    {max_x, max_y} = risk_map |> Map.keys() |> Enum.max()

    shortest_path =
      risk_map
      |> graph()
      |> Graph.get_shortest_path({0, 0}, {max_x, max_y})
      |> MapSet.new()

    Enum.map_join(0..max_y, "\n", fn y ->
      Enum.map_join(0..max_x, "", fn x ->
        risk = Map.fetch!(risk_map, {x,y})
        if MapSet.member?(shortest_path, {x,y}) do
          IO.ANSI.bright() <> "#{risk}" <> IO.ANSI.reset()
        else
          "#{risk}"
        end
      end)
    end)
  end

  def expand(risk_map) do
    {max_x, max_y} = risk_map |> Map.keys() |> Enum.max()

    for {{x, y}, risk} <- risk_map, tile_y <- 0..4, tile_x <- 0..4 do
      x = tile_x * (max_x + 1) + x
      y = tile_y * (max_y + 1) + y
      risk = rem(risk + tile_x + tile_y - 1, 9) + 1
      {{x, y}, risk}
    end
    |> Map.new()
  end

end
