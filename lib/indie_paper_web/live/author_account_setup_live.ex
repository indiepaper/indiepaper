defmodule IndiePaperWeb.AuthorAccountSetupLive do
  use IndiePaperWeb, :live_view

  alias IndiePaper.Authors

  @impl Phoenix.LiveView
  def mount(_params, %{"author_token" => author_token}, socket) do
    current_author = Authors.get_author_by_session_token(author_token)
    changeset = Authors.change_account_setup(current_author)

    {:ok,
     socket
     |> assign(:current_author, current_author)
     |> assign(:changeset, changeset)}
  end
end
