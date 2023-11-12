defmodule Flyster.Repo.Migrations.CreateGoals do
  use Ecto.Migration

  def change do
    create table(:goals) do
      add :creator_id, references(:users, name: :creator_id), null: false
      add :description, :string, null: false
      add :category, :string
      add :accomplished, :boolean, default: false, null: false
      add :accomplish_by, :string, null: false
      add :private, :boolean, default: false, null: false

      timestamps()
    end
  end
end
