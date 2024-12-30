defmodule Flyster.Repo do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :flyster,
    adapter: Ecto.Adapters.Postgres

    use Scrivener, page_size: 10
end
