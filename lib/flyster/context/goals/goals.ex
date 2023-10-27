defmodule Flyster.Context.Goals do
  @moduledoc """
   Goals Context
  """

  alias Flyster.Goals.Goal
  alias Flyster.Repo

  @doc """
  Creates a goal.

  ## Examples

      iex> save_goal(%{description: "get ayesha", accomplish_by: "3rd June 2024"...})
      {:ok, %Goal{}}

      iex> save_goal(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def save_goal(goal_params) do
    %Goal{}
    |> Goal.changeset(goal_params)
    |> Repo.insert()
  end

  @doc """
  Updates a goal. We only allow an update to mark the goal accomplished.

  ## Examples

      iex> update_goal(%Goal{}, %{accomplished: true})
      {:ok, %Goal{}}

      iex> create_goal(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def update_goal(goal, params) do
    goal
    |> change_goal(params)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for updating a goal.

  ## Examples

      iex> change_goal(goal)
      %Ecto.Changeset{data: %Goal{}}

  """
  def change_goal(goal, attrs \\ %{}) do
    Goal.changeset(goal, attrs)
  end
end
