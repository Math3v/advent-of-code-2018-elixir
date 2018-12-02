defmodule T02InventoryManagement do
  def call do
    "./input.txt"
    |> File.stream!
    |> Stream.map(&unit_checksum(&1))
    |> Enum.reduce({0, 0}, fn {twos, threes}, {accTwos, accThrees} ->
      {twos + accTwos, threes + accThrees}
    end)
  end

  def unit_checksum(input) do
    input
    |> String.graphemes()
    |> Enum.reduce(%{}, fn x, acc ->
      Map.update(acc, String.to_atom(x), 1, &(&1 + 1))
    end)
    |> Enum.reduce({0, 0}, fn {_k, v}, {twos, threes} ->
      case v do
        2 -> {increment_if_zero(twos), threes}
        3 -> {twos, increment_if_zero(threes)}
        _ -> {twos, threes}
      end
    end)
  end

  def increment_if_zero(0), do: 1
  def increment_if_zero(x), do: x
end
