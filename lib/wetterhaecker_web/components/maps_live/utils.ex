defmodule WetterhaeckerWeb.Components.MapsLive.Utils do
  @moduledoc """
  Utility functions for the Maps LiveView components.

  Provides shared functionality used by multiple components.
  """

  alias Phoenix.HTML.Form, as: HTMLForm
  alias Wetterhaecker.Gpx.Utils, as: GpxUtils

  @doc """
  Adds time and weather data to GPX points based on form inputs.

  This function processes the GPX points by:
  1. Adding timestamps based on estimated travel time
  2. Sampling points at the specified rate
  3. Adding weather data to each sampled point

  ## Parameters

  - form: The form containing user inputs
  - gpx: The GPX data structure with route points

  ## Returns

  A list of points with added time and weather data
  """
  def add_time_and_weather(form, gpx) do
    points = gpx.points
    estimated_time = GpxUtils.estimated_route_time(gpx, form)
    sampling_rate = HTMLForm.input_value(form, :sampling_rate)

    start_date_time =
      form
      |> HTMLForm.input_value(:start_date_time)

    points
    |> GpxUtils.wrap_with_index()
    |> GpxUtils.update_points_time(
      estimated_time,
      start_date_time
    )
    |> GpxUtils.sample_weather_points(
      estimated_time,
      sampling_rate
    )
    |> GpxUtils.add_weather_data()
  end
end
