defmodule SongManagerTests do
  use ExUnit.Case
  doctest SongManager

  test "SongManager give a song tuple" do
    {song_title, path} = SongManager.get_song

    assert String.length(song_title) > 0
    assert String.length(path) > 0
  end

  test "SongManager should return two different songs" do
    {song_title1, _} = SongManager.get_song
    {song_title2, _} = SongManager.get_song

    assert song_title1 != song_title2
  end

  test "SongManager reads file whith songs and returns a enumeration" do
    song_list = SongManager.load_from_file("../lib/assets/song_list.txt")

    assert Enum.any?(song_list)
  end
end
