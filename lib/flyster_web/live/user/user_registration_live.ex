defmodule FlysterWeb.UserRegistrationLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Accounts
  alias Flyster.Accounts.User
  alias FlysterWeb.UserAuth

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => params}, socket) do
    user_params = Map.put(params, "group", "dancer")
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

          {:noreply,
            socket
            |> put_flash(:info, "Account created successfully, please proceed to login!")
            |> redirect(to: ~p"/users/log_in")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  defp all_roles do
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

  defp format_error(error) do
    [field | message ] = Tuple.to_list(error)
    [error_message | _validation ] = message |> List.first |> Tuple.to_list
    "#{Atom.to_string(field)} #{error_message}"
  end
end
