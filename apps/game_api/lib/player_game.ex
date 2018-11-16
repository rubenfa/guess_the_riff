defmodule PlayerGame do
  defstruct id: "", nick_name: "", score: [], ready: false


  def new(id, nick_name) do
    %PlayerGame{
      id: id,
      nick_name: nick_name
    }
  end

  def is_ready(%PlayerGame{} = player) do
    %{player | ready: true }
  end

end
