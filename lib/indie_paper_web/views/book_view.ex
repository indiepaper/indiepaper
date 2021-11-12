defmodule IndiePaperWeb.BookView do
  use IndiePaperWeb, :view

  def error_to_string(:too_large), do: "Too large"
  def error_to_string(:too_many_files), do: "You have selected too many files"
  def error_to_string(:not_accepted), do: "You have selected an unacceptable file type"

  def error_to_string(:external_client_failure),
    do: "An unexpected error occured while uploading the file."
end
