defmodule Exercise do
  def run() do
    load_file("day_2/data.txt") |> games()
  end

  def game_power(game) do
    IO.inspect(game)
    game["green"] * game["red"] * game["blue"]
  end

  def games(data) do
    data
    |> String.split("\n")
    |> Enum.map(&parse_game/1)
    |> Enum.map(&game_power/1)
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

IO.inspect(Exercise.run())
