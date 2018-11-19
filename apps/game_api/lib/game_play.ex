defmodule GamePlay do
  @moduledoc """
  This module controls every step of a game play.
  """

  def join(%RiffGame{players: players} = game, nick_name) do
    player_count = players |> Enum.count()

    player = PlayerGame.new(player_count + 1, nick_name)
    RiffGame.add_player(game, player)
  end

  def player_ready(game, nick_name) do
    case game.players |> Enum.find(fn p -> p.nick_name == nick_name end) do
      nil -> game
      player -> player |> RiffGame.player_ready(game)
    end
  end

  def play(%RiffGame{players: []}), do: []
  def play(%RiffGame{players: players} = game) do
    if Enum.all?(players, fn p -> p.ready end) do
      get_next_turn(game)
    else
      []
    end
  end

  defp get_next_turn(game) do
    game.turns |> Enum.fetch!(0)
  end
end
