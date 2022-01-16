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
    """
    \\chapter{#{title}}

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
    #{convert(head)}#{convert(rest)}
    """
  end

  def convert([]), do: ""

  def convert(%{"type" => "doc", "content" => content}) do
    """
    #{convert(content)}
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

  def convert(%{"type" => "text", "text" => text}) do
    text
  end

  def convert(%{"type" => "heading", "content" => content, "attrs" => %{"level" => _level}}) do
    """
    \\section*{#{convert(content)}}
    """
  end
end
