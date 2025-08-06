defmodule Wetterhaecker.Gpx do
  @moduledoc false

  alias GpxEx.{
    Gpx,
    Track,
    TrackSegment
  }

  alias Wetterhaecker.Gpx.Calculate

  # TODO: create proper struct
  @type gpx_with_length() :: %{points: list(), total_length: float()}

  @doc """
  Reads a preset GPX file from the `priv/static/gpx` directory and returns the points and total length.
  """
  @spec get_from_preset(preset_file_name :: String.t()) :: {:ok, gpx_with_length()} | {:error, binary()}
  def get_from_preset(preset_file_name \\ "Langeoog.gpx") do
    [:code.priv_dir(:wetterhaecker), "static", "gpx", preset_file_name]
    |> Path.join()
    |> get_from_path()
  end

  @doc """
  Reads a GPX file from the given file path and returns the points and total length.
  """
  @spec get_from_path(file_path :: String.t()) :: {:ok, gpx_with_length()} | {:error, binary()}
  def get_from_path(file_path) when is_binary(file_path) do
    # credo:disable-for-next-line
    with {:ok, _gpx} = parse_result <- parse_gpx(file_path) do
      {:ok, points} = extract_points(parse_result)

      # TODO: this could be refactored.
      case calculate_total_length(points) do
        {:ok, total_length} ->
          {:ok, %{points: points, total_length: total_length}}

        {:error, reason} ->
          {:error, reason}
      end
    end
  end

  defp parse_gpx(file_path) do
    with {:ok, gpx_doc} <- File.read(file_path) do
      GpxEx.parse(gpx_doc)
    end
  end

  defp calculate_total_length(points) when is_list(points) do
    if Enum.empty?(points) do
      {:error, "no points given to calculate total_length"}
    else
      {:ok, Calculate.calc_length(points)}
    end
  end

  defp extract_points({:ok, %Gpx{tracks: [%Track{segments: [%TrackSegment{points: points}]}]}}), do: {:ok, points}
end
