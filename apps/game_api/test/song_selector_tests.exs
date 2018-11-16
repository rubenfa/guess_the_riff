defmodule SongManagerTests do
  use ExUnit.Case
  doctest SongManager

  test "SongManager give a song tuple" do
    {song_title, path} = SongManager.get_song

    assert String.length(song_title) > 0
    assert String.length(path) > 0
  end

  test "SongManager should return two different songs" do
    {song_title1, song_path1} = SongManager.get_song
    {song_title2, song_path2} = SongManager.get_song

    assert song_title1 != song_title2
    assert song_path1 != song_path2
  end

  test "SongManager reads file whith songs and returns a enumeration" do
    song_list = SongManager.load_songs("../lib/assets/song_list.txt")
    assert Enum.any?(song_list)
  end

  test "SongManager reads file whith songs and returns a enumeration with all elements different and unique" do
    song_list = SongManager.load_songs("../lib/assets/song_list.txt")

    {titles, paths} =
      song_list
      |> Enum.reduce({[],[]}, fn({t, p}, {ts, ps}) -> { [t | ts], [p | ps]} end)

    assert (titles |> Enum.uniq |> Enum.count) == (song_list |> Enum.count)
    assert (paths |> Enum.uniq |> Enum.count) == (song_list |> Enum.count)
  end
end
