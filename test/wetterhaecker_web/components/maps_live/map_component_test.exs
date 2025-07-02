defmodule WetterhaeckerWeb.Components.MapsLive.MapComponentTest do
  use WetterhaeckerWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias WetterhaeckerWeb.Components.MapsLive.MapComponent

  # So far, `MapComponent` is a client side component only.
  # All testing should be done to the according js hooks.

  describe "mount/3" do
    test "initial render works" do
      actual = render_component(MapComponent)

      assert actual =~ ~s(id="map" phx-hook="Map")
    end
  end
end
