# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     IndiePaper.Repo.insert!(%IndiePaper.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias IndiePaper.Authors
alias IndiePaper.Repo

%IndiePaper.Authors.Author{
  username: "aswinmohanme",
  email: "aswinmmohan@gmail.com",
  first_name: "Aswin",
  last_name: "Mohan",
  stripe_connect_id: "acct_1JhzH2Q0OKd1TdMK",
  is_payment_connected: true,
  account_status: :payment_connected
}
|> Authors.Author.registration_changeset(%{password: "longpassword123"})
|> Ecto.Changeset.put_change(:password, "longpassword123")
|> Repo.insert!()
