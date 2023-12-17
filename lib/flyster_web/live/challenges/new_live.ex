defmodule FlysterWeb.ChallengesNewLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Challenges
  alias Flyster.Challenges.Challenge

  def mount(_params, _session, socket) do
    changeset = Challenges.change_challenge(%Challenge{})
    current_user = socket.assigns.current_user

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false, current_user: current_user)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event(action, %{"challenge" => challenge_params}, socket) do
    if action == "validate" do
      changeset = Challenges.change_challenge(%Challenge{}, challenge_params)
      {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
    else
      case Challenges.add_challenge(challenge_params) do
        {:ok, _challenge} ->
          {:noreply,
            socket
            |> put_flash(:info, "Challenge created!")
            |> redirect(to: ~p"/challenges")}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
      end
    end
  end

  defp challenge_category_types do
    challenge_category_types = [
      %{name: "Pole", value: "Pole"},
      %{name: "Silks", value: "Silks"},
      %{name: "Hoops", value: "Hoops"},
      %{name: "Fire Dance", value: "Fire Dance"}
    ]
    Enum.map(challenge_category_types, &{&1.name, &1.value})
  end

  defp challenge_level_types do
    challenge_level_types = [
      %{name: "Beginner", value: "Beginner"},
      %{name: "Beginner-Intermediate", value: "Beginner-Intermediate"},
      %{name: "Intermediate", value: "Intermediate"},
      %{name: "Intermediate-Advanced", value: "Intermediate-Advanced"},
      %{name: "Advanced", value: "Advanced"}
    ]
    Enum.map(challenge_level_types, &{&1.name, &1.value})
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "challenge")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
