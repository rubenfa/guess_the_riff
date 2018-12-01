defmodule GamePlayTests do
  use ExUnit.Case
  doctest GamePlay

  setup do
    SongAgentServer.start_link()
    {:ok, []}
  end

  test "A game does not start if has not players" do
    game = RiffGame.create()
    turn = GamePlay.play(game)
    assert turn == []
  end

  test "A game does not start if all the players are not ready" do
    game = RiffGame.create()

    game =
      game
      |> GamePlay.join("RockMaster")
      |> GamePlay.join("MegaRocker")

    turn = GamePlay.play(game, 1)

    assert turn == []
  end

  test "A game starts if all the players are ready" do
    game = RiffGame.create()

    game =
      game
      |> GamePlay.join("RockMaster")
      |> GamePlay.join("MegaRocker")
      |> GamePlay.player_ready("RockMaster")
      |> GamePlay.player_ready("MegaRocker")

    turn = GamePlay.play(game, 1)

    assert Enum.all?(game.players, fn p -> p.ready end)
    assert turn = %GameTurn{}
  end

  test "The players can pick up their options" do
    game = RiffGame.create()

    game =
      game
      |> GamePlay.join("RockMaster")
      |> GamePlay.join("MegaRocker")
      |> GamePlay.player_ready("RockMaster")
      |> GamePlay.player_ready("MegaRocker")

    turn = GamePlay.play(game, 1)
  end
end
