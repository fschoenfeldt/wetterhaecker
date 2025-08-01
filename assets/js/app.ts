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
import topbar from "topbar";

import mitt, { Emitter } from "mitt";
import Chart from "./hooks/chart";
import { Events } from "./hooks/event";
import Map from "./hooks/map";

const csrfToken = document
  .querySelector("meta[name='csrf-token']")
  ?.getAttribute("content");

const Hooks = {
  Chart,
  Map,
};

const liveSocket = new LiveSocket("/wetterhaecker/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", () => {
  topbar.show(300);
});
window.addEventListener("phx:page-loading-stop", () => {
  topbar.hide();
});

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;

declare global {
  interface Window {
    emitter: Emitter<Events>;
  }
}

const emitter: Emitter<Events> = mitt<Events>();
window.emitter = emitter;

// Allows to execute JS commands from the server
window.addEventListener("phx:js-exec", (event) => {
  const customEvent = event as CustomEvent<{ to: string; attr: string }>;
  const { detail } = customEvent;

  document.querySelectorAll(detail.to).forEach((el) => {
    // @ts-expect-error this is phoenix code
    liveSocket.execJS(el, el.getAttribute(detail.attr));
  });
});
