defmodule T04ReposeRecord do
  def call do
    "./input.txt"
    |> File.stream!
    |> Enum.sort()
    |> sleeps_most()
  end

  def sort_inputs(inputs) do
    Enum.sort(inputs)
  end

  def sleeps_most(inputs) do
    {_, _, sleeping_map, minutes_map} =
      inputs
      |> Enum.reduce({nil, nil, Map.new(), Map.new()}, fn input,
                                                          {current_guard, previous_input,
                                                           sleeping_map, minutes_map} ->
        parsed_input = parse_input(input, current_guard)
        {guard, action, _, _, _} = parsed_input

        case action do
          :guard ->
            {guard, parsed_input, sleeping_map, minutes_map}

          :sleep ->
            {guard, parsed_input, sleeping_map, minutes_map}

          :wake ->
            tdiff = datetime_diff(previous_input, parsed_input)
            new_sleeping_map = Map.update(sleeping_map, guard, tdiff, &(&1 + tdiff))

            {_, _, _, _, minute_from} = previous_input
            {_, _, _, _, minute_to} = parsed_input

            new_minutes_map =
              update_sleeping_minutes_map(minutes_map, guard, minute_from, minute_to)

            {guard, parsed_input, new_sleeping_map, new_minutes_map}
        end
      end)

    {guard, max} =
      Enum.reduce(sleeping_map, {0, 0}, fn {key, val}, {guard, max} ->
        if val > max do
          {key, val}
        else
          {guard, max}
        end
      end)

    {_, minute, _} =
      Enum.reduce(minutes_map, {guard, 0, 0}, fn {{key_guard, key_minute}, val},
                                                 {guard, minute, max} ->
        if key_guard == guard && val > max do
          {guard, key_minute, val}
        else
          {guard, minute, max}
        end
      end)

    {guard, max, minute}
  end

  def update_sleeping_minutes_map(sleeping_minutes_map, guard, from, to) do
    spread_minutes(from, to)
    |> Enum.reduce(sleeping_minutes_map, fn minute, map ->
      Map.update(map, {guard, minute}, 1, &(&1 + 1))
    end)
  end

  def spread_minutes(from, to) do
    do_spread_minutes(from, decrease_minute(to), [from])
    |> Enum.reverse()
  end

  def do_spread_minutes(_from, to, [to | t]), do: [to | t]

  def do_spread_minutes(from, to, [h | t]),
    do: do_spread_minutes(from, to, [increase_minute(h)] ++ [h | t])

  def increase_minute(59), do: 0
  def increase_minute(x), do: x + 1

  def decrease_minute(0), do: 59
  def decrease_minute(x), do: x - 1

  def datetime_diff(prev, curr) do
    d1 = to_datetime(prev)
    d2 = to_datetime(curr)
    DateTime.diff(d2, d1) / 60
  end

  def parse_input(input, guard_id) do
    matches =
      ~r/\[\d+-\d+-(?<day>\d+) (?<hour>\d+):(?<minute>\d+)\].*/
      |> Regex.named_captures(input)
      |> Map.values()
      |> Enum.map(&String.to_integer(&1))

    action = parse_action(input)
    new_guard_id = get_guard_id(action, input, guard_id)

    {new_guard_id, action, Enum.at(matches, 0), Enum.at(matches, 1), Enum.at(matches, 2)}
  end

  def to_datetime({_, _, day, hour, minute}) do
    %DateTime{
      year: 2018,
      month: 12,
      day: day,
      hour: hour,
      minute: minute,
      second: 0,
      zone_abbr: "UTC",
      utc_offset: 0,
      std_offset: 0,
      time_zone: "Etc/UTC"
    }
  end

  def parse_action(input) do
    cond do
      String.contains?(input, "wakes") -> :wake
      String.contains?(input, "falls") -> :sleep
      true -> :guard
    end
  end

  def get_guard_id(:guard, input, _), do: parse_guard_id(input)
  def get_guard_id(_, _, guard_id), do: guard_id

  def parse_guard_id(input) do
    ~r/.*#(?<id>\d+)/
    |> Regex.named_captures(input)
    |> Map.values()
    |> Enum.map(&String.to_integer(&1))
    |> Enum.at(0)
  end
end
