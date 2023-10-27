defmodule Flyster.GoalsTest do
  use Flyster.DataCase

  alias Flyster.Context.Goals
  import Flyster.AccountsFixtures

  describe "save_goal/1" do
    test "saves a goal given valid params" do
      user = user_fixture()

      assert {:ok, goal} = Goals.save_goal(%{description: "Master Ayesha", accomplish_by: "2023-11-19", user_id: user.id})
    end

    test "goal is not saved given invalid params" do
      user = user_fixture()
      assert {:error, changeset} = Goals.save_goal(%{description: "Master Ayesha", accomplish_by: "", user_id: user.id})
    end
  end

  describe "update_goal/2" do
    test "updates a goal" do
      user = user_fixture()
      {:ok, goal} = Goals.save_goal(%{description: "Master Ayesha", accomplish_by: "2023-11-19", user_id: user.id})

      assert {:ok, goal} = Goals.update_goal(goal, %{accomplished: true})
    end

  end
end
