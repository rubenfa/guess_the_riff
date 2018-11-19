defmodule GameTurnTests do
  use ExUnit.Case

  doctest GameTurn

  setup_all do
    SongAgentServer.start_link()
    {:ok, []}
  end

  test "A game turn should have one played song and three different songs" do
    turn = GameTurn.new()

    refute Enum.member?(turn.other_songs, turn.played_song)
  end
end
