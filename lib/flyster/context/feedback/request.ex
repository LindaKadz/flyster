defmodule Flyster.Context.Requests do
  alias Flyster.Feedback.Request
  alias Flyster.Repo

  import Ecto.Query, warn: false

  @doc """
  Creates a request.

  ## Examples

      iex> create_request(%{description: "step 1....", user_id: 1...})
      {:ok, %Request{}}

      iex> create_request(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_request(request_params) do
    %Request{}
    |> Request.changeset(request_params)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for a request.

  ## Examples

      iex> change_request(%Request{})
      %Ecto.Changeset{data: %Request{}}

  """
  def change_request(request, attrs \\ %{}) do
    Request.changeset(request, attrs)
  end

  @doc ~S"""
  Gets all the challenges in the database

  ## Examples

      iex> all_requests()
      [%Request{id: 1, description: y}, %Request{id: z, description: 2}, ...]

  """

  def all_requests do
    Repo.all(Request) |> Repo.preload(:user)
  end
end
