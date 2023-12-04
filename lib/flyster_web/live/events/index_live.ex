defmodule FlysterWeb.EventsIndexLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Events

  def render(assigns) do
    ~H"""
      All events

      <div class="space-y-12 divide-y">
      <%= for event <- @events do %>
       <div class="grid gap-6">
       <.link
         href={~p"/events/#{event.id}"}
         class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
       >
           <%= event.name %>
       </.link>
        <%= event.location %>
        <%= event.host.username %>
       </div>
      <% end %>
      </div>
    """
  end

  def mount(_params, _session, socket) do
    events = Events.all_events()
    current_user = socket.assigns.current_user

    {:ok, assign(socket, events: events, current_user: current_user)}
  end
end
