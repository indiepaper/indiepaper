defmodule IndiePaperWeb.AuthorAccountSetupLive do
  use IndiePaperWeb, :live_view

  alias IndiePaper.Authors

  @impl Phoenix.LiveView
  def mount(_params, %{"author_token" => author_token}, socket) do
    current_author = Authors.get_author_by_session_token(author_token)
    changeset = Authors.change_author_profile(current_author)

    {:ok,
     socket
     |> assign(:current_author, current_author)
     |> assign(:changeset, changeset)}
  end

  @impl Phoenix.LiveView
  def handle_event(
        "validate",
        %{"author" => author_params},
        %{assigns: %{current_author: current_author}} = socket
      ) do
    changeset =
      current_author
      |> Authors.change_author_profile(author_params)
      |> Map.put(:action, :validate)

    {:noreply, socket |> assign(:changeset, changeset)}
  end

  @impl Phoenix.LiveView
  def handle_event(
        "finish_profile_setup",
        %{"author" => author_params},
        %{assigns: %{current_author: current_author}} = socket
      ) do
    case Authors.update_author_profile(current_author, author_params) do
      {:ok, _author} ->
        socket = socket |> redirect(to: IndiePaperWeb.AuthorAuth.signed_in_path(socket))
        {:noreply, socket}

      {:error, _} ->
        {:noreply, socket}
    end
  end
end
