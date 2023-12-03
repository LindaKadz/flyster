defmodule FlysterWeb.MyChallengesIndexLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Challenges

  def render(assigns) do
    ~H"""
      <%= if Enum.empty?(@challenges) do %>
        <div class="text-center">
          <br>
          <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
            <path vector-effect="non-scaling-stroke" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 13h6m-3-3v6m-9 1V7a2 2 0 012-2h6l2 2h6a2 2 0 012 2v8a2 2 0 01-2 2H5a2 2 0 01-2-2z" />
          </svg>
          <h3 class="mt-2 text-sm font-semibold text-gray-900">You have not created any challenges.</h3>
          <p class="mt-1 text-sm text-gray-500">Thinking of something that people may enjoy? Create the challenge for them!</p>
          <div class="mt-6">
            <a href="/challenges/new">
              <button type="button" class="inline-flex items-center rounded-md bg-official px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-official focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-official">
                <svg class="-ml-0.5 mr-1.5 h-5 w-5" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                  <path d="M10.75 4.75a.75.75 0 00-1.5 0v4.5h-4.5a.75.75 0 000 1.5h4.5v4.5a.75.75 0 001.5 0v-4.5h4.5a.75.75 0 000-1.5h-4.5v-4.5z" />
                </svg>
                New Challenge
              </button>
            </a>
          </div>
          <br>
        </div>
      <% end %>

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
    challenges = Challenges.all_my_challenges(current_user.id)

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false, current_user: current_user, challenges: challenges)

    {:ok, socket}
  end
end
