defmodule Flyster.Goals.Goal do
  @moduledoc """
   Goal Schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "goals" do
    field :description, :string
    field :accomplished, :boolean, default: false
    field :accomplish_by, :string
    field :category, :string
    field :private, :boolean
    belongs_to :creator, Flyster.Accounts.User
    has_many :comments, Flyster.Goals.GoalComment, on_delete: :delete_all

    timestamps()
  end

  def changeset(goal_type, attrs) do
    goal_type
    |> cast(attrs, [:description, :accomplished, :accomplish_by, :creator_id, :category, :private])
    |> validate_accomplish_by()
    |> validate_required([:description, :accomplish_by, :creator_id, :category, :private])
    |> validate_length(:description, min: 5, max: 100)
  end

  defp validate_accomplish_by(changeset) do
    changeset
    |> validate_change(:accomplish_by, fn :accomplish_by, accomplish_by ->
      if FlysterWeb.SharedComponents.check_date_validity(accomplish_by) != :gt do
        [accomplish_by: "Date has to be greater than today"]
      else
        []
      end
    end)
  end

end
