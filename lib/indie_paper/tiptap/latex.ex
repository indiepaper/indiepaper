defmodule IndiePaper.TipTap.Latex do
  def to_latex(content_json) do
    """
    Test Latex things
    #{convert(content_json)}
    """
    |> IO.puts()
  end

  def convert([head | []]) do
    """
    #{convert(head)}
    """
  end

  def convert([head | rest]) do
    """
    #{convert(head)}

    #{convert(rest)}
    """
  end

  def convert([]), do: ""

  def convert(%{"content" => content, "type" => "doc"}) do
    """
    doc start
    #{convert(content)}
    doc end
    """
  end

  def convert(%{"content" => content, "type" => "paragraph"}) do
    """
    p start
    #{convert(content)}
    p end
    """
  end

  def convert(%{"type" => "text", "text" => text}) do
    text
  end

  def convert(%{"type" => "heading", "content" => content, "attrs" => %{"level" => level}}) do
    """
    heading #{level} start
    #{convert(content)}
    heading #{level} end
    """
  end
end
