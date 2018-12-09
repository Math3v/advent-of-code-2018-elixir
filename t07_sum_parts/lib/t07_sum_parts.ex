defmodule T07SumParts do
  def call do
    lines =
      "./input.txt"
      |> File.stream!()
      |> Enum.reduce([], fn line, acc -> acc ++ [line] end)

    {nextStepsMap, prerequisitiesMap} = parse_lines(lines)

    order_steps(nextStepsMap, prerequisitiesMap, ["W", "R", "G"])
  end

  def parse_lines(lines) do
    lines
    |> Enum.reduce({%{}, %{}}, fn line, {nextSteps, prerequisities} ->
      {a, b} = parse_line(line)

      {
        Map.update(nextSteps, a, [b], &(&1 ++ [b])),
        Map.update(prerequisities, b, [a], &(&1 ++ [a]))
      }
    end)
  end

  def parse_line(line) do
    matches =
      ~r/Step (?<step1>[A-Z]{1}) must be finished before step (?<step2>[A-Z]{1}) can begin./
      |> Regex.named_captures(line)

    {matches["step1"], matches["step2"]}
  end

  def order_steps(nextStepMap, prerequisitiesMap, enabled) do
    do_order_steps(nextStepMap, prerequisitiesMap, enabled, "")
  end

  defp do_order_steps(_, _, [], result), do: result

  defp do_order_steps(nextStepsMap, prerequisitiesMap, enabled, result) do
    {nextStep, enabledRest} = next_enabled_step(enabled, prerequisitiesMap, result, 0)

    nextEnabled = Map.get(nextStepsMap, nextStep)

    if nextEnabled do
      do_order_steps(
        nextStepsMap,
        prerequisitiesMap,
        update_enabled_list(enabledRest, nextEnabled),
        "#{result}#{nextStep}"
      )
    else
      do_order_steps(nextStepsMap, prerequisitiesMap, enabledRest, "#{result}#{nextStep}")
    end
  end

  defp next_enabled_step(enabled, prerequisitiesMap, result, pop_at) when is_list(enabled) do
    {next, rest} =
      enabled
      |> Enum.sort()
      |> List.pop_at(pop_at)

    prerequisities = Map.get(prerequisitiesMap, next, [])

    suffice =
      prerequisities
      |> Enum.all?(fn x -> String.contains?(result, x) end)

    if suffice do
      {next, rest}
    else
      next_enabled_step(enabled, prerequisitiesMap, result, pop_at + 1)
    end
  end

  defp update_enabled_list(enabled, values) when is_list(enabled) do
    map =
      enabled
      |> List.flatten()
      |> MapSet.new()

    values
    |> Enum.reduce(map, fn x, map -> MapSet.put(map, x) end)
    |> MapSet.to_list()
  end
end
