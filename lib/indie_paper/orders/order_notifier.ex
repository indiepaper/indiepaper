defmodule IndiePaper.Orders.OrderNotifier do
  import Swoosh.Email

  alias IndiePaper.Mailer
  alias IndiePaperWeb.Router.Helpers, as: Routes
  alias IndiePaperWeb.Endpoint

  def deliver_order_payment_completed_email(
        reader: reader,
        author: author,
        book: book
      ) do
    email =
      new()
      |> to(reader.email)
      |> from({"IndiePaper", "support@" <> Endpoint.url()})
      |> subject("Thanks for buying at IndiePaper")
      |> text_body("""
      ==============================

      Heyy #{reader.email},

      Thanks for buying #{book.title} from #{author.email} on IndiePaper. You can read book online at #{Routes.book_read_url(Endpoint, :index, book)}.

      If you have any queries reply to this email and we'll take care of it.

      Thanking You for taking a chance with us,
      Team IndiePaper
      ==============================

      We're a small team of people building out a new platform for authors to self publish their books easily. You can find out more at https://indiepaper.me
      """)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end
end
