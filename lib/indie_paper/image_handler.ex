defmodule IndiePaper.ImageHandler do
  def resize(image, width, height) do
    image |> Mogrify.resize("#{width}x#{height}")
  end

  def resize_to_square(image, dimension) do
    image
    |> Mogrify.custom("resize", "#{dimension}x#{dimension}>")
    |> Mogrify.custom("gravity", "center")
    |> Mogrify.custom("background", "white")
    |> Mogrify.custom("alpha", "remove")
    |> Mogrify.custom("alpha", "off")
    |> Mogrify.custom("extent", "#{dimension}x#{dimension}")
  end

  def open(path), do: Mogrify.open(path)

  def save(image), do: Mogrify.save(image, in_place: false)
  def save_in_place(image), do: Mogrify.save(image, in_place: true)

  def to_file!(%{path: path}) do
    File.read!(path)
  end
end
