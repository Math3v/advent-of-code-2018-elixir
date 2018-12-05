defmodule T04ReposeRecordTest do
  use ExUnit.Case

  test "sleeps most" do
    assert T04ReposeRecord.sleeps_most([
             "[1518-11-01 00:00] Guard #10 begins shift",
             "[1518-11-01 00:05] falls asleep",
             "[1518-11-01 00:25] wakes up",
             "[1518-11-01 00:30] falls asleep",
             "[1518-11-01 00:55] wakes up",
             "[1518-11-01 23:58] Guard #99 begins shift",
             "[1518-11-02 00:40] falls asleep",
             "[1518-11-02 00:50] wakes up",
             "[1518-11-03 00:05] Guard #10 begins shift",
             "[1518-11-03 00:24] falls asleep",
             "[1518-11-03 00:29] wakes up",
             "[1518-11-04 00:02] Guard #99 begins shift",
             "[1518-11-04 00:36] falls asleep",
             "[1518-11-04 00:46] wakes up",
             "[1518-11-05 00:03] Guard #99 begins shift",
             "[1518-11-05 00:45] falls asleep",
             "[1518-11-05 00:55] wakes up"
           ]) == {10, 50, 24}
  end

  test "sorts inputs" do
    assert T04ReposeRecord.sort_inputs([
             "[1518-11-01 00:05] falls asleep",
             "[1518-11-01 00:00] Guard #10 begins shift",
             "[1518-11-05 00:55] wakes up",
             "[1518-11-01 00:25] wakes up",
             "[1518-11-01 00:30] falls asleep",
             "[1518-11-01 00:55] wakes up",
             "[1518-11-01 23:58] Guard #99 begins shift",
             "[1518-11-02 00:40] falls asleep",
             "[1518-11-02 00:50] wakes up",
             "[1518-11-03 00:05] Guard #10 begins shift",
             "[1518-11-03 00:29] wakes up",
             "[1518-11-04 00:02] Guard #99 begins shift",
             "[1518-11-04 00:36] falls asleep",
             "[1518-11-04 00:46] wakes up",
             "[1518-11-05 00:03] Guard #99 begins shift",
             "[1518-11-03 00:24] falls asleep",
             "[1518-11-05 00:45] falls asleep"
           ]) == [
             "[1518-11-01 00:00] Guard #10 begins shift",
             "[1518-11-01 00:05] falls asleep",
             "[1518-11-01 00:25] wakes up",
             "[1518-11-01 00:30] falls asleep",
             "[1518-11-01 00:55] wakes up",
             "[1518-11-01 23:58] Guard #99 begins shift",
             "[1518-11-02 00:40] falls asleep",
             "[1518-11-02 00:50] wakes up",
             "[1518-11-03 00:05] Guard #10 begins shift",
             "[1518-11-03 00:24] falls asleep",
             "[1518-11-03 00:29] wakes up",
             "[1518-11-04 00:02] Guard #99 begins shift",
             "[1518-11-04 00:36] falls asleep",
             "[1518-11-04 00:46] wakes up",
             "[1518-11-05 00:03] Guard #99 begins shift",
             "[1518-11-05 00:45] falls asleep",
             "[1518-11-05 00:55] wakes up"
           ]
  end

  test "parses input string" do
    assert T04ReposeRecord.parse_input("[1518-11-05 00:55] wakes up", 10) == {10, :wake, 5, 0, 55}

    assert T04ReposeRecord.parse_input("[1518-11-06 00:42] falls asleep", 10) ==
             {10, :sleep, 6, 0, 42}

    assert T04ReposeRecord.parse_input("[1518-11-06 00:35] Guard #12 begins shift", 10) ==
             {12, :guard, 6, 0, 35}
  end

  test "spreads minutes" do
    assert T04ReposeRecord.spread_minutes(5, 7) == [5, 6]
    assert T04ReposeRecord.spread_minutes(58, 3) == [58, 59, 0, 1, 2]
    assert T04ReposeRecord.spread_minutes(57, 0) == [57, 58, 59]
  end

  test "updates sleeping minutes map" do
    map = T04ReposeRecord.update_sleeping_minutes_map(Map.new(), 10, 59, 1)

    assert map == %{
             {10, 59} => 1,
             {10, 0} => 1
           }

    assert T04ReposeRecord.update_sleeping_minutes_map(map, 10, 57, 0) == %{
             {10, 0} => 1,
             {10, 57} => 1,
             {10, 58} => 1,
             {10, 59} => 2
           }
  end
end
