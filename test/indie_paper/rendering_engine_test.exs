defmodule IndiePaper.TipTapTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.RenderingEngine

  describe "to_latex!/1" do
    test "converts the book into a single latex file" do
      book = insert(:book)

      latex = RenderingEngine.to_latex!(book)

      assert latex =~ book.title
      assert latex =~ book.author.first_name
    end
  end
end
