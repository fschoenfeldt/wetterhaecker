import { Chart } from "highcharts";
import { Hook, ViewHookInterface } from "phoenix_live_view";
import { drawWeatherUpdate } from "./chart/eventHandler";
import { registerLiveViewEvent } from "../events";

export interface ChartHookInterface extends ViewHookInterface {
  chart: Chart | null;
}

// @ts-expect-error this is fine
interface ChartHook extends Hook, Pick<ChartHookInterface, "chart"> {
  mounted: (this: ChartHookInterface) => void;
}

const chartHook: ChartHook = {
  chart: null,

  mounted(this: ChartHookInterface) {
    console.debug("Chart hook mounted");

    registerLiveViewEvent(this, drawWeatherUpdate);
  },
};

export default chartHook;
