defmodule Flyster.Context.Events do
  @moduledoc """
   Events Context
  """

  import Ecto.Query, warn: false
  alias Flyster.Repo

  alias Flyster.Events.{Event, EventType}

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
    |> Event.changeset(event_params)
    |> Repo.insert()
  end

  @doc ~S"""
  Gets all the events in the database

  ## Examples

      iex> all_events()
      [%Event{id: x, name: y}, %Event{id: z, name: r}, ...]

  """

  def all_events do
    Repo.all(Event) |> Repo.preload(:user)
  end

  @doc ~S"""
  Gets an event from the database

  ## Examples

      iex> find_event(id)
      %Event{id: x, name: y}

  """

  def find_event(id) do
    Repo.get(Event, id) |> Repo.preload(:user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event_creation(event)
      %Ecto.Changeset{data: %Event{}}

  """
  def change_event_creation(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  @doc ~S"""
  Gets an event with all its attendees

  ## Examples

      iex> find_event_with_attendees(id)
      %Event{id: x, name: y}

  """

  def find_event_with_attendees(id) do
    id |> find_event |> Repo.preload(:attendees)
  end
end
