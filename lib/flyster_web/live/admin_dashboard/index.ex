defmodule FlysterWeb.AdminDashboardLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.{Accounts, Challenges, Events, Goals}

  def mount(_params, _session, socket) do
    events = Events.all_events()
    challenges = Challenges.all_challenges()
    goals = Goals.all_goals()
    users = Accounts.all_users()
    comments = Goals.all_goal_comments()

    socket =
      socket
      |> assign(events: events, challenges: challenges, goals: goals, users: users, comments: comments)

    {:ok, socket, layout: false}
  end

  defp calculate_percentage(category) do
  end
end
