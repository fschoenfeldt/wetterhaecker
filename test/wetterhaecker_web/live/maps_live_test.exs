defmodule WetterhaeckerWeb.MapsLive.IndexTest do
  alias GpxEx.TrackPoint
  use WetterhaeckerWeb.ConnCase

  # import Phoenix.LiveViewTest
  import WetterhaeckerWeb.MapsLive.Index

  describe "estimated_time_and_sampling_rate_to_points/3" do
    test "returns the correct points" do
      estimated_time = 234.5
      sampling_rate = 60.0

      points =
        1..12
        |> Enum.map(fn i ->
          %TrackPoint{
            lat: i,
            lon: i,
            ele: i
          }
        end)

      actual =
        estimated_time_and_sampling_rate_to_points(
          points,
          estimated_time,
          sampling_rate
        )

      expected = [
        {%TrackPoint{lat: 1, lon: 1, ele: 1, time: nil}, 0},
        {%TrackPoint{lat: 4, lon: 4, ele: 4, time: nil}, 3},
        {%TrackPoint{lat: 7, lon: 7, ele: 7, time: nil}, 6},
        {%TrackPoint{lat: 10, lon: 10, ele: 10, time: nil}, 9}
      ]

      assert actual == expected
    end
  end
end
