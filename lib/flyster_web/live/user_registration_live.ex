defmodule FlysterWeb.UserRegistrationLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Accounts
  alias Flyster.Accounts.User

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Register for an account
        <:subtitle>
          Already registered?
          <.link navigate={~p"/users/log_in"} class="font-semibold text-brand hover:underline">
            Sign in
          </.link>
          to your account now.
        </:subtitle>
      </.header>
    </div>

    <.simple_form
      for={@form}
      id="registration_form"
      phx-submit="save"
      phx-change="validate"
      phx-trigger-action={@trigger_submit}
      action={~p"/users/log_in?_action=registered"}
      method="post"
    >
      <.error :if={@check_errors}>
        Oops, something went wrong! Please check the errors below.
      </.error>

        <div class="grid lg:grid-cols-2 gap-6">
          <div>
            <div class="-mt-4 absolute tracking-wider px-1 uppercase text-xs">
              <p>
                <label for="first_name" class="bg-white text-gray-600 px-1">First name *</label>
              </p>
            </div>
            <p>
              <.input field={@form[:first_name]} type="text" required />
            </p>
          </div>
          <div>
            <div class="-mt-4 absolute tracking-wider px-1 uppercase text-xs">
              <p>
                <label for="lastname" class="bg-white text-gray-600 px-1">Last name *</label>
              </p>
            </div>
            <p>
              <.input field={@form[:last_name]} type="text" required />
            </p>
          </div>
          <div>
            <div class="-mt-4 absolute tracking-wider px-1 uppercase text-xs">
              <p>
                <label for="username" class="bg-white text-gray-600 px-1">Username *</label>
              </p>
            </div>
            <p>
              <.input field={@form[:username]} type="text" required />
            </p>
          </div>
          <div>
            <div class="-mt-4 absolute tracking-wider px-1 uppercase text-xs">
              <p>
                <label for="phone_number" class="bg-white text-gray-600 px-1">Phone Number *</label>
              </p>
            </div>
            <p>
              <.input field={@form[:phone_number]} type="text" inputmode="numeric" pattern="[0-9]*" required />
            </p>
          </div>
          <div>
            <div class="-mt-4 absolute tracking-wider px-1 uppercase text-xs">
              <p>
                <label for="email" class="bg-white text-gray-600 px-1">Email *</label>
              </p>
            </div>
            <p>
              <.input field={@form[:email]} type="email" required />
            </p>
          </div>
          <div>
            <div class="-mt-4 absolute tracking-wider px-1 uppercase text-xs">
              <p>
                <label for="password" class="bg-white text-gray-600 px-1">Password *</label>
              </p>
            </div>
            <p>
              <.input field={@form[:password]} type="password" required />
            </p>
          </div>
          <div>
            <div class="-mt-4 absolute tracking-wider px-1 uppercase text-xs">
              <p>
                <label for="city" class="bg-white text-gray-600 px-1">City *</label>
              </p>
            </div>
            <p>
              <.input field={@form[:city]} type="text" required />
            </p>
          </div>
          <div>
            <div class="-mt-4 absolute tracking-wider px-1 uppercase text-xs">
              <p>
                <label for="country" class="bg-white text-gray-600 px-1">Country *</label>
              </p>
            </div>
            <p>
              <.input field={@form[:country]} type="text" required />
            </p>
          </div>
          <div>
            <div class="-mt-4 absolute tracking-wider px-1 uppercase text-xs">
              <p>
                <label for="role" class="bg-white text-gray-600 px-1">Speciality *</label>
              </p>
            </div>
            <p>
              <.input field={@form[:role_id]} options={all_roles} type="select" label="Choose your Sport" required />
            </p>
          </div>
        </div>

      <:actions>
        <div class="pt-3">
        <.button phx-disable-with="Creating account..."
        class="w-full rounded text-gray-100 bg-blue-500 hover:shadow-inner hover:bg-blue-700 transition-all duration-300">
          Create an account
        </.button>
        </div>
      </:actions>
    </.simple_form>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def all_roles do
    roles = Accounts.all_roles()
    Enum.map(roles, &{&1.name, &1.id})
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
