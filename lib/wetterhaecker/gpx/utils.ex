defmodule Wetterhaecker.Gpx.Utils do
  alias GpxEx.Gpx
  def route_length_km(gpx) when is_map(gpx), do: route_length_km(gpx[:total_length])

  def route_length_km(total_length) when is_float(total_length),
    do: Float.ceil(total_length / 1000, 2)

  def estimated_route_time(gpx, form) when is_map(gpx) and is_struct(form, Phoenix.HTML.Form),
    do:
      estimated_route_time(
        Map.get(gpx, :total_length, 0),
        Phoenix.HTML.Form.input_value(form, :average_speed)
      )

  def estimated_route_time(total_length, average_speed)
      when is_float(total_length) and is_float(average_speed),
      do: total_length / 1000 / average_speed * 60

  def estimated_route_time_hours(gpx, form)
      when is_map(gpx) and is_struct(form, Phoenix.HTML.Form),
      do:
        estimated_route_time_hours(
          Map.get(gpx, :total_length, 0),
          Phoenix.HTML.Form.input_value(form, :average_speed)
        )

  def estimated_route_time_hours(total_length, average_speed)
      when is_float(total_length) and is_float(average_speed),
      do: (total_length / 1000 / average_speed) |> Float.ceil(2)

  def sample_weather_points(
        points,
        estimated_time,
        sampling_rate
      ) do
    parts_we_need_to_sample = estimated_time / sampling_rate

    take_point_every_n =
      round(Enum.count(points) / parts_we_need_to_sample)

    points_to_sample =
      points
      |> Enum.with_index()
      |> Enum.filter(fn {%GpxEx.TrackPoint{}, i} ->
        # always take the first point
        i == 0 or rem(i, take_point_every_n) == 0
      end)
      |> Enum.map(fn {%GpxEx.TrackPoint{} = point, index} ->
        %{
          point: point,
          index: index
        }
      end)

    points_to_sample
  end

  def add_weather_data(
        sampled_weather_points,
        start_date \\ DateTime.utc_now()
      )
      when is_list(sampled_weather_points) do
    sampled_weather_points
    |> Enum.map(fn %{point: %GpxEx.TrackPoint{} = point} = sampled_point ->
      # TODO: calculate the date based on the points index, the sampling rate
      #       the estimated route time and the start_date.
      date = DateTime.utc_now()
      Map.put(sampled_point, :weather, weather_for_point(point, date))
    end)
  end

  defp weather_for_point(
         %GpxEx.TrackPoint{lat: lat, lon: lon},
         date
       ) do
    opts = [
      date: date,
      lat: lat,
      lon: lon
    ]

    weather_data = Wetterhaecker.Brightsky.Operations.get_weather(opts)

    # because we don't define a timespan (`last_date`), we always only get
    # a list with one item in `sources` and `weather`.
    %{
      source: List.first(weather_data.sources),
      weather: List.first(weather_data.weather)
    }
  end
end
