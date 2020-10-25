defmodule Identicon do
  @moduledoc """
  Documentation for `Identicon`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Identicon.hello()
      :world

  """
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_pixel_rows
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  def save_image(binary, filename) do
    File.write("#{filename}.png", binary)
  end

  def draw_image(%Identicon.Image{color: color, pixels: pixels}) do
    image = :egd.create(250, 250)
    fill_color = :egd.color(color)

    Enum.each(pixels, fn {start, stop} ->
      :egd.filledRectangle(image, start, stop, fill_color)
    end)

    :egd.render(image)
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixels =
      Enum.map(grid, fn {_value, index} ->
        row = rem(index, 5) * 50
        column = div(index, 5) * 50

        top_left = {row, column}
        bottom_right = {row + 50, column + 50}

        {top_left, bottom_right}
      end)

    %Identicon.Image{image | pixels: pixels}
  end

  def filter_pixel_rows(%Identicon.Image{grid: grid} = image) do
    grid =
      Enum.filter(grid, fn {value, _index} ->
        rem(value, 2) == 0
      end)

    %Identicon.Image{image | grid: grid}
  end

  def hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _t]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Identicon.Image{image | grid: grid}
  end

  def mirror_row(row) do
    [first, second | _tail] = row

    row ++ [second, first]
  end
end
