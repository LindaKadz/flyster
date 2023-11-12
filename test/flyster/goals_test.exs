defmodule Flyster.GoalsTest do
  use Flyster.DataCase

  alias Flyster.Context.Goals
  import Flyster.AccountsFixtures
  import Flyster.GoalsFixtures

  describe "save_goal/1" do
    test "saves a goal given valid params" do
      user = user_fixture()

      assert {:ok, _goal} = Goals.save_goal(%{description: "Master Ayesha", accomplish_by: "2023-11-19", creator_id: user.id, private: false, category: "Pole"})
    end

    test "goal is not saved given invalid params" do
      user = user_fixture()
      assert {:error, _changeset} = Goals.save_goal(%{description: "Master Ayesha", accomplish_by: "", creator_id: user.id, private: false, category: "Silks"})
    end
  end

  describe "update_goal/2" do
    test "updates a goal" do
      user = user_fixture()
      {:ok, goal} = Goals.save_goal(%{description: "Master Ayesha", accomplish_by: "2023-11-19", creator_id: user.id, private: false, category: "Fire"})

      assert {:ok, _goal} = Goals.update_goal(goal, %{accomplished: true})
    end
  end

  describe "add_goal_comment/1" do
    test "comments can be added on goals" do
      user = user_fixture()
      goal = goal_fixture()

      assert {:ok, _goal_comment} = Goals.add_goal_comment(%{goal_id: goal.id, creator_id: user.id, comment: "This works!"})
    end
  end
end
