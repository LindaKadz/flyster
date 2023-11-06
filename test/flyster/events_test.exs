defmodule Flyster.EventsTest do
  use Flyster.DataCase

  alias Flyster.Context.Events
  import Flyster.AccountsFixtures

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

  describe "create_event/1" do
    test "user can create an event with required fields" do
      user = user_fixture()
      {:ok, event_type} = Events.create_event_type("Foo")
      params = %{name: "Foo Bar", time: "1120", date: "Mon July 2023", description: "Foo Bar Event", location: "123 St", event_type_id: event_type.id, host_id: user.id}

      assert {:ok, _event} = Events.create_event(params)
    end

    test "throws an error when given invalid parameters" do
      params = %{name: "Foo Bar", time: "1120", date: "Mon July 2023", description: "Foo Bar Event", location: "123 St", event_type_id: "", host_id: ""}

      {:error, changeset} = Events.create_event(params)
      assert %{
               host_id: ["can't be blank"],
               event_type_id: ["can't be blank"],
             } = errors_on(changeset)
    end
  end

  describe "update_attendee_list/1" do
    setup do
      user = user_fixture()
      {:ok, event_type} = Events.create_event_type("Foo")
      params = %{name: "Foo Bar", time: "1120", date: "Mon July 2023", description: "Foo Bar Event", location: "123 St", event_type_id: event_type.id, host_id: user.id}
      {:ok, event} = Events.create_event(params)

      %{user: user, event: event}
    end

    test "user is added to event list", %{user: user, event: event} do
      params = %{"user_id" => user.id, "event_id" => event.id}
      assert {:ok, _event, action} = Events.update_attendee_list(params)
      assert action == "Added"
    end

    test "user is removed from event list", %{user: user, event: event} do
      params = %{"user_id" => user.id, "event_id" => event.id}
      Events.update_attendee_list(params)

      assert {:ok, _event, action} = Events.update_attendee_list(params)
      assert action == "Removed"
    end
  end
end
