defmodule T06ChronalCoordinatesTest do
  use ExUnit.Case

  @points [
    {1, 1, 1},
    {2, 1, 6},
    {3, 8, 3},
    {4, 3, 4},
    {5, 5, 5},
    {6, 8, 9}
  ]

  test "largest finite area" do
    assert T06ChronalCoordinates.largest_finite_size(@points) == 17
  end

  test "computes size of an area" do
    assert T06ChronalCoordinates.area_size(@points, {4, 3, 4}) == 9
    assert T06ChronalCoordinates.area_size(@points, {5, 5, 5}) == 17
  end

  test "computes plane from points" do
    assert T06ChronalCoordinates.get_plane(@points) == {1, 1, 8, 9}
  end

  test "recognizes infinite area" do
    plane = {1, 1, 8, 9}

    assert T06ChronalCoordinates.infinite?(@points, plane, {1, 1, 1}) == true
    assert T06ChronalCoordinates.infinite?(@points, plane, {2, 1, 6}) == true
    assert T06ChronalCoordinates.infinite?(@points, plane, {3, 8, 3}) == true
    assert T06ChronalCoordinates.infinite?(@points, plane, {4, 3, 4}) == false
    assert T06ChronalCoordinates.infinite?(@points, plane, {5, 5, 5}) == false
    assert T06ChronalCoordinates.infinite?(@points, plane, {6, 8, 9}) == true
  end

  test "coords closest to" do
    points = [
      {1, 1, 1},
      {5, 5, 5}
    ]

    assert T06ChronalCoordinates.closest_to({2, 2}, points) == 1
    assert T06ChronalCoordinates.closest_to({4, 4}, points) == 5
    assert T06ChronalCoordinates.closest_to({3, 3}, points) == nil
  end

  test "coords are at the edge" do
    plane = {1, 1, 8, 9}
    assert T06ChronalCoordinates.at_edge?({2, 2}, plane) == false
    assert T06ChronalCoordinates.at_edge?({1, 3}, plane) == true
    assert T06ChronalCoordinates.at_edge?({3, 1}, plane) == true
    assert T06ChronalCoordinates.at_edge?({8, 9}, plane) == true
    assert T06ChronalCoordinates.at_edge?({7, 8}, plane) == false
  end

  test "computes manhattan distance" do
    assert T06ChronalCoordinates.manhattan({0, 0}, {1, 1}) == 2
    assert T06ChronalCoordinates.manhattan({3, 5}, {2, 7}) == 3
  end
end
