import Highcharts from "highcharts";
import { WeatherTrackPoint } from "../map";

interface DrawHighChartParams {
  el?: string; // Element ID where the chart will be drawn
  weatherPoints: WeatherTrackPoint[];
  // TODO: get proper type for mapHook
  mapHook: {
    el: HTMLElement; // The map element to which the chart is related
  };
}

export const drawHighChart = ({
  el = "chart",
  weatherPoints,
  mapHook,
}: DrawHighChartParams) => {
  return Highcharts.chart(el, {
    chart: {
      type: "line",
    },
    title: {
      text: `Temperature forecast, starting at ${new Date(
        weatherPoints[0].date
      ).toLocaleTimeString("de-DE", {
        hour: "2-digit",
        minute: "2-digit",
        timeZone: "UTC",
      })}`,
    },
    xAxis: {
      categories: weatherPoints.map((point) => {
        // Assume point.date is in MESZ (+02:00)
        const date = new Date(point.date);

        return date.toLocaleTimeString("de-DE", {
          hour: "2-digit",
          minute: "2-digit",
          timeZone: "UTC",
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
        max: 5,
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
      series: {
        point: {
          events: {
            click: function (event) {
              onPointClicked({
                event,
                that: this,
                mapHook,
              });
            },
          },
        },
      },
    },
    series: [
      {
        name: "Temperature (°C)",
        type: "spline",
        color: "#ff5733",
        data: weatherPoints.map((point) => {
          return point.weather.weather.temperature ?? null;
        }),
      },
      {
        name: "Precipitation Probability (%)",
        type: "column",
        color: "rgba(0, 123, 255, 0.3)",
        data: weatherPoints.map((point) => {
          return point.weather.weather.precipitation_probability ?? null;
        }),
        yAxis: 1,
      },
      {
        name: "Precipitation Amount (mm)",
        color: "rgba(0, 123, 255, 0.7)",
        type: "column",
        data: weatherPoints.map((point) => {
          return point.weather.weather.precipitation ?? null;
        }),
        yAxis: 2,
      },
      {
        name: "Wind Speed (m/s)",
        type: "spline",
        color: "#28a745",
        data: weatherPoints.map((point) => {
          return point.weather.weather.wind_speed ?? null;
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

interface OnPointClickedParams {
  event: Highcharts.PointClickEventObject;
  that: Highcharts.Point;
  mapHook: {
    el: HTMLElement; // The map element to which the chart is related
  };
}

function onPointClicked({ that, mapHook }: OnPointClickedParams) {
  // console.debug({ event, that, mapHook });
  const { x, y } = that;

  const customEvent = new CustomEvent("chart:pointClicked", {
    detail: {
      x,
      y,
    },
  });
  mapHook.el.dispatchEvent(customEvent);

  // console.log("mouseOver on line series", chart);
}
