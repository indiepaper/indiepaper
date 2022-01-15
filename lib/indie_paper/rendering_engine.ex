defmodule IndiePaper.RenderingEngine do
  alias IndiePaper.RenderingEngine.Latex

  def to_latex!(content_json) do
    Latex.to_latex!(content_json)
  end
end
