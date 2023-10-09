defmodule FlysterWeb.EventsShowLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Events

  def render(assigns) do
    ~H"""
      Event
    """
  end

  # def mount(%{"id" => id}, _session, socket) do
  #   event = Events.find_event(id)
  #
  #   {:ok, assign(socket, event: event)}
  # end
end
