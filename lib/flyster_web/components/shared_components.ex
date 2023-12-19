defmodule FlysterWeb.SharedComponents do
  @moduledoc false
  alias Flyster.Cldr

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

  def convert_date(date) do
    date |> NaiveDateTime.to_date() |> Date.to_string()
  end
end
