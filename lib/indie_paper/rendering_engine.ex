defmodule IndiePaper.RenderingEngine do
  alias IndiePaper.RenderingEngine.Latex
  alias IndiePaper.Books

  def to_latex!(%Books.Book{} = book) do
    book_with_author = Books.with_assoc(book, :author)
    Latex.render_latex(book_with_author)
  end
end
