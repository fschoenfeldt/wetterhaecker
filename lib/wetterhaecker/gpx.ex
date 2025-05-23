defmodule Wetterhaecker.Gpx do
  @moduledoc false

  alias Wetterhaecker.Gpx.Calculate

  alias GpxEx.{
    Gpx,
    Track,
    TrackSegment
  }

  def get(file_name \\ "Langeoog.gpx") do
    with {:ok, _gpx} = parse_result <-
           [:code.priv_dir(:wetterhaecker), "static", "gpx", file_name]
           |> Path.join()
           |> parse_gpx(),
         {:ok, points} = extract_points(parse_result) do
      total_length = calculate_total_length(points)

      {
        :ok,
        %{
          points: points,
          total_length: total_length
        }
      }
    end
  end

  defp parse_gpx(file_path) do
    {:ok, gpx_doc} = File.read(file_path)

    GpxEx.parse(gpx_doc)
  end

  defp calculate_total_length(points) when is_list(points) and length(points) == 0 do
    {:error, "no points given to calculate total_length"}
  end

  defp calculate_total_length(points) when is_list(points) and length(points) > 0 do
    Calculate.calc_length(points)
  end

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
       do: {:ok, points}
end
