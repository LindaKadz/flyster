defmodule FlysterWeb.ChallengesIndexLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Challenges

  def render(assigns) do
    ~H"""
      All Challenges

      <div class="space-y-12 divide-y">
        <%= for challenge <- @challenges do %>
         <div class="grid gap-6">
          <%= challenge.creator.username %>
          <%= challenge.category %>
          <%= challenge.level %>
          <%= challenge.description %>
         </div>
        <% end %>
      </div>
    """
  end

  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user
    challenges = Challenges.all_challenges()

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false, current_user: current_user, challenges: challenges)

    {:ok, socket}
  end
end
