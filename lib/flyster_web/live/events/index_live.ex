defmodule FlysterWeb.EventsIndexLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Events

  def mount(_params, _session, socket) do
    events = Events.all_events()
    current_user = socket.assigns.current_user

    {:ok, assign(socket, events: events, current_user: current_user)}
  end
end
