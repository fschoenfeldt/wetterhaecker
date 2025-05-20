defmodule WetterhaeckerWeb.MapsLive.Index do
  use WetterhaeckerWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    # {:ok, stream(socket, :map, Tracks.list_map())}
    points = Wetterhaecker.Gpx.points("Langeoog.gpx")

    if connected?(socket) do
      socket =
        push_event(socket, "map:init", %{
          initial: %{
            lat: 53.551086,
            lon: 9.993682,
            zoom: 10
          },
          points: Enum.map(points, &Map.from_struct/1)
        })

      {:ok, socket}
    else
      {:ok, socket}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h1>GPX Map</h1>
      <div id="map" phx-hook="Map" phx-update="ignore" class="h-96"></div>
    </div>
    """
  end
end
