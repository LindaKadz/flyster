defmodule FlysterWeb.GoalsNewLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Goals
  alias Flyster.Goals.Goal

  def mount(_params, _session, socket) do
    changeset = Goals.change_goal(%Goal{})
    current_user = socket.assigns.current_user

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false, current_user: current_user)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event(action, %{"goal" => goal_params}, socket) do
    if action == "validate" do
      changeset = Goals.change_goal(%Goal{}, goal_params)
      {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
    else
      case Goals.save_goal(goal_params) do
        {:ok, _goal} ->
          {:noreply,
            socket
            |> put_flash(:info, "Documented!")
            |> redirect(to: ~p"/my/goals")}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
      end
    end
  end

  defp goal_category_types do
    goal_types = [
      %{name: "Active Flexibility", value: "Active Flexibility"},
      %{name: "Fire Dance", value: "Fire Dance"},
      %{name: "Hoops", value: "Hoops"},
      %{name: "Pole", value: "Pole"},
      %{name: "Silks", value: "Silks"},
      %{name: "Splits", value: "Splits"}
    ]
    Enum.map(goal_types, &{&1.name, &1.value})
  end

  defp privacy_status do
    goal_types = [
      %{name: "Yes", value: false},
      %{name: "No", value: true}
    ]
    Enum.map(goal_types, &{&1.name, &1.value})
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "goal")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
