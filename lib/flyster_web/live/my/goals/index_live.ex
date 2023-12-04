defmodule FlysterWeb.MyGoalsIndexLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Goals
  alias Flyster.Goals.GoalComment

  def mount(_params, _session, socket) do
    changeset = Goals.goal_comment_changeset(%GoalComment{})
    current_user = socket.assigns.current_user
    goals = Goals.all_my_goals(current_user.id)

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false, current_user: current_user, goals: goals, page_title: "Goals")
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
            |> redirect(to: ~p"/goals")}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
      end
    end
  end
end
