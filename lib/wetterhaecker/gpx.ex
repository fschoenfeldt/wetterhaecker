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

  defmodule Calculate do
    @moduledoc """
    source: https://github.com/velomapa/gpx_ex/pull/6/files?diff=unified&w=1
    """
    @spec calc_length(list(GpxEx.TrackPoint.t())) :: float()
    def calc_length(points), do: calc_length(0, points)
    def calc_length(length, [_head | _tail = []]), do: length

    def calc_length(length, [head | tail]) do
      length = length + calc_length_between_points(head, List.first(tail))
      calc_length(length, tail)
    end

    @spec calc_length_between_points(GpxEx.TrackPoint.t(), GpxEx.TrackPoint.t()) :: float()
    def calc_length_between_points(start, finish) do
      # Radius of the Earth in kilometers
      earth_radius = 6371.0

      d_lat = to_radians(finish.lat - start.lat)
      d_lon = to_radians(finish.lon - start.lon)

      a =
        haversine(d_lat) +
          Math.cos(to_radians(start.lat)) * Math.cos(to_radians(finish.lat)) * haversine(d_lon)

      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

      horizontal_length = earth_radius * c
      vertical_length = Kernel.abs(finish.ele / 1000 - start.ele / 1000)

      length =
        Math.sqrt(horizontal_length * horizontal_length + vertical_length * vertical_length)

      length * 1000
    end

    @spec to_radians(float()) :: float()
    defp to_radians(degrees) do
      degrees * (Math.pi() / 180)
    end

    @spec haversine(float()) :: float()
    defp haversine(angle) do
      Math.pow(Math.sin(angle / 2.0), 2)
    end
  end
end
