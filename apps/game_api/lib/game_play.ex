defmodule GamePlay do
  @moduledoc """
  This module controls every step of a game play.
  """

  def join(%GameState{players: players, status: :waiting_players} = game, nick_name) do
    case Enum.any?(players, fn p -> p.nick_name == nick_name end) do
      true -> {:error, "There is already a player with the name #{nick_name}"}
      _ -> {:ok, GameState.add_player(game, Player.new(nick_name))}
    end
  end

  def join(_, nick_name), do: {:error, "#{nick_name} cannot join at this point of the game play"}

  def ready(%GameState{status: :waiting_players} = game, nick_name) do
    with {:ok, game} <- set_player_ready(game, nick_name),
         game <- GameState.start_game?(game) do
      {:ok, game}
    else
      {:error, message} -> {:error, message}
    end
  end

  def ready(_, nick_name),
    do: {:error, "#{nick_name} cannot set as ready at this point of the game play"}

  def next(%GameState{status: :next_turn} = game) do
    {:ok, GameState.next_turn()}
  end

  def next(_), do: {:error, "Cannot play next turn at this point of the game play"}

  # def play(:choose, %GameState{} = game, player_name, picked) do    
  #   turn_number = (game.played_turns |> Enum.count()) + 1

  #   # score = get_score(game.current_turn.played_song, picked)

  #   # game
  #   # |> GameState.get_player(player_name)
  #   # |> PlayerGame.save_score(player, score, turn_number)

  #   # cond do
  #   #   game.current_turn.played_song == picked -> PlayerGame.save_score(player, 10, turn_number)
  #   #   true -> PlayerGame.save_score
  #   # end
  # end

  defp set_player_ready(game, nick_name) do
    case game.players |> Enum.find(fn p -> p.nick_name == nick_name end) do
      nil -> {:error, "There is no player with the name #{nick_name}"}
      player -> {:ok, GameState.player_ready(game, player)}
    end
  end
end
