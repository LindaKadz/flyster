defmodule Flyster.Accounts.Role do
  @moduledoc """
   Role Schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field :name, :string

    timestamps()
  end

  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name])
    |> validate_required(:name)
    |> unique_constraint(:name)
  end
end
