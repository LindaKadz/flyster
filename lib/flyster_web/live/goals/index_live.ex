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
       <%= for goal_comment <- goal.comments do %>
         <%= goal_comment.comment %>
       <% end %>
       </div>
       <.simple_form for={@form} id="goal_comments_form" phx-submit="add_comments">
         <div class="grid gap-6">
           <div>
             <.input field={@form[:creator_id]} type="hidden" value={@current_user.id} required />
             <.input field={@form[:goal_id]} type="hidden" value={goal.id} required />
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
         <:actions>
           <div class="pt-3">
             <.button phx-disable-with="I hope you were kind..."
             class="w-full rounded text-gray-100 bg-blue-500 hover:shadow-inner hover:bg-blue-700 transition-all duration-300">
               Add Comment
             </.button>
           </div>
         </:actions>
       </.simple_form>
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

  def handle_event(action, %{"goal_comments" => goal_comments_params}, socket) do
    if action == "validate" do
      changeset = Goals.goal_comment_changeset(%GoalComment{}, goal_comments_params)
      {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
    else
      case Goals.add_goal_comment(goal_comments_params) do
        {:ok, _goal} ->
          {:noreply,
            socket
            |> put_flash(:info, "Comment Added!")
            |> redirect(to: ~p"/goals/index")}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
      end
    end
  end
end
