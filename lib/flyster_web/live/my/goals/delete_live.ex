defmodule FlysterWeb.MyGoalsDeleteLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Goals

  def mount(%{"id" => id}, _session, socket) do
    goal = Goals.get_goal!(id)

    case Goals.delete_goal(goal) do
      {:ok, goal} ->
        {:ok,
          socket
          |> put_flash(:info, "#{goal.category} has been successfully deleted.")
          |> redirect(to: ~p"/my/goals")}
      {:error, _} ->
        {:noreply,
          socket
          |> put_flash(:info, "We had a problem deleting this goal, please try again.")
          |> redirect(to: ~p"/my/goals")}
    end
  end
end
