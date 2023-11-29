defmodule Flyster.Repo.Migrations.CreateChallenges do
  use Ecto.Migration

  def change do
    create table(:challenges) do
      add :creator_id, references(:users, name: :creator_id), null: false
      add :description, :text, null: false
      add :level, :string, null: false
      add :category, :string, null: false

      timestamps()
    end
  end
end