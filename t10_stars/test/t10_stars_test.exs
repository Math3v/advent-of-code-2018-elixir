defmodule T10StarsTest do
  use ExUnit.Case

  @constellation [
    {9, 1, 0, 2},
    {7, 0, -1, 0},
    {3, -2, -1, 1},
    {6, 10, -2, -1},
    {2, -4, 2, 2},
    {-6, 10, 2, -2},
    {1, 8, 1, -1},
    {1, 7, 1, 0},
    {-3, 11, 1, -2},
    {7, 6, -1, -1},
    {-2, 3, 1, 0},
    {-4, 3, 2, 0},
    {10, -3, -1, 1},
    {5, 11, 1, -2},
    {4, 7, 0, -1},
    {8, -2, 0, 1},
    {15, 0, -2, 0},
    {1, 6, 1, 0},
    {8, 9, 0, -1},
    {3, 3, -1, 1},
    {0, 5, 0, -1},
    {-2, 2, 2, 0},
    {5, -2, 1, 2},
    {1, 4, 2, 1},
    {-2, 7, 2, -2},
    {3, 6, -1, -1},
    {5, 0, 1, 0},
    {-6, 0, 2, 0},
    {5, 9, 1, -2},
    {14, 7, -2, 0},
    {-3, 6, 2, -1}
  ]

  test "moves single star" do
    star = {15, 0, -2, 0}
    assert T10Stars.move_star(star) == {13, 0, -2, 0}
  end

  test "computes constellation boundaries" do
    constellation = [
      {15, 0, -2, 0},
      {30, -2, 0, 0},
      {-3, 17, 0, 0},
      {4, -9, -3, 0}
    ]

    assert T10Stars.constellation_boundaries(constellation) == {-3, 30, -9, 17}
  end

  test "prints constellation" do
    @constellation
    |> Enum.map(&T10Stars.move_star/1)
    |> Enum.map(&T10Stars.move_star/1)
    |> Enum.map(&T10Stars.move_star/1)
    |> T10Stars.print_constellation()
  end

  test "stops when constellation is the smallest" do
    @constellation
    |> T10Stars.smallest_constellation()
    |> T10Stars.print_constellation()
  end

  test "parses input line" do
    assert T10Stars.parse_line("position=<-6, 10> velocity=< 2, -2>") == {-6, 10, 2, -2}
  end
end
