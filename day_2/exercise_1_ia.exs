defmodule Exercise do
  def run(red_count \\ 0, green_count \\ 0, blue_count \\ 0) do
    "day_2/data.txt"
    |> load_file()
    |> parse_data()
    |> Enum.filter(&game_possible?(&1, green_count, red_count, blue_count))
    |> Enum.map(& &1.id)
    |> Enum.sum()
  end

  defp game_possible?(%{red: r, green: g, blue: b}, gr, re, bl) do
    r <= re and g <= gr and b <= bl
  end

  defp parse_data(data) do
    data
    |> String.split("\n")
    |> Enum.map(&parse_game/1)
  end

  defp parse_game(data) do
    [id_str, game_str] = String.split(data, ": ")

    id =
      id_str
      |> String.split("Game ")
      |> Enum.at(1)
      |> String.to_integer()

    %{id: id, red: 0, green: 0, blue: 0}
    |> parse_colors(game_str)
  end

  defp parse_colors(game, colors_str) do
    colors_str
    |> String.split(";")
    |> Enum.map(&String.split(&1, ","))
    |> List.flatten()
    |> Enum.reduce(game, &update_color/2)
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

  defp load_file(path) do
    {:ok, data} = File.read(path)
    data
  end
end

IO.inspect(Exercise.run(12, 13, 14))
