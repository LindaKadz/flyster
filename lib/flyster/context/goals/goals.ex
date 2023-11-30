defmodule Flyster.Context.Goals do
  @moduledoc """
   Goals Context
  """

  import Ecto.Query, warn: false
  alias Flyster.Goals.Goal
  alias Flyster.Goals.GoalComment
  alias Flyster.Repo

  ###GOALS

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

  @doc ~S"""
  Gets all the goals in the database marked as `private: false`

  ## Examples

      iex> all_public_goals()
      [%Goal{id: x, description: y}, %Goal{id: z, description: r}, ...]

  """

  def all_public_goals do
    query = from goal in Goal,
              where: goal.private == false

    query |> Repo.all() |> Repo.preload([:creator, comments: [:creator]])
  end

  @doc ~S"""
  Gets all the goals in the database marked as `private: true`

  ## Examples

      iex> all_private_goals()
      [%Goal{id: x, description: y}, %Goal{id: z, description: r}, ...]

  """

  def all_private_goals do
    query = from goal in Goal,
              where: goal.private == true

    query |> Repo.all() |> Repo.preload([:creator, comments: [:creator]])
  end

  #### GOAL COMMENTS

  @doc """
  Creates a goal comment.

  ## Examples

      iex> add_goal_comment(%{description: "get ayesha", accomplish_by: "3rd June 2024"...})
      {:ok, %GoalComment{}}

      iex> add_goal_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def add_goal_comment(goal_comment_params) do
    %GoalComment{}
    |> GoalComment.changeset(goal_comment_params)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for updating a goal.

  ## Examples

      iex> goal_comment_changeset(goal)
      %Ecto.Changeset{data: %GoalComment{}}

  """
  def goal_comment_changeset(goal_comment, attrs \\ %{}) do
    GoalComment.changeset(goal_comment, attrs)
  end
end
