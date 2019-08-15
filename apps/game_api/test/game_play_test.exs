defmodule GamePlayTests do
  use ExUnit.Case
  doctest GamePlay

  setup do
    SongAgentServer.start_link()
    {:ok, []}
  end

  test "A game does not start if has not players" do
    game = GameState.create()
    {:error, message} = GamePlay.next(game)

    assert message == "Cannot play next turn at this point of the game play"
  end

  test "A game cannot have two players with the same name" do
    game = GameState.create()

    with {:ok, game} <- GamePlay.join(game, "RockMaster"),
         {:error, message} <- GamePlay.join(game, "RockMaster") do
      assert message == "There is already a player with the name RockMaster"
    else
      {:ok, message} -> assert "error" == message
    end
  end

  test "A game does not start if all the players are not ready" do
    game = GameState.create()

    with {:ok, game} <- GamePlay.join(game, "RockMaster"),
         {:ok, game} <- GamePlay.join(game, "MegaRocker"),
         {:error, message} <- GamePlay.next(game) do
      assert message == "Cannot play next turn at this point of the game play"
    else
      {:error, message} -> assert "error" == message
    end
  end

  test "A game starts if all the players are ready" do
    game = GameState.create()

    with {:ok, game} <- GamePlay.join(game, "RockMaster"),
         {:ok, game} <- GamePlay.join(game, "MegaRocker"),
         {:ok, game} <- GamePlay.ready(game, "RockMaster"),
         {:ok, game} <- GamePlay.ready(game, "MegaRocker"),
         {:ok, game} <- GamePlay.next(game) do
      assert game.status == :next_turn
    else
      {:error, message} -> assert "error" == message
    end
  end

  test "When we pass the las turn, the status of the game is changed" do
    game =
      GameState.create(turns: 2)
      |> GameState.add_player(PlayerGame.new("RockMaster"))
      |> GameState.next_turn()
      |> GameState.next_turn()

    assert game.status == :finished
  end

  test "A game turn is the same always if the options are not saved" do
    game = GameState.create()

    with {:ok, game} <- GamePlay.join(game, "RockMaster"),
         {:ok, game} <- GamePlay.join(game, "MegaRocker"),
         {:ok, game} <- GamePlay.ready(game, "RockMaster"),
         {:ok, game} <- GamePlay.ready(game, "MegaRocker"),
         {:ok, game} <- GamePlay.next(game) do
      assert game == GamePlay.next(game)
    else
      {:error, message} -> assert "error" == message
    end
  end

  # test "The players can pick up their options and save " do
  #   game = GameState.create()

  #   game =
  #     game
  #     |> GamePlay.join("RockMaster")
  #     |> GamePlay.join("MegaRocker")
  #     |> GamePlay.player_ready("RockMaster")
  #     |> GamePlay.player_ready("MegaRocker")
  #     |> GamePlay.next

  #    {correct_song, _} = game.current_turn.played_song

  #    game = game |> GamePlay.pick_song("MegaRocker", correct_song)
  #    game = game |> GamePlay.pick_song("RockMaster", "not exist song")

  # end
end
