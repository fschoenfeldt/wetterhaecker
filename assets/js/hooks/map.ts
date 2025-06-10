import leaflet from "leaflet";

import { Chart } from "highcharts";
import { Hook, ViewHookInterface } from "phoenix_live_view";
import {
  mapDrawGpxFileUpdate,
  mapDrawWeatherUpdate,
  mapInit,
} from "./map/eventHandler";
import { Source, WeatherRecord } from "../types/brightsky";

export interface GpxExTrackPoint {
  lat: number;
  lon: number;
  ele: number;
  time: string;
}

export interface WeatherTrackPoint {
  index: number;
  point: {
    lat: number;
    lon: number;
  };
  "weather_point?": boolean;
  date: Date;
  weather: {
    weather: WeatherRecord;
    source: Source;
  };
}

export interface MapHookInterface extends ViewHookInterface {
  map: leaflet.Map | null;
  chart: Chart | null;
  points: GpxExTrackPoint[] | [];
  route: {
    routePolyline: leaflet.Polyline;
    startMarker: leaflet.CircleMarker;
    endMarker: leaflet.CircleMarker;
    directionMarkers: leaflet.Marker[];
  } | null;
  weatherMarkers: leaflet.Marker[];
}

// @ts-expect-error this is fine
interface MapHook
  extends Hook,
    Pick<
      MapHookInterface,
      "map" | "chart" | "points" | "route" | "weatherMarkers"
    > {
  mounted: (this: MapHookInterface) => void;
}

const mapHook: MapHook = {
  map: null,
  chart: null,
  points: [],
  route: null,
  weatherMarkers: [],

  mounted(this: MapHookInterface) {
    console.debug("Map mounted");

    this.handleEvent(mapInit.name, mapInit.handler.bind(this));

    this.handleEvent(
      mapDrawGpxFileUpdate.name,
      mapDrawGpxFileUpdate.handler.bind(this),
    );

    this.handleEvent(
      mapDrawWeatherUpdate.name,
      mapDrawWeatherUpdate.handler.bind(this),
    );

    interface ChartPointClickedPayload {
      x: number; // index of the point in the weatherMarkers array
    }

    this.el.addEventListener("chart:pointClicked", (event: Event) => {
      const customEvent = event as CustomEvent<ChartPointClickedPayload>;
      console.debug("event: chart:pointClicked", customEvent.detail);
      const { x } = customEvent.detail;

      // open the weather marker popup
      // x is the index of the point in the weatherMarkers array
      if (this.weatherMarkers[x]) {
        this.weatherMarkers[x].openPopup();
      }
    });
  },
};

export default mapHook;
