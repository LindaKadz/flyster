defmodule Flyster.Repo.Migrations.CreateAttendingEvents do
  use Ecto.Migration

  def change do
    create table(:attending_events) do
      add :user_id, references(:users), null: false
      add :event_id, references(:events), null: false
      timestamps
    end
  end
end
