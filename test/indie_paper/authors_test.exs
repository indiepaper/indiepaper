defmodule IndiePaper.AuthorsTest do
  use IndiePaper.DataCase

  alias IndiePaper.Authors

  import IndiePaper.AuthorsFixtures
  alias IndiePaper.Authors.{Author, AuthorToken}

  describe "get_author_by_email/1" do
    test "does not return the author if the email does not exist" do
      refute Authors.get_author_by_email("unknown@example.com")
    end

    test "returns the author if the email exists" do
      %{id: id} = author = author_fixture()
      assert %Author{id: ^id} = Authors.get_author_by_email(author.email)
    end
  end

  describe "get_author_by_email_and_password/2" do
    test "does not return the author if the email does not exist" do
      refute Authors.get_author_by_email_and_password("unknown@example.com", "hello world!")
    end

    test "does not return the author if the password is not valid" do
      author = author_fixture()
      refute Authors.get_author_by_email_and_password(author.email, "invalid")
    end

    test "returns the author if the email and password are valid" do
      %{id: id} = author = author_fixture()

      assert %Author{id: ^id} =
               Authors.get_author_by_email_and_password(author.email, valid_author_password())
    end
  end

  describe "get_author!/1" do
    test "raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        Authors.get_author!("11111111-1111-1111-1111-111111111111")
      end
    end

    test "returns the author with the given id" do
      %{id: id} = author = author_fixture()
      assert %Author{id: ^id} = Authors.get_author!(author.id)
    end
  end

  describe "register_author/1" do
    test "requires email and password to be set" do
      {:error, changeset} = Authors.register_author(%{})

      assert %{
               password: ["can't be blank"],
               email: ["can't be blank"]
             } = errors_on(changeset)
    end

    test "validates email and password when given" do
      {:error, changeset} = Authors.register_author(%{email: "not valid", password: "not valid"})

      assert %{
               email: ["must have the @ sign and no spaces"],
               password: ["should be at least 12 character(s)"]
             } = errors_on(changeset)
    end

    test "validates maximum values for email and password for security" do
      too_long = String.duplicate("db", 100)
      {:error, changeset} = Authors.register_author(%{email: too_long, password: too_long})
      assert "should be at most 160 character(s)" in errors_on(changeset).email
      assert "should be at most 80 character(s)" in errors_on(changeset).password
    end

    test "validates email uniqueness" do
      %{email: email} = author_fixture()
      {:error, changeset} = Authors.register_author(%{email: email})
      assert "has already been taken" in errors_on(changeset).email

      # Now try with the upper cased email too, to check that email case is ignored.
      {:error, changeset} = Authors.register_author(%{email: String.upcase(email)})
      assert "has already been taken" in errors_on(changeset).email
    end

    test "registers authors with a hashed password" do
      email = unique_author_email()
      {:ok, author} = Authors.register_author(valid_author_attributes(email: email))
      assert author.email == email
      assert is_binary(author.hashed_password)
      assert is_nil(author.confirmed_at)
      assert is_nil(author.password)
    end

    test "registered author has account status as created" do
      email = unique_author_email()
      {:ok, author} = Authors.register_author(valid_author_attributes(email: email))

      assert author.account_status == :created
    end

    test "sets the username and first_name field from the given email" do
      author_params =
        params_for(:author, email: "testauthor@gmail.com", username: nil, first_name: nil)

      {:ok, author} = Authors.register_author(author_params)

      assert author.username
      assert author.first_name
    end
  end

  describe "change_author_registration/2" do
    test "returns a changeset" do
      assert %Ecto.Changeset{} = changeset = Authors.change_author_registration(%Author{})
      assert changeset.required == [:password, :email]
    end

    test "allows fields to be set" do
      email = unique_author_email()
      password = valid_author_password()

      changeset =
        Authors.change_author_registration(
          %Author{},
          valid_author_attributes(email: email, password: password)
        )

      assert changeset.valid?
      assert get_change(changeset, :email) == email
      assert get_change(changeset, :password) == password
      assert is_nil(get_change(changeset, :hashed_password))
    end
  end

  describe "change_author_email/2" do
    test "returns a author changeset" do
      assert %Ecto.Changeset{} = changeset = Authors.change_author_email(%Author{})
      assert changeset.required == [:email]
    end
  end

  describe "apply_author_email/3" do
    setup do
      %{author: author_fixture()}
    end

    test "requires email to change", %{author: author} do
      {:error, changeset} = Authors.apply_author_email(author, valid_author_password(), %{})
      assert %{email: ["did not change"]} = errors_on(changeset)
    end

    test "validates email", %{author: author} do
      {:error, changeset} =
        Authors.apply_author_email(author, valid_author_password(), %{email: "not valid"})

      assert %{email: ["must have the @ sign and no spaces"]} = errors_on(changeset)
    end

    test "validates maximum value for email for security", %{author: author} do
      too_long = String.duplicate("db", 100)

      {:error, changeset} =
        Authors.apply_author_email(author, valid_author_password(), %{email: too_long})

      assert "should be at most 160 character(s)" in errors_on(changeset).email
    end

    test "validates email uniqueness", %{author: author} do
      %{email: email} = author_fixture()

      {:error, changeset} =
        Authors.apply_author_email(author, valid_author_password(), %{email: email})

      assert "has already been taken" in errors_on(changeset).email
    end

    test "validates current password", %{author: author} do
      {:error, changeset} =
        Authors.apply_author_email(author, "invalid", %{email: unique_author_email()})

      assert %{current_password: ["is not valid"]} = errors_on(changeset)
    end

    test "applies the email without persisting it", %{author: author} do
      email = unique_author_email()
      {:ok, author} = Authors.apply_author_email(author, valid_author_password(), %{email: email})
      assert author.email == email
      assert Authors.get_author!(author.id).email != email
    end
  end

  describe "deliver_update_email_instructions/3" do
    setup do
      %{author: author_fixture()}
    end

    test "sends token through notification", %{author: author} do
      token =
        extract_author_token(fn url ->
          Authors.deliver_update_email_instructions(author, "current@example.com", url)
        end)

      {:ok, token} = Base.url_decode64(token, padding: false)
      assert author_token = Repo.get_by(AuthorToken, token: :crypto.hash(:sha256, token))
      assert author_token.author_id == author.id
      assert author_token.sent_to == author.email
      assert author_token.context == "change:current@example.com"
    end
  end

  describe "update_author_email/2" do
    setup do
      author = author_fixture()
      email = unique_author_email()

      token =
        extract_author_token(fn url ->
          Authors.deliver_update_email_instructions(%{author | email: email}, author.email, url)
        end)

      %{author: author, token: token, email: email}
    end

    test "updates the email with a valid token", %{author: author, token: token, email: email} do
      assert Authors.update_author_email(author, token) == :ok
      changed_author = Repo.get!(Author, author.id)
      assert changed_author.email != author.email
      assert changed_author.email == email
      assert changed_author.confirmed_at
      assert changed_author.confirmed_at != author.confirmed_at
      refute Repo.get_by(AuthorToken, author_id: author.id)
    end

    test "does not update email with invalid token", %{author: author} do
      assert Authors.update_author_email(author, "oops") == :error
      assert Repo.get!(Author, author.id).email == author.email
      assert Repo.get_by(AuthorToken, author_id: author.id)
    end

    test "does not update email if author email changed", %{author: author, token: token} do
      assert Authors.update_author_email(%{author | email: "current@example.com"}, token) ==
               :error

      assert Repo.get!(Author, author.id).email == author.email
      assert Repo.get_by(AuthorToken, author_id: author.id)
    end

    test "does not update email if token expired", %{author: author, token: token} do
      {1, nil} = Repo.update_all(AuthorToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      assert Authors.update_author_email(author, token) == :error
      assert Repo.get!(Author, author.id).email == author.email
      assert Repo.get_by(AuthorToken, author_id: author.id)
    end
  end

  describe "change_author_password/2" do
    test "returns a author changeset" do
      assert %Ecto.Changeset{} = changeset = Authors.change_author_password(%Author{})
      assert changeset.required == [:password]
    end

    test "allows fields to be set" do
      changeset =
        Authors.change_author_password(%Author{}, %{
          "password" => "new valid password"
        })

      assert changeset.valid?
      assert get_change(changeset, :password) == "new valid password"
      assert is_nil(get_change(changeset, :hashed_password))
    end
  end

  describe "update_author_password/3" do
    setup do
      %{author: author_fixture()}
    end

    test "validates password", %{author: author} do
      {:error, changeset} =
        Authors.update_author_password(author, valid_author_password(), %{
          password: "not valid",
          password_confirmation: "another"
        })

      assert %{
               password: ["should be at least 12 character(s)"],
               password_confirmation: ["does not match password"]
             } = errors_on(changeset)
    end

    test "validates maximum values for password for security", %{author: author} do
      too_long = String.duplicate("db", 100)

      {:error, changeset} =
        Authors.update_author_password(author, valid_author_password(), %{password: too_long})

      assert "should be at most 80 character(s)" in errors_on(changeset).password
    end

    test "validates current password", %{author: author} do
      {:error, changeset} =
        Authors.update_author_password(author, "invalid", %{password: valid_author_password()})

      assert %{current_password: ["is not valid"]} = errors_on(changeset)
    end

    test "updates the password", %{author: author} do
      {:ok, author} =
        Authors.update_author_password(author, valid_author_password(), %{
          password: "new valid password"
        })

      assert is_nil(author.password)
      assert Authors.get_author_by_email_and_password(author.email, "new valid password")
    end

    test "deletes all tokens for the given author", %{author: author} do
      _ = Authors.generate_author_session_token(author)

      {:ok, _} =
        Authors.update_author_password(author, valid_author_password(), %{
          password: "new valid password"
        })

      refute Repo.get_by(AuthorToken, author_id: author.id)
    end
  end

  describe "generate_author_session_token/1" do
    setup do
      %{author: author_fixture()}
    end

    test "generates a token", %{author: author} do
      token = Authors.generate_author_session_token(author)
      assert author_token = Repo.get_by(AuthorToken, token: token)
      assert author_token.context == "session"

      # Creating the same token for another author should fail
      assert_raise Ecto.ConstraintError, fn ->
        Repo.insert!(%AuthorToken{
          token: author_token.token,
          author_id: author_fixture().id,
          context: "session"
        })
      end
    end
  end

  describe "get_author_by_session_token/1" do
    setup do
      author = author_fixture()
      token = Authors.generate_author_session_token(author)
      %{author: author, token: token}
    end

    test "returns author by token", %{author: author, token: token} do
      assert session_author = Authors.get_author_by_session_token(token)
      assert session_author.id == author.id
    end

    test "does not return author for invalid token" do
      refute Authors.get_author_by_session_token("oops")
    end

    test "does not return author for expired token", %{token: token} do
      {1, nil} = Repo.update_all(AuthorToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      refute Authors.get_author_by_session_token(token)
    end
  end

  describe "delete_session_token/1" do
    test "deletes the token" do
      author = author_fixture()
      token = Authors.generate_author_session_token(author)
      assert Authors.delete_session_token(token) == :ok
      refute Authors.get_author_by_session_token(token)
    end
  end

  describe "deliver_author_confirmation_instructions/2" do
    setup do
      %{author: author_fixture()}
    end

    test "sends token through notification", %{author: author} do
      token =
        extract_author_token(fn url ->
          Authors.deliver_author_confirmation_instructions(author, url)
        end)

      {:ok, token} = Base.url_decode64(token, padding: false)
      assert author_token = Repo.get_by(AuthorToken, token: :crypto.hash(:sha256, token))
      assert author_token.author_id == author.id
      assert author_token.sent_to == author.email
      assert author_token.context == "confirm"
    end
  end

  describe "confirm_author/1" do
    setup do
      author = author_fixture()

      token =
        extract_author_token(fn url ->
          Authors.deliver_author_confirmation_instructions(author, url)
        end)

      %{author: author, token: token}
    end

    test "confirms the email with a valid token", %{author: author, token: token} do
      assert {:ok, confirmed_author} = Authors.confirm_author(token)
      assert confirmed_author.confirmed_at
      assert confirmed_author.confirmed_at != author.confirmed_at
      assert Repo.get!(Author, author.id).confirmed_at
      refute Repo.get_by(AuthorToken, author_id: author.id)
    end

    test "does not confirm with invalid token", %{author: author} do
      assert Authors.confirm_author("oops") == :error
      refute Repo.get!(Author, author.id).confirmed_at
      assert Repo.get_by(AuthorToken, author_id: author.id)
    end

    test "does not confirm email if token expired", %{author: author, token: token} do
      {1, nil} = Repo.update_all(AuthorToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      assert Authors.confirm_author(token) == :error
      refute Repo.get!(Author, author.id).confirmed_at
      assert Repo.get_by(AuthorToken, author_id: author.id)
    end
  end

  describe "deliver_author_reset_password_instructions/2" do
    setup do
      %{author: author_fixture()}
    end

    test "sends token through notification", %{author: author} do
      token =
        extract_author_token(fn url ->
          Authors.deliver_author_reset_password_instructions(author, url)
        end)

      {:ok, token} = Base.url_decode64(token, padding: false)
      assert author_token = Repo.get_by(AuthorToken, token: :crypto.hash(:sha256, token))
      assert author_token.author_id == author.id
      assert author_token.sent_to == author.email
      assert author_token.context == "reset_password"
    end
  end

  describe "get_author_by_reset_password_token/1" do
    setup do
      author = author_fixture()

      token =
        extract_author_token(fn url ->
          Authors.deliver_author_reset_password_instructions(author, url)
        end)

      %{author: author, token: token}
    end

    test "returns the author with valid token", %{author: %{id: id}, token: token} do
      assert %Author{id: ^id} = Authors.get_author_by_reset_password_token(token)
      assert Repo.get_by(AuthorToken, author_id: id)
    end

    test "does not return the author with invalid token", %{author: author} do
      refute Authors.get_author_by_reset_password_token("oops")
      assert Repo.get_by(AuthorToken, author_id: author.id)
    end

    test "does not return the author if token expired", %{author: author, token: token} do
      {1, nil} = Repo.update_all(AuthorToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      refute Authors.get_author_by_reset_password_token(token)
      assert Repo.get_by(AuthorToken, author_id: author.id)
    end
  end

  describe "reset_author_password/2" do
    setup do
      %{author: author_fixture()}
    end

    test "validates password", %{author: author} do
      {:error, changeset} =
        Authors.reset_author_password(author, %{
          password: "not valid",
          password_confirmation: "another"
        })

      assert %{
               password: ["should be at least 12 character(s)"],
               password_confirmation: ["does not match password"]
             } = errors_on(changeset)
    end

    test "validates maximum values for password for security", %{author: author} do
      too_long = String.duplicate("db", 100)
      {:error, changeset} = Authors.reset_author_password(author, %{password: too_long})
      assert "should be at most 80 character(s)" in errors_on(changeset).password
    end

    test "updates the password", %{author: author} do
      {:ok, updated_author} =
        Authors.reset_author_password(author, %{password: "new valid password"})

      assert is_nil(updated_author.password)
      assert Authors.get_author_by_email_and_password(author.email, "new valid password")
    end

    test "deletes all tokens for the given author", %{author: author} do
      _ = Authors.generate_author_session_token(author)
      {:ok, _} = Authors.reset_author_password(author, %{password: "new valid password"})
      refute Repo.get_by(AuthorToken, author_id: author.id)
    end
  end

  describe "inspect/2" do
    test "does not include password" do
      refute inspect(%Author{password: "123456"}) =~ "password: \"123456\""
    end
  end

  describe "update_author_internal_profile/2" do
    test "updates author profile with limited profile fields" do
      author = insert(:author)

      {:ok, author} =
        Authors.update_author_internal_profile(author, %{
          stripe_connect_id: "updated_stripe_connect_id"
        })

      assert author.stripe_connect_id == "updated_stripe_connect_id"
    end
  end

  describe "has_stripe_connect_id?/1" do
    test "check if stripe_connect_id exists on Author" do
      author = insert(:author)
      author_without_stripe = insert(:author, stripe_connect_id: nil)

      assert Authors.has_stripe_connect_id?(author)
      refute Authors.has_stripe_connect_id?(author_without_stripe)
    end
  end

  describe "get_by_stripe_connect_id!/1" do
    test "gets author by stripe_connect_id" do
      author = insert(:author)

      found_author = Authors.get_by_stripe_connect_id!(author.stripe_connect_id)

      assert found_author.id == author.id
    end
  end

  describe "set_payment_connected/1" do
    test "sets the payment_connected field on author" do
      author = insert(:author, is_payment_connected: false, account_status: :created)

      {:ok, updated_author} = Authors.set_payment_connected(author)

      assert updated_author.is_payment_connected
      assert updated_author.account_status == :payment_connected
    end
  end

  describe "is_payment_connected/1" do
    test "checks if the author has payment connected" do
      author = insert(:author)
      author_without_payment = insert(:author, is_payment_connected: false)

      assert Authors.is_payment_connected?(author)
      refute Authors.is_payment_connected?(author_without_payment)
    end
  end

  describe "set_stripe_connect_id/2" do
    test "sets stripe connect id for author" do
      author = insert(:author, stripe_connect_id: nil)

      {:ok, connected_author} = Authors.set_stripe_connect_id(author, "connect_id")

      assert connected_author.stripe_connect_id == "connect_id"
    end
  end

  describe "fetch_or_create_author/1" do
    test "creates confirmed author if email not present" do
      author_params = params_for(:author, password: "test_password")

      {:ok, created_author} = Authors.fetch_or_create_author(author_params)

      assert created_author.email == author_params[:email]
      assert Authors.is_confirmed?(created_author)
    end
  end

  describe "is_confirmed?" do
    test "tests if author is confirmed" do
      author = insert(:author, account_status: :created)

      refute Authors.is_confirmed?(author)
    end
  end
end
