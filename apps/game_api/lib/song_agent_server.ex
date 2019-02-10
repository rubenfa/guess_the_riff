defmodule SongAgentServer do
  @moduledoc """
  An agent server to provide random songs tuples {song_title, song_path}
  """

  @songs_file_path "./assets/song_list.txt"

  use Agent

  def start_link do
    songs = load_songs(@songs_file_path)

    Agent.start_link(fn -> {songs, []} end, name: __MODULE__)
  end

  @doc "Gets a new random song, to be played. Any time a song is picked up to be played, it is not choosen again"
  def get_played_song do
    selected = Agent.get(__MODULE__, fn {songs, played} -> get_random_song(songs, played) end)

    Agent.update(__MODULE__, fn {songs, played} -> {songs, [selected | played]} end)

    selected
  end

  @doc "Gets a new random song, but it can be selected again"
  def get_song(songs_to_ignore \\ []) do
    Agent.get(__MODULE__, fn {songs, _} -> get_random_song(songs, songs_to_ignore) end)
  end

  def get_songs(0, _ingored_songs), do: []
  def get_songs(number, ignored_songs \\ []) do
    song = get_song(ignored_songs)
    [song | get_songs(number - 1, [song | ignored_songs])]
  end

  @doc "Return all the songs from a file path"
  def load_songs(songs_file_path) do
    file_path = Path.join(__DIR__, songs_file_path)

    file_path
    |> File.stream!([], :line)
    |> Stream.map(&parse_line(&1))
  end

  defp get_random_song(songs, selected_songs) do
    songs
    |> Enum.reject(fn f -> Enum.any?(selected_songs, fn s -> s == f end) end)
    |> Enum.random()
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
