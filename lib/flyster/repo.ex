defmodule Flyster.Repo do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :flyster,
    adapter: Ecto.Adapters.Postgres
end
