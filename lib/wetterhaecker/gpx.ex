defmodule Wetterhaecker.Gpx do
  @moduledoc false

  @spec parse(String.t()) :: {:ok, GpxEx.Gpx} | {:error, String.t()}
  def parse(file_path) do
    gpx_doc = File.read!(file_path)

    GpxEx.parse(gpx_doc)
  end
end
