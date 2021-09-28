defmodule IndiePaper.Mailer do
  use Swoosh.Mailer, otp_app: :indie_paper

  defp email_domain() do
    Application.get_env(:indie_paper, IndiePaper.Mailer)[:email_domain]
  end

  def from_email(), do: from_email("support")

  def from_email(from) do
    "#{from}@#{email_domain()}"
  end
end
