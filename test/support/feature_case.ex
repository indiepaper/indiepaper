defmodule IndiePaperWeb.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL
      import Wallaby.Query

      alias IndiePaperWeb.Router.Helpers, as: Routes

      @endpoint IndiePaperWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(IndiePaper.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(IndiePaper.Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(IndiePaper.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)
    {:ok, session: session}
  end
end
