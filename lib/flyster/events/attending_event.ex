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

  def changeset(attending_event, attrs) do
    attending_event
    |> cast(attrs, [:user_id, :event_id])
    |> validate_required([:user_id, :event_id])
  end
end
