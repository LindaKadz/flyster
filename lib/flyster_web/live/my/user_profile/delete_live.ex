defmodule FlysterWeb.UserProfileDeleteLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Accounts

  def mount(%{"id" => id}, _session, socket) do
    user = Accounts.get_user!(id)

    case Accounts.delete_account(user) do
      {:ok, user} ->
        {:ok,
          socket
          |> put_flash(:info, "#{user.first_name}, we are so sad to see you go. Hope you can join us again!")
          |> redirect(to: ~p"/users/log_in")}
      {:error, _} ->
        {:noreply,
          socket
          |> put_flash(:info, "We had a problem deleting your account, please try again.")
          |> redirect(to: ~p"/goals")}
    end
  end
end
