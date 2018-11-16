defmodule SongAgentServer do
  @moduledoc """
  An agent server to provide random songs tuples {song_title, song_path}
  """

  @songs_file_path "./assets/song_list.txt"

  use Agent

  def start_link() do
    songs = load_songs(@songs_file_path)

    Agent.start_link(fn -> songs end, name: __MODULE__)
  end

  @doc "Gets a new random song"
  def get_song() do
    Agent.get(__MODULE__, fn songs -> Enum.random(songs) end)
  end

  @doc "Return all the songs from a file path"
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
