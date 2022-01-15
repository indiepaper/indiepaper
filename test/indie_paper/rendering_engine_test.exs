defmodule IndiePaper.TipTapTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.RenderingEngine

  describe "to_latex" do
    test "converts the given content_json to latex file" do
      chapter = insert(:chapter)

      latex = RenderingEngine.to_latex!(chapter.content_json)

      assert latex =~ "/begin"
    end
  end
end
