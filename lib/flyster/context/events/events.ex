defmodule Flyster.Context.Events do
  @moduledoc """
   Events Context
  """

  import Ecto.Query, warn: false
  alias Flyster.Repo

  alias Flyster.Events.{AttendingEvent, Event, EventType}

  ### Event Types

  @doc """
  Creates an event type.

  ## Examples

      iex> create_event_type(%{field: value})
      {:ok, %EventType{}}

      iex> create_event_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event_type(event_type) do
    %EventType{}
    |> EventType.changeset(%{name: event_type})
    |> Repo.insert()
  end

  @doc ~S"""
  Gets all the event_types in the database

  ## Examples

      iex> all_event_types()
      [%EventType{id: x, name: y}, %EventType{id: z, name: r}, ...]

  """

  def all_event_types do
    Repo.all(EventType)
  end

  ### Events

  @doc """
  Creates an event.

  ## Examples

      iex> create_event(%{name: "Event New", time: "12:00"...})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(event_params) do
    %Event{}
    |> change_event(event_params)
    |> Repo.insert()
  end

  @doc ~S"""
  Gets all the events in the database

  ## Examples

      iex> all_events()
      [%Event{id: x, name: y}, %Event{id: z, name: r}, ...]

  """

  def all_events do
    Repo.all(Event) |> Repo.preload([:host, :attendees, :event_type])
  end

  @doc ~S"""
  Gets an event from the database

  ## Examples

      iex> find_event(id)
      %Event{id: x, name: y}

  """

  def find_event(id) do
    Repo.get(Event, id) |> Repo.preload(:host)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{data: %Event{}}

  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  @doc ~S"""
  Gets an event with all its attendees

  ## Examples

      iex> find_event_with_attendees(id)
      %Event{id: x, name: y}

  """

  def find_event_with_attendees(id) do
    id |> find_event |> Repo.preload([attendees: [:role]])
  end

  ### Events

  @doc """
  Find out which action needs to happen to the user, then acts accordingly.
  It will always return either :ok or :error

  ## Examples

      iex> update_attendee_list(%{user_id: "Event New", event_id: "12:00"...})
      {:ok, %AttendingEvent{}, "Added" || "Removed"}

      iex> update_attendee_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def update_attendee_list(event_attendee_params) do
    event = find_event_with_attendees(event_attendee_params["event_id"])
    user = Flyster.Context.Accounts.get_user!(event_attendee_params["user_id"])

    if !Enum.member?(event.attendees, user) do
      result = add_attendee_to_event_list(event_attendee_params)
      Tuple.insert_at(result, 2, "Added")
    else
      result = remove_attendee_from_event_list(event_attendee_params)
      Tuple.insert_at(result, 2, "Removed")
    end
  end

  defp add_attendee_to_event_list(attendee_event_params) do
    %AttendingEvent{}
    |> AttendingEvent.changeset(attendee_event_params)
    |> Repo.insert()
  end

  defp remove_attendee_from_event_list(attendee_event_params) do
    event_id = attendee_event_params["event_id"]
    user_id = attendee_event_params["user_id"]

    query = from e in AttendingEvent,
              where: e.event_id == ^event_id and e.user_id == ^user_id

    query
    |> Repo.all()
    |> List.first()
    |> Repo.delete()
  end

  @doc """
  It updates the data saved in the database with new information

  ## Examples

      iex> apply_event_changes(event, %{email: ...})
      {:ok, %Event{}}

      iex> apply_event_changes(event, %{email: ...})
      {:error, %Ecto.Changeset{}}

  """
  def apply_event_changes(event, attrs) do
    event
    |> change_event(attrs)
    |> Repo.update()
  end

  @doc ~S"""
  Gets all the events in the database for a specific user

  ## Examples

      iex> all_my_events()
      [%Event{id: 1, description: y}, %Event{id: z, description: 2}, ...]

  """

  def all_my_events(user_id) do
    query = from event in Event,
              where: event.host_id == ^user_id

    query |> Repo.all() |> Repo.preload([:attendees, :event_type])
  end

  @doc ~S"""
  Deletes a single event from the database

  ## Examples

      iex> delete_event()
      {:ok, %{description: ...}}

  """

  def delete_event(event), do: Repo.delete(event)

  def send_end_year_email() do
  end
end
