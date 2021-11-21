defmodule IndiePaper.ImageHandler do
  def resize(image, width, height) do
    image |> Mogrify.resize("#{width}x#{height}")
  end

  def resize_to_square(image, dimension) do
    image |> Mogrify.gravity("center") |> Mogrify.resize_to_limit("#{dimension}x#{dimension}")
  end

  def open(path), do: Mogrify.open(path)

  def save(image), do: Mogrify.save(image, in_place: false)
  def save_in_place(image), do: Mogrify.save(image, in_place: true)

  def to_file!(%{path: path}) do
    File.read!(path)
  end
end
