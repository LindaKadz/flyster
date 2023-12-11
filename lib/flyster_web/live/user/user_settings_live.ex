defmodule FlysterWeb.UserSettingsLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Accounts

  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Accounts.update_user_email(socket.assigns.current_user, token) do
        :ok ->
          put_flash(socket, :info, "Email changed successfully.")

        :error ->
          put_flash(socket, :error, "Email change link is invalid or it has expired.")
      end

    {:ok, push_navigate(socket, to: ~p"/users/settings")}
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    email_changeset = Accounts.change_user_email(user)
    password_changeset = Accounts.change_user_password(user)
    public_info_changeset = Accounts.change_public_info(user)
    personal_info_changeset = Accounts.change_private_info(user)

    socket =
      socket
      |> assign(:current_password, nil)
      |> assign(:email_form_current_password, nil)
      |> assign(:current_email, user.email)
      |> assign(:uploaded_files, [])
      |> allow_upload(:profile_picture, accept: ~w(.jpg .jpeg), max_entries: 1)
      |> assign(:email_form, to_form(email_changeset))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:public_info_form, to_form(public_info_changeset))
      |> assign(:personal_info_form, to_form(personal_info_changeset))
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  def handle_event("validate_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    email_form =
      socket.assigns.current_user
      |> Accounts.change_user_email(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, email_form: email_form, email_form_current_password: password)}
  end

  def handle_event("update_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_user_update_email_instructions(
          applied_user,
          user.email,
          &url(~p"/users/settings/confirm_email/#{&1}")
        )

        info = "A link to confirm your email change has been sent to the new address."
        {:noreply, socket |> put_flash(:info, info) |> assign(email_form_current_password: nil)}

      {:error, changeset} ->
        {:noreply, assign(socket, :email_form, to_form(Map.put(changeset, :action, :insert)))}
    end
  end

  def handle_event("validate_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    password_form =
      socket.assigns.current_user
      |> Accounts.change_user_password(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form, current_password: password)}
  end

  def handle_event("update_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        password_form =
          user
          |> Accounts.change_user_password(user_params)
          |> to_form()

        {:noreply, assign(socket, trigger_submit: true, password_form: password_form)}

      {:error, changeset} ->
        {:noreply, assign(socket, password_form: to_form(changeset))}
    end
  end

  def handle_event("validate_public_info", params, socket) do
    public_info_form =
      socket.assigns.current_user
      |> Accounts.change_public_info(params["user"])
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, public_info_form: public_info_form)}
  end

  def handle_event("update_public_info", params, socket) do
    user = socket.assigns.current_user

    if Enum.empty?(socket.assigns.uploads.profile_picture.entries) do
      update_public_info(socket, user, params["user"])
    else
      consumed_image = consume_profile_pic(socket)
      IO.inspect consumed_image
      user_params = Map.put(params["user"], "profile_picture", consumed_image)
      IO.inspect user_params
      update_public_info(socket, user, user_params)
    end
  end

  defp consume_profile_pic(socket) do
    [file_path | _] =
      consume_uploaded_entries(socket, :profile_picture, fn %{path: path}, _entry ->
        dest = Path.join([:code.priv_dir(:flyster), "static", "uploads", Path.basename(path)])
        File.cp!(path, dest)
        {:ok, ~p"/uploads/#{Path.basename(dest)}"}
      end)

    file_path
  end

  defp update_public_info(socket, user, user_params) do
    case Accounts.apply_public_info_changes(user, user_params) do
      {:ok, _updated_user} ->

        info = "Public Information successfully updated."
        {:noreply,
          socket
          |> put_flash(:info, info)
          |> redirect(to: ~p"/users/settings")}

      {:error, changeset} ->
        {:noreply, assign(socket, public_info_form: to_form(changeset))}
    end
  end

  def handle_event("validate_personal_info", params, socket) do
    personal_info_form =
      socket.assigns.current_user
      |> Accounts.change_private_info(params["user"])
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, personal_info_form: personal_info_form)}
  end

  def handle_event("update_personal_info", params, socket) do
    user = socket.assigns.current_user

    case Accounts.apply_private_info_changes(user, params["user"]) do
      {:ok, user} ->
        info = "Private Information successfully updated."

        {:noreply,
          socket
          |> put_flash(:info, info)
          |> redirect(to: ~p"/users/settings")}

      {:error, changeset} ->
        {:noreply, assign(socket, personal_info_form: to_form(changeset))}
    end
  end

  defp all_roles do
    roles = Accounts.all_roles()
    Enum.map(roles, &{&1.name, &1.id})
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

  defp country_options() do
    FlysterWeb.SharedComponents.country_options()
  end
end
