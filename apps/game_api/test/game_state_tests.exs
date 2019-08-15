defmodule GameStateTests do
  use ExUnit.Case
  doctest GameState

  describe "Tests for the module GameState" do
    setup do
      SongAgentServer.start_link()
      {:ok, []}
    end

    test "By starting a game you get a %GameState struct with unique id" do
      game1 = GameState.create()
      game2 = GameState.create()

      assert game1 != game2
    end

    test "We can add a player to a game" do
      game = GameState.create()
      player1 = Player.new("RockMaster")

      game = GameState.add_player(game, player1)

      assert Enum.count(game.players) == 1
      assert Enum.at(game.players, 0) == player1
    end

    test "We cannot add a player to a game twice" do
      game = GameState.create()
      player1 = Player.new("RockMaster")

      game = GameState.add_player(game, player1)
      game = GameState.add_player(game, player1)

      assert Enum.count(game.players) == 1
    end

    test "A player is unique if his nick_name is unique" do
      game = GameState.create()
      player1 = Player.new("RockMaster")
      player1 = %{player1 | score: [1]}

      player2 = Player.new("RockMaster")
      player2 = %{player2 | score: [2]}

      game = GameState.add_player(game, player1)
      game = GameState.add_player(game, player2)

      assert Enum.count(game.players) == 1
    end

    test "We can only add many players as game is configured" do
      game = GameState.create(max_players: 2)
      player1 = Player.new("RockMaster")
      player2 = Player.new("RockMaster2")
      player3 = Player.new("RockMaster3")

      game =
        game
        |> GameState.add_player(player1)
        |> GameState.add_player(player2)
        |> GameState.add_player(player3)

      assert Enum.count(game.players) == 2
    end

    test "We can only add 4 players by default to a game" do
      game = GameState.create()
      player1 = Player.new("RockMaster")
      player2 = Player.new("MegaRocker")
      player3 = Player.new("HeavyRocker")
      player4 = Player.new("SonOfAnarchy")
      player5 = Player.new("ReguetonFan")

      game = GameState.add_player(game, player1)
      game = GameState.add_player(game, player2)
      game = GameState.add_player(game, player3)
      game = GameState.add_player(game, player4)
      game = GameState.add_player(game, player5)

      assert Enum.count(game.players) == 4
    end

    test "A game play should have a defined number of turns" do
      game = GameState.create(turns: 10)
      assert Enum.count(game.pending_turns) == 10
    end

    test "A game play should have a defined number of turns with different played songs" do
      game = GameState.create(turns: 10)

      played_songs =
        game.pending_turns
        |> Enum.map(fn x -> x.played_song end)
        |> Enum.uniq()

      assert Enum.count(played_songs) == 10
    end

    test "We can get the player of a game" do
      game = GameState.create()
      player1 = Player.new("RockMaster")
      player2 = Player.new("MegaRocker")
      player3 = Player.new("HeavyRocker")
      player4 = Player.new("SonOfAnarchy")
      player5 = Player.new("ReguetonFan")

      game =
        game
        |> GameState.add_player(player1)
        |> GameState.add_player(player2)
        |> GameState.add_player(player3)
        |> GameState.add_player(player4)
        |> GameState.add_player(player5)

      player_returned = GameState.get_player(game, "RockMaster")
      assert player_returned == player1
    end

    test "We get the same game when try to get next turn but there aren't more" do
      game =
        GameState.create(turns: 1)
        |> GameState.add_player(Player.new("RockMaster"))
        |> GameState.next_turn()

      assert game == GameState.next_turn(game)
    end

    test "When we have only one turn as start, it has to be returned" do
      game = GameState.create(turns: 1)

      game2 =
        game
        |> GameState.add_player(Player.new("RockMaster"))
        |> GameState.next_turn()

      assert Enum.fetch!(game.pending_turns, 0) == game2.current_turn
      assert Enum.empty?(game2.played_turns)
    end

    test "When we get a turn it is changed to current and removed from pending" do
      game = GameState.create(turns: 2)
      first_not_played_turn = Enum.fetch!(game.pending_turns, 0)

      game =
        game
        |> GameState.add_player(Player.new("RockMaster"))
        |> GameState.next_turn()

      assert game.current_turn == first_not_played_turn
    end
  end
end
