defmodule IndiePaper.Mailer do
  use Swoosh.Mailer, otp_app: :indie_paper

  defp email_domain() do
    domain_uri = URI.parse(IndiePaperWeb.Endpoint.url())
    domain_uri.host
  end

  def from_email(), do: from_email("support")

  def from_email(from) do
    "#{from}@#{email_domain()}"
  end
end
