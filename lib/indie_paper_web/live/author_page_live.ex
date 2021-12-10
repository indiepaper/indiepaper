defmodule IndiePaperWeb.AuthorPageLive do
  use IndiePaperWeb, :live_view

  on_mount {IndiePaperWeb.AuthorLiveAuth, :fetch_current_author}

  alias IndiePaper.Authors
  alias IndiePaper.Books
  alias IndiePaper.MembershipTiers
  alias IndiePaper.Subscriptions

  @impl true
  def mount(%{"username" => username}, _, socket) do
    case Authors.get_author_by_username(username) do
      nil ->
        {:ok,
         socket
         |> put_flash(:info, "The Author was not found, check the profile url.")
         |> redirect(to: "/")}

      author ->
        published_books = Books.get_published_books(author)
        membership_tiers = MembershipTiers.list_membership_tiers(author)

        {:ok,
         socket
         |> assign(
           author: author,
           books: published_books,
           membership_tiers: membership_tiers,
           page_title: IndiePaper.Authors.get_full_name(author)
         )}
    end
  end

  @impl true
  def handle_event(
        "subscribe",
        %{"membership_tier_id" => membership_tier},
        %{
          assigns: %{current_author: nil}
        } = socket
      ) do
    membership_tier = MembershipTiers.get_membership_tier!(membership_tier)
    author = Authors.get_author!(membership_tier.author_id)

    {:noreply,
     socket
     |> put_flash(
       :info,
       "Create an account or Sign in to subscribe to #{Authors.get_full_name(author)}."
     )
     |> redirect(to: Routes.author_registration_path(socket, :new))}
  end

  @impl true
  def handle_event(
        "subscribe",
        %{"membership_tier_id" => membership_tier_id},
        %{
          assigns: %{current_author: reader}
        } = socket
      ) do
    membership_tier = MembershipTiers.get_membership_tier!(membership_tier_id)

    case Subscriptions.create_subscription(reader, membership_tier) do
      {:ok, stripe_checkout_session_url} ->
        {:noreply, socket |> redirect(external: stripe_checkout_session_url)}

      {:error, message} ->
        author = Authors.get_author!(membership_tier.author_id)

        {:noreply,
         socket
         |> put_flash(:error, message)
         |> redirect(to: Routes.author_page_path(socket, :show, author))}
    end
  end
end
