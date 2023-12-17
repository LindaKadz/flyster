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

  @doc """
  Gets a single goal.

  Raises `Ecto.NoResultsError` if the Goal does not exist.

  ## Examples

      iex> get_goal!(123)
      %Goal{}

      iex> get_goal!(456)
      ** (Ecto.NoResultsError)

  """
  def get_goal!(id), do: Repo.get!(Goal, id)

  @doc ~S"""
  Gets all the goals in the database

  ## Examples

      iex> all_goals()
      [%Goal{id: 1, description: y}, %Goal{id: z, description: 2}, ...]

  """

  def all_goals do
    Repo.all(Goal) |> Repo.preload(:creator)
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

  @doc """
  Returns a list of goals for one user.

  ## Examples

      iex> all_my_goals(user_id)
      [%Goal{id: x, description: y}, %Goal{id: z, description: r}, ...]

  """
  def all_my_goals(user_id) do
    query = from goal in Goal,
              where: goal.creator_id == ^user_id

    query |> Repo.all() |> Repo.preload([:creator, comments: [:creator]])
  end

  @doc """
  It updates the data saved in the database with new information

  ## Examples

      iex> apply_goal_changes(goal, %{id: ...})
      {:ok, %Goal{}}

      iex> apply_goal_changes(goal, %{id: ...})
      {:error, %Ecto.Changeset{}}

  """
  def apply_goal_changes(goal, attrs) do
    goal
    |> change_goal(attrs)
    |> Repo.update()
  end


  @doc ~S"""
  Gets all the goals in the database

  ## Examples

      iex> all_goal_comments()
      [%GoalComment{id: 1, description: y}, %GoalComment{id: z, description: 2}, ...]

  """

  def all_goal_comments do
    Repo.all(GoalComment) |> Repo.preload(:creator)
  end
end
