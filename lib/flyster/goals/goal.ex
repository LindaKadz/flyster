defmodule Flyster.Goals.Goal do
  @moduledoc """
   Goal Schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "goals" do
    field :description, :string
    field :accomplished, :boolean, default: false
    field :accomplish_by, :string
    field :category, :string
    field :private, :boolean
    belongs_to :creator, Flyster.Accounts.User
    has_many :comments, Flyster.Goals.GoalComments

    timestamps()
  end

  def changeset(event_type, attrs) do
    event_type
    |> cast(attrs, [:description, :accomplished, :accomplish_by, :creator_id, :category, :private])
    |> validate_required([:description, :accomplish_by, :creator_id, :category, :private])
    |> validate_length(:description, min: 5, max: 60)
  end
end
