defmodule FlysterWeb.ChallengesIndexLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Challenges

  def mount(_params, _session, socket) do
    IO.inspect socket.assigns
    current_user = socket.assigns.current_user

    {:ok,
     socket
     |> assign(current_user: current_user, page: 1, per_page: 5)
     |> fetch(), temporary_assigns: [challenges: []]}
  end

  defp fetch(%{assigns: %{page: page, per_page: per}} = socket) do
    assign(socket, challenges: Challenges.list_challenges(paginate: %{page: page, per_page: per}))
  end

  # def handle_event("load-more", _, %{assigns: assigns} = socket) do
  #   {:noreply, socket |> assign(page: assigns.page + 1) |> fetch()}
  # end
end
