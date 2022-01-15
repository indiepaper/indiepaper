defmodule IndiePaper.RenderingEngine.LatexTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.RenderingEngine.Latex

  describe "to_latex!/1" do
    test "converts the given content_json to latex file" do
      chapter = insert(:chapter)

      latex = Latex.to_latex!(chapter.content_json)

      assert latex =~ "/begin"
    end
  end
end
