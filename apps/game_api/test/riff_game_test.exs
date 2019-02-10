defmodule RiffGameTests do
  use ExUnit.Case
  doctest RiffGame

  setup do
    SongAgentServer.start_link()
    {:ok, []}
  end

  test "By starting a game you get a %RiffGame struct with unique id" do
    game1 = RiffGame.create()
    game2 = RiffGame.create()

    assert game1 != game2
  end

  test "We can add a player to a game" do
    game = RiffGame.create()
    player1 = PlayerGame.new(1, "RockMaster")

    game = RiffGame.add_player(game, player1)

    assert Enum.count(game.players) == 1
    assert Enum.at(game.players, 0) == player1
  end

  test "We cannot add a player to a game twice" do
    game = RiffGame.create()
    player1 = PlayerGame.new(1, "RockMaster")

    game = RiffGame.add_player(game, player1)
    game = RiffGame.add_player(game, player1)

    assert Enum.count(game.players) == 1
  end

  test "A player is unique if his id and nick_name are unique" do
    game = RiffGame.create()
    player1 = PlayerGame.new(1, "RockMaster")
    player1 = %{player1 | score: [1]}

    player2 = PlayerGame.new(1, "RockMaster")
    player2 = %{player2 | score: [2]}

    game = RiffGame.add_player(game, player1)
    game = RiffGame.add_player(game, player2)

    assert Enum.count(game.players) == 1
  end

  test "We can only add 4 players to a game" do
    game = RiffGame.create()
    player1 = PlayerGame.new(1, "RockMaster")
    player2 = PlayerGame.new(2, "MegaRocker")
    player3 = PlayerGame.new(3, "HeavyRocker")
    player4 = PlayerGame.new(4, "SonOfAnarchy")
    player5 = PlayerGame.new(4, "ReguetonFan")

    game = RiffGame.add_player(game, player1)
    game = RiffGame.add_player(game, player2)
    game = RiffGame.add_player(game, player3)
    game = RiffGame.add_player(game, player4)
    game = RiffGame.add_player(game, player5)

    assert Enum.count(game.players) == 4
  end

  test "A game play should have a defined number of turns" do
    game = RiffGame.create(turns: 10)
    assert Enum.count(game.pending_turns) == 10
  end

  test "A game play should have a defined number of turns with different played songs" do
    game = RiffGame.create(turns: 10)

    played_songs =
      game.pending_turns
      |> Enum.map(fn x -> x.played_song end)
      |> Enum.uniq()

    assert Enum.count(played_songs) == 10
  end

  test "We can get the player of a game" do
    game = RiffGame.create()
    player1 = PlayerGame.new(1, "RockMaster")
    player2 = PlayerGame.new(2, "MegaRocker")
    player3 = PlayerGame.new(3, "HeavyRocker")
    player4 = PlayerGame.new(4, "SonOfAnarchy")
    player5 = PlayerGame.new(4, "ReguetonFan")

    game =
      game
      |> RiffGame.add_player(player1)
      |> RiffGame.add_player(player2)
      |> RiffGame.add_player(player3)
      |> RiffGame.add_player(player4)
      |> RiffGame.add_player(player5)

    player_returned = RiffGame.get_player(game, "RockMaster")
    assert player_returned == player1
  end

  # test "We can update the player of a game 2" do
  #   game = RiffGame.create()
  #   player1 = PlayerGame.new(1, "RockMaster")
  #   player2 = PlayerGame.new(2, "MegaRocker")
  #   player3 = PlayerGame.new(3, "HeavyRocker")
  #   player4 = PlayerGame.new(4, "SonOfAnarchy")
  #   player5 = PlayerGame.new(4, "ReguetonFan")

  #   game =
  #     game
  #     |> RiffGame.add_player(player1)
  #     |> RiffGame.add_player(player2)
  #     |> RiffGame.add_player(player3)
  #     |> RiffGame.add_player(player4)
  #     |> RiffGame.add_player(player5)

  #   player_returned =
  #     game
  #     |> RiffGame.get_player("RockMaster")
  #     |> PlayerGame.save_score(10, 1)

  #   assert player_returned == player1
  # end
end
