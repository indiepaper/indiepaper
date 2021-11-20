defmodule IndiePaper.AuthorProfile do
  alias IndiePaper.Repo
  alias IndiePaper.Authors.Author

  def change_profile(author, attrs \\ %{}) do
    Author.profile_changeset(author, attrs)
  end

  def update_profile(author, params) do
    author
    |> Author.profile_changeset(params)
    |> Repo.update()
  end

  def default_profile_changeset(author, nil) do
    default_profile_changeset(author, generate_random_username())
  end

  def default_profile_changeset(author, email) do
    name_from_email = String.split(email, "@") |> Enum.at(0) |> String.capitalize()

    author
    |> Author.profile_changeset(%{
      "username" => generate_random_username(),
      "first_name" => name_from_email
    })
  end

  def generate_random_username do
    base_username =
      IndiePaper.Utils.username_matrix()
      |> Enum.map(fn names -> Enum.random(names) end)
      |> Enum.join("-")

    salt =
      :crypto.strong_rand_bytes(4)
      |> Base.url_encode64()
      |> binary_part(0, 4)
      |> String.downcase()

    "#{base_username}-#{salt}"
  end
end
