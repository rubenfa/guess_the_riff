defmodule PlayerGame do
  @moduledoc """
  This is the struct for create new users to play the game
  """

  defstruct nick_name: "", score: [], ready: false

  def new(nick_name) do
    %PlayerGame{
      nick_name: nick_name
    }
  end

  def is_ready?(%PlayerGame{} = player) do
    %{player | ready: true}
  end

  def save_score(%PlayerGame{} = player, score_change, turn_number) do
    %{player | score: [{turn_number, score_change} | player.score]}
  end
end
