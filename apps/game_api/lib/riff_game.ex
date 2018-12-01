defmodule RiffGame do
  @moduledoc """
  This module controls the state of a game play of the riff game.
  """

  defstruct id: "", players: [], turns: [], score: []

  def create(turns \\ 4) do
    %RiffGame{
      id: generate_id(),
      turns: generate_turns(turns)
    }
  end

  def add_players(game, []), do: game

  def add_players(game, players) do
    players
    |> Enum.reduce(game, fn p, g -> add_player(g, p) end)
  end

  def add_player(%RiffGame{players: []} = game, %PlayerGame{} = player) do
    %{game | players: [player | game.players]}
  end

  def add_player(%RiffGame{players: pys} = game, %PlayerGame{} = player) when length(pys) < 4 do
    case Enum.any?(pys, fn x -> x.id == player.id or x.nick_name == player.nick_name end) do
      true -> game
      false -> %{game | players: [player | game.players]}
    end
  end

  def add_player(%RiffGame{} = game, _) do
    game
  end

  def player_ready(%PlayerGame{} = player, %RiffGame{players: players} = game) do
    updated_players =
      players
      |> Enum.map(fn p ->
        if p.nick_name == player.nick_name do
          PlayerGame.is_ready(p)
        else
          p
        end
      end)

    %{game | players: updated_players}
  end

  defp generate_turns(n) do
    for _ <- 1..n do
      GameTurn.new()
    end
  end

  defp generate_id do
    30
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
  end
end
