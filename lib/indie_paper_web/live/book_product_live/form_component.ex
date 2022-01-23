defmodule IndiePaperWeb.BookProductLive.FormComponent do
  use IndiePaperWeb, :live_component

  alias IndiePaper.Products
  alias IndiePaper.Books

  @impl true
  def update(%{product: product, book: book} = assigns, socket) do
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
    IO.inspect(product_params)

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

  def assets_select(assigns) do
    existing_ids =
      assigns.changeset |> Ecto.Changeset.get_change(:assets, []) |> Enum.map(& &1.data.id)

    assets = Books.get_assets(assigns.book)

    ~H"""
    <div class="flex flex-row items-center mt-2 space-x-4">
        <%= for asset <- assets do %>
            <label>
                <input id={asset.id} type="checkbox" name="product[asset_ids][]" value={asset.id} checked={asset.id in existing_ids} />
                <%= asset.title %>
            </label>
        <% end %>
    </div>
    """
  end

  def submit_text(:new), do: "Create product"
  def submit_text(:edit), do: "Update product"
end
