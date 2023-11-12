defmodule Flyster.GoalsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Flyster.Context.Events` context.
  """

  alias Flyster.Context.{Accounts, Goals}

  def valid_goal_attributes(attrs \\ %{}) do
    {:ok, user} = Accounts.register_user(user_params())

    Enum.into(attrs, %{
      description: "Hope to get Ayesha",
      category: "Aeriel",
      private: false,
      accomplish_by: "2023-12-10",
      creator_id: user.id
    })
  end

  def goal_fixture(attrs \\ %{}) do
    {:ok, goal} =
      attrs
      |> valid_goal_attributes()
      |> Goals.save_goal()

    goal
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
