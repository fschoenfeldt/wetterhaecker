defmodule Wetterhaecker.Gpx.Utils do
  @moduledoc """
  Helper functions for GPX calculations and weather data.
  """

  alias GpxEx.TrackPoint
  alias Phoenix.HTML.Form
  alias Wetterhaecker.Brightsky.Operations

  def route_length_km(gpx) when is_map(gpx), do: route_length_km(gpx[:total_length])

  def route_length_km(total_length) when is_float(total_length),
    do: Float.ceil(total_length / 1000, 2)

  def estimated_route_time(gpx, form) when is_map(gpx) and is_struct(form, Phoenix.HTML.Form),
    do:
      estimated_route_time(
        Map.get(gpx, :total_length, 0),
        Form.input_value(form, :average_speed)
      )

  def estimated_route_time(total_length, average_speed)
      when is_float(total_length) and is_float(average_speed),
      do: total_length / 1000 / average_speed * 60

  def estimated_route_time_hours(gpx, form)
      when is_map(gpx) and is_struct(form, Phoenix.HTML.Form),
      do:
        estimated_route_time_hours(
          Map.get(gpx, :total_length, 0),
          Form.input_value(form, :average_speed)
        )

  def estimated_route_time_hours(total_length, average_speed)
      when is_float(total_length) and is_float(average_speed),
      do: (total_length / 1000 / average_speed) |> Float.ceil(2)

  def wrap_with_index(points) when is_list(points) do
    points
    |> Enum.with_index()
    |> Enum.map(fn {%GpxEx.TrackPoint{} = point, index} ->
      %{
        point: point,
        index: index
      }
    end)
  end

  def sample_weather_points(
        points_with_indexes,
        estimated_time,
        sampling_rate
      )
      when is_list(points_with_indexes) do
    parts_we_need_to_sample = estimated_time / sampling_rate

    total_points_count = Enum.count(points_with_indexes)

    if total_points_count <= 1 do
      # if we only have one point, we just return the points as is to prevent
      # division by zero errors
      points_with_indexes
    else
      take_point_every_n =
        round((total_points_count - 1) / parts_we_need_to_sample)

      Enum.map(points_with_indexes, fn %{point: %TrackPoint{}, index: index} =
                                         point_with_index ->
        # always take the first point
        Map.put(
          point_with_index,
          :weather_point?,
          index == 0 or rem(index, take_point_every_n) == 0
        )
      end)
    end
  end

  def add_weather_data(points) do
    points
    |> Enum.map(fn %{point: %TrackPoint{}, weather_point?: weather_point?} = sampled_point ->
      weather =
        if weather_point? do
          weather_for_point(sampled_point)
        else
          nil
        end

      Map.put(sampled_point, :weather, weather)
    end)
  end

  def update_points_time(
        points_with_indexes,
        estimated_time,
        start_date
      )
      when is_list(points_with_indexes) and
             is_struct(start_date, DateTime) do
    points_with_indexes
    |> Enum.map(fn point_with_index ->
      date = date_for_point(point_with_index, points_with_indexes, start_date, estimated_time)

      Map.put(point_with_index, :date, date)
    end)
  end

  defp date_for_point(
         %{point: %TrackPoint{}, index: index},
         points,
         start_date,
         estimated_time
       ) do
    total_points_count = Enum.count(points)

    if total_points_count <= 1 do
      # if we only have one point, we just return the start date to prevent
      # division by zero errors
      start_date
    else
      interval_seconds = estimated_time * 60 / (total_points_count - 1)

      # calculate the date based on the index of the point and the sampling rate
      DateTime.add(
        start_date,
        round(index * interval_seconds),
        :second
      )
    end
  end

  defp weather_for_point(%{
         point: %TrackPoint{lat: lat, lon: lon},
         date: date
       }) do
    opts = [
      date: date,
      lat: lat,
      lon: lon
    ]

    weather_data = Operations.get_weather(opts)

    # because we don't define a timespan (`last_date`), we always only get
    # a list with one item in `sources` and `weather`.
    %{
      source: List.first(weather_data.sources),
      weather: List.first(weather_data.weather)
    }
  end
end
