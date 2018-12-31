defmodule T10Stars do
  def call do
    constellation = "./input.txt"
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
    
    constellation
    |> smallest_constellation()
    |> print_constellation()
  end

  def parse_line(line) do
    line = String.replace(line, " ", "")

    IO.puts(line)

    captures =
      Regex.named_captures(
        ~r/position=<(?<x>[\-0-9]+),(?<y>[\-0-9]+)>velocity=<(?<vx>[\-0-9]+),(?<vy>[\-0-9]+)>/,
        line
      )

    {String.to_integer(captures["x"]), String.to_integer(captures["y"]),
     String.to_integer(captures["vx"]), String.to_integer(captures["vy"])}
  end

  def smallest_constellation(constellation) do
    current_size = constellation_size(constellation)

    new_constellation =
      constellation
      |> Enum.map(&move_star/1)

    new_size = constellation_size(new_constellation)

    if new_size > current_size do
      constellation
    else
      smallest_constellation(new_constellation)
    end
  end

  defp constellation_size(constellation) do
    {min_x, max_x, min_y, max_y} = constellation_boundaries(constellation)
    abs(min_x - max_x) + abs(min_y - max_y)
  end

  def print_constellation(constellation) do
    {min_x, max_x, min_y, max_y} = constellation_boundaries(constellation)

    IO.puts("")

    for y <- min_y..max_y do
      for x <- min_x..max_x do
        present =
          Enum.any?(constellation, fn {tx, ty, _, _} ->
            x == tx && y == ty
          end)

        if present do
          IO.write("#")
        else
          IO.write(".")
        end
      end

      IO.puts("")
    end
  end

  def constellation_boundaries(constellation) do
    {{min_x, _, _, _}, {max_x, _, _, _}} =
      Enum.min_max_by(constellation, fn {x, _, _, _} -> x end)

    {{_, min_y, _, _}, {_, max_y, _, _}} =
      Enum.min_max_by(constellation, fn {_, y, _, _} -> y end)

    {min_x, max_x, min_y, max_y}
  end

  def move_star({x, y, vx, vy}) do
    {x + vx, y + vy, vx, vy}
  end
end
