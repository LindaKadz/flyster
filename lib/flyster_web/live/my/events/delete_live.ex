defmodule FlysterWeb.MyEventsDeleteLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Events

  def mount(%{"id" => id}, _session, socket) do
    event = Events.find_event(id)

    case Events.delete_event(event) do
      {:ok, event} ->
        {:ok,
          socket
          |> put_flash(:info, "#{event.name} event successfully deleted.")
          |> redirect(to: ~p"/my/events")}
      {:error, _} ->
        {:noreply,
          socket
          |> put_flash(:info, "We had a problem deleting this event, please try again.")
          |> redirect(to: ~p"/my/events")}
    end
  end
end
