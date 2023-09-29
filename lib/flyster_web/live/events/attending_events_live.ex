defmodule FlysterWeb.AttendingEventsLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Events

  def render(assigns) do
    ~H"""
      Event
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("save", %{"attend_event" => event_params}, socket) do
    event = Events.find_event_with_attendees(event_params["id"])
    attendees = [socket.assigns.current_user.id | event.attendees]

    {:noreply,
      socket
      |> put_flash(:info, "You have registered for #{event.name}")
      |> redirect(to: ~p"/events/index")}
  end
end
