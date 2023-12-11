defmodule FlysterWeb.ProfileShowLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Accounts

  def mount(%{"id" => id}, _session, socket) do
    user = Accounts.get_user_profile(id)
    current_user = socket.assigns.current_user

    {:ok, assign(socket, current_user: current_user, user: user)}
  end

  defp get_user_activities(id, activity, current_user) do
    if current_user do
      Accounts.get_all_user_activities(id, activity) |> Enum.count
    else
      Accounts.get_all_public_user_activities(id, activity) |> Enum.count
    end
  end
end
