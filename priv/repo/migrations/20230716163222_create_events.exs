defmodule Flyster.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string, null: false
      add :event_type_id, references(:event_types), null: false
      add :host_id, references(:users, name: :host_id), null: false
      add :time, :string, null: false
      add :date, :string, null: false
      add :description, :text, null: false
      add :rules, :text
      add :price, :float
      add :customer_paid, :boolean, default: false
      add :city, :string, null: false
      add :country, :string, null: false
      add :address, :string
      add :currency, :string
      add :duration, :string

      timestamps()
    end
  end
end
