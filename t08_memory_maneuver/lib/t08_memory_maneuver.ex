defmodule T08MemoryManeuver do
  def parse_node(input) do
    [nchildren | [nmeta | meta]] =
      input
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)

    {nchildren, nmeta, meta}
  end

  def split_children(children) do
    split_children(children, [])
  end

  def split_children([], result), do: result

  def split_children(children, result) do
    size = node_size(children)
    {child, rest} = Enum.split(children, size + 2)
    split_children(rest, result ++ [child])
  end

  def sum_nodes([]), do: {0, []}

  def sum_nodes([0 | [nmeta | meta]]) do
    {to_sum, rest} =
      meta
      |> Enum.reverse()
      |> Enum.split(nmeta)

    {Enum.sum(to_sum), rest}
  end

  def sum_nodes([nchildren | [nmeta | meta]] = nodes) do
    {to_sum, rest} =
      meta
      |> Enum.reverse()
      |> Enum.split(nmeta)

    {Enum.sum(to_sum) + sum_nodes(rest), rest}
  end

  defp node_size([_ | [size | _]]), do: size

  defp sum_last_n_and_return_rest(list, n) do
    {to_sum, rest} =
      list
      |> Enum.reverse()
      |> Enum.split(n)

    {Enum.sum(to_sum), Enum.reverse(rest)}
  end
end
