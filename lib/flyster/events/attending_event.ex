defmodule Flyster.Events.AttendingEvent do
  @moduledoc """
   Event Type Schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "attending_events" do
    belongs_to :user, Flyster.Accounts.User
    belongs_to :event, Flyster.Events.Event

    timestamps()
  end

  def changeset(event_type, attrs) do
    event_type
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
