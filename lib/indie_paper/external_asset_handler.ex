defmodule IndiePaper.ExternalAssetHandler do
  alias IndiePaper.Services.S3Handler

  def presigned_post(key: key, content_type: content_type, max_file_size: max_file_size) do
    S3Handler.generate_presigned_post(
      key: key,
      content_type: content_type,
      max_file_size: max_file_size
    )
  end

  def get_url(asset) do
    S3Handler.get_url(asset)
  end

  def file_ext(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    ext
  end
end
