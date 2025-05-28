// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";
import Highcharts from "highcharts";

import leaflet from "leaflet";

window.leaflet = leaflet;

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

let Hooks = {};

Hooks.Map = {
  mounted() {
    console.debug("Map mounted");

    this.map = null;
    this.chart = null;
    this.weatherMarkers = [];

    this.handleEvent("map:init", (payload) => {
      console.debug("event: map:init", payload);

      const { lat, lon, zoom } = payload.initial;
      const { points } = payload;

      this.map = leaflet.map(this.el).setView([lat, lon], zoom);
      setTileLayer(this.map);

      // draw a polyline for the trackpoints
      const polyline = drawPolyline(this.map, trackpointsToPolyline(points), {
        color: "#146eff",
        weight: 4,
        opacity: 1,
      });

      // TODO: every now and then, display an arrow marker on the polyline
      //       to indicate the direction of the track

      // draw a circle for the start and end point
      const startPoint = points[0];
      const endPoint = points[points.length - 1];
      drawCircleMarker(this.map, [startPoint.lat, startPoint.lon]);
      drawCircleMarker(this.map, [endPoint.lat, endPoint.lon]);

      this.map.fitBounds(polyline.getBounds());
    });

    this.handleEvent("map:drawUpdate", (payload) => {
      console.debug("event: map:drawUpdate", payload);
      const { points } = payload;
      const weatherPoints = points.filter((point) => point["weather_point?"]);
      console.debug("weatherPoints", weatherPoints);

      clearPreviousWeatherMarkers(this);

      this.weatherMarkers = weatherMarkers(weatherPoints);
      this.weatherMarkers.forEach((marker) => marker.addTo(this.map));
      this.weatherMarkers[0].openPopup();

      // graph init
      this.chart = drawHighChart({
        el: "chart",
        weatherPoints,
      });
    });
  },
};

const drawHighChart = ({ el = "chart", weatherPoints }) => {
  return Highcharts.chart(el, {
    chart: {
      type: "line",
    },
    title: {
      text: `Temperature forecast, starting at ${new Date(
        weatherPoints[0].date
      ).toLocaleTimeString([], {
        hour: "2-digit",
        minute: "2-digit",
      })}`,
    },
    xAxis: {
      categories: weatherPoints.map((point) => {
        const date = new Date(point.date);

        // format time with HH:MM
        return date.toLocaleTimeString([], {
          hour: "2-digit",
          minute: "2-digit",
        });
      }),
    },
    yAxis: [
      {
        // Primary yAxis
        title: { text: "Temperature (°C)" },
      },
      {
        // Secondary yAxis
        title: { text: "Precipitation Probability (%)" },
        min: 0,
        max: 100,
        opposite: true,
      },
      {
        // third axis for precipitation amount
        title: { text: "Precipitation Amount (mm)" },
        min: 0,
        // opposite: true,
      },
      {
        // Fourth yAxis for wind speed
        title: { text: "Wind Speed (m/s)" },
        min: 0,
        opposite: true,
      },
    ],
    plotOptions: {
      line: {
        dataLabels: {
          enabled: true,
        },
        enableMouseTracking: false,
      },
    },
    series: [
      {
        name: "Route Temperature (°C)",
        type: "spline",
        color: "#ff5733",
        data: weatherPoints.map((point) => {
          return point?.weather?.weather?.temperature
            ? point.weather.weather.temperature
            : null;
        }),
      },
      {
        name: "Precipitation Probability (%)",
        type: "column",
        color: "rgba(0, 123, 255, 0.3)",
        data: weatherPoints.map((point) => {
          return point?.weather?.weather?.precipitation_probability
            ? point.weather.weather.precipitation_probability
            : null;
        }),
        yAxis: 1,
      },
      {
        name: "Precipitation Amount (mm)",
        color: "rgba(0, 123, 255, 0.7)",
        type: "column",
        data: weatherPoints.map((point) => {
          return point?.weather?.weather?.precipitation
            ? point.weather.weather.precipitation
            : null;
        }),
        yAxis: 2,
      },
      {
        name: "Wind Speed (m/s)",
        type: "spline",
        color: "#28a745",
        data: weatherPoints.map((point) => {
          return point?.weather?.weather?.wind_speed
            ? point.weather.weather.wind_speed
            : null;
        }),
        yAxis: 3,
        visible: false,
      },
    ],
    responsive: {
      rules: [
        {
          condition: {
            maxWidth: 500, // z.B. für Smartphones
          },
          chartOptions: {
            xAxis: {
              labels: {
                style: {
                  fontSize: "10px",
                },
                rotation: -45, // optional: Labels schräg stellen
              },
              title: { text: null }, // Achsentitel ausblenden
            },
            yAxis: [
              {
                // Temperatur
                title: { text: null },
                labels: { style: { fontSize: "10px" } },
              },
              {
                // Niederschlagswahrscheinlichkeit
                title: { text: null },
                labels: { style: { fontSize: "10px" } },
              },
              {
                // Niederschlagsmenge
                title: { text: null },
                labels: { style: { fontSize: "10px" } },
              },
              {
                // Wind
                title: { text: null },
                labels: { style: { fontSize: "10px" } },
              },
            ],
            legend: {
              layout: "vertical",
              // enabled: false, // optional: Legende ausblenden
            },
          },
        },
      ],
    },
  });
};

