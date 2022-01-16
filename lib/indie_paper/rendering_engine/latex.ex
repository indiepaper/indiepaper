defmodule IndiePaper.RenderingEngine.Latex do
  require EEx

  alias IndiePaper.Authors
  alias IndiePaper.Chapters

  EEx.function_from_file(
    :def,
    :render_latex,
    Path.expand("./latex_template.tex.eex", __DIR__),
    [:book, :author, :chapters]
  )

  def convert_chapters(%Chapters.Chapter{
        published_content_json: published_content_json,
        title: title
      }) do
    chapter_title =
      cond do
        title in ["Introduction", "Preface"] ->
          """
          \\chapter*{#{title}}
          \\addcontentsline{toc}{chapter}{\\protect\\numberline{~}#{title}}
          """

        true ->
          """
          \\chapter{#{title}}
          """
      end

    """
    #{chapter_title}

    #{convert(published_content_json)}
    """
  end

  def convert_chapters([chapter | []]) do
    """
    #{convert_chapters(chapter)}
    """
  end

  def convert_chapters([chapter | rest]) do
    """
    #{convert_chapters(chapter)}

    #{convert_chapters(rest)}
    """
  end

  def convert_chapters([]), do: ""

  def convert([head | []]) do
    "#{convert(head)}"
  end

  def convert([head | rest]) do
    """
    #{convert(head)} #{convert(rest)}
    """
  end

  def convert([]), do: ""

  def convert(%{"marks" => [mark | []]} = content) do
    parse_mark(mark, convert(Map.delete(content, "marks")))
  end

  def convert(%{"marks" => [mark | rest]} = content) do
    parse_mark(mark, convert(Map.put(content, "marks", rest)))
  end

  def convert(%{"type" => "doc", "content" => content}) do
    """
    #{convert(content)}
    """
  end

  def convert(%{"type" => "bulletList", "content" => content}) do
    """
    \\begin{itemize}
    #{convert(content)}
    \\end{itemize}
    """
  end

  def convert(%{"type" => "listItem", "content" => content}) do
    """
    \\item #{convert(content)}
    """
  end

  def convert(%{"type" => "paragraph", "content" => content}) do
    """
    \\par
    #{convert(content)}
    """
  end

  def convert(%{"type" => "paragraph"}) do
    ""
  end

  def convert(%{"type" => "hardBreak"}) do
    "\n"
  end

  def convert(%{"type" => "horizontalRule"}) do
    "\\par\\noindent\\rule{\\textwidth}{0.4pt}"
  end

  def convert(%{"type" => "text", "text" => text}) do
    text
  end

  def convert(%{"type" => "heading", "content" => content, "attrs" => %{"level" => level}}) do
    case level do
      1 -> "\\section*{#{convert(content)}}"
      2 -> "\\subsection*{#{convert(content)}}"
      _ -> "\\subsubsection*{#{convert(content)}}"
    end
  end

  def parse_mark(%{"type" => "link", "attrs" => %{"href" => href}}, text) do
    "\\href{#{href}}{#{text}}"
  end

  def parse_mark(%{"type" => "bold"}, text) do
    "\\textbf{#{text}}"
  end

  def parse_mark(%{"type" => "italic"}, text) do
    "\\emph{#{text}}"
  end
end
