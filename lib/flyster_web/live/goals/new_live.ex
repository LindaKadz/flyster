defmodule FlysterWeb.GoalsNewLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Goals
  alias Flyster.Goals.Goal

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Working on a new Goal? Let's help you track it!
      </.header>
    </div>

    <.simple_form
      for={@form}
      id="goal_form"
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
              <label for="description" class="bg-white text-gray-600 px-1">What's your goal? *</label>
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
                <label for="goal_category_type" class="bg-white text-gray-600 px-1"> What category does this goal fall under? *</label>
              </p>
            </div>
            <p>
              <.input field={@form[:category]} options={goal_category_types()} type="select" label="" required />
            </p>
          </div>
          <div>
            <div class="-mt-4 absolute tracking-wider px-1 uppercase text-xs">
              <p>
                <label for="accomplish_by" class="bg-white text-gray-600 px-1"> What timeframe are you giving yourself? (Be kind to yourself) *</label>

              </p>
            </div>
            <p>
              <.input field={@form[:accomplish_by]} type="text" required />
            </p>
          </div>
          <div class="-mt-4 absolute tracking-wider px-1 uppercase text-xs">
            <.input field={@form[:creator_id]} type="hidden" value={@current_user.id} required />
          </div>
          <div>
            <div class="-mt-4 absolute tracking-wider px-1 uppercase text-xs">
              <p>
                <label for="privacy_status" class="bg-white text-gray-600 px-1"> Can we share this goal with everyone else? *</label>
              </p>
            </div>
            <p>
              <.input field={@form[:private]} options={privacy_status()} type="select" label="" required />
            </p>
          </div>
        </div>


      <:actions>
        <div class="pt-3">
        <.button phx-disable-with="Writing it in our diary..."
        class="w-full rounded text-gray-100 bg-blue-500 hover:shadow-inner hover:bg-blue-700 transition-all duration-300">
          Document Goal!
        </.button>
        </div>
      </:actions>
    </.simple_form>
    """
  end

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
            |> redirect(to: ~p"/goals")}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
      end
    end
  end

  defp goal_category_types do
    goal_types = [
      %{name: "Pole", value: "Pole"},
      %{name: "Silks", value: "Silks"},
      %{name: "Hoops", value: "Hoops"},
      %{name: "Fire Dance", value: "Fire Dance"}
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
