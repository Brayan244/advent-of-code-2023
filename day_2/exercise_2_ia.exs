defmodule Exercise do
  def run() do
    "day_2/data.txt"
    |> load_file()
    |> parse_data()
    |> Enum.map(&game_power/1)
    |> Enum.sum()
  end

  defp game_power(game) do
    Enum.reduce([:green, :red, :blue], 1, fn color, acc ->
      acc * Map.get(game, color, 0)
    end)
  end

  defp parse_data(data) do
    data
    |> String.split("\n")
    |> Enum.map(&parse_game/1)
  end

  defp parse_game(data) do
    [id_str, game_str] = String.split(data, ": ")
    Map.merge(%{id: game_id(id_str)}, parse_colors(game_str))
  end

  defp parse_colors(colors_str) do
    colors_str
    |> String.split(";")
    |> Enum.map(&String.split(&1, ","))
    |> List.flatten()
    |> Enum.reduce(%{}, &update_color/2)
  end

  defp update_color(draw, acc) do
    # Filtramos cualquier cadena vacía que pueda haberse colado debido a espacios extra
    parts = String.split(draw, " ") |> Enum.filter(fn x -> x != "" end)

    # Ahora, esperamos que 'parts' tenga exactamente dos elementos: count_str y color_with_comma
    [count_str, color_with_comma] = parts
    color = String.trim_trailing(color_with_comma, ",")
    count = String.to_integer(count_str)

    Map.update(acc, String.to_atom(color), count, &Enum.max([count, &1]))
  end

  defp game_id(id_str) do
    id_str
    |> String.split(" ")
    |> List.last()
    |> String.to_integer()
  end

  defp load_file(path) do
    {:ok, data} = File.read(path)
    data
  end
end

IO.inspect(Exercise.run())
