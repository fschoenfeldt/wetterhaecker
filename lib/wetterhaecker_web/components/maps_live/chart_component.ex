defmodule WetterhaeckerWeb.Components.MapsLive.ChartComponent do
  @moduledoc """
  A component that renders a chart for weather data using Highcharts.

  This component is responsible for displaying the weather information
  along the route based on calculation results.
  """
  use WetterhaeckerWeb, :live_component

  @doc """
  Renders the chart component.

  ## Examples

      <.live_component
        module={WetterhaeckerWeb.Components.MapsLive.ChartComponent}
        id="chart"
      />
  """
  def render(assigns) do
    ~H"""
    <div id="chart" phx-hook="Chart" phx-update="ignore" class="h-[50vh] lg:h-64 p-2">
      <div class="flex items-center justify-center h-full bg-gray-50">
        <p class="text-center text-gray-500">
          Weather data will be displayed here after you submit the form.
        </p>
      </div>
    </div>
    """
  end

  @doc """
  Updates the chart with weather data points.

  This function should be called when the weather data is calculated.

  ## Parameters

  - socket: The LiveView socket
  - points: A list of track points with weather data

  ## Returns

  The updated socket
  """
  @spec update_weather_data(Phoenix.LiveView.Socket.t(), [
          Wetterhaecker.Gpx.Utils.track_point_with_weather()
        ]) :: Phoenix.LiveView.Socket.t()
  def update_weather_data(socket, points) do
    push_event(socket, "chart:drawWeatherUpdate", %{
      points: points
    })
  end
end
