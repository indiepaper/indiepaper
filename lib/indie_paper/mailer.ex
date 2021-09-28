defmodule IndiePaper.Mailer do
  use Swoosh.Mailer, otp_app: :indie_paper

  defp email_domain() do
    case Domainatrex.parse(IndiePaperWeb.Endpoint.url()) do
      {:ok, %{domain: domain, tld: tld}} ->
        "#{domain}.#{tld}"

      {:error, _} ->
        "example.com"
    end
  end

  def from_email(), do: from_email("support")

  def from_email(from) do
    "#{from}@#{email_domain()}"
  end
end
