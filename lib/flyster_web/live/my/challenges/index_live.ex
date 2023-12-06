defmodule FlysterWeb.MyChallengesIndexLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Challenges

  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user
    challenges = Challenges.all_my_challenges(current_user.id)

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false, current_user: current_user, challenges: challenges)

    {:ok, socket}
  end
end
