defmodule FlysterWeb.MyGoalsEditLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Goals

  def mount(%{"id" => id}, _session, socket) do
    goal = Goals.get_goal!(id)

    {status, _} = Goals.apply_goal_changes(goal, %{"accomplished" => true})

    if status == :ok do
      {:ok,
        socket
        |> put_flash(:info, "Goal completed! Congratulations  🎉")
        |> redirect(to: ~p"/my/goals")}
    else
      {:ok,
        socket
        |> put_flash(:info, "Problem marking goal as completed, please try again")
        |> redirect(to: ~p"/my/goals")}
    end
  end
end
