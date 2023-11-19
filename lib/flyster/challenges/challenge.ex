defmodule Flyster.Challenges.Challenge do
  @moduledoc """
   Challenge Schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "challenges" do
    field :description, :string
    field :level, :string
    field :category, :string
    belongs_to :creator, Flyster.Accounts.User

    timestamps()
  end

  def changeset(challenge_type, attrs) do
    challenge_type
    |> cast(attrs, [:description, :level, :creator_id, :category])
    |> validate_required([:description, :level, :creator_id, :category])
    |> validate_length(:description, min: 5)
  end
end
