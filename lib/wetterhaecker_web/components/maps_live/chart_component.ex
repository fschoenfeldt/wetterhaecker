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
  attr :has_weather_data?, :boolean, default: false

  def render(assigns) do
    ~H"""
    <div id="chart" phx-hook="Chart" class="h-[50vh] lg:h-64 p-2 flex flex-col">
      <div :if={@has_weather_data?} class="flex justify-end mb-2">
        <.chart_dropdown />
      </div>
      <.chart_canvas />
    </div>
    """
  end

  defp chart_dropdown(assigns) do
    ~H"""
    <SaladUI.DropdownMenu.dropdown_menu id="chart-type-select">
      <SaladUI.DropdownMenu.dropdown_menu_trigger>
        <.button variant="outline">
          <span data-chart-current-label>Temperature</span>
        </.button>
      </SaladUI.DropdownMenu.dropdown_menu_trigger>
      <SaladUI.DropdownMenu.dropdown_menu_content class="w-44">
        <SaladUI.DropdownMenu.dropdown_menu_label>
          Chart Type
        </SaladUI.DropdownMenu.dropdown_menu_label>
        <SaladUI.DropdownMenu.dropdown_menu_separator />
        <SaladUI.DropdownMenu.dropdown_menu_group data-chart-mode-items>
          <SaladUI.DropdownMenu.dropdown_menu_item data-chart-mode="temperature" value="temperature">
            Temperature
          </SaladUI.DropdownMenu.dropdown_menu_item>
          <SaladUI.DropdownMenu.dropdown_menu_item
            data-chart-mode="precipitation"
            value="precipitation"
          >
            Precipitation
          </SaladUI.DropdownMenu.dropdown_menu_item>
          <SaladUI.DropdownMenu.dropdown_menu_item data-chart-mode="wind" value="wind">
            Wind
          </SaladUI.DropdownMenu.dropdown_menu_item>
        </SaladUI.DropdownMenu.dropdown_menu_group>
      </SaladUI.DropdownMenu.dropdown_menu_content>
    </SaladUI.DropdownMenu.dropdown_menu>
    """
  end

  defp chart_canvas(assigns) do
    ~H"""
    <div id="chart-canvas" phx-update="ignore" class="flex-1">
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
