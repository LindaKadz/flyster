defmodule FlysterWeb.AdminLiveAuth do
  import Phoenix.LiveView

  def on_mount(:default, _params, _session, socket) do
    if socket.assigns.current_user.group == "admin" do
      {:cont, socket}
    else
      socket = socket |> put_flash(:error, "Sorry, you are not allowed to acess this page.")
      {:halt, redirect(socket, to: "/goals")}
    end
  end
end
