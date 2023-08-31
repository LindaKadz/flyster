defmodule FlysterWeb.EventsIndexLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Events

  def render(assigns) do
    ~H"""
      All events
    """
  end

  def mount(_params, _session, socket) do
    events = Events.all_events()

    {:ok, assign(socket, events: events)}
  end
end
