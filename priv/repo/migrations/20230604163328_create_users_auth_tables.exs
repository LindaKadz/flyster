defmodule Flyster.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :username, :string, null: false
      add :city, :string
      add :state, :string
      add :postal_code, :string
      add :level, :string
      add :full_address, :string
      add :country, :string
      add :profile_picture, :string
      add :cover_picture, :string
      add :phone_number, :string
      add :terms_of_service, :boolean
      add :group, :string
      add :email, :citext, null: false
      add :hashed_password, :string, null: false
      add :confirmed_at, :naive_datetime
      add :role_id, references(:roles), null: false
      timestamps()
    end

    create unique_index(:users, [:email])

    create table(:users_tokens) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:users_tokens, [:user_id])
    create unique_index(:users_tokens, [:context, :token])
  end
end
