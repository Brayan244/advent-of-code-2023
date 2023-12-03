defmodule Exercise do
  def run(red_count \\ 0, green_count \\ 0, blue_count \\ 0) do
    load_file("day_2/data.txt") |> games(green_count, red_count, blue_count)
  end

  def is_game_possible?(game, green_count, red_count, blue_count) do
    game["green"] <= green_count && game["red"] <= red_count && game["blue"] <= blue_count
  end

  def games(data, green_count, red_count, blue_count) do
    data
    |> String.split("\n")
    |> Enum.map(&parse_game/1)
    |> Enum.filter(&is_game_possible?(&1, green_count, red_count, blue_count))
    |> Enum.map(& &1[:id])
    |> Enum.sum()
  end

  def game_id(game_data) do
    game_data
    |> String.split(" ")
    |> List.last()
    |> String.to_integer()
  end

  def color_data(game) do
    draws = String.split(game, ";")

    Enum.reduce(draws, %{}, fn draw, acc ->
      counters = String.split(draw, ",") |> Enum.map(&String.trim/1)

      Enum.reduce(counters, acc, fn color_count, acc ->
        [count, color] = String.split(color_count, " ")

        case acc[color] do
          nil -> Map.put(acc, color, String.to_integer(count))
          _ -> Map.put(acc, color, Enum.max([acc[color], String.to_integer(count)]))
        end
      end)
    end)
  end

  def parse_game(data) do
    [id_data, game_data] = String.split(data, ":")

    Map.merge(%{id: game_id(id_data)}, color_data(game_data))
  end

  defp load_file(path) do
    {:ok, data} = File.read(path)

    data
  end
end

IO.inspect(Exercise.run(12, 13, 14))
