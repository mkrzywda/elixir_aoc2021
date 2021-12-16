defmodule AdventOfCode.Day16 do

def part1(args) do
  args
  |> String.trim()
  |> hex2bin()
  |> parse_package()
  |> elem(0)
  |> count()
end

def hex2bin(string) do
  string
  |> String.graphemes()
  |> Enum.map(&String.to_integer(&1, 16))
  |> Enum.map(&int2bin/1)
  |> Enum.into(<<>>)
end

def int2bin(n) do
  bitstring = n |> Integer.digits(2) |> Enum.map(&<<&1>>) |> Enum.into(<<>>)
  padding_size = 4 - byte_size(bitstring)
  <<padding::binary-size(padding_size), _::binary>> = <<0, 0, 0, 0>>
  padding <> bitstring
end

def bit2int(bs), do: bs |> :erlang.binary_to_list() |> Integer.undigits(2)

def parse_package(binary) do
  {v, tl} = parse_version(binary)
  {inner, tl} = parse(tl)
  {{v, inner}, tl}
end

def parse_packages(<<>>), do: []

def parse_packages(binary) do
  {p, tl} = parse_package(binary)
  [p | parse_packages(tl)]
end

def part2(args) do
  args
  |> String.trim()
  |> hex2bin()
  |> parse_package()
  |> elem(0)
  |> eval()
end

  def parse_n_packages(tl, 0), do: {[], tl}

  def parse_n_packages(binary, n) do
    {p, tl} = parse_package(binary)
    {ps, tl} = parse_n_packages(tl, n - 1)
    {[p | ps], tl}
  end

  def parse(<<1, 0, 0, tl::binary>>), do: parse_lit(tl)
  def parse(<<o::binary-size(3), tl::binary>>), do: parse_op(tl, bit2int(o))

  def parse_version(<<v::binary-size(3), tl::binary>>), do: {{:v, bit2int(v)}, tl}

  def parse_lit(bitstring), do: parse_lit(bitstring, <<>>)
  def parse_lit(<<1, b::binary-size(4), tl::binary>>, res), do: parse_lit(tl, res <> b)
  def parse_lit(<<0, b::binary-size(4), tl::binary>>, res), do: {{:l, bit2int(res <> b)}, tl}

  def parse_op(<<0, tl::binary>>, op) do
    <<length::binary-size(15), tl::binary>> = tl
    length = bit2int(length)
    <<sub::binary-size(length), tl::binary>> = tl
    {{:o, op, parse_packages(sub)}, tl}
  end

  def parse_op(<<1, tl::binary>>, op) do
    <<length::binary-size(11), tl::binary>> = tl
    length = bit2int(length)
    {operands, tl} = parse_n_packages(tl, length)
    {{:o, op, operands}, tl}
  end

  def count({:v, v}), do: v
  def count({:l, _}), do: 0
  def count({:o, _, lst}), do: lst |> Enum.map(&count/1) |> Enum.sum()
  def count({t1, t2}), do: count(t1) + count(t2)

  def eval({{:v, _}, r}), do: eval(r)
  def eval({:l, n}), do: n
  def eval({:o, 0, lst}), do: lst |> Enum.map(&eval/1) |> Enum.sum()
  def eval({:o, 1, lst}), do: lst |> Enum.map(&eval/1) |> Enum.product()
  def eval({:o, 2, lst}), do: lst |> Enum.map(&eval/1) |> Enum.min()
  def eval({:o, 3, lst}), do: lst |> Enum.map(&eval/1) |> Enum.max()
  def eval({:o, 5, [l, r]}), do: if(eval(l) > eval(r), do: 1, else: 0)
  def eval({:o, 6, [l, r]}), do: if(eval(l) < eval(r), do: 1, else: 0)
  def eval({:o, 7, [l, r]}), do: if(eval(l) == eval(r), do: 1, else: 0)
end
