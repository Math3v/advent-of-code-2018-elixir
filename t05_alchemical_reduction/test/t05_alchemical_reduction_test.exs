defmodule T05AlchemicalReductionTest do
  use ExUnit.Case

  test "reduces simple chemical" do
    assert T05AlchemicalReduction.reduce("dabAcCaCBAcCcaDA") == "dabCBAcaDA"
  end

  test "reduces smaller particles" do
    assert T05AlchemicalReduction.reduce("aA") == ""
    assert T05AlchemicalReduction.reduce("abAB") == "abAB"
    assert T05AlchemicalReduction.reduce("aabAAB") == "aabAAB"
  end
end
