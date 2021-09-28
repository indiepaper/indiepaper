defmodule IndiePaper.Authors.OrderNotifier do
  import Swoosh.Email

  alias IndiePaper.Mailer

  def deliver_order_payment_completed_email(reader, author, book, book_read_url) do
    email =
      new()
      |> to(reader.email)
      |> from({"IndiePaper", "support@indiepaper.co"})
      |> subject("Thanks for buying at IndiePaper")
      |> text_body("""
      ==============================

      Heyy #{reader.email},

      Thanks for buying #{book.title} from #{author.email} on IndiePaper. You can read book online at #{book_read_url}.

      If you have any queries reply to this email and we'll take care of it.

      Thanking You for taking a chance with us,
      Team IndiePaper
      ==============================

      We're a small team of people building out a new platform for authors to self publish their books easily. You can find out more at https://indiepaper.me/why
      """)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end
end
