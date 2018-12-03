defmodule T03SlicingMatterTest do
  use ExUnit.Case

  test "returns all points for 1x1" do
    assert T03SlicingMatter.to_points({1, 3, 1, 1}) == [{2, 4}]
  end

  test "returns all points for 2x2" do
    assert T03SlicingMatter.to_points({1, 3, 2, 2}) == [{2, 4}, {2, 5}, {3, 4}, {3, 5}]
  end

  test "computes intersections" do
    inputs = [{1, 3, 4, 4}, {3, 1, 4, 4}, {5, 5, 2, 2}]
    assert T03SlicingMatter.intersections(inputs) == 4
  end

  test "computes intersections only once" do
    inputs = [{1, 3, 1, 1}, {1, 3, 1, 1}, {1, 3, 1, 1}]
    assert T03SlicingMatter.intersections(inputs) == 1
  end

  test "parses input string" do
    assert T03SlicingMatter.parse_input("#1 @ 1,3: 4x4") == {1, 3, 4, 4}
  end

  test "parses large input" do
    assert T03SlicingMatter.parse_input("#2 @ 11,13: 42x430") == {11, 13, 42, 430}
  end
end
