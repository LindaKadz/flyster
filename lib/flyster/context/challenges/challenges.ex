defmodule Flyster.Context.Challenges do
  @moduledoc """
   Challeges Context
  """

  alias Flyster.Challenges.Challenge
  alias Flyster.Repo
  import Ecto.Query, warn: false

  @doc """
  Creates a challenge.

  ## Examples

      iex> add_challenge(%{description: "step 1....", creator_id: 1...})
      {:ok, %Challenge{}}

      iex> add_challenge(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def add_challenge(challenge_params) do
    %Challenge{}
    |> Challenge.changeset(challenge_params)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for a challenge.

  ## Examples

      iex> change_challenge(%Challenge{})
      %Ecto.Changeset{data: %Challenge{}}

  """
  def change_challenge(challenge, attrs \\ %{}) do
    Challenge.changeset(challenge, attrs)
  end

  @doc ~S"""
  Gets all the challenges in the database

  ## Examples

      iex> all_challenges()
      [%Challenge{id: 1, description: y}, %Challenge{id: z, description: 2}, ...]

  """

  def all_challenges do
    Repo.all(Challenge) |> Repo.preload(:creator)
  end

  @doc ~S"""
  Gets all the challenges in the database for a specific

  ## Examples

      iex> all_challenges()
      [%Challenge{id: 1, description: y}, %Challenge{id: z, description: 2}, ...]

  """

  def all_my_challenges(user_id) do
    query = from challenge in Challenge,
              where: challenge.creator_id == ^user_id

    query |> Repo.all() |> Repo.preload(:creator)
  end

  @doc ~S"""
  Deletes challenges from the database

  ## Examples

      iex> all_challenges()
      [%Challenge{id: 1, description: y}, %Challenge{id: z, description: 2}, ...]

  """

  def delete_challenge(challenge), do: Repo.delete(challenge)

  @doc """
  Gets a single challenge.

  Raises `Ecto.NoResultsError` if the Challenge does not exist.

  ## Examples

      iex> get_challenge!(123)
      %Goal{}

      iex> get_challenge!(456)
      ** (Ecto.NoResultsError)

  """
  def get_challenge!(id), do: Repo.get!(Challenge, id)
end
