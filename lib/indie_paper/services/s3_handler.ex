defmodule IndiePaper.Services.S3Handler do
  @region Application.get_env(:ex_aws, :s3)[:region]
  @host Application.get_env(:ex_aws, :s3)[:host]

  defp bucket_name(), do: Application.get_env(:ex_aws, :bucket_name)
  defp access_key_id(), do: Application.get_env(:ex_aws, :access_key_id)
  defp secret_access_key(), do: Application.get_env(:ex_aws, :secret_access_key)

  def generate_presigned_post(key: key, content_type: content_type, max_file_size: max_file_size) do
    config = %{
      region: @region,
      access_key_id: access_key_id(),
      secret_access_key: secret_access_key()
    }

    {:ok, fields} =
      sign_form_upload(config, bucket_name(),
        key: key,
        content_type: content_type,
        max_file_size: max_file_size,
        expires_in: :timer.hours(1)
      )

    {:ok, "https://#{bucket_name()}.#{@host}", fields}
  end

  def upload_file(path, file, opts \\ []) do
    content_type = Keyword.get(opts, :content_type, "application/octect-stream")
    permission = Keyword.get(opts, :permission, :private)

    ExAws.S3.put_object(bucket_name(), path, file,
      content_type: content_type,
      acl: permission
    )
    |> ExAws.request()
  end

  def get_public_read_url(file) do
    "https://#{bucket_name()}.#{@host}/#{file}"
  end

  def delete_objects(objects) do
    ExAws.S3.delete_all_objects(bucket_name(), objects) |> ExAws.request()
  end

  def sign_form_upload(config, bucket, opts) do
    key = Keyword.fetch!(opts, :key)
    max_file_size = Keyword.fetch!(opts, :max_file_size)
    content_type = Keyword.fetch!(opts, :content_type)
    expires_in = Keyword.fetch!(opts, :expires_in)

    expires_at = DateTime.add(DateTime.utc_now(), expires_in, :millisecond)
    amz_date = amz_date(expires_at)
    credential = credential(config, expires_at)

    encoded_policy =
      Base.encode64("""
      {
        "expiration": "#{DateTime.to_iso8601(expires_at)}",
        "conditions": [
          {"bucket":  "#{bucket}"},
          ["eq", "$key", "#{key}"],
          {"acl": "public-read"},
          ["eq", "$Content-Type", "#{content_type}"],
          ["content-length-range", 0, #{max_file_size}],
          {"x-amz-server-side-encryption": "AES256"},
          {"x-amz-credential": "#{credential}"},
          {"x-amz-algorithm": "AWS4-HMAC-SHA256"},
          {"x-amz-date": "#{amz_date}"}
        ]
      }
      """)

    fields = %{
      "key" => key,
      "acl" => "public-read",
      "content-type" => content_type,
      "x-amz-server-side-encryption" => "AES256",
      "x-amz-credential" => credential,
      "x-amz-algorithm" => "AWS4-HMAC-SHA256",
      "x-amz-date" => amz_date,
      "policy" => encoded_policy,
      "x-amz-signature" => signature(config, expires_at, encoded_policy)
    }

    {:ok, fields}
  end

  defp amz_date(time) do
    time
    |> NaiveDateTime.to_iso8601()
    |> String.split(".")
    |> List.first()
    |> String.replace("-", "")
    |> String.replace(":", "")
    |> Kernel.<>("Z")
  end

  defp credential(%{} = config, %DateTime{} = expires_at) do
    "#{config.access_key_id}/#{short_date(expires_at)}/#{config.region}/s3/aws4_request"
  end

  defp signature(config, %DateTime{} = expires_at, encoded_policy) do
    config
    |> signing_key(expires_at, "s3")
    |> sha256(encoded_policy)
    |> Base.encode16(case: :lower)
  end

  defp signing_key(%{} = config, %DateTime{} = expires_at, service) when service in ["s3"] do
    amz_date = short_date(expires_at)
    %{secret_access_key: secret, region: region} = config

    ("AWS4" <> secret)
    |> sha256(amz_date)
    |> sha256(region)
    |> sha256(service)
    |> sha256("aws4_request")
  end

  defp short_date(%DateTime{} = expires_at) do
    expires_at
    |> amz_date()
    |> String.slice(0..7)
  end

  defp sha256(secret, msg), do: :crypto.mac(:hmac, :sha256, secret, msg)
end
