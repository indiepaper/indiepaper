defmodule IndiePaper.TipTap do
  alias IndiePaper.TipTap.Latex

  def to_latex!(content_json) do
    Latex.to_latex!(content_json)
  end
end
