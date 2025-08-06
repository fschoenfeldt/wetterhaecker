defmodule Wetterhaecker.Gpx.UtilsTest do
  use ExUnit.Case, async: true

  import Hammox

  alias Wetterhaecker.Gpx.Utils
  alias Wetterhaecker.Weather.WeatherMock
  alias WetterhaeckerWeb.Components.MapsLive.FormComponent.Form

  # Make sure all mocks defined via Hammox implement the behaviour they're mocking
  setup :verify_on_exit!

  describe "route_length_km/1" do
    test "works with gpx map" do
      gpx = %{total_length: 12_345.6789}
      assert Utils.route_length_km(gpx) == 12.35
    end

    test "works with float" do
      assert Utils.route_length_km(12_345.6789) == 12.35
    end

    test "raises on integer" do
      assert_raise FunctionClauseError, fn ->
        Utils.route_length_km(12_345)
      end
    end
  end

  describe "estimated_route_time/2" do
    test "works with gpx and form" do
      gpx = %{total_length: 12_345.6789}

      form =
        Form.changeset(%Form{}, %{
          "average_speed" => 20.0,
          "sampling_rate" => 60
        })
        |> Phoenix.Component.to_form()

      assert Utils.estimated_route_time(gpx, form) == 37.0370367
    end

    test "works with float" do
      assert Utils.estimated_route_time(12_345.6789, 10.0) == 74.0740734
    end

    test "raises on integer" do
      assert_raise FunctionClauseError, fn ->
        Utils.estimated_route_time(12_345, 10)
      end
    end
  end

  describe "estimated_route_time_hours/2" do
    test "works with gpx and form" do
      gpx = %{total_length: 12_345.6789}

      form =
        Form.changeset(%Form{}, %{
          "average_speed" => 20.0,
          "sampling_rate" => 60
        })
        |> Phoenix.Component.to_form()

      actual = Utils.estimated_route_time(gpx, form)
      expected = 37.0370367

      assert actual == expected
    end

    test "works with float" do
      actual = Utils.estimated_route_time(12_345.6789, 10.0)
      expected = 74.0740734

      assert actual == expected
    end

    test "raises on integer" do
      assert_raise FunctionClauseError, fn ->
        Utils.estimated_route_time_hours(12_345, 10)
      end
    end
  end

  describe "hours_humanized/1" do
    test "works with hours" do
      actual = Utils.hours_humanized(1.25)
      expected = "1 hour, 15 minutes"

      assert actual == expected
    end

    test "truncates seconds" do
      actual = Utils.hours_humanized(1.26)
      expected = "1 hour, 15 minutes"

      assert actual == expected
    end
  end

  describe "wrap_with_index/1" do
    test "wraps points with index" do
      points = [
        %GpxEx.TrackPoint{lat: 53.551086, lon: 9.993682},
        %GpxEx.TrackPoint{lat: 53.552086, lon: 9.994682}
      ]

      wrapped_points = Utils.wrap_with_index(points)

      assert length(wrapped_points) == 2
      assert wrapped_points |> Enum.at(0) |> Map.get(:index) == 0
      assert wrapped_points |> Enum.at(1) |> Map.get(:index) == 1
    end
  end

  describe "update_points_time/3" do
    test "updates points with time" do
      points_with_indexes =
        [
          %GpxEx.TrackPoint{lat: 0.0, lon: 0.0},
          %GpxEx.TrackPoint{lat: 0.0, lon: 0.0},
          %GpxEx.TrackPoint{lat: 0.0, lon: 0.0}
        ]
        |> Utils.wrap_with_index()

      start_date = ~U[2000-01-01 00:00:00Z]

      actual = Utils.update_points_time(points_with_indexes, 60, start_date)

      expected = [
        %{
          point: %GpxEx.TrackPoint{lat: 0.0, lon: 0.0},
          index: 0,
          date: start_date
        },
        %{
          point: %GpxEx.TrackPoint{lat: 0.0, lon: 0.0},
          index: 1,
          date: DateTime.add(start_date, 30, :minute)
        },
        %{
          point: %GpxEx.TrackPoint{lat: 0.0, lon: 0.0},
          index: 2,
          date: DateTime.add(start_date, 60, :minute)
        }
      ]

      assert actual == expected
    end

    test "works with single point" do
      points_with_indexes =
        [
          %GpxEx.TrackPoint{lat: 0.0, lon: 0.0}
        ]
        |> Utils.wrap_with_index()

      start_date = ~U[2000-01-01 00:00:00Z]

      actual = Utils.update_points_time(points_with_indexes, 60, start_date)

      expected = [
        %{
          point: %GpxEx.TrackPoint{lat: 0.0, lon: 0.0},
          index: 0,
          date: start_date
        }
      ]

      assert actual == expected
    end
  end

  describe "sample_weather_points/3" do
    test "samples weather points correctly" do
      points = [
        %{point: %GpxEx.TrackPoint{lat: 0, lon: 0}, index: 0},
        %{point: %GpxEx.TrackPoint{lat: 0, lon: 0}, index: 1},
        %{point: %GpxEx.TrackPoint{lat: 0, lon: 0}, index: 2},
        %{point: %GpxEx.TrackPoint{lat: 0, lon: 0}, index: 3},
        %{point: %GpxEx.TrackPoint{lat: 0, lon: 0}, index: 4}
      ]

      estimated_time = 60
      sampling_rate = 30

      actual = Utils.sample_weather_points(points, estimated_time, sampling_rate)

      expected = [
        %{point: %GpxEx.TrackPoint{lat: 0, lon: 0}, index: 0, weather_point?: true},
        %{point: %GpxEx.TrackPoint{lat: 0, lon: 0}, index: 1, weather_point?: false},
        %{point: %GpxEx.TrackPoint{lat: 0, lon: 0}, index: 2, weather_point?: true},
        %{point: %GpxEx.TrackPoint{lat: 0, lon: 0}, index: 3, weather_point?: false},
        %{point: %GpxEx.TrackPoint{lat: 0, lon: 0}, index: 4, weather_point?: true}
      ]

      assert actual == expected
    end
  end

  describe "add_weather_data/1" do
    test "adds weather data to points that have weather_point? flag set to true" do
      # Setup test data
      test_date = ~U[2023-01-01 12:00:00Z]
      points = create_test_points(test_date)

      # Mock weather API responses
      setup_weather_api_mocks()

      # Call the function under test
      actual = Utils.add_weather_data(points)
      expected = create_expected_result(test_date)

      assert actual == expected
    end

    # Test helper functions
    defp create_test_points(test_date) do
      [
        create_point(53.551086, 9.993682, 0, true, test_date),
        create_point(53.552086, 9.994682, 1, false, DateTime.add(test_date, 30, :minute)),
        create_point(53.553086, 9.995682, 2, true, DateTime.add(test_date, 60, :minute))
      ]
    end

    defp create_point(lat, lon, index, is_weather_point, date) do
      %{
        point: %GpxEx.TrackPoint{lat: lat, lon: lon},
        index: index,
        weather_point?: is_weather_point,
        date: date
      }
    end

    defp setup_weather_api_mocks do
      # First weather point (index 0)
      expect(WeatherMock, :get_weather, fn opts ->
        assert opts[:lat] == 53.551086
        assert opts[:lon] == 9.993682

        {:ok,
         %{
           sources: [%{id: "test_source_1", distance: 100}],
           weather: [%{temperature: 20.0, precipitation: 0.0, cloud_cover: 10}]
         }}
      end)

      # Second weather point (index 2)
      expect(WeatherMock, :get_weather, fn opts ->
        assert opts[:lat] == 53.553086
        assert opts[:lon] == 9.995682

        {:ok,
         %{
           sources: [%{id: "test_source_2", distance: 200}],
           weather: [%{temperature: 22.0, precipitation: 5.0, cloud_cover: 80}]
         }}
      end)
    end

    defp create_expected_result(test_date) do
      [
        %{
          point: %GpxEx.TrackPoint{lat: 53.551086, lon: 9.993682},
          index: 0,
          weather_point?: true,
          date: test_date,
          weather: %{
            source: %{id: "test_source_1", distance: 100},
            weather: %{temperature: 20.0, precipitation: 0.0, cloud_cover: 10}
          }
        },
        %{
          point: %GpxEx.TrackPoint{lat: 53.552086, lon: 9.994682},
          index: 1,
          weather_point?: false,
          date: DateTime.add(test_date, 30, :minute),
          weather: nil
        },
        %{
          point: %GpxEx.TrackPoint{lat: 53.553086, lon: 9.995682},
          index: 2,
          weather_point?: true,
          date: DateTime.add(test_date, 60, :minute),
          weather: %{
            source: %{id: "test_source_2", distance: 200},
            weather: %{temperature: 22.0, precipitation: 5.0, cloud_cover: 80}
          }
        }
      ]
    end
  end
end
