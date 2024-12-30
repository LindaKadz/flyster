defmodule Flyster.Mailer.SendEmail do
  @moduledoc """
   Mailer for sending emails
  """

  import Swoosh.Email

  alias Flyster.Mailer

  # Delivers the email using the application mailer.
  def deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({"My Cheza", "no-reply@mycheza.com"})
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end
end
