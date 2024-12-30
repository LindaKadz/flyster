defmodule Flyster.Accounts.EventNotifier do
  @moduledoc """
   User Notifier for prepping emails to be sent
  """

  alias Flyster.Mailer.SendEmail

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    SendEmail.deliver(recipient, subject, body)
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_end_of_year_email(user, goal) do
    deliver(user.email, "Catch Up with your Dance Goals", """

    ==============================

    Hi #{user.first_name},

    You had amazing goals for your dance journey. As we end this year, we wanted to check in
    and confirm if you had achieved them. One of the goals was:

    `
    #{goal.description}
    `

    If you need a reminder of all the goals you wanted to achieve this year, please
    click on the link below to take you to them:

    https://www.mycheza.com/my/goals

    We understand that you may not remember the email you used to sign up, we got you. Email:
    #{user.email}, if you cannot remember your password you will need to reset it.

    Love,

    My Cheza ❤️
    """)
  end
end
