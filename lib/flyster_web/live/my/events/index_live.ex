defmodule FlysterWeb.MyEventsIndexLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Events

  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user
    events = Events.all_my_events(current_user.id)

    {:ok, assign(socket, events: events, current_user: current_user)}
  end

  defp full_country_name(country_code) do
    FlysterWeb.SharedComponents.full_country_name(country_code)
  end
end
