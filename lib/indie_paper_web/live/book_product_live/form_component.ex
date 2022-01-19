defmodule IndiePaperWeb.BookProductLive.FormComponent do
  use IndiePaperWeb, :live_component

  alias IndiePaper.Products

  @impl true
  def update(%{product: product} = assigns, socket) do
    changeset = Products.change_product(product)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(changeset: changeset, form_submit_error: false)}
  end

  @impl true
  def handle_event("save", %{"product" => product_params}, socket) do
    save_product(socket, socket.assigns.action, product_params)
  end

  def save_product(socket, :new, product_params) do
    case Products.create_product(socket.assigns.book, product_params) do
      {:ok, _product} ->
        {:noreply, socket |> push_redirect(to: Routes.dashboard_path(socket, :index))}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset, form_submit_error: true)}
    end
  end

  def save_product(socket, :edit, product_params) do
    case Products.update_product(
           socket.assigns.current_author,
           socket.assigns.product,
           product_params
         ) do
      {:ok, _updated_product} ->
        {:noreply, push_redirect(socket, to: Routes.dashboard_path(socket, :index))}

      {:error, changeset} ->
        {:noreply, socket |> assign(changeset: changeset, form_submit_error: true)}
    end
  end
end
