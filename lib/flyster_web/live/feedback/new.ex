defmodule FlysterWeb.NewFeedbackLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Requests
  alias Flyster.Feedback.Request

  def mount(_params, _session, socket) do
    changeset = Requests.change_request(%Request{})
    current_user = socket.assigns.current_user

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false, current_user: current_user)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event(action, %{"request" => request_params}, socket) do
    if action == "validate" do
      changeset = Requests.change_request(%Request{}, request_params)
      {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
    else
      case Requests.create_request(request_params) do
        {:ok, _request} ->
          {:noreply,
            socket
            |> put_flash(:info, "Thank you for the feedback! We'll try to address it as soon as we can.")
            |> redirect(to: ~p"/goals")}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
      end
    end
  end

  defp request_types do
    request_types = [
      %{name: "Feedback", value: "Feedback"},
      %{name: "App Issue", value: "App Issue"},
      %{name: "Feature Request", value: "Feature Request"}
    ]
    Enum.map(request_types, &{&1.name, &1.value})
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "request")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
