export const weatherMarkers = (weatherPoints) => {
  return weatherPoints.map(weatherMarker);
};

export const routeDirectionMarkers = (points, drawEveryNthMarker = 1) => {
  return points
    .map((currentPoint, index) => {
      // skip the last point, as it has no next point to calculate direction
      if (index === points.length - 1) return null;

      const nextPoint = points[index + 1];
      return routeDirectionMarker({
        index: index + 1, // start from 1 for better readability
        currentPoint,
        nextPoint,
      });
    })
    .filter((marker) => marker !== null)
    .filter((_, index) => index % drawEveryNthMarker === 0);
};

const routeDirectionMarker = ({
  index,
  currentPoint: { lat, lon },
  nextPoint: { lat: nextLat, lon: nextLon },
}) => {
  // based on current and next point, calculate the direction in degrees
  // and rotate the marker accordingly
  // convert radians to degrees
  const directionDegreesInDegrees =
    (Math.atan2(nextLon - lon, nextLat - lat) * 180) / Math.PI;
  const directionDegrees = (directionDegreesInDegrees + 360) % 360;

  const style = `transform: rotate(${directionDegrees}deg);`;
  return L.marker([lat, lon], {
    icon: L.divIcon({
      className: "bg-transparent",
      iconSize: [24, 24],
      iconAnchor: [12, 12],
      html: `
        <div class="bg-white rounded-full">
          <div style="${style}" class="hero-arrow-up-circle-solid h-6 w-6 bg-gray-800">
            <span class="sr-only">
              ${index}
            </span>
          </div>
        </div>
      `,
    }),
  });
};

const weatherMarker = ({
  index,
  point: { lat, lon },
  weather: { weather },
  date,
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
      iconSize: [16, 16],
      iconAnchor: [8, 8],
      html: `
        <div class="h-4 w-4 bg-white rounded-full flex items-center justify-center" role="button">
          <div class="bg-blue-200 h-2 w-2 rounded-full">
            <span class="sr-only">
              show weather for point #${index}
            </span>
          </div>
        </div>
      `,
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
                  <li>${weather.precipitation}mm precipitation</li>
                  <li>Wind Direction: ${formattedWindDirection(
                    weather.wind_direction
                  )}</li>
                  <li>${weather.wind_speed} m/s wind speed</li>
                  <li>${weather.cloud_cover}% cloud cover</li>
                </ul>
              </div>
              `
      : `No weather data available for this point`,
    {
      autoClose: true,
      closeOnClick: false,
    }
  );
};

const formattedWindDirection = (windDirectionInDegrees) => {
  if (windDirectionInDegrees === null) return "N/A";

  if (windDirectionInDegrees < 0 || windDirectionInDegrees > 360) {
    throw new Error("Wind direction must be between 0 and 360 degrees");
  }

  const directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"];

  const index = Math.round((windDirectionInDegrees % 360) / 45) % 8;
  return directions[index];
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

    clearPreviousDirectionMarkers(that);

    that.route = null;
    console.debug("cleared previous route");
  }
};

const clearPreviousDirectionMarkers = (that) => {
  // Remove previous directionMarkers from the map
  that.route.directionMarkers.forEach((marker) => {
    that.map.removeLayer(marker);
  });

  that.route.directionMarkers = [];
  console.debug("cleared previous directionMarkers");
};

export const drawRoute = (map, points) => {
  // draw a polyline for the trackpoints
  const polyline = drawPolyline(map, trackpointsToPolyline(points), {
    color: "#1f2937",
    weight: 5,
    opacity: 1,
  });

  // TODO: every now and then, display an arrow marker on the polyline
  //       to indicate the direction of the track
  // draw a circle for the start and end point
  const directionMarkers = routeDirectionMarkers(
    points,
    Math.round(points.length / 10)
  );
  directionMarkers.forEach((marker) => {
    marker.addTo(map);
  });

  const startPoint = points[0];
  const endPoint = points[points.length - 1];
  const startMarker = drawCircleMarker(map, [startPoint.lat, startPoint.lon]);
  const endMarker = drawCircleMarker(map, [endPoint.lat, endPoint.lon]);

  return {
    routePolyline: polyline,
    startMarker,
    endMarker,
    directionMarkers,
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
