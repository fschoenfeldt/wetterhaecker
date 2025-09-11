defmodule WetterhaeckerWeb.Components.MapsLive.ChartComponentTest do
  use WetterhaeckerWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias WetterhaeckerWeb.Components.MapsLive.ChartComponent
  # So far, `ChartComponent` is a client side component only.
  # All testing should be done to the according js hooks.

  describe "mount/3" do
    test "initial render works" do
      actual = render_component(ChartComponent)

      assert actual =~ ~s(id="chart" phx-hook="Chart")
    end

    test "shows dropdown when has weather data" do
      actual = render_component(ChartComponent, has_weather_data?: true)

      assert actual =~ ~s(id="chart-type-select")
      assert actual =~ ~r/Temperature.*Precipitation.*Wind/s
    end

    test "hides dropdown when no weather data" do
      actual = render_component(ChartComponent, has_weather_data?: false)

      refute actual =~ ~s(id="chart-type-select")
    end
  end
end
