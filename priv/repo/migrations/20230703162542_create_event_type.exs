defmodule Flyster.Repo.Migrations.CreateEventType do
  use Ecto.Migration

  def change do
    create table(:event_types) do
      add :name, :string

      timestamps
    end
  end
end
