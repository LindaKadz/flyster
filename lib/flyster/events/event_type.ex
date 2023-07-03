defmodule Flyster.Events.EventType do
  @moduledoc """
   Event Type Schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "event_types" do
    field :name, :string

    timestamps()
  end

  def changeset(event_type, attrs) do
    event_type
    |> cast(attrs, [:name])
    |> validate_required(:name)
    |> unique_constraint(:name)
  end
end
