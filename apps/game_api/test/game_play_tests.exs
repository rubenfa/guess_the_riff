defmodule SongManagerTests do
  use ExUnit.Case
  doctest GamePlay


  test "A game does not start if all the players are not ready" do

    game = RiffGame.create

    player1 = PlayerGame.new(1, "RockMaster")
    player2 = PlayerGame.new(2, "MegaRocker")

    game = RiffGame.add_players(game, [player1, player2])

    turn = GamePlay.play(game)

    assert turn == []
    

  end

end
