defmodule FlysterWeb.MyChallengesDeleteLive do
  use FlysterWeb, :live_view

  alias Flyster.Context.Challenges

  def mount(%{"id" => id}, _session, socket) do
    challenge = Challenges.get_challenge!(id)

    case Challenges.delete_challenge(challenge) do
      {:ok, challenge} ->
        {:ok,
          socket
          |> put_flash(:info, "#{challenge.category} has been successfully deleted.")
          |> redirect(to: ~p"/my/challenges")}
      {:error, _} ->
        {:noreply,
          socket
          |> put_flash(:info, "We had a problem deleting this challenge, please try again.")
          |> redirect(to: ~p"/my/challenges")}
    end
  end
end
