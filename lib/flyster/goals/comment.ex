defmodule Flyster.Goals.GoalComment do
  @moduledoc """
   Goal Schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "goal_comments" do
    field :comment, :string
    belongs_to :goal, Flyster.Goals.Goal
    belongs_to :creator, Flyster.Accounts.User

    timestamps()
  end

  def changeset(goal_comment_type, attrs) do
    goal_comment_type
    |> cast(attrs, [:comment, :goal_id, :creator_id])
    |> validate_required([:comment, :goal_id, :creator_id])
    |> validate_length(:comment, min: 1, max: 40)
  end
end
