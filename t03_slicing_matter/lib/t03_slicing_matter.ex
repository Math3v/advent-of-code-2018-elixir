defmodule T03SlicingMatter do
  def call do
    inputs =
      "./input.txt"
      |> File.stream!()
      |> Enum.map(&parse_input(&1))

    intersections(inputs)
  end

  def parse_input(input) do
    matches =
      ~r/#\d+ @ (?<x>\d+),(?<y>\d+): (?<width>\d+)x(?<height>\d+)/
      |> Regex.named_captures(input)
      |> Map.values()
      |> Enum.map(&String.to_integer(&1))

    {Enum.at(matches, 2), Enum.at(matches, 3), Enum.at(matches, 1), Enum.at(matches, 0)}
  end

  def intersections(inputs) do
    {_, _, intersections} =
      inputs
      |> Enum.reduce({MapSet.new(), MapSet.new(), 0}, fn x,
                                                         {intersectionSet, countedSet,
                                                          intersections} ->
        temporalSet =
          x
          |> to_points
          |> Enum.reduce(MapSet.new(), fn x, set -> MapSet.put(set, x) end)

        temporalIntersections =
          intersectionSet
          |> MapSet.intersection(temporalSet)

        intersectionsCount =
          temporalIntersections
          |> MapSet.difference(countedSet)
          |> MapSet.size()

        {MapSet.union(intersectionSet, temporalSet),
         MapSet.union(temporalIntersections, countedSet), intersections + intersectionsCount}
      end)

    intersections
  end

  def to_points({x, y, width, height}) do
    xPts = Enum.map((x + 1)..(x + width), & &1)
    yPts = Enum.map((y + 1)..(y + height), & &1)
    for xPt <- xPts, yPt <- yPts, do: {xPt, yPt}
  end
end
