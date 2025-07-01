defmodule WetterhaeckerWeb.Components.MapsLive.UtilsTest do
  use ExUnit.Case, async: true

  import Phoenix.Component, only: [to_form: 1]

  alias WetterhaeckerWeb.Components.MapsLive.{
    ChartComponent,
    FormComponent,
    MapComponent,
    Utils
  }

  describe "add_time_and_weather/2" do
    test "works when there are no points in the gpx file (noop)" do
      form = to_form(%{})

      gpx = %{
        points: [],
        total_length: 0
      }

      actual = Utils.add_time_and_weather(form, gpx)
      expected = []
      assert actual == expected
    end

    # TODO: in order to do this test, we'll need to mock the underlying modules
    #       (especially the brightsky module)
    @tag :skip
    test "works when there are points in the gpx file" do
      form =
        to_form(%{
          "average_speed" => 20.0,
          "start_date_time" => DateTime.utc_now(),
          "sampling_rate" => 10
        })

      gpx = %{
        points: [
          %GpxEx.TrackPoint{lat: 52.5200, lon: 13.4050},
          %GpxEx.TrackPoint{lat: 52.5201, lon: 13.4051},
          %GpxEx.TrackPoint{lat: 52.5202, lon: 13.4052}
        ],
        total_length: 100.0
      }

      actual = Utils.add_time_and_weather(form, gpx)

      expected = [
        %{lat: 52.5200, lon: 13.4050, time: 0, weather: "sunny"},
        %{lat: 52.5201, lon: 13.4051, time: 100, weather: "sunny"}
      ]

      assert actual == expected
    end
  end
end
