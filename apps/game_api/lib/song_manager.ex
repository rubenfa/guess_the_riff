defmodule SongManager do

  @songs_file_path "./assets/song_list.txt"

  def get_song() do
    @songs_file_path
    |> load_songs
    |> Enum.random
  end

  def load_songs(songs_file_path) do
    Path.join(__DIR__, songs_file_path)
    |> File.stream!([], :line)
    |> Stream.map(&parse_line(&1))
  end

  defp parse_line([""]), do: {}
  defp parse_line(line) do
    line
    |> String.split("#")
    |> extract_song
  end

  defp extract_song([""]), do: {}
  defp extract_song([title, path]), do: {title, String.replace(path, "\n", "")}
  
end
