defmodule Flyster.Repo.Migrations.CreateRequestForm do
  use Ecto.Migration

  def change do
    create table(:requests) do
      add :category, :string
      add :description, :text
      add :user_id, references(:users), null: false

      timestamps()
    end
  end
end
