import Highcharts from "highcharts";
import { TrackPointWithWeather } from "../../trackpoints";

export type ChartMode = "temperature" | "precipitation" | "wind";

interface DrawHighChartParams {
  el?: string;
  weatherPoints: TrackPointWithWeather[];
  mode: ChartMode;
}

export const drawHighChart = ({
  el = "chart-canvas",
  weatherPoints,
  mode,
}: DrawHighChartParams) => {
  const categories = weatherPoints.map((point) =>
    dateToLocalTimeString(new Date(point.date))
  );

  const base: Highcharts.Options = {
    chart: { type: mode === "precipitation" ? "column" : "line" },
    title: {
      text: `${titleForMode(mode)} (start ${dateToLocalTimeString(
        weatherPoints[0].date
      )})`,
    },
    xAxis: { categories },
    plotOptions: {
      series: {
        point: {
          events: {
            click: function (event) {
              onPointClicked({ event, that: this });
            },
          },
        },
      },
    },
    responsive: { rules: responsiveRules() },
  };

  switch (mode) {
    case "temperature":
      return Highcharts.chart(el, {
        ...base,
        yAxis: { title: { text: "Temperature (°C)" } },
        series: [
          {
            name: "Temperature (°C)",
            type: "spline",
            color: "#ff5733",
            data: weatherPoints.map(
              (p) => p.weather.weather.temperature ?? null
            ),
          },
        ],
      });
    case "precipitation":
      return Highcharts.chart(el, {
        ...base,
        yAxis: [
          { title: { text: "Precipitation Amount (mm)" }, min: 0 },
          {
            title: { text: "Probability (%)" },
            min: 0,
            max: 100,
            opposite: true,
          },
        ],
        series: [
          {
            name: "Amount (mm)",
            type: "column",
            color: "rgba(0,123,255,0.7)",
            data: weatherPoints.map(
              (p) => p.weather.weather.precipitation ?? null
            ),
          },
          {
            name: "Probability (%)",
            type: "spline",
            yAxis: 1,
            color: "#0056b3",
            data: weatherPoints.map(
              (p) => p.weather.weather.precipitation_probability ?? null
            ),
          },
        ],
      });
    case "wind":
      return Highcharts.chart(el, {
        ...base,
        yAxis: [
          { title: { text: "Wind Speed (m/s)" }, min: 0 },
          {
            title: { text: "Direction (°)" },
            min: 0,
            max: 360,
            opposite: true,
          },
        ],
        series: [
          {
            name: "Speed (m/s)",
            type: "spline",
            color: "#28a745",
            data: weatherPoints.map(
              (p) => p.weather.weather.wind_speed ?? null
            ),
          },
          {
            name: "Direction (°)",
            type: "line",
            yAxis: 1,
            color: "#6c757d",
            data: weatherPoints.map(
              (p) => p.weather.weather.wind_direction ?? null
            ),
          },
        ],
      });
  }
};

function titleForMode(mode: ChartMode) {
  switch (mode) {
    case "temperature":
      return "Temperature";
    case "precipitation":
      return "Precipitation";
    case "wind":
      return "Wind";
  }
}

function responsiveRules(): Highcharts.ResponsiveRulesOptions[] {
  return [
    {
      condition: { maxWidth: 500 },
      chartOptions: {
        xAxis: {
          labels: { style: { fontSize: "10px" }, rotation: -45 },
          title: { text: null },
        },
        legend: { layout: "vertical" },
      },
    },
  ];
}

interface OnPointClickedParams {
  event: Highcharts.PointClickEventObject;
  that: Highcharts.Point;
}

function onPointClicked({ that }: OnPointClickedParams) {
  const { x } = that;

  window.emitter.emit("chart:pointClicked", {
    x,
  });
}

function dateToLocalTimeString(dateTime: number | string | Date): string {
  return new Date(dateTime).toLocaleTimeString("de-DE", {
    hour: "2-digit",
    minute: "2-digit",
    // timeZone: "UTC",
  });
}
