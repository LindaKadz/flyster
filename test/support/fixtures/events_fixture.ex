defmodule Flyster.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Flyster.Context.Events` context.
  """

  alias Flyster.Context.{Accounts, Events}

  def valid_event_attributes(attrs \\ %{}) do
    {:ok, event_type} = Events.create_event_type("Foo")
    {:ok, user} = Accounts.register_user(user_params())

    Enum.into(attrs, %{
      name: "Foo Bar",
      time: "1120",
      date: "Mon July 2023",
      description: "Foo Bar Event",
      location: "123 St",
      event_type_id: event_type.id,
      host_id: user.id
    })
  end

  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> valid_event_attributes()
      |> Events.create_event()

    event
  end

  def user_params() do
    {:ok, role} = Accounts.create_role("Foo#{System.unique_integer()}")
    %{
      first_name: "Test",
      last_name: "Account",
      phone_number: "1234567890",
      country: "USA",
      city: "LA",
      role_id: role.id,
      username: "user_test",
      email: "user#{System.unique_integer()}@example.com",
      password: "Abcdefgh123456!!"
    }
  end
end
