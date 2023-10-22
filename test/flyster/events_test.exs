defmodule Flyster.EventsTest do
  use Flyster.DataCase

  alias Flyster.Context.Events

  describe "create_event_type/1" do
    test "creates an event type when given valid parameters" do
      assert {:ok, _event_type} = Events.create_event_type("Foo")
    end

    test "throws an error when given invalid parameters" do
      {:error, changeset} = Events.create_event_type("")
      assert %{
               name: ["can't be blank"],
             } = errors_on(changeset)
    end
  end
end
