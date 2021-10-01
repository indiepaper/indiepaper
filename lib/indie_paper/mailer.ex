defmodule IndiePaper.Mailer do
  use Swoosh.Mailer, otp_app: :indie_paper

  defp email_domain() do
    domain_uri = URI.parse(IndiePaperWeb.Endpoint.url())

    case domain_uri.host do
      "dev.indiepaper.co" -> "indiepaper.co"
      "localhost" -> "example.com"
      _ -> domain_uri.host
    end
  end

  def from_email(), do: from_email("support")

  def from_email(from) do
    "#{from}@#{email_domain()}"
  end
end
