defmodule Wetterhaecker.Gpx.Utils do
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
      when is_map(gpx) and is_struct(form, Phoenix.HTML.FormData),
      do:
        estimated_route_time_hours(
          Map.get(gpx, :total_length, 0),
          Phoenix.HTML.Form.input_value(form, :average_speed)
        )

  def estimated_route_time_hours(total_length, average_speed)
      when is_float(total_length) and is_float(average_speed),
      do: (total_length / 1000 / average_speed) |> Float.ceil(2)

  def estimated_time_and_sampling_rate_to_points_with_index(
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

    points_to_sample
  end
end
