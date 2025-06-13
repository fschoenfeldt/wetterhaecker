import { Source, WeatherRecord } from "../types/brightsky";

export interface Weather {
  weather: WeatherRecord;
  source: Source;
}

export interface GpxExTrackPoint {
  lat: number;
  lon: number;
  ele: number;
  time: string;
}

export interface TrackPoint {
  index: number;
  point: {
    lat: number;
    lon: number;
  };
  date: Date;
}

export interface TrackPointWithMaybeWeather extends TrackPoint {
  "weather_point?": boolean;
  weather?: Weather;
}

export interface TrackPointWithWeather extends TrackPoint {
  "weather_point?": true;
  weather: Weather;
}

/**
 * Given a list of points, get only those with weather points
 */
export const filterWeatherTrackPoints = (
  points: TrackPointWithMaybeWeather[]
): TrackPointWithWeather[] =>
  points.filter(byWeatherPoint) as TrackPointWithWeather[];

/**
 * Check if a track point has weather data associated with it.
 */
export const byWeatherPoint = (point: TrackPointWithMaybeWeather): boolean =>
  point["weather_point?"] && point.weather !== undefined;
