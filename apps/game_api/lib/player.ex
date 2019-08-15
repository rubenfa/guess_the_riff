defmodule Player do
  @moduledoc """
  This is the struct for create new users to play the game
  """

  defstruct nick_name: "", score: [], ready: false

  def new(nick_name) do
    %Player{
      nick_name: nick_name
    }
  end

  def is_ready?(%Player{} = player) do
    %{player | ready: true}
  end

  def save_score(%Player{} = player, score_change, turn_number) do
    %{player | score: [{turn_number, score_change} | player.score]}
  end
end
