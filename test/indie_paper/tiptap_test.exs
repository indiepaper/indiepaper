defmodule IndiePaper.TipTapTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.TipTap

  describe "to_latex" do
    test "converts the given content_json to latex file" do
      chapter = insert(:chapter)

      {:ok, latex} = TipTap.to_latex(chapter.content_json)

      assert latex =~ "/begin"
    end
  end
end
