defmodule Flyster.Repo do
  use Ecto.Repo,
    otp_app: :flyster,
    adapter: Ecto.Adapters.Postgres
end
