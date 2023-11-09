defmodule FlysterWeb.GoalsIndexLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Goals
  alias Flyster.Goals.GoalComment

  def render(assigns) do
    ~H"""
      All Goals

      <div class="space-y-12 divide-y">
      <%= for goal <- @goals do %>
       <div class="grid gap-6">
        <%= goal.creator.username %>
        <%= goal.category %>
        <%= goal.description %>
       </div>
       <div>
       <.simple_form for={@form} id="goal_comments_form" phx-submit="add_comments">
         <.input field={@form[:user_id]} type="hidden" value={@current_user.id} required />
         <.input field={@form[:goal_id]} type="hidden" value={goal.id} required />

         <div class="grid gap-6">
           <div>
             <div class="-mt-4 absolute tracking-wider px-1 uppercase text-xs">
               <p>
                 <label for="comment" class="bg-white text-gray-600 px-1">Add Comment *</label>
               </p>
             </div>
             <p>
               <.input field={@form[:comment]} type="text" required />
             </p>
           </div>
         </div>
       </.simple_form>
       </div>
      <% end %>
      </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Goals.goal_comment_changeset(%GoalComment{})
    current_user = socket.assigns.current_user
    goals = Goals.all_public_goals()

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false, current_user: current_user, goals: goals)
      |> assign_form(changeset)

    {:ok, socket}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "goal_comments")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
