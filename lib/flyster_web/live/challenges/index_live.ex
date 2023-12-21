defmodule FlysterWeb.ChallengesIndexLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Challenges

  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user
    challenges = Challenges.all_challenges()

    socket =
      socket
      |> assign(current_user: current_user, challenges: challenges)

    {:ok, socket}
  end
end