const weatherMarkers = (weatherPoints) => {
  return weatherPoints.map(weatherMarker);
};

const weatherMarker = ({
  index: index,
  point: { lat, lon },
  weather: { weather },
  date: date,
}) => {
  const weatherDate = new Date(date);

  // format time with DD:MM:YYYY HH:mm
  const formattedDate = weatherDate.toLocaleDateString([], {
    day: "2-digit",
    month: "2-digit",
    year: "numeric",
  });
  const formattedTime = weatherDate.toLocaleTimeString([], {
    hour: "2-digit",
    minute: "2-digit",
  });

  return L.marker([lat, lon], {
    icon: L.divIcon({
      className: "bg-transparent",
      iconSize: [48, 48],
      iconAnchor: [24, 48],
      html: `<div class="hero-map-pin-solid h-12 w-12 bg-blue-500"><span class="sr-only">${index}</span></div>`,
    }),
  }).bindPopup(
    weather
      ? `
              <div class="space-y-1">
                <div class="flex gap-x-4 items-center text-xl">
                  ${weatherIcon(weather.icon)}
                  ${weather.temperature}°C
                </div>
                <ul>
                  <li class="text-sm text-gray-500">${formattedDate} ${formattedTime}</li>
                  <li>${weather.precipitation_probability}% chance of rain</li>
                  <li>${weather.wind_speed} m/s wind speed</li>
                  <li>${weather.cloud_cover}% cloud cover</li>
                </ul>
              </div>
              `
      : `No weather data available for this point`,
    {
      autoClose: false,
      closeOnClick: false,
    }
  );
};

/**
 * returns html string with weather icon based on the icon code,
 * see: https://brightsky.dev/docs/#/operations/getWeather#response-body
 *
 * // TODO: there are many icons missing in this switch statement
 *
 * @param {String} icon
 * @returns html string with icon
 */
const weatherIcon = (icon) => {
  let iconClass;

  switch (icon) {
    case "clear-day":
      iconClass = "hero-sun-solid";
      break;
    case "clear-night":
      iconClass = "hero-moon-solid";
      break;
    case "partly-cloudy-day":
    case "partly-cloudy-night":
    case "cloudy":
    case "fog":
    case "wind":
      iconClass = "hero-cloud-solid";
      break;
    case "rain":
    case "snow":
    case "hail":
    case "thunderstorm":
      iconClass = "hero-cloud-arrow-down-solid";
      break;
    default:
      iconClass = "hero-question-mark-circle-solid";
  }

  return `<div class="${iconClass} h-8 w-8 bg-gray-500"><span class="sr-only">${icon}</span></div>`;
};

const clearPreviousWeatherMarkers = (that) => {
  // Remove previous sampled weather points from the map
  that.weatherMarkers.forEach((marker) => {
    that.map.removeLayer(marker);
  });
  that.weatherMarkers = [];
  console.debug("cleared weatherMarkers", that.weatherMarkers);
};

const setTileLayer = (map) => {
  L.tileLayer("https://tile.openstreetmap.org/{z}/{x}/{y}.png", {
    // L.tileLayer("http://{s}.tile.thunderforest.com/cycle/{z}/{x}/{y}.png", {
    maxZoom: 19,
    attribution:
      '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
    // '&copy; <a href="https://thunderforest.com">OpenCycleMap</a>',
  }).addTo(map);
};

const drawPopup = (
  map,
  latlngs,
  opts = {
    content: "",
  }
) => {
  return L.popup(latlngs, opts).openOn(map);
};

const drawCircleMarker = (
  map,
  latlng,
  opts = {
    color: "blue",
    radius: 10,
  }
) => {
  return L.circleMarker(latlng, opts).addTo(map);
};

const drawPolyline = (
  map,
  latlngs,
  opts = {
    color: "red",
  }
) => {
  return L.polyline(latlngs, opts).addTo(map);
};

/**
 * maps gpx trackpoints to leaflet polylines
 *
 * @param {Array} trackpoints
 */
const trackpointsToPolyline = (trackpoints) => {
  return trackpoints.map(({ ele, lat, lon, time }) => {
    return [lat, lon];
  });
};

let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;

// Allows to execute JS commands from the server
window.addEventListener("phx:js-exec", ({ detail }) => {
  document.querySelectorAll(detail.to).forEach((el) => {
    liveSocket.execJS(el, el.getAttribute(detail.attr));
  });
});
