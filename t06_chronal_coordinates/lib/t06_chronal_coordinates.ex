defmodule T06ChronalCoordinates do
  def call do
    points =
      "./input.txt"
      |> File.stream!()
      |> Stream.with_index()
      |> Enum.map(fn {line, index} ->
        [x, y] =
          line
          |> String.split(", ")
          |> Enum.map(&String.trim/1)
          |> Enum.map(&String.to_integer/1)

        {index, x, y}
      end)

    largest_finite_size(points)
  end

  def largest_finite_size(points) do
    plane = get_plane(points)

    points
    |> Enum.filter(fn pt -> infinite?(points, plane, pt) == false end)
    |> Enum.map(&area_size(points, &1))
    |> Enum.max()
  end

  def area_size(points, point) do
    current_level_size = level_size(points, point)

    task1 = Task.async(fn -> area_size(points, point, 0, &(&1 + 1)) end)
    task2 = Task.async(fn -> area_size(points, point, 0, &(&1 - 1)) end)
    Task.await(task1) + Task.await(task2) - current_level_size
  end

  def area_size(points, {id, x, y}, size, op) do
    current_level_size = level_size(points, {id, x, y})

    if current_level_size == -1 do
      size
    else
      area_size(points, {id, op.(x), y}, size + current_level_size, op)
    end
  end

  def level_size(points, point) do
    task1 = Task.async(fn -> level_size(points, point, 0, &(&1 + 1)) end)
    task2 = Task.async(fn -> level_size(points, point, 0, &(&1 - 1)) end)
    Task.await(task1) + Task.await(task2) - 1
  end

  def level_size(points, {startId, startX, startY}, size, op) do
    if closest_to({startX, startY}, points) == startId do
      level_size(points, {startId, startX, op.(startY)}, size + 1, op)
    else
      size
    end
  end

  def get_plane(points) do
    {{_, min_x, _}, {_, max_x, _}} = Enum.min_max_by(points, &elem(&1, 1))
    {{_, _, min_y}, {_, _, max_y}} = Enum.min_max_by(points, &elem(&1, 2))
    {min_x, min_y, max_x, max_y}
  end

  def __get_plane([head | points]) do
    {_, xMin, yMin} =
      points
      |> Enum.reduce(head, fn {id, x, y}, {idMin, xMin, yMin} ->
        if x <= xMin && y <= yMin do
          {id, x, y}
        else
          {idMin, xMin, yMin}
        end
      end)

    {_, xMax, yMax} =
      points
      |> Enum.reduce(head, fn {id, x, y}, {idMax, xMax, yMax} ->
        if x >= xMax && y >= yMax do
          {id, x, y}
        else
          {idMax, xMax, yMax}
        end
      end)

    {xMin, yMin, xMax, yMax}
  end

  def infinite?(points, plane, point) do
    task1 = Task.async(fn -> infinite?(points, plane, point, {&(&1 + 1), & &1}) end)
    task2 = Task.async(fn -> infinite?(points, plane, point, {&(&1 - 1), & &1}) end)
    task3 = Task.async(fn -> infinite?(points, plane, point, {& &1, &(&1 + 1)}) end)
    task4 = Task.async(fn -> infinite?(points, plane, point, {& &1, &(&1 - 1)}) end)

    Task.await(task1) || Task.await(task2) || Task.await(task3) || Task.await(task4)
  end

  def infinite?(points, plane, {id, x, y}, {xop, yop}) do
    case {closest_to({x, y}, points) == id, at_edge?({x, y}, plane)} do
      {true, false} ->
        infinite?(points, plane, {id, xop.(x), yop.(y)}, {xop, yop})

      {true, true} ->
        true

      {_, _} ->
        false
    end
  end

  def closest_to({x, y}, points) do
    distances =
      points
      |> Enum.map(fn {pid, px, py} ->
        {pid, manhattan({x, y}, {px, py})}
      end)
      |> Enum.sort_by(fn {_pid, distance} -> distance end)

    {{pid, first}, _rest} = List.pop_at(distances, 0)
    {{_, second}, _rest} = List.pop_at(distances, 1)

    if first == second, do: nil, else: pid
  end

  def manhattan({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  def at_edge?({x, y}, {x, y, _, _}), do: true
  def at_edge?({x, y}, {_, _, x, y}), do: true
  def at_edge?({x, _}, {x, _, _, _}), do: true
  def at_edge?({x, _}, {_, _, x, _}), do: true
  def at_edge?({_, y}, {_, y, _, _}), do: true
  def at_edge?({_, y}, {_, _, _, y}), do: true

  def at_edge?({_, _}, {_, _, _, _}), do: false
end
