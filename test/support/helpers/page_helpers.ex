defmodule IndiePaperWeb.PageHelpers do
  defmacro __using__(_) do
    quote do
      use Wallaby.DSL
      import Wallaby.Query

      alias IndiePaperWeb.Router.Helpers, as: Routes

      @endpoint IndiePaperWeb.Endpoint
    end
  end
end
