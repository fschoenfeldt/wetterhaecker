import leaflet from "leaflet";
import { GpxExTrackPoint, MapHookInterface, WeatherTrackPoint } from "../map";
import { drawHighChart } from "./chartUtils";
import {
  clearPreviousRoute,
  clearPreviousWeatherMarkers,
  drawRoute,
  setTileLayer,
  weatherMarkers,
} from "./mapUtils";

interface MapInitPayload {
  initial: {
    lat: number;
    lon: number;
    zoom: number;
  };
  points: GpxExTrackPoint[];
}

export const mapInit = {
  name: "map:init",
  handler: function (this: MapHookInterface, payload: MapInitPayload) {
    console.debug("event: map:init", payload);

    const { lat, lon, zoom } = payload.initial;
    const { points } = payload;
    this.points = points;

    this.map = leaflet.map(this.el).setView([lat, lon], zoom);
    setTileLayer(this.map);

    // route
    this.route = drawRoute(this.map, this.points);
    this.map.fitBounds(this.route.routePolyline.getBounds());
  },
};

interface DrawGpxFileUpdatePayload {
  points: GpxExTrackPoint[];
}

export const mapDrawGpxFileUpdate = {
  name: "map:drawGpxFileUpdate",
  handler: function (
    this: MapHookInterface,
    payload: DrawGpxFileUpdatePayload,
  ) {
    console.debug("event: map:drawGpxFileUpdate", payload);
    const { points } = payload;

    // clear previous route
    clearPreviousRoute(this);

    // draw new route
    this.route = drawRoute(this.map, points);
    this.map?.fitBounds(this.route.routePolyline.getBounds());
  },
};

interface DrawWeatherUpdatePayload {
  points: WeatherTrackPoint[];
}

export const mapDrawWeatherUpdate = {
  name: "map:drawWeatherUpdate",
  handler: function (
    this: MapHookInterface,
    payload: DrawWeatherUpdatePayload,
  ) {
    console.debug("event: map:drawWeatherUpdate", payload);
    const { points } = payload;
    const weatherPoints = points.filter(
      (point: WeatherTrackPoint) => point["weather_point?"],
    );
    console.debug("weatherPoints", weatherPoints);

    clearPreviousWeatherMarkers(this);

    this.weatherMarkers = weatherMarkers(weatherPoints);
    this.weatherMarkers.forEach(
      (marker: leaflet.Marker) => this.map && marker.addTo(this.map),
    );

    // graph init
    this.chart = drawHighChart({
      el: "chart",
      weatherPoints,
      mapHook: this,
    });
  },
};
