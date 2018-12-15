defmodule T09Marble do
  def start(players, last_marble) do
    {_, _, scores} =
      1..last_marble
      |> Enum.reduce({1, {0, [0], 0}, %{}}, fn marble, {player, state, scoreMap} ->
        {marble_index, board, score} = place_marble(marble, state)
        newScoreMap = Map.update(scoreMap, player, score, &(&1 + score))
        {rem(player + 1, players), {marble_index, board, 0}, newScoreMap}
      end)

    scores
    |> Map.values()
    |> Enum.max()
  end

  def place_marble(marble, {marble_index, board, score}) do
    if rem(marble, 23) == 0 do
      new_marble_index = adj_marble_index(marble_index, board)
      {popped_marble, new_board} = List.pop_at(board, marble_index - 7)
      {new_marble_index, new_board, score + popped_marble + marble}
    else
      new_marble_index = next_marble_index(marble_index, board)
      new_board = List.insert_at(board, new_marble_index, marble)
      {new_marble_index, new_board, 0}
    end
  end

  defp adj_marble_index(index, board) do
    new_marble_index = index - 7

    cond do
      new_marble_index == -1 -> 0
      new_marble_index < -1 -> Enum.count(board) + new_marble_index
      true -> new_marble_index
    end
  end

  defp next_marble_index(index, board) do
    board_count = Enum.count(board)

    cond do
      board_count == 1 -> 1
      index + 2 == board_count -> board_count
      true -> rem(index + 2, board_count)
    end
  end
end
