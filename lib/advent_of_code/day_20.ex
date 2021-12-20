defmodule AdventOfCode.Day20 do

    def part1(args) do
      [algo, image] = args
      |> String.split("\n\n", trim: true)

      algo =
        algo
        |> String.codepoints()
        |> Enum.reject(&(&1 == "\n"))
        |> Enum.with_index()
        |> Map.new(fn {v, k} -> {k, v} end)

      image =
        image
        |> String.codepoints()
        |> Enum.reduce({Map.new(), 0, 0}, fn
          "\n", {acc, _x, y} -> {acc, 0, y + 1}
          point, {acc, x, y} -> {Map.put(acc, {x, y}, point), x + 1, y}
        end)
        |> elem(0)

      image
      |> make_output(algo, 1)
      |> make_output(algo, 2)
      |> Map.values()
      |> Enum.count(&(&1 == "#"))
    end

    def part2(args) do
      [algo, image] = args
      |> String.split("\n\n", trim: true)

      algo =
        algo
        |> String.codepoints()
        |> Enum.reject(&(&1 == "\n"))
        |> Enum.with_index()
        |> Map.new(fn {v, k} -> {k, v} end)

      image =
        image
        |> String.codepoints()
        |> Enum.reduce({Map.new(), 0, 0}, fn
          "\n", {acc, _x, y} -> {acc, 0, y + 1}
          point, {acc, x, y} -> {Map.put(acc, {x, y}, point), x + 1, y}
        end)
        |> elem(0)


      Enum.reduce(1..50, image, fn n, acc ->
        make_output(acc, algo, n)
      end)
      |> Map.values()
      |> Enum.count(&(&1 == "#"))
    end

    def make_output(image, algo, n) do
      {min_x, max_x} = image |> Map.keys() |> Enum.map(fn {x, _} -> x end) |> Enum.min_max()
      {min_y, max_y} = image |> Map.keys() |> Enum.map(fn {_, y} -> y end) |> Enum.min_max()

      Enum.reduce(
        for(x <- (min_x - 1)..(max_x + 1), y <- (min_y - 1)..(max_y + 1), do: {x, y}),
        Map.new(),
        fn point, acc ->
          bin = point |> get_nbs(image, n) |> Enum.join() |> String.to_integer(2)
          Map.put(acc, point, Map.get(algo, bin))
        end
      )
    end

    def get_nbs({x, y}, image, n) do
      Enum.map(
        [{-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {0, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}],
        fn {x1, y1} ->
          case Map.get(image, {x + x1, y + y1}) do
            "#" -> 1
            "." -> 0
            nil -> if rem(n, 2) == 0, do: 1, else: 0
          end
        end
      )
    end

end
