defmodule IndiePaper.TipTap.Latex do
  def to_latex(content_json) do
    """
    Test Latex things
    #{parse(content_json)}
    """
    |> IO.puts()
  end

  def parse([head | []]) do
    """
    #{parse(head)}
    """
  end

  def parse([head | rest]) do
    """
    #{parse(head)}

    #{parse(rest)}
    """
  end

  def parse([]), do: ""

  def parse(%{"content" => content, "type" => "doc"}) do
    """
    doc start
    #{parse(content)}
    doc end
    """
  end

  def parse(%{"content" => content, "type" => "paragraph"}) do
    """
    p start
    #{parse(content)}
    p end
    """
  end

  def parse(%{"type" => "text", "text" => text}) do
    text
  end

  def parse(%{"type" => "heading", "content" => content, "attrs" => %{"level" => level}}) do
    """
    heading #{level} start
    #{parse(content)}
    heading #{level} end
    """
  end
end
