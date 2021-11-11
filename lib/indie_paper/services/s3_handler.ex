defmodule IndiePaper.Services.S3Handler do
  @bucket_name Application.get_env(:ex_aws, :bucket_name)

  def generate_presigned_url(key) do
    %{fields: fields, url: url} =
      ExAws.Config.new(:s3)
      |> ExAws.S3.presigned_post(@bucket_name, key, acl: "public-read")

    fields = Map.put(fields, "acl", "public-read")

    {:ok, url, fields}
  end
end
