defmodule FlysterWeb.ChallengesNewLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Challenges
  alias Flyster.Challenges.Challenge

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Feeling creative? Create a challenge for people to work on!
      </.header>
    </div>

    <.simple_form
      for={@form}
      id="challenge_form"
      phx-submit="save"
      phx-change="validate"
      phx-trigger-action={@trigger_submit}
      method="post"
    >
      <.error :if={@check_errors}>
        Oops, something went wrong! Please check the errors below.
      </.error>

      <div class="grid gap-6">
        <div>
          <div class="-mt-4 absolute tracking-wider px-1 uppercase text-xs">
            <p>
              <label for="description" class="bg-white text-gray-600 px-1">Document the challenge *</label>
            </p>
          </div>
          <p>
            <.input field={@form[:description]} type="text" required />
          </p>
        </div>
      </div>

        <div class="grid lg:grid-cols-2 gap-6">
          <div>
            <div class="-mt-4 absolute tracking-wider px-1 uppercase text-xs">
              <p>
                <label for="challenge_category_type" class="bg-white text-gray-600 px-1"> What category does this challenge fall under? *</label>
              </p>
            </div>
            <p>
              <.input field={@form[:category]} options={challenge_category_types()} type="select" label="" required />
            </p>
          </div>

          <div>
            <div class="-mt-4 absolute tracking-wider px-1 uppercase text-xs">
              <p>
                <label for="challenge_level" class="bg-white text-gray-600 px-1"> What level is this challenge? *</label>
              </p>
            </div>
            <p>
              <.input field={@form[:level]} options={challenge_level_types()} type="select" label="" required />
            </p>
          </div>

          <div class="-mt-4 absolute tracking-wider px-1 uppercase text-xs">
            <.input field={@form[:creator_id]} type="hidden" value={@current_user.id} required />
          </div>

        </div>


      <:actions>
        <div class="pt-3">
        <.button phx-disable-with="Building the challenge..."
        class="w-full rounded text-gray-100 bg-blue-500 hover:shadow-inner hover:bg-blue-700 transition-all duration-300">
          Create Challenge
        </.button>
        </div>
      </:actions>
    </.simple_form>
    """
  end

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
