defmodule IndiePaper.ExternalAssetHandler do
  alias IndiePaper.Services.S3Handler

  def presigned_post(key: key, content_type: content_type, max_file_size: max_file_size) do
    S3Handler.generate_presigned_post(
      key: key,
      content_type: content_type,
      max_file_size: max_file_size
    )
  end

  def upload_file(path, file, content_type, permission \\ :private) do
    S3Handler.upload_file(path, file, content_type: content_type, permission: permission)
  end

  def get_public_url(asset) do
    S3Handler.get_public_read_url(asset)
  end

  def delete_assets(assets_list) do
    S3Handler.delete_objects(assets_list)
  end

  def delete_asset(asset) do
    S3Handler.delete_object(asset)
  end
end
