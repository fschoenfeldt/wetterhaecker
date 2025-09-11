import Chart from "./chart";
import Map from "./map";
// @ts-expect-error its okay because its works :)
import SaladUI from "../../../deps/salad_ui/assets/salad_ui/index.js";

export default {
  Chart,
  Map,
  // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
  SaladUI: SaladUI.SaladUIHook,
};
