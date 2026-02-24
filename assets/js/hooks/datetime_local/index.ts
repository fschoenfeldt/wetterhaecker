import { Hook, ViewHookInterface } from "phoenix_live_view";

interface DatetimeLocalHookInterface extends ViewHookInterface {
  el: HTMLInputElement;
}

// @ts-expect-error this is fine
interface DatetimeLocalHook
  extends Hook,
    Pick<DatetimeLocalHookInterface, never> {
  mounted: (this: DatetimeLocalHookInterface) => void;
  updated: (this: DatetimeLocalHookInterface) => void;
}

/**
 * Formats a Date to the "YYYY-MM-DDTHH:mm" string expected by datetime-local inputs,
 * using the browser's local time.
 * The "sv-SE" locale produces "YYYY-MM-DD HH:MM" which only needs a space→T replacement.
 */
function toDatetimeLocalString(date: Date): string {
  return date
    .toLocaleString("sv-SE", {
      year: "numeric",
      month: "2-digit",
      day: "2-digit",
      hour: "2-digit",
      minute: "2-digit",
    })
    .replace(" ", "T");
}

/**
 * Converts the UTC-based value rendered by the server into the browser's local time
 * so the user always sees and enters times in their own timezone.
 */
function convertUtcToLocal(input: HTMLInputElement): void {
  const utcValue = input.value;
  if (!utcValue) return;

  // The server renders the datetime as a UTC string (e.g. "2026-02-24T12:30").
  // Appending ":00Z" makes the Date constructor interpret it as UTC.
  const utcDate = new Date(utcValue + ":00Z");
  if (!isNaN(utcDate.getTime())) {
    input.value = toDatetimeLocalString(utcDate);
  }
}

/**
 * Writes the browser's UTC offset in minutes into the hidden offset field.
 * Date.getTimezoneOffset() returns UTC − local in minutes (negative for UTC+ zones).
 */
function updateOffsetField(): void {
  const offsetInput = document.getElementById(
    "form_timezone_offset"
  ) as HTMLInputElement | null;
  if (offsetInput) {
    offsetInput.value = String(new Date().getTimezoneOffset());
  }
}

const datetimeLocalHook: DatetimeLocalHook = {
  mounted(this: DatetimeLocalHookInterface) {
    updateOffsetField();
    convertUtcToLocal(this.el);
  },

  updated(this: DatetimeLocalHookInterface) {
    // Re-convert whenever the server pushes a new UTC value (e.g. after a
    // successful form submission that re-renders the field).
    convertUtcToLocal(this.el);
  },
};

export default datetimeLocalHook;
