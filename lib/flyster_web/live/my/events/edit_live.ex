defmodule FlysterWeb.MyEventsEditLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Events

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
      {:ok, _applied_user} ->
        #TODO: Add a feature for sending emails to event attendeess when event details change
        info = "Event Details Changed!"
        {:noreply, socket |> put_flash(:info, info) |> redirect(to: ~p"/my/events")}

      {:error, changeset} ->
        {:noreply, assign(socket, :event_form, to_form(Map.put(changeset, :action, :insert)))}
    end
  end

  defp all_event_types do
    event_types = Events.all_event_types()
    Enum.map(event_types, &{&1.name, &1.id})
  end

  defp currencies() do
    currency_types = [
      %{name: "USD", value: "USD"},
      %{name: "Euro", value: "Euro"}
    ]
    Enum.map(currency_types, &{&1.name, &1.value})
  end

  defp country_options() do
    FlysterWeb.SharedComponents.country_options()
  end

  defp format_error(error) do
    [field | message ] = Tuple.to_list(error)
    [error_message | _validation ] = message |> List.first |> Tuple.to_list
    "#{Atom.to_string(field)} #{error_message}"
  end

end
