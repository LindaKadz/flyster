defmodule FlysterWeb.MyGoalCommentDeleteLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Goals

  def mount(%{"id" => id}, _session, socket) do
    comment = Goals.get_comment!(id)

    case Goals.delete_comment(comment) do
      {:ok, _goal} ->
        {:ok,
          socket
          |> redirect(to: ~p"/goals")}
      {:error, _} ->
        {:noreply,
          socket
          |> put_flash(:info, "We had a problem deleting this goal, please try again.")
          |> redirect(to: ~p"/goals")}
    end
  end
end
