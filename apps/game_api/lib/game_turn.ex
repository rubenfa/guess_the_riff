defmodule GameTurn do
  @moduledoc """
  A game its played by turns, and this module controls an individual turn.
  """

  defstruct played_song: {}, other_songs: []

  def new do
    played = SongAgentServer.get_played_song()

    %GameTurn{
      played_song: played,
      other_songs: SongAgentServer.get_songs(3, [played])
    }
  end
end
