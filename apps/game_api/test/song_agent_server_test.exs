defmodule SongAgentServerTests do
  use ExUnit.Case
  doctest SongAgentServer

  setup do
    SongAgentServer.start_link()
    {:ok, []}
  end

  test "SongAgentServer give a song tuple" do
    {song_title, path} = SongAgentServer.get_played_song()

    assert String.length(song_title) > 0
    assert String.length(path) > 0
  end

  test "SongAgentServer should return two different songs" do
    for _ <- 1..10 do
      {song_title1, song_path1} = SongAgentServer.get_played_song()
      {song_title2, song_path2} = SongAgentServer.get_played_song()

      assert song_title1 != song_title2
      assert song_path1 != song_path2
    end
  end

  test "SongAgentServer should return 4 different songs for other songs (NOT PLAYED)" do
    for _ <- 1..100 do
      other_songs = SongAgentServer.get_songs(4)

      different_songs =
        other_songs
        |> Enum.uniq()
        |> Enum.count()

      assert different_songs == 4
    end
  end

  test "SongAgentServer should return 3 different songs for other songs, and one song played" do
    for _ <- 1..10 do
      played_song = SongAgentServer.get_played_song()
      other_songs = SongAgentServer.get_songs(3, [played_song])

      assert Enum.count(other_songs) == 3
      assert other_songs != []
      assert other_songs |> Enum.uniq() |> Enum.count() == 3
      refute other_songs |> Enum.any?(fn x -> x == played_song end)
    end
  end

  test "SongAgentServer file whith songs and returns a enumeration" do
    song_list = SongAgentServer.load_songs("../lib/assets/song_list.txt")
    assert Enum.any?(song_list)
  end

  test "SongAgetnServer reads file whith songs and returns a enumeration with all elements different and unique" do
    song_list = SongAgentServer.load_songs("../lib/assets/song_list.txt")

    {titles, paths} =
      song_list
      |> Enum.reduce({[], []}, fn {t, p}, {ts, ps} -> {[t | ts], [p | ps]} end)

    assert titles |> Enum.uniq() |> Enum.count() == song_list |> Enum.count()
    assert paths |> Enum.uniq() |> Enum.count() == song_list |> Enum.count()
  end
end
