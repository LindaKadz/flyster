defmodule FlysterWeb.EventsIndexLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Events

  def render(assigns) do
    ~H"""
      All events

      <div class="space-y-12 divide-y">
      <%= for event <- @events do %>
       <div class="grid gap-6">
        <%= event.name %>
        <%= event.description %>
        <%= event.rules %>
        <%= event.location %>
        <%= event.user.username %>
       </div>
      <% end %>
      </div>
    """
  end

  def mount(_params, _session, socket) do
    events = Events.all_events()

    {:ok, assign(socket, events: events)}
  end
end
