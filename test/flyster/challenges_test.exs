defmodule Flyster.ChallengesTest do
  use Flyster.DataCase

  alias Flyster.Context.Challenges
  import Flyster.AccountsFixtures

  describe "add_challenge/1" do
    test "saves a challenge given valid params" do
      user = user_fixture()

      assert {:ok, _challenges} = Challenges.add_challenge(%{description: "Foo Bar Baz", creator_id: user.id, category: "Pole", level: "Beginner"})
    end

    test "challenge is not saved given invalid params" do
      user = user_fixture()
      assert {:error, _changeset} = Challenges.add_challenge(%{description: "Master Ayesha", creator_id: user.id, category: "Silks", level: ""})
    end
  end
end
