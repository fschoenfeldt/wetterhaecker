defmodule WetterhaeckerWeb.Components.MapsLive.MapComponent do
  @moduledoc """
  A component that renders a map using Leaflet.

  This component is responsible for displaying the route on the map
  and updating it when the GPX file or weather data changes.
  """
  use WetterhaeckerWeb, :live_component

  @doc """
  Renders the map component.

  ## Examples

      <.live_component
        module={WetterhaeckerWeb.Components.MapsLive.MapComponent}
        id="map"
      />
  """
  def render(assigns) do
    ~H"""
    <div id="map" phx-hook="Map" phx-update="ignore" class="h-[50vh] lg:h-[calc(100vh-20rem)]"></div>
    """
  end

  @doc """
  Updates the map with new points data.

  This function should be called when the GPX file is updated.
  """
  @spec update_gpx_points(Phoenix.LiveView.Socket.t(), list(Wetterhaecker.Gpx.Utils.track_point())) ::
          Phoenix.LiveView.Socket.t()
  def update_gpx_points(socket, points) do
    push_event(socket, "map:drawGpxFileUpdate", %{
      points: points
    })
  end

  @doc """
  Updates the map with weather data points.

  This function should be called when the weather data is calculated.
  """
  @spec update_weather_points(Phoenix.LiveView.Socket.t(), list(Wetterhaecker.Gpx.Utils.track_point_with_weather())) ::
          Phoenix.LiveView.Socket.t()
  def update_weather_points(socket, points) do
    push_event(socket, "map:drawWeatherUpdate", %{
      points: points
    })
  end

  @doc """
  Initializes the map with default settings and points.

  This function should be called when the component is mounted.
  """
  @type map_settings :: %{
          lat: float(),
          lon: float(),
          zoom: integer()
        }
  @spec init_map(Phoenix.LiveView.Socket.t(), map_settings(), list()) :: Phoenix.LiveView.Socket.t()
  def init_map(socket, initial_settings, points) do
    push_event(socket, "map:init", %{
      initial: initial_settings,
      points: points
    })
  end
end
