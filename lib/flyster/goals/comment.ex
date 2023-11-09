defmodule Flyster.Goals.GoalComment do
  @moduledoc """
   Goal Schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "goal_comments" do
    field :comment, :string
    belongs_to :user, Flyster.Accounts.User
    belongs_to :goal, Flyster.Goals.Goal

    timestamps()
  end

  def changeset(event_type, attrs) do
    event_type
    |> cast(attrs, [:comment, :goal_id, :user_id])
    |> validate_required([:comment, :goal_id, :user_id])
    |> validate_length(:comment, min: 1, max: 40)
  end
end
