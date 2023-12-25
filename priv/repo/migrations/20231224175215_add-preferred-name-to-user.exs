defmodule :"Elixir.Flyster.Repo.Migrations.Add-preferred-name-to-user" do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :preferred_name, :string
    end
  end
end
