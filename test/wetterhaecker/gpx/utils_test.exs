defmodule Wetterhaecker.Gpx.UtilsTest do
  use ExUnit.Case, async: true
  alias Wetterhaecker.Gpx.Utils
  alias WetterhaeckerWeb.MapsLive.Index.Form

  describe "route_length_km/1" do
    test "works with gpx map" do
      gpx = %{total_length: 12345.6789}
      assert Utils.route_length_km(gpx) == 12.35
    end

    test "works with float" do
      assert Utils.route_length_km(12345.6789) == 12.35
    end

    test "raises on integer" do
      assert_raise FunctionClauseError, fn ->
        Utils.route_length_km(12345)
      end
    end
  end

  describe "estimated_route_time/2" do
    test "works with gpx and form" do
      gpx = %{total_length: 12345.6789}

      form =
        Form.changeset(%Form{}, %{
          "average_speed" => 20.0,
          "sampling_rate" => 60
        })
        |> Phoenix.Component.to_form()

      assert Utils.estimated_route_time(gpx, form) == 37.0370367
    end

    test "works with float" do
      assert Utils.estimated_route_time(12345.6789, 10.0) == 74.0740734
    end

    test "raises on integer" do
      assert_raise FunctionClauseError, fn ->
        Utils.estimated_route_time(12345, 10)
      end
    end
  end
end
