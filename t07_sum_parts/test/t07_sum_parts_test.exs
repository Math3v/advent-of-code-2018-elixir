defmodule T07SumPartsTest do
  use ExUnit.Case

  @nextStepsMap %{
    "C" => ["A", "F"],
    "A" => ["B", "D"],
    "F" => ["E"],
    "B" => ["E"],
    "D" => ["E"]
  }

  @prerequisitiesMap %{
    "A" => ["C"],
    "F" => ["C"],
    "B" => ["A"],
    "D" => ["A"],
    "E" => ["B", "D", "F"]
  }

  test "parses input lines" do
    lines = [
      "Step C must be finished before step A can begin.",
      "Step C must be finished before step F can begin.",
      "Step A must be finished before step B can begin.",
      "Step A must be finished before step D can begin.",
      "Step B must be finished before step E can begin.",
      "Step D must be finished before step E can begin.",
      "Step F must be finished before step E can begin."
    ]

    {nextSteps, prerequisities} = T07SumParts.parse_lines(lines)

    assert Map.equal?(@nextStepsMap, nextSteps) == true
    assert Map.equal?(@prerequisitiesMap, prerequisities) == true
  end

  test "parses input line" do
    assert T07SumParts.parse_line("Step C must be finished before step A can begin.") ==
             {"C", "A"}
  end

  test "computes order of steps" do
    assert T07SumParts.order_steps(@nextStepsMap, @prerequisitiesMap, ["C"]) == "CABDFE"
  end
end
