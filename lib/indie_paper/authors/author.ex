defmodule IndiePaper.Authors.Author do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Phoenix.Param, key: :username}
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "authors" do
    field :email, :string

    field :password, :string, virtual: true, redact: true
    field :hashed_password, :string, redact: true
    field :confirmed_at, :naive_datetime

    field :account_status, Ecto.Enum,
      values: [:created, :confirmed, :payment_connected, :suspended, :banned],
      default: :created,
      nil: false

    field :username, :string, null: false
    field :first_name, :string, null: false
    field :last_name, :string

    field :stripe_connect_id, :string
    field :is_payment_connected, :boolean, default: false
    field :stripe_customer_id, :string

    field :profile_picture, :string,
      null: false,
      default: "public/profile_pictures/placeholder.png"

    has_many :books, IndiePaper.Books.Book, preload_order: [desc: :updated_at]
    has_many :orders, IndiePaper.Orders.Order, foreign_key: :reader_id

    timestamps()
  end

  @doc """
  A author changeset for registration.

  It is important to validate the length of both email and password.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def registration_changeset(author, attrs, opts \\ []) do
    author
    |> cast(attrs, [:email, :password])
    |> validate_email()
    |> validate_password(opts)
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, IndiePaper.Repo)
    |> unique_constraint(:email)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 12, max: 80)
    # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  @doc """
  A author changeset for changing the email.

  It requires the email to change otherwise an error is added.
  """
  def email_changeset(author, attrs) do
    author
    |> cast(attrs, [:email])
    |> validate_email()
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "did not change")
    end
  end

  @doc """
  A author changeset for changing the password.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def password_changeset(author, attrs, opts \\ []) do
    author
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password(opts)
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(author) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    change(author, confirmed_at: now, account_status: :confirmed)
  end

  @doc """
  Verifies the password.

  If there is no author or the author doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%IndiePaper.Authors.Author{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end

  def internal_profile_changeset(author, attrs) do
    author
    |> cast(attrs, [
      :stripe_connect_id,
      :stripe_customer_id,
      :is_payment_connected,
      :account_status
    ])
    |> unique_constraint([:stripe_connect_id])
    |> unique_constraint([:stripe_customer_id])
  end

  def profile_changeset(author, attrs) do
    author
    |> cast(attrs, [:username, :first_name, :last_name, :profile_picture])
    |> validate_required([:username, :first_name])
    |> validate_length(:username, min: 3, max: 32)
    |> validate_format(:username, ~r/^[a-zA-Z0-9\_\-]+$/)
    |> update_change(:username, &String.downcase/1)
    |> validate_length(:first_name, max: 128)
    |> validate_length(:last_name, max: 128)
    |> unsafe_validate_unique(:username, IndiePaper.Repo)
    |> unique_constraint(:username)
  end
end
