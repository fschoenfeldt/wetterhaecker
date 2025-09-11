import { ChartHookInterface } from ".";
import { drawHighChart, ChartMode } from "./utils";
import {
  filterWeatherTrackPoints,
  TrackPointWithMaybeWeather,
} from "../../trackpoints";
import { buildEvent } from "../../events";

interface DrawChartUpdatePayload {
  points: TrackPointWithMaybeWeather[];
  mode?: ChartMode;
}

export const drawWeatherUpdate = buildEvent(
  "chart:drawWeatherUpdate",
  function (this: ChartHookInterface, payload: DrawChartUpdatePayload) {
    const weatherPoints = filterWeatherTrackPoints(payload.points);
    this.lastPoints = payload.points;
    const mode: ChartMode = payload.mode ?? this.currentMode;
    this.chart = drawHighChart({ weatherPoints, mode });
  }
);
