defmodule Flyster.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string, null: false
      add :event_type_id, references(:event_types), null: false
      add :host_id, references(:users, name: :host_id), null: false
      add :time, :string, null: false
      add :date, :naive_datetime, null: false
      add :description, :text, null: false
      add :rules, :text
      add :price, :float
      add :customer_paid, :boolean, default: false
      add :location, :string, null: false
      add :currency, :string

      timestamps
    end
  end
end
