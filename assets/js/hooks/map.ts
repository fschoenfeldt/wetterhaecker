import leaflet from "leaflet";

import { Chart } from "highcharts";
import { Hook, ViewHookInterface } from "phoenix_live_view";
import {
  drawGpxFileUpdate,
  drawWeatherUpdate,
  mapInit,
} from "./map/eventHandler";
import { registerLiveViewEvent } from "./event";
import { GpxExTrackPoint } from "../trackpoints";

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
    console.debug("Map hook mounted");

    registerLiveViewEvent(this, mapInit);
    registerLiveViewEvent(this, drawGpxFileUpdate);
    registerLiveViewEvent(this, drawWeatherUpdate);

    window.emitter.on("chart:pointClicked", (payload) => {
      this.weatherMarkers[payload.x]?.openPopup();
    });
  },
};

export default mapHook;
