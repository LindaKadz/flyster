defmodule Flyster.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:goal_comments) do
      add :creator_id, references(:users, name: :creator_id), null: false
      add :goal_id, references(:goals), null: false
      add :comment, :text, null: false

      timestamps()
    end
  end
end
