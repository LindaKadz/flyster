defmodule FlysterWeb.EventsShowLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Events

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
          |> redirect(to: ~p"/events")}
      {:error, _, action} ->
        flash = if action == "Added", do: "We experienced a problem trying to register you to #{event.name}, please try again later.", else: "We experienced a problem trying to remove you from #{event.name} attendee list, please try again later."
        {:noreply,
         socket
         |> put_flash(:error, flash)
         |> redirect(to: ~p"/events")}
    end
  end

  defp is_user_an_event_attendee?(event_id, current_user_id) do
    Events.user_is_an_attendee?(event_id, current_user_id)
  end

  defp full_country_name(country_code) do
    FlysterWeb.SharedComponents.full_country_name(country_code)
  end

  defp remaining_slots(registered_people, available_slots) do
    String.to_integer(available_slots) - Enum.count(registered_people)
  end
end
