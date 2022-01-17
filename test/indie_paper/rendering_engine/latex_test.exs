defmodule IndiePaper.TypesettingEngine.LatexTest do
  use IndiePaper.DataCase, async: true

  alias IndiePaper.TypesettingEngine.Latex

  describe "convert/1" do
    test "correctly parses link" do
      latex =
        Latex.convert(%{
          "marks" => [
            %{
              "attrs" => %{
                "href" =>
                  "http://localhost:4000/drafts/e4a570d3-9203-4d38-afff-418d4c125cc2/edit",
                "target" => "_blank"
              },
              "type" => "link"
            }
          ],
          "text" => "http://localhost:4000/drafts/e4a570d3-9203-4d38-afff-418d4c125cc2/edit",
          "type" => "text"
        })

      assert latex ==
               "\\href{http://localhost:4000/drafts/e4a570d3-9203-4d38-afff-418d4c125cc2/edit}{http://localhost:4000/drafts/e4a570d3-9203-4d38-afff-418d4c125cc2/edit}"
    end
  end

  describe "render_latex/3" do
    test "returns latex" do
      content_json = %{
        "content" => [
          %{
            "attrs" => %{"level" => 1},
            "content" => [%{"text" => "Introduction", "type" => "text"}],
            "type" => "heading"
          },
          %{
            "content" => [%{"text" => "Paragraph Test", "type" => "text"}],
            "type" => "paragraph"
          },
          %{
            "content" => [
              %{"marks" => [%{"type" => "bold"}], "text" => "Bold Test", "type" => "text"}
            ],
            "type" => "paragraph"
          },
          %{
            "content" => [
              %{"marks" => [%{"type" => "italic"}], "text" => "Italic Test", "type" => "text"}
            ],
            "type" => "paragraph"
          },
          %{
            "content" => [
              %{
                "marks" => [%{"type" => "bold"}, %{"type" => "italic"}],
                "text" => "Bold Italic Test",
                "type" => "text"
              }
            ],
            "type" => "paragraph"
          },
          %{
            "attrs" => %{"level" => 1},
            "content" => [%{"text" => "H1 Test", "type" => "text"}],
            "type" => "heading"
          },
          %{
            "attrs" => %{"level" => 2},
            "content" => [%{"text" => "H2 Test", "type" => "text"}],
            "type" => "heading"
          },
          %{
            "attrs" => %{"level" => 3},
            "content" => [%{"text" => "H3 Test", "type" => "text"}],
            "type" => "heading"
          },
          %{"type" => "paragraph"},
          %{
            "content" => [
              %{"marks" => [%{"type" => "bold"}], "text" => "Heading Bold Test", "type" => "text"}
            ],
            "type" => "paragraph"
          },
          %{
            "content" => [
              %{
                "marks" => [%{"type" => "italic"}],
                "text" => "Heading Italic Test",
                "type" => "text"
              }
            ],
            "type" => "paragraph"
          },
          %{
            "content" => [
              %{
                "marks" => [%{"type" => "bold"}, %{"type" => "italic"}],
                "text" => "Heading Bold Italic Test",
                "type" => "text"
              }
            ],
            "type" => "paragraph"
          },
          %{"type" => "paragraph"},
          %{
            "content" => [
              %{
                "marks" => [
                  %{
                    "attrs" => %{
                      "href" =>
                        "http://localhost:4000/drafts/e4a570d3-9203-4d38-afff-418d4c125cc2/edit",
                      "target" => "_blank"
                    },
                    "type" => "link"
                  }
                ],
                "text" =>
                  "http://localhost:4000/drafts/e4a570d3-9203-4d38-afff-418d4c125cc2/edit",
                "type" => "text"
              }
            ],
            "type" => "paragraph"
          },
          %{
            "content" => [
              %{
                "marks" => [
                  %{
                    "attrs" => %{
                      "href" =>
                        "http://localhost:4000/drafts/e4a570d3-9203-4d38-afff-418d4c125cc2/edit",
                      "target" => "_blank"
                    },
                    "type" => "link"
                  },
                  %{"type" => "italic"}
                ],
                "text" =>
                  "http://localhost:4000/drafts/e4a570d3-9203-4d38-afff-418d4c125cc2/edit",
                "type" => "text"
              }
            ],
            "type" => "paragraph"
          },
          %{
            "content" => [
              %{
                "marks" => [
                  %{
                    "attrs" => %{
                      "href" =>
                        "http://localhost:4000/drafts/e4a570d3-9203-4d38-afff-418d4c125cc2/edit",
                      "target" => "_blank"
                    },
                    "type" => "link"
                  },
                  %{"type" => "bold"}
                ],
                "text" =>
                  "http://localhost:4000/drafts/e4a570d3-9203-4d38-afff-418d4c125cc2/edit",
                "type" => "text"
              }
            ],
            "type" => "paragraph"
          }
        ],
        "type" => "doc"
      }

      latex = Latex.convert(content_json)

      assert latex
    end
  end
end
