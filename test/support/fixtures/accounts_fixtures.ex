defmodule Flyster.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Flyster.Accounts` context.
  """

  alias Flyster.Context.Accounts

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    create_role("Instructor")

    Enum.into(attrs, %{
      first_name: "Test",
      last_name: "Account",
      phone_number: "1234567890",
      country: "USA",
      city: "LA",
      role_id: Accounts.role_id("Instructor"),
      username: "user_test",
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Accounts.register_user()

    user
  end

  def create_role(role) do
    Accounts.create_role(role)
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
