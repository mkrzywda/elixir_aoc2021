defmodule AdventOfCode.Day22 do
  def part1(args) do
    args
    |> String.trim()
    |> String.split(~r/\R/)
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> then(fn [b, rest] ->
        Regex.scan(~r/[-\d]+/, rest)
        |> List.flatten()
        |> Enum.map(&String.to_integer/1)
        |> then(fn [x_min, x_max, y_min, y_max, z_min, z_max] ->
          {String.to_atom(b), {x_min..x_max, y_min..y_max, z_min..z_max}}
        end)
      end)
    end)
    |> Enum.reject(fn {_, {x1.._, y1.._, z1.._}} ->
      abs(x1) > 50 or abs(y1) > 50 or abs(z1) > 50
    end)
    |> count()
  end


defp count(ins) do
  ins
  |> Enum.reduce([], fn
    new = {:on, new_r}, acc ->
      acc
      |> Enum.flat_map(fn {_, c_r} = c ->
        if overlap?(new_r, c_r), do: [c, overlap(new, c)], else: [c]
      end)
      |> List.insert_at(0, new)
    new = {:off, new_r}, acc ->
      acc
      |> Enum.flat_map(fn {_, c_r} = c ->
        if overlap?(new_r, c_r), do: [c, overlap(new, c)], else: [c]
      end)
  end)
  |> Enum.reduce(0, fn
    {:on, {x, y, z}}, acc -> acc + (Range.size(x) * Range.size(y) * Range.size(z))
    {:off, {x, y, z}}, acc -> acc - (Range.size(x) * Range.size(y) * Range.size(z))
  end)
end

defp overlap?({ax1..ax2, ay1..ay2, az1..az2}, {bx1..bx2, by1..by2, bz1..bz2}) do
  (max(ax1, bx1) <= min(ax2, bx2))
  and (max(ay1, by1) <= min(ay2, by2))
  and (max(az1, bz1) <= min(az2, bz2))
end

defp overlap({_a, {ax1..ax2, ay1..ay2, az1..az2}}, {b, {bx1..bx2, by1..by2, bz1..bz2}}) do
  [_, x1, x2, _] = Enum.sort([ax1, ax2, bx1, bx2])
  [_, y1, y2, _] = Enum.sort([ay1, ay2, by1, by2])
  [_, z1, z2, _] = Enum.sort([az1, az2, bz1, bz2])

  intersection = {x1..x2, y1..y2, z1..z2}
  case b do
    :on -> {:off, intersection}
    :off -> {:on, intersection}
  end
end

  def part2(args) do
    args
    |> String.trim()
    |> String.split(~r/\R/)
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> then(fn [b, rest] ->
        Regex.scan(~r/[-\d]+/, rest)
        |> List.flatten()
        |> Enum.map(&String.to_integer/1)
        |> then(fn [x_min, x_max, y_min, y_max, z_min, z_max] ->
          {String.to_atom(b), {x_min..x_max, y_min..y_max, z_min..z_max}}
        end)
      end)
    end)
    |> count()
  end
end
