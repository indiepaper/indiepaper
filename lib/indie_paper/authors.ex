defmodule IndiePaper.Authors do
  @moduledoc """
  The Authors context.
  """

  import Ecto.Query, warn: false
  alias IndiePaper.Repo

  alias IndiePaper.Authors.{Author, AuthorToken, AuthorNotifier}
  alias IndiePaper.AuthorProfile
  alias IndiePaper.ExternalAssetHandler

  ## Database getters

  @doc """
  Gets a author by email.

  ## Examples

      iex> get_author_by_email("foo@example.com")
      %Author{}

      iex> get_author_by_email("unknown@example.com")
      nil

  """
  def get_author_by_email(email) when is_binary(email) do
    Repo.get_by(Author, email: email)
  end

  def get_author_by_username(username) when is_binary(username) do
    Repo.get_by(Author, username: username)
  end

  @doc """
  Gets a author by email and password.

  ## Examples

      iex> get_author_by_email_and_password("foo@example.com", "correct_password")
      %Author{}

      iex> get_author_by_email_and_password("foo@example.com", "invalid_password")
      nil

  """
  def get_author_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    author = Repo.get_by(Author, email: email)
    if Author.valid_password?(author, password), do: author
  end

  @doc """
  Gets a single author.

  Raises `Ecto.NoResultsError` if the Author does not exist.

  ## Examples

      iex> get_author!(123)
      %Author{}

      iex> get_author!(456)
      ** (Ecto.NoResultsError)

  """
  def get_author!(id), do: Repo.get!(Author, id)

  ## Author registration

  @doc """
  Registers a author.

  ## Examples

      iex> register_author(%{field: value})
      {:ok, %Author{}}

      iex> register_author(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_author(attrs) do
    %Author{}
    |> Author.registration_changeset(attrs)
    |> AuthorProfile.default_profile_changeset(attrs["email"])
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking author changes.

  ## Examples

      iex> change_author_registration(author)
      %Ecto.Changeset{data: %Author{}}

  """
  def change_author_registration(%Author{} = author, attrs \\ %{}) do
    Author.registration_changeset(author, attrs, hash_password: false)
  end

  ## Settings

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the author email.

  ## Examples

      iex> change_author_email(author)
      %Ecto.Changeset{data: %Author{}}

  """
  def change_author_email(author, attrs \\ %{}) do
    Author.email_changeset(author, attrs)
  end

  @doc """
  Emulates that the email will change without actually changing
  it in the database.

  ## Examples

      iex> apply_author_email(author, "valid password", %{email: ...})
      {:ok, %Author{}}

      iex> apply_author_email(author, "invalid password", %{email: ...})
      {:error, %Ecto.Changeset{}}

  """
  def apply_author_email(author, password, attrs) do
    author
    |> Author.email_changeset(attrs)
    |> Author.validate_current_password(password)
    |> Ecto.Changeset.apply_action(:update)
  end

  @doc """
  Updates the author email using the given token.

  If the token matches, the author email is updated and the token is deleted.
  The confirmed_at date is also updated to the current time.
  """
  def update_author_email(author, token) do
    context = "change:#{author.email}"

    with {:ok, query} <- AuthorToken.verify_change_email_token_query(token, context),
         %AuthorToken{sent_to: email} <- Repo.one(query),
         {:ok, _} <- Repo.transaction(author_email_multi(author, email, context)) do
      :ok
    else
      _ -> :error
    end
  end

  defp author_email_multi(author, email, context) do
    changeset = author |> Author.email_changeset(%{email: email}) |> Author.confirm_changeset()

    Ecto.Multi.new()
    |> Ecto.Multi.update(:author, changeset)
    |> Ecto.Multi.delete_all(:tokens, AuthorToken.author_and_contexts_query(author, [context]))
  end

  @doc """
  Delivers the update email instructions to the given author.

  ## Examples

      iex> deliver_update_email_instructions(author, current_email, &Routes.author_update_email_url(conn, :edit, &1))
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_update_email_instructions(%Author{} = author, current_email, update_email_url_fun)
      when is_function(update_email_url_fun, 1) do
    {encoded_token, author_token} =
      AuthorToken.build_email_token(author, "change:#{current_email}")

    Repo.insert!(author_token)
    AuthorNotifier.deliver_update_email_instructions(author, update_email_url_fun.(encoded_token))
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the author password.

  ## Examples

      iex> change_author_password(author)
      %Ecto.Changeset{data: %Author{}}

  """
  def change_author_password(author, attrs \\ %{}) do
    Author.password_changeset(author, attrs, hash_password: false)
  end

  @doc """
  Updates the author password.

  ## Examples

      iex> update_author_password(author, "valid password", %{password: ...})
      {:ok, %Author{}}

      iex> update_author_password(author, "invalid password", %{password: ...})
      {:error, %Ecto.Changeset{}}

  """
  def update_author_password(author, password, attrs) do
    changeset =
      author
      |> Author.password_changeset(attrs)
      |> Author.validate_current_password(password)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:author, changeset)
    |> Ecto.Multi.delete_all(:tokens, AuthorToken.author_and_contexts_query(author, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{author: author}} -> {:ok, author}
      {:error, :author, changeset, _} -> {:error, changeset}
    end
  end

  ## Session

  @doc """
  Generates a session token.
  """
  def generate_author_session_token(author) do
    {token, author_token} = AuthorToken.build_session_token(author)
    Repo.insert!(author_token)
    token
  end

  @doc """
  Gets the author with the given signed token.
  """
  def get_author_by_session_token(token) do
    {:ok, query} = AuthorToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_session_token(token) do
    Repo.delete_all(AuthorToken.token_and_context_query(token, "session"))
    :ok
  end

  ## Confirmation

  @doc """
  Delivers the confirmation email instructions to the given author.

  ## Examples

      iex> deliver_author_confirmation_instructions(author, &Routes.author_confirmation_url(conn, :edit, &1))
      {:ok, %{to: ..., body: ...}}

      iex> deliver_author_confirmation_instructions(confirmed_author, &Routes.author_confirmation_url(conn, :edit, &1))
      {:error, :already_confirmed}

  """
  def deliver_author_confirmation_instructions(%Author{} = author, confirmation_url_fun)
      when is_function(confirmation_url_fun, 1) do
    if author.confirmed_at do
      {:error, :already_confirmed}
    else
      {encoded_token, author_token} = AuthorToken.build_email_token(author, "confirm")
      Repo.insert!(author_token)

      AuthorNotifier.deliver_confirmation_instructions(
        author,
        confirmation_url_fun.(encoded_token)
      )
    end
  end

  @doc """
  Confirms a author by the given token.

  If the token matches, the author account is marked as confirmed
  and the token is deleted.
  """
  def confirm_author(token) do
    with {:ok, query} <- AuthorToken.verify_email_token_query(token, "confirm"),
         %Author{} = author <- Repo.one(query),
         {:ok, %{author: author}} <- Repo.transaction(confirm_author_multi(author)) do
      {:ok, author}
    else
      _ -> :error
    end
  end

  defp confirm_author_multi(author) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:author, Author.confirm_changeset(author))
    |> Ecto.Multi.delete_all(:tokens, AuthorToken.author_and_contexts_query(author, ["confirm"]))
  end

  ## Reset password

  @doc """
  Delivers the reset password email to the given author.

  ## Examples

      iex> deliver_author_reset_password_instructions(author, &Routes.author_reset_password_url(conn, :edit, &1))
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_author_reset_password_instructions(%Author{} = author, reset_password_url_fun)
      when is_function(reset_password_url_fun, 1) do
    {encoded_token, author_token} = AuthorToken.build_email_token(author, "reset_password")
    Repo.insert!(author_token)

    AuthorNotifier.deliver_reset_password_instructions(
      author,
      reset_password_url_fun.(encoded_token)
    )
  end

  @doc """
  Gets the author by reset password token.

  ## Examples

      iex> get_author_by_reset_password_token("validtoken")
      %Author{}

      iex> get_author_by_reset_password_token("invalidtoken")
      nil

  """
  def get_author_by_reset_password_token(token) do
    with {:ok, query} <- AuthorToken.verify_email_token_query(token, "reset_password"),
         %Author{} = author <- Repo.one(query) do
      author
    else
      _ -> nil
    end
  end

  @doc """
  Resets the author password.

  ## Examples

      iex> reset_author_password(author, %{password: "new long password", password_confirmation: "new long password"})
      {:ok, %Author{}}

      iex> reset_author_password(author, %{password: "valid", password_confirmation: "not the same"})
      {:error, %Ecto.Changeset{}}

  """
  def reset_author_password(author, attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:author, Author.password_changeset(author, attrs))
    |> Ecto.Multi.delete_all(:tokens, AuthorToken.author_and_contexts_query(author, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{author: author}} -> {:ok, author}
      {:error, :author, changeset, _} -> {:error, changeset}
    end
  end

  # For OAuth author may or may not be present in database when signing in
  def fetch_or_create_author(attrs) do
    case get_author_by_email(attrs.email) do
      %Author{} = author ->
        {:ok, author}

      _ ->
        %Author{}
        |> Author.registration_changeset(attrs)
        |> AuthorProfile.default_profile_changeset(attrs.email)
        |> Author.confirm_changeset()
        |> Repo.insert()
    end
  end

  def update_author_internal_profile(author, attrs) do
    author
    |> Author.internal_profile_changeset(attrs)
    |> Repo.update()
  end

  def has_stripe_connect_id?(%Author{stripe_connect_id: nil}), do: false
  def has_stripe_connect_id?(%Author{stripe_connect_id: _}), do: true

  def get_by_stripe_connect_id!(stripe_connect_id) do
    Repo.get_by!(Author, stripe_connect_id: stripe_connect_id)
  end

  def set_stripe_connect_id(author, stripe_connect_id) do
    author
    |> update_author_internal_profile(%{stripe_connect_id: stripe_connect_id})
  end

  def set_payment_connected(author) do
    update_author_internal_profile(author, %{
      is_payment_connected: true,
      account_status: :payment_connected
    })
  end

  def set_stripe_customer_id(reader, stripe_customer_id) do
    update_author_internal_profile(reader, %{
      stripe_customer_id: stripe_customer_id
    })
  end

  def is_payment_connected?(author) do
    author.is_payment_connected
  end

  def is_confirmed?(%{account_status: :confirmed}), do: true
  def is_confirmed?(_), do: false

  def is_created?(%{account_status: :created}), do: true
  def is_created?(_), do: false

  def get_full_name(author) do
    "#{author.first_name} #{author.last_name}"
  end

  def is_same?(%{id: id}, %{id: id}), do: true
  def is_same?(_, _), do: false

  def get_profile_picture_url(author) do
    ExternalAssetHandler.get_public_url(author.profile_picture)
  end
end
