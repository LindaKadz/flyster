defmodule FlysterWeb.EventsNewLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Events
  alias Flyster.Events.Event

  def mount(_params, _session, socket) do
    changeset = Events.change_event(%Event{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  defp all_event_types do
    event_types = Events.all_event_types()
    Enum.map(event_types, &{&1.name, &1.id})
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "event")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end

  def handle_event("validate", %{"event" => event_params}, socket) do
    changeset = Events.change_event(%Event{}, event_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  def handle_event("save", %{"event" => event_params}, socket) do
    params = Map.put(event_params, "host_id", socket.assigns.current_user.id)
    case Events.create_event(params) do
      {:ok, event} ->
        {:noreply,
          socket
          |> put_flash(:info, "#{event.name} has been successfully created!")
          |> redirect(to: ~p"/events")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
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
end
