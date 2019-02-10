defmodule RiffGame do
  @moduledoc """
  This module controls the state of a game play of the riff game.
  """

  @turns 4
  @max_players 4

  defstruct id: "", creation_time: nil,  allowed_players: 2, status: :waiting_players,  players: [],
            current_turn: nil, pending_turns: [], played_turns: [], score: []

  def create(opts \\ []) do
    turns = Keyword.get(opts, :turns, @turns)
    max_players = Keyword.get(opts, :max_players, @max_players)

    %RiffGame{
      id: generate_id(),
      creation_time: NaiveDateTime.utc_now,
      pending_turns: generate_turns(turns),
      allowed_players: max_players
    }
  end

  def get_player(game, player_name) do
    game.players |> Enum.find(fn(p) -> p.nick_name == player_name end)
  end

  def update_player(game, player) do
    %{game | players: game.players |> Enum.map(fn(x) -> update_players_list(x, player) end)}
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
    case Enum.any?(pys, fn x -> x.nick_name == player.nick_name end) do
      true -> game
      false -> %{game | players: [player | game.players]}
    end
  end

  def add_player(%RiffGame{} = game, _) do
    game
  end

  def player_ready(%RiffGame{players: players} = game, %PlayerGame{} = player) do
    updated_players =
      players
      |> Enum.map(fn p ->
        if p.nick_name == player.nick_name do
          PlayerGame.is_ready?(p)
        else
          p
        end
      end)

    %{game | players: updated_players}
  end

  def start_game?(%RiffGame{players: players} = game) do
    case players |> Enum.all?(fn(p) -> p.ready end) do
      true -> %{game | status: :next_turn}
      false -> game
    end
  end

  def next_turn(%RiffGame{pending_turns: []} = game), do: game
  def next_turn(%RiffGame{pending_turns: [next], played_turns: played, current_turn: nil} = game) do
    %{game | pending_turns: [], played_turns: [next | played], current_turn: next}
  end

  def next_turn(%RiffGame{pending_turns: [next | pending], played_turns: played, current_turn: nil} = game) do
    %{game | pending_turns: pending, played_turns: [next | played], current_turn: next}
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


  defp update_players_list(%PlayerGame{} = p, new_player) do
    cond do
      p.nick_name == new_player.nick_name -> new_player
      true -> p
    end
  end
  
end
