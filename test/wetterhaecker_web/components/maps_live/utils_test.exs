defmodule WetterhaeckerWeb.Components.MapsLive.UtilsTest do
  use ExUnit.Case, async: true

  import Hammox
  import Phoenix.Component, only: [to_form: 1]

  alias Wetterhaecker.Weather.WeatherMock
  alias WetterhaeckerWeb.Components.MapsLive.Utils

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

      expect(WeatherMock, :get_weather, fn _ ->
        {:ok, %{weather: [%{weather: "sunny"}], sources: [%{id: "mock_source"}]}}
      end)

      actual = Utils.add_time_and_weather(form, gpx)

      # TODO DRY: these mock points are used in multiple tests, consider moving to a helper function
      expected = [
        %{
          weather: %{
            source: %{id: "mock_source"},
            weather: %{weather: "sunny"}
          },
          date: DateTime.utc_now(),
          index: 0,
          point: %GpxEx.TrackPoint{
            time: nil,
            lat: 52.52,
            lon: 13.405,
            ele: nil
          },
          weather_point?: true
        },
        %{
          weather: nil,
          date: DateTime.utc_now(),
          index: 1,
          point: %GpxEx.TrackPoint{
            time: nil,
            lat: 52.5201,
            lon: 13.4051,
            ele: nil
          },
          weather_point?: false
        },
        %{
          index: 2,
          date: DateTime.utc_now(),
          weather: nil,
          point: %GpxEx.TrackPoint{
            time: nil,
            lat: 52.5202,
            lon: 13.4052,
            ele: nil
          },
          weather_point?: false
        }
      ]

      assert Enum.map(actual, &Map.delete(&1, :date)) ==
               Enum.map(expected, &Map.delete(&1, :date))
    end
  end
end
