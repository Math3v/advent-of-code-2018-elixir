defmodule T02InventoryManagementTest do
  use ExUnit.Case

  test "computes unit checksum for abcdef" do
    assert T02InventoryManagement.unit_checksum("abcdef") == {0, 0}
  end

  test "computes unit checksum for bababc" do
    assert T02InventoryManagement.unit_checksum("bababc") == {1, 1}
  end

  test "computes unit checksum for abbcde" do
    assert T02InventoryManagement.unit_checksum("abbcde") == {1, 0}
  end

  test "computes unit checksum for abcccd" do
    assert T02InventoryManagement.unit_checksum("abcccd") == {0, 1}
  end

  test "computes unit checksum for aabcdd" do
    assert T02InventoryManagement.unit_checksum("aabcdd") == {1, 0}
  end
end
