defmodule T05AlchemicalReduction do
  def reduce(input) do
    input
    |> do_reduce([])
    |> Enum.count()
  end

  defp do_reduce(<<letter, rest::binary>>, [letter2 | acc])
       when abs(letter - letter2) == 32,
       do: do_reduce(rest, acc)

  defp do_reduce(<<letter, rest::binary>>, acc), do: do_reduce(rest, [letter | acc])
  defp do_reduce(<<>>, acc), do: acc
end
