defmodule IndiePaperWeb.ProductView do
  use IndiePaperWeb, :view

  def comment(assigns) do
    ~H"""
    <%= raw("<!--") %><%= render_block(@inner_block) %><%= raw("-->") %>
    """
  end
end
