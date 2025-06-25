defmodule Wetterhaecker.GpxTest do
  use ExUnit.Case, async: true

  alias Wetterhaecker.Gpx

  describe "get_from_preset/1" do
    test "returns :ok and a map with points and total_length for default preset" do
      actual = Gpx.get_from_preset()

      {:ok, %{points: points, total_length: total_length}} = actual
      assert is_list(points)
      assert not Enum.empty?(points)
      assert is_number(total_length) or match?({:error, _}, total_length)
    end

    test "returns error tuple for non-existent file" do
      actual = Gpx.get_from_preset("does_not_exist.gpx")
      expected = {:error, :enoent}
      assert actual == expected
    end
  end

  describe "get_from_path/1" do
    test "returns :ok and a map with points and total_length for valid path" do
      path = Path.join([:code.priv_dir(:wetterhaecker), "static", "gpx", "Langeoog.gpx"])
      actual = Gpx.get_from_path(path)

      {:ok, %{points: points, total_length: total_length}} = actual
      assert is_list(points)
      assert not Enum.empty?(points)
      assert is_number(total_length) or match?({:error, _}, total_length)
    end

    test "returns error tuple for non-existent file" do
      actual = Gpx.get_from_path("non_existent_file.gpx")
      expected = {:error, :enoent}
      assert actual == expected
    end
  end
end
