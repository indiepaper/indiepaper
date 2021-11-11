defmodule IndiePaper.Services.S3Handler do
  @bucket_name Application.get_env(:ex_aws, :bucket_name)

  def generate_presigned_url(key) do
    query_params = [{"ContentType", "image/jpeg"}, {"ACL", "public-read"}]
    presign_options = [virtual_host: false, query_params: query_params]

    %{fields: fields, url: url} =
      ExAws.Config.new(:s3)
      |> ExAws.S3.presigned_post(@bucket_name, key, presign_options)

    {:ok, url, fields}
  end
end
