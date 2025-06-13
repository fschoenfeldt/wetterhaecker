import { ChartHookInterface } from "../chart";
import { drawHighChart } from "./utils";
import {
  filterWeatherTrackPoints,
  TrackPointWithMaybeWeather,
} from "../../trackpoints";
import { buildEvent } from "../event";

interface DrawChartUpdatePayload {
  points: TrackPointWithMaybeWeather[];
}

export const drawWeatherUpdate = buildEvent(
  "chart:drawWeatherUpdate",
  function (this: ChartHookInterface, payload: DrawChartUpdatePayload) {
    this.chart = drawHighChart({
      el: "chart",
      weatherPoints: filterWeatherTrackPoints(payload.points),
    });
  }
);
