defmodule FlysterWeb.IndexFeedbackLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Requests
  on_mount FlysterWeb.AdminLiveAuth

  def mount(_params, _session, socket) do
    requests = Requests.all_requests()

    socket =
      socket
      |> assign(requests: requests)

    {:ok, socket}
  end
end
