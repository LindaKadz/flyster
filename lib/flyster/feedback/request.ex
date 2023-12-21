defmodule Flyster.Feedback.Request do
  @moduledoc """
   Request Schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "requests" do
    field :description, :string
    field :category, :string
    belongs_to :user, Flyster.Accounts.User

    timestamps()
  end

  def changeset(request_type, attrs) do
    request_type
    |> cast(attrs, [:description, :user_id, :category])
    |> validate_length(:description, min: 5)
  end
end
