defmodule Flyster.Context.Events do
  @moduledoc """
   Events Context
  """

  import Ecto.Query, warn: false
  alias Flyster.Repo

  alias Flyster.Events.{EventType}

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
end
