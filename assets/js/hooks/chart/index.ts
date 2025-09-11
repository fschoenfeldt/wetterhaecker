import { Chart } from "highcharts";
import { Hook, ViewHookInterface } from "phoenix_live_view";
import { drawWeatherUpdate } from "./eventHandler";
import { ChartMode } from "./utils";
import { registerLiveViewEvent } from "../../events";

export interface ChartHookInterface extends ViewHookInterface {
  chart: Chart | null;
  currentMode: ChartMode;
  lastPoints: unknown[] | null;
}

// @ts-expect-error this is fine
interface ChartHook
  extends Hook,
    Pick<ChartHookInterface, "chart" | "currentMode" | "lastPoints"> {
  mounted: (this: ChartHookInterface) => void;
}

const chartHook: ChartHook = {
  chart: null,
  currentMode: "temperature",
  lastPoints: null,

  mounted(this: ChartHookInterface) {
    console.debug("Chart hook mounted");

    registerLiveViewEvent(this, drawWeatherUpdate);
    const container = this.el.querySelector("[data-chart-mode-items]");
    if (container) {
      container.addEventListener("click", (ev) => {
        const target = ev.target as HTMLElement;
        const mode = target
          .closest("[data-chart-mode]")
          ?.getAttribute("data-chart-mode") as ChartMode | null;
        if (!mode) return;
        this.currentMode = mode;
        const label = this.el.querySelector("[data-chart-current-label]");
        if (label) label.textContent = labelForMode(mode);
        if (this.lastPoints) {
          const emitter = (
            window as unknown as {
              emitter?: { emit: (event: string, payload: unknown) => void };
            }
          ).emitter;
          emitter?.emit("chart:drawWeatherUpdate", {
            points: this.lastPoints,
            mode,
          });
        }
      });
    }
  },
};

function labelForMode(mode: ChartMode) {
  switch (mode) {
    case "temperature":
      return "Temperature";
    case "precipitation":
      return "Precipitation";
    case "wind":
      return "Wind";
  }
}

export default chartHook;
