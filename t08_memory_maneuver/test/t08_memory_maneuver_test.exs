defmodule T08MemoryManeuverTest do
  use ExUnit.Case

  test "sums meta for childless node" do
    assert T08MemoryManeuver.sum_nodes([0, 3, 10, 11, 12]) == 33
  end

  test "sums meta for one-child node" do
    assert T08MemoryManeuver.sum_nodes([1, 1, 0, 1, 99, 2]) == 101
  end

  test "sums meta for two-child node" do
    assert T08MemoryManeuver.sum_nodes([2, 1, 0, 1, 99, 0, 1, 99, 2]) == 200
  end

  test "sums example" do
    assert T08MemoryManeuver.sum_nodes([2, 3, 0, 3, 10, 11, 12, 1, 1, 0, 1, 99, 2, 1, 1, 2]) ==
             138
  end
end
