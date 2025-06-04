export const weatherMarkers = (weatherPoints) => {
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

export const clearPreviousWeatherMarkers = (that) => {
  // Remove previous sampled weather points from the map
  that.weatherMarkers.forEach((marker) => {
    that.map.removeLayer(marker);
  });
  that.weatherMarkers = [];
  console.debug("cleared weatherMarkers", that.weatherMarkers);
};

export const setTileLayer = (map) => {
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

export const clearPreviousRoute = (that) => {
  // Remove previous route from the map
  if (that.route) {
    that.map.removeLayer(that.route.routePolyline);
    that.map.removeLayer(that.route.startMarker);
    that.map.removeLayer(that.route.endMarker);
    that.route = null;
    console.debug("cleared previous route");
  }
};

export const getRoute = (map, points) => {
  // draw a polyline for the trackpoints
  const polyline = drawPolyline(map, trackpointsToPolyline(points), {
    color: "#146eff",
    weight: 4,
    opacity: 1,
  });

  // TODO: every now and then, display an arrow marker on the polyline
  //       to indicate the direction of the track
  // draw a circle for the start and end point
  const startPoint = points[0];
  const endPoint = points[points.length - 1];
  const startMarker = drawCircleMarker(map, [startPoint.lat, startPoint.lon]);
  const endMarker = drawCircleMarker(map, [endPoint.lat, endPoint.lon]);

  return {
    routePolyline: polyline,
    startMarker,
    endMarker,
  };
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
