defmodule Wetterhaecker.Gpx do
  @moduledoc false

  alias GpxEx.{
    Gpx,
    Track,
    TrackSegment,
    TrackPoint
  }

  @spec parse(String.t()) :: {:ok, GpxEx.Gpx} | {:error, String.t()}
  def parse(file_path) do
    {:ok, gpx_doc} = File.read(file_path)

    GpxEx.parse(gpx_doc)
  end

  def points(file_name \\ "12_LA_Eimsbuettel.gpx") do
    [:code.priv_dir(:wetterhaecker), "static", "gpx", file_name]
    |> Path.join()
    |> parse()
    |> extract_points()
  end

  @spec points({:error, any()} | {:ok, Gpx}) :: [TrackPoint.t()] | []
  defp extract_points(
         {:ok,
          %Gpx{
            tracks: [
              %Track{
                segments: [
                  %TrackSegment{
                    points: points
                  }
                ]
              }
            ]
          }}
       ),
       do: points

  defp extract_points({:error, _reason}), do: []
end
