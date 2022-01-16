defmodule IndiePaper.RenderingEngine do
  alias IndiePaper.RenderingEngine.Latex
  alias IndiePaper.Books

  def to_latex!(%Books.Book{} = book) do
    book_with_author_chapters = Books.with_assoc(book, [:author, draft: :chapters])

    Latex.render_latex(
      book,
      book_with_author_chapters.author,
      book_with_author_chapters.draft.chapters
    )
  end
end
