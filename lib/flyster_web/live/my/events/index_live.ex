defmodule FlysterWeb.MyEventsIndexLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Events

  def render(assigns) do
    ~H"""
    <%= if Enum.empty?(@events) do %>
      <div class="text-center">
        <br>
        <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
          <path vector-effect="non-scaling-stroke" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 13h6m-3-3v6m-9 1V7a2 2 0 012-2h6l2 2h6a2 2 0 012 2v8a2 2 0 01-2 2H5a2 2 0 01-2-2z" />
        </svg>
        <h3 class="mt-2 text-sm font-semibold text-gray-900">You do not own any event.</h3>
        <p class="mt-1 text-sm text-gray-500">Thinking of getting people together? Create an event for them.</p>
        <div class="mt-6">
          <a href="/events/new">
            <button type="button" class="inline-flex items-center rounded-md bg-official px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-official focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-official">
              <svg class="-ml-0.5 mr-1.5 h-5 w-5" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path d="M10.75 4.75a.75.75 0 00-1.5 0v4.5h-4.5a.75.75 0 000 1.5h4.5v4.5a.75.75 0 001.5 0v-4.5h4.5a.75.75 0 000-1.5h-4.5v-4.5z" />
              </svg>
              New Event
            </button>
          </a>
        </div>
        <br>
      </div>
    <% end %>

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
    current_user = socket.assigns.current_user
    events = Events.all_my_events(current_user.id)

    {:ok, assign(socket, events: events, current_user: current_user)}
  end
end
