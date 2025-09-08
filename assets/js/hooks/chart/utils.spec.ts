import { expect, test } from "vitest";

// TODO: this is skipped because leaflet expects a DOM environment
//       either mock leaflet or run this test in a browser environment
// describe("weatherMarkers/1", () => {
//   test("should return an empty array when no weather points are provided", () => {
//     const weatherPoints = [] as TrackPointWithWeather[];

//     const actual = weatherMarkers(weatherPoints);

//     expect(actual).toEqual([]);
//   });
// });

// describe("clearPreviousRoute/1", () => {
//   test("should clear the previous route markers", () => {
//     const mapHook: MapHookInterface = {};
//   });
// });

test("expect true to be true", () => {
  expect(true).toBe(true);
});
