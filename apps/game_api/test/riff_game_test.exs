defmodule RiffGameTests do
  use ExUnit.Case
  doctest RiffGame

  describe "Tests for the module RiffGame" do
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
      player1 = PlayerGame.new("RockMaster")

      game = RiffGame.add_player(game, player1)

      assert Enum.count(game.players) == 1
      assert Enum.at(game.players, 0) == player1
    end

    test "We cannot add a player to a game twice" do
      game = RiffGame.create()
      player1 = PlayerGame.new("RockMaster")

      game = RiffGame.add_player(game, player1)
      game = RiffGame.add_player(game, player1)

      assert Enum.count(game.players) == 1
    end

    test "A player is unique if his nick_name is unique" do
      game = RiffGame.create()
      player1 = PlayerGame.new("RockMaster")
      player1 = %{player1 | score: [1]}

      player2 = PlayerGame.new("RockMaster")
      player2 = %{player2 | score: [2]}

      game = RiffGame.add_player(game, player1)
      game = RiffGame.add_player(game, player2)

      assert Enum.count(game.players) == 1
    end

    test "We can only add many players as game is configured" do
      game = RiffGame.create(max_players: 2)
      player1 = PlayerGame.new("RockMaster")
      player2 = PlayerGame.new("RockMaster2")
      player3 = PlayerGame.new("RockMaster3")

      game =
        game
        |> RiffGame.add_player(player1)
        |> RiffGame.add_player(player2)
        |> RiffGame.add_player(player3)

      assert Enum.count(game.players) == 2
    end

    test "We can only add 4 players by default to a game" do
      game = RiffGame.create()
      player1 = PlayerGame.new("RockMaster")
      player2 = PlayerGame.new("MegaRocker")
      player3 = PlayerGame.new("HeavyRocker")
      player4 = PlayerGame.new("SonOfAnarchy")
      player5 = PlayerGame.new("ReguetonFan")

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
      player1 = PlayerGame.new("RockMaster")
      player2 = PlayerGame.new("MegaRocker")
      player3 = PlayerGame.new("HeavyRocker")
      player4 = PlayerGame.new("SonOfAnarchy")
      player5 = PlayerGame.new("ReguetonFan")

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

    test "We get the same game when try to get next turn but there aren't more" do
      game =
        RiffGame.create(turns: 1)
        |> RiffGame.add_player(PlayerGame.new("RockMaster"))
        |> RiffGame.next_turn()

      assert game == RiffGame.next_turn(game)
    end

    test "When we have only one turn as start, it has to be returned" do
      game = RiffGame.create(turns: 1)

      game2 =
        game
        |> RiffGame.add_player(PlayerGame.new("RockMaster"))
        |> RiffGame.next_turn()

      assert Enum.fetch!(game.pending_turns, 0) == game2.current_turn
      assert Enum.empty?(game2.played_turns)
    end

    test "When we get a turn it is changed to current and removed from pending" do
      game = RiffGame.create(turns: 2)
      first_not_played_turn = Enum.fetch!(game.pending_turns, 0)

      game =
        game
        |> RiffGame.add_player(PlayerGame.new("RockMaster"))
        |> RiffGame.next_turn()

      assert game.current_turn == first_not_played_turn
    end
  end
end
