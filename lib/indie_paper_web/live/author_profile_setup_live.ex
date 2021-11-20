defmodule IndiePaperWeb.AuthorProfileSetupLive do
  use IndiePaperWeb, :live_view

  on_mount IndiePaperWeb.AuthorLiveAuth

  alias IndiePaper.AuthorProfile

  @impl Phoenix.LiveView
  def mount(_params, _, socket) do
    changeset = AuthorProfile.change_profile(socket.assigns.current_author)

    {:ok,
     socket
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
      |> AuthorProfile.change_profile(author_params)
      |> Map.put(:action, :validate)

    {:noreply, socket |> assign(:changeset, changeset)}
  end

  @impl Phoenix.LiveView
  def handle_event(
        "finish_profile_setup",
        %{"author" => author_params},
        %{assigns: %{current_author: current_author}} = socket
      ) do
    case AuthorProfile.update_profile(current_author, author_params) do
      {:ok, _author} ->
        socket = socket |> redirect(to: IndiePaperWeb.AuthorAuth.signed_in_path(socket))
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, socket |> assign(:changeset, changeset)}
    end
  end
end
