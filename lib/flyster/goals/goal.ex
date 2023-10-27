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
    belongs_to :user, Flyster.Accounts.User

    timestamps()
  end

  def changeset(event_type, attrs) do
    event_type
    |> cast(attrs, [:description, :accomplished, :accomplish_by, :user_id])
    |> validate_required([:description, :accomplished, :accomplish_by])
    |> validate_length(:description, min: 5, max: 60)
  end
end
