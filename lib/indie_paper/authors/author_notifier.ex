defmodule IndiePaper.Authors.AuthorNotifier do
  import Swoosh.Email

  alias IndiePaper.Mailer

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({"MyApp", "contact@example.com"})
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(author, url) do
    deliver(author.email, "Confirmation instructions", """

    ==============================

    Hi #{author.email},

    You can confirm your account by visiting the URL below:

    #{url}

    If you didn't create an account with us, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to reset a author password.
  """
  def deliver_reset_password_instructions(author, url) do
    deliver(author.email, "Reset password instructions", """

    ==============================

    Hi #{author.email},

    You can reset your password by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to update a author email.
  """
  def deliver_update_email_instructions(author, url) do
    deliver(author.email, "Update email instructions", """

    ==============================

    Hi #{author.email},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end
end
