import { ViewHookInterface } from "phoenix_live_view";

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
