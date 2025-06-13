defmodule Wetterhaecker.Gpx.CalculateTest do
  use ExUnit.Case, async: true
  alias Wetterhaecker.Gpx.Calculate

  defmodule TrackPoint do
    defstruct [:lat, :lon, :ele]
  end

  # Helper to convert to GpxEx.TrackPoint.t()
  defp tp(lat, lon, ele), do: %TrackPoint{lat: lat, lon: lon, ele: ele}

  describe "calc_length/1" do
    test "raises for empty list" do
      assert_raise FunctionClauseError, fn ->
        Calculate.calc_length([])
      end
    end

    test "returns 0 for single point" do
      points = [tp(52.0, 13.0, 30.0)]
      assert Calculate.calc_length(points) == 0
    end

    test "calculates distance between two points (horizontal only)" do
      # Berlin (52.5200, 13.4050), Paris (48.8566, 2.3522)
      points = [
        tp(52.5200, 13.4050, 30.0),
        tp(48.8566, 2.3522, 30.0)
      ]

      dist = Calculate.calc_length(points)
      # Should be close to 878000 meters (878 km)
      assert_in_delta dist, 878_000, 2_000
    end

    test "calculates distance with elevation difference" do
      # Two points 1km apart horizontally, 100m elevation difference
      p1 = tp(0.0, 0.0, 0.0)
      # ~0.0089932 deg lat ≈ 1km at equator
      p2 = tp(0.0089932, 0.0, 100.0)
      points = [p1, p2]
      dist = Calculate.calc_length(points)
      # Pythagoras: sqrt(1000^2 + 100^2) ≈ 1004.99
      assert_in_delta dist, 1004.99, 1.0
    end

    test "calculates distance for multiple points" do
      points = [
        tp(0.0, 0.0, 0.0),
        tp(0.0, 0.01, 0.0),
        tp(0.01, 0.01, 0.0)
      ]

      dist = Calculate.calc_length(points)
      # Each segment ~1.11km, total ~2.22km
      assert_in_delta dist, 2_220, 20
    end
  end

  describe "calc_length_between_points/2" do
    test "returns 0 for identical points" do
      p = tp(10.0, 20.0, 100.0)
      assert Calculate.calc_length_between_points(p, p) == 0
    end

    test "calculates correct distance for known points" do
      p1 = tp(0.0, 0.0, 0.0)
      # ~1km east at equator
      p2 = tp(0.0, 0.0089932, 0.0)
      dist = Calculate.calc_length_between_points(p1, p2)
      assert_in_delta dist, 1000, 1
    end

    test "calculates correct distance with elevation" do
      p1 = tp(0.0, 0.0, 0.0)
      p2 = tp(0.0, 0.0089932, 100.0)
      dist = Calculate.calc_length_between_points(p1, p2)
      assert_in_delta dist, 1004.99, 1
    end
  end
end
