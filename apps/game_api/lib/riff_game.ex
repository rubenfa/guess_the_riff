defmodule RiffGame do
  defstruct id: "", players: [], songs: []


  def create() do
    %RiffGame{
      id: generate_id()
    }
  end

  def add_players(game, []), do: game
  def add_players(game, players) do
    players |> Enum.reduce(game, fn(p,g)-> add_player(g, p) end)
  end

  def add_player(%RiffGame{players: []} = game, %PlayerGame{} = player) do
    %{game | players: [player | game.players]}
  end

  def add_player(%RiffGame{players: pys} = game, %PlayerGame{} = player)  when length(pys) < 4 do
    case Enum.any?(pys, fn(x) -> x.id == player.id or x.nick_name == player.nick_name end)  do
      true -> game
      false -> %{game | players: [player | game.players]}
    end
  end

  def add_player(%RiffGame{} = game, _) do
    game
  end

  defp generate_id() do
    :crypto.strong_rand_bytes(30) |> Base.url_encode64    
  end
end
