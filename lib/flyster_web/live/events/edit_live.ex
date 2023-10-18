defmodule FlysterWeb.EventsEditLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Events

  def render(assigns) do
    ~H"""
    <.header class="text-center">
      Edit your event
      (Please note that the changes made will be sent to all attendees who have registered for this event.)
      <:subtitle>Manage your account email address and password settings</:subtitle>
    </.header>

    <div class="space-y-12 divide-y">
        <.simple_form
          for={@event_form}
          id="event_form"
          phx-submit="update_event"
          phx-change="validate_event"
        >
        <div>
        <.input field={@event_form[:name]} type="text" label="Event Name" required />
        <.input field={@event_form[:location]} type="text" label="Location" required />
        <.input field={@event_form[:event_type_id]} type="select" options={all_event_types()} label="Event Type" required />
        <.input field={@event_form[:date]} type="text" label="Date" required />
        <.input field={@event_form[:time]} type="text" label="Time" required />
        <.input field={@event_form[:currency]} type="text" label="Currency" />
        <.input field={@event_form[:price]} type="text" label="Price" required />
        <.input field={@event_form[:description]} type="text" label="Description" required />
        <.input field={@event_form[:rules]} type="text" label="Rules" required />
        </div>
          <:actions>
            <.button phx-disable-with="Updating...">Update Event Details</.button>
          </:actions>
        </.simple_form>
      </div>
    """
  end

  def mount(%{"id" => id}, _session, socket) do
    event = Events.find_event(id)
    event_changeset = Events.change_event_details(event)

    socket =
      socket
      |> assign(:event, event)
      |> assign(:event_form, to_form(event_changeset))
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  def handle_event("validate_event", params, socket) do
    event_form =
      socket.assigns.event
      |> Events.change_event_details(params["event"])
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, event_form: event_form)}
  end

  def handle_event("update_event", params, socket) do
    event = socket.assigns.event

    case Events.apply_event_changes(event, params["event"]) do
      {:ok, applied_user} ->
        #TODO: Add a feature for sending emails to event attendeess when event details change
        info = "Event Details Changed!"
        {:noreply, socket |> put_flash(:info, info) |> redirect(to: ~p"/events/index")}

      {:error, changeset} ->
        {:noreply, assign(socket, :event_form, to_form(Map.put(changeset, :action, :insert)))}
    end
  end

  defp all_event_types do
    event_types = Events.all_event_types()
    Enum.map(event_types, &{&1.name, &1.id})
  end

end
