defmodule FlysterWeb.EventsShowLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Events

  def render(assigns) do
    ~H"""
    <div class="grid gap-6">
     <h1> <%= @event.name %> </h1>
     <p> <%= @event.description %> </p>
     <p> <%= @event.rules %> </p>
     <p> <%= @event.location %> </p>
     <p> <%= @event.user.username %> </p>

    </div>
    <br/>
    <div>
     <%= if @current_user && @event.user != @current_user do %>
       <.simple_form for={@attend_event_form} id="attend_event_form" phx-submit="update_event_attendees">
         <.input field={@attend_event_form[:user_id]} type="hidden", value={@current_user.id} required />
         <.input field={@attend_event_form[:event_id]} type="hidden", value={@event.id} required />

         <:actions>
           <%= if !Enum.member?(@event.attendees, @current_user) do %>
             <.button phx-disable-with="Adding you to the attendee list..." class="w-full">
               Attend Event
             </.button>
           <% else %>
             <.button phx-disable-with="Removing you from the attendee list..." class="w-full">
               De-Register from Event
             </.button>
           <% end %>
         </:actions>
       </.simple_form>
     <% else %>
       <div>
         You have already registered for this event.
       </div>
     <% end %>
    </div>

    """
  end

  def mount(%{"id" => id}, _session, socket) do
    event = Events.find_event_with_attendees(id)
    current_user = socket.assigns.current_user

    {:ok, assign(socket, event: event, current_user: current_user, attend_event_form: to_form(%{}, as: "attend_event"))}
  end

  def handle_event("update_event_attendees", %{"attend_event" => event_attendee_params}, socket) do
    event = Events.find_event(event_attendee_params["event_id"])

    case Events.update_attendee_list(event_attendee_params) do
      {:ok, _, action} ->
        flash = if action == "Added", do: "You have registered for #{event.name}", else: "You have been removed from #{event.name} attendee list"
        {:noreply,
          socket
          |> put_flash(:info, flash)
          |> redirect(to: ~p"/events/index")}
      {:error, _, action} ->
        flash = if action == "Added", do: "We experienced a problem trying to register you to #{event.name}, please try again later.", else: "We experienced a problem trying to remove you from #{event.name} attendee list, please try again later."
        {:noreply,
         socket
         |> put_flash(:error, "We experienced a problem trying to register you to #{event.name}, please try again later.")
         |> redirect(to: ~p"/events/index")}
    end
  end
end
