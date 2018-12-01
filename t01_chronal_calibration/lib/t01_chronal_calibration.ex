defmodule T01ChronalCalibration do
  def run do
    File.stream!("./input.txt")
    |> Stream.map(&Integer.parse(&1))
    |> Stream.map(&Tuple.to_list(&1))
    |> Stream.map(&List.first(&1))
    |> Enum.scan(0, &(&1 + &2))
    |> Enum.take(-1)
  end
end
