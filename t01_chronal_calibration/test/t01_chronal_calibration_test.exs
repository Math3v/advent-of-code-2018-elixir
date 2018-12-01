defmodule T01ChronalCalibrationTest do
  use ExUnit.Case

  test "computes the calibration" do
    assert T01ChronalCalibration.run() == [420]
  end
end
