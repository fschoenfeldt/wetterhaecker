import mitt, { Emitter } from "mitt";
import { ViewHookInterface } from "phoenix_live_view";

declare global {
  interface Window {
    emitter: Emitter<Events>;
  }
}

// We register our custom client side events here so they're typed.
// eslint-disable-next-line @typescript-eslint/consistent-type-definitions
export type Events = {
  "chart:pointClicked": { x: number };
};

export const buildEvent = <T, P>(
  name: string,
  handler: (this: T, payload: P) => void
) => {
  return {
    name,
    handler(this: T, payload: P) {
      console.debug(`event: ${name}`, { payload });
      handler.call(this, payload);
    },
  };
};

export function registerEvents(browserWindow: Window) {
  const emitter: Emitter<Events> = mitt<Events>();
  browserWindow.emitter = emitter;
}

// eslint-disable-next-line @typescript-eslint/no-unnecessary-type-parameters
export function registerLiveViewEvent<T extends ViewHookInterface, P = unknown>(
  that: T,
  event: {
    name: string;
    handler: (this: T, payload: P) => void;
  }
): void {
  that.handleEvent(event.name, event.handler.bind(that));
  console.debug(`Event handler registered for ${event.name}`);
}
