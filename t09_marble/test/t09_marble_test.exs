defmodule T09MarbleTest do
  use ExUnit.Case
  doctest T09Marble

  test "plays game 1" do
    assert T09Marble.start(7, 25) == 32
  end

  # @tag :skip
  test "plays game 2" do
    assert T09Marble.start(10, 1618) == 8317
  end

  # @tag :skip
  test "plays game 3" do
    assert T09Marble.start(13, 7999) == 146_373
  end

  # @tag :skip
  test "plays game 4" do
    assert T09Marble.start(17, 1104) == 2764
  end

  # @tag :skip
  test "plays game 5" do
    assert T09Marble.start(21, 6111) == 54718
  end

  # @tag :skip
  test "plays game 6" do
    assert T09Marble.start(30, 5807) == 37305
  end

  test "places marble" do
    assert T09Marble.place_marble(7, {5, [0, 4, 2, 5, 1, 6, 3], 0}) ==
             {7, [0, 4, 2, 5, 1, 6, 3, 7], 0}

    assert T09Marble.place_marble(5, {1, [0, 4, 2, 1, 3], 0}) == {3, [0, 4, 2, 5, 1, 3], 0}
    assert T09Marble.place_marble(4, {3, [0, 2, 1, 3], 0}) == {1, [0, 4, 2, 1, 3], 0}
    assert T09Marble.place_marble(3, {1, [0, 2, 1], 0}) == {3, [0, 2, 1, 3], 0}
    assert T09Marble.place_marble(2, {1, [0, 1], 0}) == {1, [0, 2, 1], 0}
    assert T09Marble.place_marble(1, {0, [0], 0}) == {1, [0, 1], 0}

    assert T09Marble.place_marble(
             23,
             {13,
              [0, 16, 8, 17, 4, 18, 9, 19, 2, 20, 10, 21, 5, 22, 11, 1, 12, 6, 13, 3, 14, 7, 15],
              0}
           ) ==
             {6, [0, 16, 8, 17, 4, 18, 19, 2, 20, 10, 21, 5, 22, 11, 1, 12, 6, 13, 3, 14, 7, 15],
              23 + 9}

    assert T09Marble.place_marble(
             69,
             {6,
              [0, 16, 8, 17, 4, 18, 22, 19, 2, 20, 10, 21, 5, 9, 11, 1, 12, 6, 13, 3, 14, 7, 15],
              3}
           ) ==
             {0, [0, 16, 8, 17, 4, 18, 22, 19, 2, 20, 10, 21, 5, 9, 11, 1, 12, 6, 13, 3, 14, 7],
              69 + 15 + 3}

    assert T09Marble.place_marble(
             46,
             {5,
              [0, 16, 8, 17, 4, 22, 18, 19, 2, 20, 10, 21, 5, 9, 11, 1, 12, 6, 13, 3, 14, 7, 15],
              0}
           ) ==
             {21, [0, 16, 8, 17, 4, 22, 18, 19, 2, 20, 10, 21, 5, 9, 11, 1, 12, 6, 13, 3, 14, 15],
              46 + 7}

    assert T09Marble.place_marble(23, {0, [0, 1, 2, 3, 4, 5, 6, 7], 0}) ==
             {1, [0, 2, 3, 4, 5, 6, 7], 24}
  end
end
