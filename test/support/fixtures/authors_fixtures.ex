defmodule IndiePaper.AuthorsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `IndiePaper.Authors` context.
  """

  def unique_author_email, do: "author#{System.unique_integer()}@example.com"
  def valid_author_password, do: "hello world!"

  def valid_author_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_author_email(),
      password: valid_author_password()
    })
  end

  def author_fixture(attrs \\ %{}) do
    {:ok, author} =
      attrs
      |> valid_author_attributes()
      |> IndiePaper.Authors.register_author()

    author
  end

  def extract_author_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
