defmodule IndiePaperWeb.ModalComponent do
  use IndiePaperWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div
      id={@id}
      class="fixed w-screen h-screen z-30 inset-0 bg-gray-600 bg-opacity-70 inset-x-0 bottom-0 md:inset-y-0 overflow-y-hidden flex flex-row items-end md:items-center justify-center"
      phx-capture-click="close"
      phx-window-keydown="close"
      phx-key="escape"
      phx-target={@myself}
      phx-page-loading>
      <div class="bg-white w-full md:w-auto max-h-3/4 md:inline-block rounded-t-xl md:rounded-xl overflow-hidden overflow-y-scroll max-w-6xl relative">
        <div class="w-full flex flex-row items-end justify-end p-4 border-b border-primary-border rounded-t-xl bg-background sticky top-0">
        <%= live_patch to: @return_to, class: "border rounded-full border-primary-border bg-white p-2 hover:bg-primary hover:text-white" do %>
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
        <% end %>
        </div>
            <%= live_component @component, @opts %>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("close", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
