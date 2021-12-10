defmodule AdventOfCode.Day10 do

  def part1(args) do
    args
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(fn line -> part_valid(line) end)
    |> Enum.filter(&match?({:corrupted, _}, &1))
    |> Enum.map(fn {:corrupted, on} -> score(on) end)
    |> Enum.sum()
  end


  def part_valid(chunk, stack \\ [])
  def part_valid([], []), do: :valid
  def part_valid([], still_open), do: {:incomplete, still_open}

  def part_valid([next | rest], open_chunks) do
    if opener?(next) do
      part_valid(rest, [next | open_chunks])
    else
      [expected | remaining_open_chunks] = open_chunks

      if matching?(next, expected) do
        part_valid(rest, remaining_open_chunks)
      else
        {:corrupted, next}
      end
    end
  end

  def opener?("("), do: true
  def opener?("["), do: true
  def opener?("{"), do: true
  def opener?("<"), do: true
  def opener?(_closer), do: false

  def matching?("(", ")"), do: true
  def matching?("[", "]"), do: true
  def matching?("{", "}"), do: true
  def matching?("<", ">"), do: true
  def matching?(")", "("), do: true
  def matching?("]", "["), do: true
  def matching?("}", "{"), do: true
  def matching?(">", "<"), do: true
  def matching?(_, _), do: false

  def bracket_change("("), do: ")"
  def bracket_change("["), do: "]"
  def bracket_change("{"), do: "}"
  def bracket_change("<"), do: ">"

  def score(")"), do: 3
  def score("]"), do: 57
  def score("}"), do: 1197
  def score(">"), do: 25137

  def part2(args) do
    scores =
      args
      |> String.split("\n")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&part_valid/1)
      |> Enum.filter(&match?({:incomplete, _remaining}, &1))
      |> Enum.map(fn {:incomplete, remaining} -> Enum.map(remaining, &bracket_change/1) end)
      |> Enum.map(&score_completion/1)

    middle_index = div(length(scores), 2)

    Enum.sort(scores)
    |> Enum.at(middle_index)
  end

  def score_completion(remaining) do
    Enum.reduce(remaining, 0, fn char, score ->
      point =
        case char do
          ")" -> 1
          "]" -> 2
          "}" -> 3
          ">" -> 4
        end

      score * 5 + point
    end)
  end
end
