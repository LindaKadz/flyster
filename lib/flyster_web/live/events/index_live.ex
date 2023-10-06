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
       <div>
        <%= if @current_user && event.user != @current_user && !Enum.member?(event.attendees, @current_user) do %>
          <.simple_form for={@attend_event_form} id="attend_event_form" phx-submit="update_event_attendees">
            <.input field={@attend_event_form[:user_id]} type="hidden", value={@current_user.id} required />
            <.input field={@attend_event_form[:event_id]} type="hidden", value={event.id} required />

            <:actions>
              <.button phx-disable-with="Adding you to the attendee list..." class="w-full">
                Attend Event
              </.button>
            </:actions>
          </.simple_form>
        <% else %>
          <div>
            You have already registered for this event.
          </div>
        <% end %>
       </div>
      <% end %>
      </div>
    """
  end

  def mount(_params, _session, socket) do
    events = Events.all_events()
    current_user = socket.assigns.current_user

    {:ok, assign(socket, events: events, current_user: current_user, attend_event_form: to_form(%{}, as: "attend_event"))}
  end

  def handle_event("update_event_attendees", %{"attend_event" => event_attendee_params}, socket) do
    event = Events.find_event(event_attendee_params["event_id"])

    case Events.save_attendee(event_attendee_params) do
      {:ok, _} ->
        {:noreply,
          socket
          |> put_flash(:info, "You have registered for #{event.name}")
          |> redirect(to: ~p"/events/index")}
      {:error, _} ->
        {:noreply,
         socket
         |> put_flash(:error, "We experienced a problem trying to register you to #{event.name}, please try again later.")
         |> redirect(to: ~p"/events/index")}
    end
  end
end
