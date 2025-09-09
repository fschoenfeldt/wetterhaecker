import leaflet from "leaflet";
import { GpxExTrackPoint, TrackPointWithMaybeWeather } from "../../trackpoints";
import {
  clearPreviousRoute,
  clearPreviousWeatherMarkers,
  drawRoute,
  setTileLayer,
  weatherMarkers,
} from "./utils";
import { filterWeatherTrackPoints } from "../../trackpoints";
import { buildEvent } from "../../events";
import { MapHookInterface } from "../map";

interface MapInitPayload {
  initial: {
    lat: number;
    lon: number;
    zoom: number;
  };
  points: GpxExTrackPoint[];
}

export const mapInit = buildEvent(
  "map:init",
  function (this: MapHookInterface, payload: MapInitPayload) {
    const { lat, lon, zoom } = payload.initial;
    const { points } = payload;
    this.points = points;

    this.map = leaflet.map(this.el).setView([lat, lon], zoom);
    setTileLayer(this.map);

    this.route = drawRoute(this.map, this.points);
    this.map.fitBounds(this.route.routePolyline.getBounds());
  }
);

interface DrawGpxFileUpdatePayload {
  points: GpxExTrackPoint[];
}

export const drawGpxFileUpdate = buildEvent(
  "map:drawGpxFileUpdate",
  function (this: MapHookInterface, payload: DrawGpxFileUpdatePayload) {
    clearPreviousRoute(this);

    const { points } = payload;
    this.route = drawRoute(this.map, points);
    this.map?.fitBounds(this.route.routePolyline.getBounds());
  }
);

interface DrawWeatherUpdatePayload {
  points: TrackPointWithMaybeWeather[];
}

export const drawWeatherUpdate = buildEvent(
  "map:drawWeatherUpdate",
  function (this: MapHookInterface, payload: DrawWeatherUpdatePayload) {
    const { points } = payload;
    const weatherPoints = filterWeatherTrackPoints(points);
    console.debug("weatherPoints", weatherPoints);

    clearPreviousWeatherMarkers(this);

    this.weatherMarkers = weatherMarkers(weatherPoints);
    this.weatherMarkers.forEach(
      (marker: leaflet.Marker) => this.map && marker.addTo(this.map)
    );
  }
);
