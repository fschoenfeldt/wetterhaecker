defmodule WetterhaeckerWeb.MapsLive.IndexTest do
  use WetterhaeckerWeb.ConnCase, async: true

  import Hammox
  import Phoenix.Component, only: [to_form: 1]
  import Phoenix.LiveViewTest

  alias Wetterhaecker.Brightsky.WeatherMock
  alias WetterhaeckerWeb.Components.MapsLive.FormComponent

  setup :verify_on_exit!

  test "renders all components correctly", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/")

    assert html =~ "id=\"map\""
    assert html =~ "id=\"chart\""
    assert html =~ "id=\"weather-form\""
  end

  test "mount/3 initializes the map with preset GPX data", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    # initially we use a preset GPX file
    {:ok, gpx} = Wetterhaecker.Gpx.get_from_preset()

    expected = %{
      initial: %{
        lat: 53.551086,
        lon: 9.993682,
        zoom: 10
      },
      points: gpx.points
    }

    assert_push_event(
      view,
      "map:init",
      ^expected
    )
  end

  describe "handle_info :form_submitted" do
    test "handles gpx error and displays flash message", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      form = %{}
      gpx_result = {:error, "reason"}

      send(
        view.pid,
        {:form_submitted,
         %{
           form: form,
           gpx_result: gpx_result
         }}
      )

      html_after = render(view)

      assert html_after =~ "Failed to process GPX file"
    end

    @tag :todo
    test "handles form submission when no gpx file is provided", %{conn: _conn} do
    end

    test "handles form submission and updates map and chart", %{conn: conn} do
      # Mock the weather API call
      expect(WeatherMock, :get_weather, fn opts ->
        assert opts[:lat] == 53.551086
        assert opts[:lon] == 9.993682

        {:ok,
         %{
           sources: [%{id: "mock_source", distance: 42}],
           weather: [%{temperature: 21.0, precipitation: 0.1, cloud_cover: 50}]
         }}
      end)

      form =
        FormComponent.Form.changeset(
          %FormComponent.Form{},
          %{
            "total_length" => 100.0,
            "average_speed" => 20.0,
            "sampling_rate" => 60,
            "start_date_time" => DateTime.utc_now() |> DateTime.truncate(:second)
          }
        )
        |> to_form()

      {:ok, initial_gpx_file} = Wetterhaecker.Gpx.get_from_preset()

      gpx_result =
        {:ok,
         %{
           points: mock_track_points(),
           total_length: 100.0
         }}

      {:ok, view, _html} = live(conn, "/")

      # initial event when the view is mounted
      assert_push_event(view, "map:init", %{
        initial: %{
          lat: 53.551086,
          lon: 9.993682,
          zoom: 10
        },
        points: map_init_actual_points
      })

      assert map_init_actual_points == initial_gpx_file.points

      # send the form submission event
      send(
        view.pid,
        {:form_submitted,
         %{
           form: form,
           gpx_result: gpx_result
         }}
      )

      # the following events should be triggered to subcomponents
      assert_push_event(view, "map:drawGpxFileUpdate", %{
        points: map_draw_gpx_file_update_actual_points
      })

      map_draw_gpx_file_update_expected_points = mock_track_points()
      assert map_draw_gpx_file_update_actual_points == map_draw_gpx_file_update_expected_points

      assert_push_event(view, "chart:drawWeatherUpdate", %{
        points: chart_draw_weather_update_actual_points
      })

      chart_draw_weather_update_expected_points = mock_track_points_with_weather()

      assert Enum.map(
               chart_draw_weather_update_actual_points,
               &Map.delete(&1, :date)
             ) ==
               Enum.map(
                 chart_draw_weather_update_expected_points,
                 &Map.delete(&1, :date)
               )
    end
  end

  @spec mock_track_points() :: list(GpxEx.TrackPoint.t())
  defp mock_track_points do
    [
      %GpxEx.TrackPoint{lat: 53.551086, lon: 9.993682, ele: 0, time: nil},
      %GpxEx.TrackPoint{lat: 53.552086, lon: 9.994682, ele: 0, time: nil}
    ]
  end

  @spec mock_track_points_with_weather() :: list(Wetterhaecker.Gpx.Utils.track_point_with_weather())
  defp mock_track_points_with_weather do
    points = mock_track_points()
    weather = mock_weather_data()
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    [
      %{
        point: Enum.at(points, 0),
        index: 0,
        weather_point?: true,
        date: now,
        weather: weather
      },
      %{
        point: Enum.at(points, 1),
        index: 1,
        weather_point?: false,
        date: now,
        weather: nil
      }
    ]
  end

  @spec mock_weather_data() :: Wetterhaecker.Gpx.Utils.weather_data()
  defp mock_weather_data do
    %{
      source: %{id: "mock_source", distance: 42},
      weather: %{
        temperature: 21.0,
        precipitation: 0.1,
        cloud_cover: 50
      }
    }
  end
end
