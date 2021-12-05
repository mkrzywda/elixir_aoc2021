defmodule AdventOfCode.Day04 do
  def part1(args) do

    [lines | grids] = String.split(args, "\n")
    draws = String.split(lines, ",", trim: true)

    grids =
      grids
      |> Enum.chunk_by(fn elem -> elem == "" end)
      |> Enum.filter(fn elem -> elem != [""] end)
      |> Enum.map(fn grid -> grid_builder(grid, [], []) end)

    {:winner, draw, grid} =
      Enum.reduce_while(draws, {:no_winner, grids}, fn
        draw, {:no_winner, grids} ->
          case drawing(draw, grids) do
            {:no_winner, _new_grids} = resp -> {:cont, resp}
            {:winner, grid, _grids} -> {:halt, {:winner, draw, grid}}
          end
      end)

    ret_winner(draw, grid)
  end

  def part2(args) do

    [lines | grids] = String.split(args, "\n")
    draws = String.split(lines, ",", trim: true)

    grids =
      grids
      |> Enum.chunk_by(fn elem -> elem == "" end)
      |> Enum.filter(fn elem -> elem != [""] end)
      |> Enum.map(fn grid -> grid_builder(grid, [], []) end)


    {:winner, draw, grid} =
      Enum.reduce_while(draws, {:no_winner, grids}, fn
        draw, {:no_winner, grids} ->
          case drawing(draw, grids) do
            {:no_winner, _new_grids} = resp -> {:cont, resp}
            {:winner, grid, grids} ->
              case grids do
                [] -> {:halt, {:winner, draw, grid}}
                grids -> {:cont, {:no_winner, grids}}
              end
          end
      end)

    ret_winner(draw, grid)
  end


  defp ret_winner(draw, {_cols, lines}) do
    String.to_integer(draw) *
      (lines
       |> Enum.map(fn col -> col |> Enum.map(&String.to_integer/1) |> Enum.sum() end)
       |> Enum.sum())
  end

  defp drawing(draw, grids) do
    grids =
      grids
      |> Enum.map(fn {cols, lines} ->
        cols = Enum.map(cols, fn elts -> Enum.filter(elts, fn elt -> elt != draw end) end)
        lines = Enum.map(lines, fn elts -> Enum.filter(elts, fn elt -> elt != draw end) end)
        {cols, lines}
      end)


    {winners, loosers} =
      Enum.split_with(grids, fn {cols, lines} ->
      Enum.find(cols, fn elt -> elt == [] end) != nil or
        Enum.find(lines, fn elt -> elt == [] end) != nil end)

    case winners do
      [] -> {:no_winner, loosers}
      [grid | _] -> {:winner, grid, loosers}
    end
  end


  defp grid_builder([line | lines], [], []) do
    line = String.split(line, " ", trim: true)
    grid_builder(lines, Enum.chunk_every(line, 1), [line])
  end

  defp grid_builder([line_new | lines_new], cols, lines) do
    line = String.split(line_new, " ", trim: true)
    cols = columns_builder(line, cols, [])
    grid_builder(lines_new, cols, [line | lines])
  end

  defp grid_builder([], cols, lines), do: {cols, lines}

  defp columns_builder([col_new | cols_new], [col | cols], acc) do
    columns_builder(cols_new, cols, [[col_new | col] | acc])
  end

  defp columns_builder([], [], acc), do: Enum.reverse(acc)

end
