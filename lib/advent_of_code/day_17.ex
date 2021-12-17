defmodule AdventOfCode.Day17 do
  def part1(args) do
    data = Regex.scan(~r/-*\d+/, args)

    data
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
    |> solve()
  end

  def solve([_x1, _x2, y1, _y2]), do: div(y1 * (y1 + 1), 2)

  def part2(args) do
    data = Regex.scan(~r/-*\d+/, args)

    data
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
    |> velocity()
  end

  defp velocity([x1, x2, y1, y2]),
    do:
      for(vx <- 1..x2, vy <- y1..(1 - y1), do: check(0, 0, vx, vy, x1, x2, y1, y2))
      |> Enum.count(&(&1 == :in))

  defp check(x, y, _vx, _vy, x1, x2, y1, y2) when x in x1..x2 and y in y1..y2, do: :in
  defp check(x, y, _vx, _vy, _x1, x2, y1, _y2) when x > x2 or y < y1, do: :out
  defp check(x, y, vx, vy, x1, x2, y1, y2), do: check(x + vx, y + vy, set(vx), vy - 1, x1, x2, y1, y2)

  defp set(0), do: 0
  defp set(vx), do: vx + ((vx < 0 && 1) || -1)

end
