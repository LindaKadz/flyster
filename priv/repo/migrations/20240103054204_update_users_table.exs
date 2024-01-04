defmodule Flyster.Repo.Migrations.UpdateUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :profile_picture, :text
      modify :cover_picture, :text
    end
  end
end
