defmodule T08MemoryManeuver do
  def call do
    "./input.txt"
    |> File.read!()
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> sum_nodes()
  end

  def sum_nodes(nodes) do
    {sum, _} = next_node(nodes)
    sum
  end

  defp next_node(numbers) do
    [num_children, num_metas | numbers] = numbers
    {children, numbers} = next_nodes(numbers, num_children)
    {metas, numbers} = Enum.split(numbers, num_metas)
    sum = Enum.sum(metas) + Enum.sum(children)
    {sum, numbers}
  end

  defp next_nodes(numbers, nchildren) do
    {reversed_children, numbers} =
      [nil]
      |> Stream.cycle()
      |> Stream.take(nchildren)
      |> Enum.reduce({[], numbers}, fn _, {children, numbers} ->
        {child, numbers} = next_node(numbers)
        {[child | children], numbers}
      end)

    {Enum.reverse(reversed_children), numbers}
  end
end
