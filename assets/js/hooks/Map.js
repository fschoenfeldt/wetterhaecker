import leaflet from "leaflet";

import {
  setTileLayer,
  drawRoute,
  clearPreviousRoute,
  clearPreviousWeatherMarkers,
  weatherMarkers,
  routeDirectionMarkers,
} from "./map/mapUtils.js";

import { drawHighChart } from "./map/chartUtils.js";

export default {
  mounted() {
    console.debug("Map mounted");

    this.map = null;
    this.chart = null;
    this.points = [];
    this.route = null;
    this.weatherMarkers = [];

    this.handleEvent("map:init", (payload) => {
      console.debug("event: map:init", payload);

      const { lat, lon, zoom } = payload.initial;
      const { points } = payload;
      this.points = points;

      this.map = leaflet.map(this.el).setView([lat, lon], zoom);
      setTileLayer(this.map);

      // route
      this.route = drawRoute(this.map, this.points);
      this.map.fitBounds(this.route.routePolyline.getBounds());
    });

    this.handleEvent("map:drawGpxFileUpdate", (payload) => {
      console.debug("event: map:drawGpxFileUpdate", payload);
      const { points } = payload;

      // clear previous route
      clearPreviousRoute(this);

      // draw new route
      this.route = drawRoute(this.map, points);
      this.map.fitBounds(this.route.routePolyline.getBounds());
    });

    this.handleEvent("map:drawWeatherUpdate", (payload) => {
      console.debug("event: map:drawWeatherUpdate", payload);
      const { points } = payload;
      const weatherPoints = points.filter((point) => point["weather_point?"]);
      console.debug("weatherPoints", weatherPoints);

      clearPreviousWeatherMarkers(this);

      this.weatherMarkers = weatherMarkers(weatherPoints);
      this.weatherMarkers.forEach((marker) => marker.addTo(this.map));

      // graph init
      this.chart = drawHighChart({
        el: "chart",
        weatherPoints,
        mapHook: this,
      });
    });

    this.el.addEventListener("chart:pointClicked", (event) => {
      console.debug("event: chart:pointClicked", event.detail);
      const { x, y } = event.detail;

      // open the weather marker popup
      // x is the index of the point in the weatherMarkers array
      if (this.weatherMarkers[x]) {
        this.weatherMarkers[x].openPopup();
      }
    });
  },
};
