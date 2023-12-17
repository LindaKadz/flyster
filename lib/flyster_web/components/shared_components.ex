defmodule FlysterWeb.SharedComponents do
  @moduledoc false
  alias Flyster.Cldr
  alias Flyster.Repo
  alias Flyster.Goals.Goal
  alias Flyster.Challenges.Challenge
  alias Flyster.Events.Event
  alias Flyster.Accounts.User

  import Ecto.Query, warn: false

  ## Country Functions Country functions

  def country_options() do
    Cldr.Territory.country_codes()
    |> Enum.map(&country_option/1)
    |> Enum.sort(&(&1[:key] <= &2[:key]))
  end

  defp country_option(country) do
    [key: Cldr.Territory.from_territory_code!(country),
     value: country,
     data_label: Cldr.Territory.to_unicode_flag!(country)]
  end

  def full_country_name(country_code) do
    {:ok, country_name} = Cldr.Territory.from_territory_code(country_code)
    country_name
  end

  ## Date Functions

  defp convert_to_date(date) do
    date
    |> String.split("-")
    |> Enum.map(fn string -> String.to_integer(string) end)
    |> convert_list_to_date()
  end

  defp convert_list_to_date(date_list) do
    {:ok, date} = Date.new(Enum.at(date_list, 0), Enum.at(date_list, 1), Enum.at(date_list, 2))

    date
  end

  @doc """
  Checks if date is greater than today's date

  ## Examples

      iex> convert_to_date("2023-12-31")
      :gt

  """

  def check_date_validity(accomplish_by_date) do
    date = convert_to_date(accomplish_by_date)

    Date.compare(date, Date.utc_today())
  end

  @doc """
  Queries to see how many records were created today

  ## Examples

      iex> records_created_today("users")
      :gt

  """

  def records_created_today(record_name) do
    date = NaiveDateTime.utc_now()

    query =
      cond do
        record_name == "goal" ->
          from g in Goal,
                    where: g.inserted_at == ^date
        record_name == "event" ->
          from e in Event,
                    where: e.inserted_at == ^date
        record_name == "challenge" ->
          from c in Challenge,
                    where: c.inserted_at == ^date
        record_name == "user" ->
          from u in User,
                    where: u.inserted_at == ^date
      end

    query |> Repo.all()
  end
end
