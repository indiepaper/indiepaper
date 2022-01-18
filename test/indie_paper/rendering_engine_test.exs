defmodule IndiePaper.TypesettingEngineTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.TypesettingEngine

  describe "to_latex!/1" do
    test "converts the book into a single latex file" do
      book = insert(:book)

      latex = TypesettingEngine.to_latex!(book)

      assert latex =~ book.title
      assert latex =~ book.author.first_name
    end
  end
end
