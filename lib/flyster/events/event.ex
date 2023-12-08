defmodule Flyster.Events.Event do
  @moduledoc """
   Event Type Schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :name, :string
    field :time, :string
    field :date, :string
    field :description, :string
    field :rules, :string
    field :price, :float
    field :customer_paid, :boolean
    field :address, :string
    field :city, :string
    field :country, :string
    field :currency, :string
    field :duration, :string

    belongs_to :event_type, Flyster.Events.EventType
    belongs_to :host, Flyster.Accounts.User, foreign_key: :host_id
    has_many :attending_events, Flyster.Events.AttendingEvent
    has_many :attendees, through: [:attending_events, :user]

    timestamps()
  end

  def changeset(event_type, attrs) do
    event_type
    |> cast(attrs, [:name, :time, :date, :description, :duration, :rules, :price, :customer_paid, :address, :currency, :event_type_id, :host_id, :city, :country,])
    |> run_validations()
    |> foreign_key_constraint(:event_type_id)
    |> foreign_key_constraint(:host_id)
  end

  def run_validations(changeset) do
    changeset
    |> validate_required([:name, :time, :date, :description, :duration, :city, :country, :event_type_id, :host_id])
    |> validate_length(:name, min: 5, max: 22)
    |> validate_length(:description, min: 10)
    |> validate_date()
  end

  defp validate_date(changeset) do
    changeset
    |> validate_change(:date, fn :date, date ->
      if FlysterWeb.SharedComponents.check_date_validity(date) != :gt do
        [date: "Date has to be greater than today"]
      else
        []
      end
    end)
  end
end
