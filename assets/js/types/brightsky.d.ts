import type {
  OpenAPIClient,
  Parameters,
  UnknownParamsObject,
  OperationResponse,
  AxiosRequestConfig,
} from 'openapi-client-axios';

declare namespace Components {
    namespace Schemas {
        /**
         * Alert
         */
        export interface Alert {
            /**
             * Id
             * Bright Sky-internal ID for this alert
             * example:
             * 279977
             */
            id?: number;
            /**
             * Alert Id
             * Unique CAP message identifier
             * example:
             * 2.49.0.0.276.0.DWD.PVW.1691344680000.2cf9fad6-dc83-44ba-9e88-f2827439da59
             */
            alert_id?: string;
            /**
             * Status
             * Alert status
             */
            status?: "actual" | "test";
            /**
             * Effective
             * Alert issue time
             * example:
             * 2023-08-06T17:58:00+00:00
             */
            effective?: string; // date-time
            /**
             * Onset
             * Expected event begin time
             * example:
             * 2023-08-07T08:00:00+00:00
             */
            onset?: string; // date-time
            /**
             * Expires
             * Expected event end time
             * example:
             * 2023-08-07T19:00:00+00:00
             */
            expires?: string | null; // date-time
            /**
             * Category
             * Alert category, meteorological message (`met`) or public health related message (`health`)
             */
            category?: "met" | "health";
            /**
             * Response Type
             * Code denoting type of action recommended for target audience
             */
            response_type?: "prepare" | "allclear" | "none" | "monitor";
            /**
             * Urgency
             * Alert time frame
             */
            urgency?: "immediate" | "future";
            /**
             * Severity
             * Alert severity
             */
            severity?: "minor" | "moderate" | "severe" | "extreme";
            /**
             * Certainty
             * Alert certainty
             */
            certainty?: "observed" | "likely";
            /**
             * Event Code
             * DWD event code
             * example:
             * 51
             */
            event_code?: number | null;
            /**
             * Event En
             * Label for DWD event code (English)
             * example:
             * wind gusts
             */
            event_en?: string | null;
            /**
             * Event De
             * Label for DWD event code (German)
             * example:
             * WINDBÖEN
             */
            event_de?: string | null;
            /**
             * Headline En
             * Alert headline (English)
             * example:
             * Official WARNING of WIND GUSTS
             */
            headline_en?: string;
            /**
             * Headline De
             * Alert headline (German)
             * example:
             * Amtliche WARNUNG vor WINDBÖEN
             */
            headline_de?: string;
            /**
             * Description En
             * Alert description (English)
             * example:
             * There is a risk of wind gusts (level 1 of 4).
             * Max. gusts: 50-60 km/h; Wind direction: west; Increased gusts: near showers and in exposed locations < 70 km/h
             */
            description_en?: string;
            /**
             * Description De
             * Alert description (German)
             * example:
             * Es treten Windböen mit Geschwindigkeiten zwischen 50 km/h (14 m/s, 28 kn, Bft 7) und 60 km/h (17 m/s, 33 kn, Bft 7) aus westlicher Richtung auf. In Schauernähe sowie in exponierten Lagen muss mit Sturmböen bis 70 km/h (20 m/s, 38 kn, Bft 8) gerechnet werden.
             */
            description_de?: string;
            /**
             * Instruction En
             * Additional instructions and safety advice (English)
             * example:
             * NOTE: Be aware of the following possible dangers: The downpours can cause temporary traffic disruption.
             */
            instruction_en?: string | null;
            /**
             * Instruction De
             * Additional instructions and safety advice (German)
             * example:
             * ACHTUNG! Hinweis auf mögliche Gefahren: Während des Platzregens sind kurzzeitig Verkehrsbehinderungen möglich.
             */
            instruction_de?: string | null;
        }
        /**
         * AlertsResponse
         */
        export interface AlertsResponse {
            /**
             * Alerts
             */
            alerts?: /* Alert */ Alert[];
            location?: /* Location */ Location;
        }
        /**
         * CurrentWeatherRecord
         */
        export interface CurrentWeatherRecord {
            /**
             * Timestamp
             * ISO 8601-formatted timestamp of this weather record
             * example:
             * 2023-08-07T12:30:00+00:00
             */
            timestamp?: string; // date-time
            /**
             * Source Id
             * Bright Sky source ID for this record
             * example:
             * 238685
             */
            source_id?: number;
            /**
             * Cloud Cover
             * Total cloud cover at timestamp
             * example:
             * 12.1
             */
            cloud_cover?: number | null;
            /**
             * Condition
             * Current weather conditions. Unlike the numerical parameters, this field is not taken as-is from the raw data (because it does not exist), but is calculated from different fields in the raw data as a best effort. Not all values are available for all source types.
             */
            condition?: "dry" | "fog" | "rain" | "sleet" | "snow" | "hail" | "thunderstorm";
            /**
             * Dew Point
             * Dew point at timestamp, 2 m above ground
             * example:
             * -2.5
             */
            dew_point?: number | null;
            /**
             * Icon
             * Icon alias suitable for the current weather conditions. Unlike the numerical parameters, this field is not taken as-is from the raw data (because it does not exist), but is calculated from different fields in the raw data as a best effort. Not all values are available for all source types.
             */
            icon?: "clear-day" | "clear-night" | "partly-cloudy-day" | "partly-cloudy-night" | "cloudy" | "fog" | "wind" | "rain" | "sleet" | "snow" | "hail" | "thunderstorm";
            /**
             * Pressure Msl
             * Atmospheric pressure at timestamp, reduced to mean sea level
             * example:
             * 1015.1
             */
            pressure_msl?: number | null;
            /**
             * Relative Humidity
             * Relative humidity at timestamp
             * example:
             * 40
             */
            relative_humidity?: number | null;
            /**
             * Temperature
             * Air temperature at timestamp, 2 m above the ground
             * example:
             * 10.6
             */
            temperature?: number | null;
            /**
             * Visibility
             * Visibility at timestamp
             * example:
             * 50000
             */
            visibility?: number | null;
            /**
             * Fallback Source Ids
             * Object mapping meteorological parameters to the source IDs of alternative sources that were used to fill up missing values in the main source
             * example:
             * {
             *   "pressure_msl": 11831,
             *   "wind_speed_30": 11831
             * }
             */
            fallback_source_ids?: {
                [name: string]: any;
            };
            /**
             * Precipitation 10
             * Total precipitation during previous 10 minutes
             * example:
             * 0.8
             */
            precipitation_10?: number | null;
            /**
             * Precipitation 30
             * Total precipitation during previous 30 minutes
             * example:
             * 1.2
             */
            precipitation_30?: number | null;
            /**
             * Precipitation 60
             * Total precipitation during previous 60 minutes
             * example:
             * 1.8
             */
            precipitation_60?: number | null;
            /**
             * Solar 10
             * Solar irradiation during previous 10 minutes
             * example:
             * 0.081
             */
            solar_10?: number | null;
            /**
             * Solar 30
             * Solar irradiation during previous 30 minutes
             * example:
             * 0.207
             */
            solar_30?: number | null;
            /**
             * Solar 60
             * Solar irradiation during previous 60 minutes
             * example:
             * 0.48
             */
            solar_60?: number | null;
            /**
             * Sunshine 30
             * Sunshine duration during previous 30 minutes
             * example:
             * 28
             */
            sunshine_30?: number | null;
            /**
             * Sunshine 60
             * Sunshine duration during previous 60 minutes
             * example:
             * 52
             */
            sunshine_60?: number | null;
            /**
             * Wind Direction 10
             * Mean wind direction during previous 10 minutes, 10 m above the ground
             * example:
             * 70
             */
            wind_direction_10?: number | null;
            /**
             * Wind Direction 30
             * Mean wind direction during previous 30 minutes, 10 m above the ground
             * example:
             * 70
             */
            wind_direction_30?: number | null;
            /**
             * Wind Direction 60
             * Mean wind direction during previous 60 minutes, 10 m above the ground
             * example:
             * 70
             */
            wind_direction_60?: number | null;
            /**
             * Wind Speed 10
             * Mean wind speed during previous 10 minutes, 10 m above the ground
             * example:
             * 12.6
             */
            wind_speed_10?: number | null;
            /**
             * Wind Speed 30
             * Mean wind speed during previous 30 minutes, 10 m above the ground
             * example:
             * 12.6
             */
            wind_speed_30?: number | null;
            /**
             * Wind Speed 60
             * Mean wind speed during previous 60 minutes, 10 m above the ground
             * example:
             * 12.6
             */
            wind_speed_60?: number | null;
            /**
             * Wind Gust Direction 10
             * Direction of maximum wind gust during previous 10 minutes, 10 m above the ground
             * example:
             * 50
             */
            wind_gust_direction_10?: number | null;
            /**
             * Wind Gust Direction 30
             * Direction of maximum wind gust during previous 30 minutes, 10 m above the ground
             * example:
             * 50
             */
            wind_gust_direction_30?: number | null;
            /**
             * Wind Gust Direction 60
             * Direction of maximum wind gust during previous 60 minutes, 10 m above the ground
             * example:
             * 50
             */
            wind_gust_direction_60?: number | null;
            /**
             * Wind Gust Speed 10
             * Speed of maximum wind gust during previous 10 minutes, 10 m above the ground
             * example:
             * 33.5
             */
            wind_gust_speed_10?: number | null;
            /**
             * Wind Gust Speed 30
             * Speed of maximum wind gust during previous 30 minutes, 10 m above the ground
             * example:
             * 33.5
             */
            wind_gust_speed_30?: number | null;
            /**
             * Wind Gust Speed 60
             * Speed of maximum wind gust during previous 60 minutes, 10 m above the ground
             * example:
             * 33.5
             */
            wind_gust_speed_60?: number | null;
        }
        /**
         * CurrentWeatherResponse
         */
        export interface CurrentWeatherResponse {
            weather?: /* CurrentWeatherRecord */ CurrentWeatherRecord;
            /**
             * Sources
             */
            sources?: /* Source */ Source[];
        }
        /**
         * HTTPValidationError
         */
        export interface HTTPValidationError {
            /**
             * Detail
             */
            detail?: /* ValidationError */ ValidationError[];
        }
        /**
         * Location
         */
        export interface Location {
            /**
             * Warn Cell Id
             * Municipality warn cell ID of given location
             * example:
             * 803159016
             */
            warn_cell_id?: number;
            /**
             * Name
             * Municipality name
             * example:
             * Stadt Göttingen
             */
            name?: string;
            /**
             * Name Short
             * Shortened municipality name
             * example:
             * Göttingen
             */
            name_short?: string;
            /**
             * District
             * District name
             * example:
             * Göttingen
             */
            district?: string;
            /**
             * State
             * Federal state name
             * example:
             * Niedersachsen
             */
            state?: string;
            /**
             * State Short
             * Shortened federal state name
             * example:
             * NI
             */
            state_short?: string;
        }
        /**
         * NotFoundResponse
         */
        export interface NotFoundResponse {
            /**
             * Detail
             */
            detail?: string;
        }
        /**
         * RadarRecord
         */
        export interface RadarRecord {
            /**
             * Timestamp
             * ISO 8601-formatted timestamp of this radar record
             * example:
             * 2023-08-07T08:00:00+00:00
             */
            timestamp?: string; // date-time
            /**
             * Source
             * Unique identifier for DWD radar product source of this radar record
             * example:
             * RADOLAN::RV::2023-08-08T11:45:00+00:00
             */
            source?: string;
            /**
             * Precipitation 5
             * Pixelwise 5-minute precipitation data, in units of 0.01 mm / 5 min. Depending on the `format` parameter, this field contains either a two-dimensional array of integers (`plain`), or a base64 string (`bytes` or `compressed`).
             * example:
             * eF5jGAWjYBTQEQAAA3IAAQ==
             */
            precipitation_5?: string;
        }
        /**
         * RadarResponse
         */
        export interface RadarResponse {
            /**
             * Radar
             */
            radar?: /* RadarRecord */ RadarRecord[];
            /**
             * Geometry
             * GeoJSON-formatted bounding box of returned radar data, i.e. lat/lon coordinates of the four corners.
             * example:
             * {
             *   "coordinates": [
             *     [
             *       7.44365,
             *       52.08712
             *     ],
             *     [
             *       7.45668,
             *       51.90644
             *     ],
             *     [
             *       7.7487,
             *       51.914
             *     ],
             *     [
             *       7.73716,
             *       52.09473
             *     ]
             *   ],
             *   "type": "Polygon"
             * }
             */
            geometry?: {
                [name: string]: any;
            };
            /**
             * Bbox
             * Bounding box (top, left, bottom, right) calculated from the supplied position and distance. Only returned if you supplied `lat` and `lon`.
             * example:
             * [
             *   100,
             *   100,
             *   300,
             *   300
             * ]
             */
            bbox?: number[] | null;
            /**
             * Latlon Position
             * Exact x-y-position of the supplied position. Only returned if you supplied `lat` and `lon`.
             * example:
             * {
             *   "x": 10.244,
             *   "y": 10.088
             * }
             */
            latlon_position?: {
                [name: string]: any;
            } | null;
        }
        /**
         * Source
         */
        export interface Source {
            /**
             * Id
             * Bright Sky source ID
             * example:
             * 6007
             */
            id?: number;
            /**
             * Dwd Station Id
             * DWD weather station ID
             * example:
             * 01766
             */
            dwd_station_id?: string | null;
            /**
             * Wmo Station Id
             * WMO weather station ID
             * example:
             * 10315
             */
            wmo_station_id?: string | null;
            /**
             * Station Name
             * DWD weather station name
             * example:
             * Münster/Osnabrück
             */
            station_name?: string | null;
            /**
             * Observation Type
             * Source type
             */
            observation_type?: "historical" | "current" | "synop" | "forecast";
            /**
             * First Record
             * Timestamp of first available record for this source
             * example:
             * 2010-01-01T00:00+02:00
             */
            first_record?: string; // date-time
            /**
             * Last Record
             * Timestamp of latest available record for this source
             * example:
             * 2023-08-07T12:40+02:00
             */
            last_record?: string; // date-time
            /**
             * Lat
             * Station latitude, in decimal degrees
             * example:
             * 52.1344
             */
            lat?: number;
            /**
             * Lon
             * Station longitude, in decimal degrees
             * example:
             * 7.6969
             */
            lon?: number;
            /**
             * Height
             * Station height, in meters
             * example:
             * 47.8
             */
            height?: number;
            /**
             * Distance
             * Distance of weather station to the requested `lat` and `lon` (if given), in meters
             * example:
             * 16365
             */
            distance?: number;
        }
        /**
         * SourcesResponse
         */
        export interface SourcesResponse {
            /**
             * Sources
             */
            sources?: /* Source */ Source[];
        }
        /**
         * SynopRecord
         */
        export interface SynopRecord {
            /**
             * Timestamp
             * ISO 8601-formatted timestamp of this weather record
             * example:
             * 2023-08-07T12:30:00+00:00
             */
            timestamp?: string; // date-time
            /**
             * Source Id
             * Bright Sky source ID for this record
             * example:
             * 238685
             */
            source_id?: number;
            /**
             * Cloud Cover
             * Total cloud cover at timestamp
             * example:
             * 12.1
             */
            cloud_cover?: number | null;
            /**
             * Condition
             * Current weather conditions. Unlike the numerical parameters, this field is not taken as-is from the raw data (because it does not exist), but is calculated from different fields in the raw data as a best effort. Not all values are available for all source types.
             */
            condition?: "dry" | "fog" | "rain" | "sleet" | "snow" | "hail" | "thunderstorm";
            /**
             * Dew Point
             * Dew point at timestamp, 2 m above ground
             * example:
             * -2.5
             */
            dew_point?: number | null;
            /**
             * Icon
             * Icon alias suitable for the current weather conditions. Unlike the numerical parameters, this field is not taken as-is from the raw data (because it does not exist), but is calculated from different fields in the raw data as a best effort. Not all values are available for all source types.
             */
            icon?: "clear-day" | "clear-night" | "partly-cloudy-day" | "partly-cloudy-night" | "cloudy" | "fog" | "wind" | "rain" | "sleet" | "snow" | "hail" | "thunderstorm";
            /**
             * Pressure Msl
             * Atmospheric pressure at timestamp, reduced to mean sea level
             * example:
             * 1015.1
             */
            pressure_msl?: number | null;
            /**
             * Relative Humidity
             * Relative humidity at timestamp
             * example:
             * 40
             */
            relative_humidity?: number | null;
            /**
             * Temperature
             * Air temperature at timestamp, 2 m above the ground
             * example:
             * 10.6
             */
            temperature?: number | null;
            /**
             * Visibility
             * Visibility at timestamp
             * example:
             * 50000
             */
            visibility?: number | null;
            /**
             * Fallback Source Ids
             * Object mapping meteorological parameters to the source IDs of alternative sources that were used to fill up missing values in the main source
             * example:
             * {
             *   "pressure_msl": 11831,
             *   "wind_speed_30": 11831
             * }
             */
            fallback_source_ids?: {
                [name: string]: any;
            };
            /**
             * Precipitation 10
             * Total precipitation during previous 10 minutes
             * example:
             * 0.8
             */
            precipitation_10?: number | null;
            /**
             * Precipitation 30
             * Total precipitation during previous 30 minutes
             * example:
             * 1.2
             */
            precipitation_30?: number | null;
            /**
             * Precipitation 60
             * Total precipitation during previous 60 minutes
             * example:
             * 1.8
             */
            precipitation_60?: number | null;
            /**
             * Solar 10
             * Solar irradiation during previous 10 minutes
             * example:
             * 0.081
             */
            solar_10?: number | null;
            /**
             * Solar 30
             * Solar irradiation during previous 30 minutes
             * example:
             * 0.207
             */
            solar_30?: number | null;
            /**
             * Solar 60
             * Solar irradiation during previous 60 minutes
             * example:
             * 0.48
             */
            solar_60?: number | null;
            /**
             * Sunshine 30
             * Sunshine duration during previous 30 minutes
             * example:
             * 28
             */
            sunshine_30?: number | null;
            /**
             * Sunshine 60
             * Sunshine duration during previous 60 minutes
             * example:
             * 52
             */
            sunshine_60?: number | null;
            /**
             * Wind Direction 10
             * Mean wind direction during previous 10 minutes, 10 m above the ground
             * example:
             * 70
             */
            wind_direction_10?: number | null;
            /**
             * Wind Direction 30
             * Mean wind direction during previous 30 minutes, 10 m above the ground
             * example:
             * 70
             */
            wind_direction_30?: number | null;
            /**
             * Wind Direction 60
             * Mean wind direction during previous 60 minutes, 10 m above the ground
             * example:
             * 70
             */
            wind_direction_60?: number | null;
            /**
             * Wind Speed 10
             * Mean wind speed during previous 10 minutes, 10 m above the ground
             * example:
             * 12.6
             */
            wind_speed_10?: number | null;
            /**
             * Wind Speed 30
             * Mean wind speed during previous 30 minutes, 10 m above the ground
             * example:
             * 12.6
             */
            wind_speed_30?: number | null;
            /**
             * Wind Speed 60
             * Mean wind speed during previous 60 minutes, 10 m above the ground
             * example:
             * 12.6
             */
            wind_speed_60?: number | null;
            /**
             * Wind Gust Direction 10
             * Direction of maximum wind gust during previous 10 minutes, 10 m above the ground
             * example:
             * 50
             */
            wind_gust_direction_10?: number | null;
            /**
             * Wind Gust Direction 30
             * Direction of maximum wind gust during previous 30 minutes, 10 m above the ground
             * example:
             * 50
             */
            wind_gust_direction_30?: number | null;
            /**
             * Wind Gust Direction 60
             * Direction of maximum wind gust during previous 60 minutes, 10 m above the ground
             * example:
             * 50
             */
            wind_gust_direction_60?: number | null;
            /**
             * Wind Gust Speed 10
             * Speed of maximum wind gust during previous 10 minutes, 10 m above the ground
             * example:
             * 33.5
             */
            wind_gust_speed_10?: number | null;
            /**
             * Wind Gust Speed 30
             * Speed of maximum wind gust during previous 30 minutes, 10 m above the ground
             * example:
             * 33.5
             */
            wind_gust_speed_30?: number | null;
            /**
             * Wind Gust Speed 60
             * Speed of maximum wind gust during previous 60 minutes, 10 m above the ground
             * example:
             * 33.5
             */
            wind_gust_speed_60?: number | null;
            /**
             * Sunshine 10
             * Sunshine duration during previous 10 minutes
             * example:
             * 8
             */
            sunshine_10?: number | null;
        }
        /**
         * SynopResponse
         */
        export interface SynopResponse {
            /**
             * Weather
             */
            weather?: /* SynopRecord */ SynopRecord[];
            /**
             * Sources
             */
            sources?: /* Source */ Source[];
        }
        /**
         * ValidationError
         */
        export interface ValidationError {
            /**
             * Location
             */
            loc: (string | number)[];
            /**
             * Message
             */
            msg: string;
            /**
             * Error Type
             */
            type: string;
        }
        /**
         * WeatherRecord
         */
        export interface WeatherRecord {
            /**
             * Timestamp
             * ISO 8601-formatted timestamp of this weather record
             * example:
             * 2023-08-07T12:30:00+00:00
             */
            timestamp?: string; // date-time
            /**
             * Source Id
             * Bright Sky source ID for this record
             * example:
             * 238685
             */
            source_id?: number;
            /**
             * Cloud Cover
             * Total cloud cover at timestamp
             * example:
             * 12.1
             */
            cloud_cover?: number | null;
            /**
             * Condition
             * Current weather conditions. Unlike the numerical parameters, this field is not taken as-is from the raw data (because it does not exist), but is calculated from different fields in the raw data as a best effort. Not all values are available for all source types.
             */
            condition?: "dry" | "fog" | "rain" | "sleet" | "snow" | "hail" | "thunderstorm";
            /**
             * Dew Point
             * Dew point at timestamp, 2 m above ground
             * example:
             * -2.5
             */
            dew_point?: number | null;
            /**
             * Icon
             * Icon alias suitable for the current weather conditions. Unlike the numerical parameters, this field is not taken as-is from the raw data (because it does not exist), but is calculated from different fields in the raw data as a best effort. Not all values are available for all source types.
             */
            icon?: "clear-day" | "clear-night" | "partly-cloudy-day" | "partly-cloudy-night" | "cloudy" | "fog" | "wind" | "rain" | "sleet" | "snow" | "hail" | "thunderstorm";
            /**
             * Pressure Msl
             * Atmospheric pressure at timestamp, reduced to mean sea level
             * example:
             * 1015.1
             */
            pressure_msl?: number | null;
            /**
             * Relative Humidity
             * Relative humidity at timestamp
             * example:
             * 40
             */
            relative_humidity?: number | null;
            /**
             * Temperature
             * Air temperature at timestamp, 2 m above the ground
             * example:
             * 10.6
             */
            temperature?: number | null;
            /**
             * Visibility
             * Visibility at timestamp
             * example:
             * 50000
             */
            visibility?: number | null;
            /**
             * Fallback Source Ids
             * Object mapping meteorological parameters to the source IDs of alternative sources that were used to fill up missing values in the main source
             * example:
             * {
             *   "pressure_msl": 11831,
             *   "wind_speed_30": 11831
             * }
             */
            fallback_source_ids?: {
                [name: string]: any;
            };
            /**
             * Precipitation
             * Total precipitation during previous 60 minutes
             * example:
             * 1.8
             */
            precipitation?: number | null;
            /**
             * Solar
             * Solar irradiation during previous 60 minutes
             * example:
             * 0.563
             */
            solar?: number | null;
            /**
             * Sunshine
             * Sunshine duration during previous 60 minutes
             * example:
             * 58
             */
            sunshine?: number | null;
            /**
             * Wind Direction
             * Mean wind direction during previous hour, 10 m above the ground
             * example:
             * 70
             */
            wind_direction?: number | null;
            /**
             * Wind Speed
             * Mean wind speed during previous hour, 10 m above the ground
             * example:
             * 12.6
             */
            wind_speed?: number | null;
            /**
             * Wind Gust Direction
             * Direction of maximum wind gust during previous hour, 10 m above the ground
             * example:
             * 50
             */
            wind_gust_direction?: number | null;
            /**
             * Wind Gust Speed
             * Speed of maximum wind gust during previous hour, 10 m above the ground
             * example:
             * 33.5
             */
            wind_gust_speed?: number | null;
            /**
             * Precipitation Probability
             * Probability of more than 0.1 mm of precipitation in the previous hour (only available in forecasts)
             * example:
             * 46
             */
            precipitation_probability?: number | null;
            /**
             * Precipitation Probability 6H
             * Probability of more than 0.2 mm of precipitation in the previous 6 hours (only available in forecasts at 0:00, 6:00, 12:00, and 18:00 UTC)
             * example:
             * 75
             */
            precipitation_probability_6h?: number | null;
        }
        /**
         * WeatherResponse
         */
        export interface WeatherResponse {
            /**
             * Weather
             */
            weather?: /* WeatherRecord */ WeatherRecord[];
            /**
             * Sources
             */
            sources?: /* Source */ Source[];
        }
    }
}
declare namespace Paths {
    namespace GetAlerts {
        namespace Parameters {
            /**
             * Lat
             * Latitude in decimal degrees.
             * example:
             * 52.52
             * 51.55
             */
            export type Lat = number;
            /**
             * Lon
             * Longitude in decimal degrees.
             * example:
             * 13.4
             * 9.9
             */
            export type Lon = number;
            /**
             * Tz
             * Timezone in which record timestamps will be presented, as <a href="https://en.wikipedia.org/wiki/List_of_tz_database_time_zones">tz database name</a>. Will also be used as timezone when parsing `date` and `last_date`, unless these have explicit UTC offsets. If omitted but `date` has an explicit UTC offset, that offset will be used as timezone. Otherwise will default to UTC.
             * example:
             * Europe/Berlin
             * Australia/Darwin
             * Etc/UTC
             */
            export type Tz = string;
            /**
             * Warn Cell Id
             * Municipality warn cell ID.
             * example:
             * 803159016
             * 705515101
             */
            export type WarnCellId = number;
        }
        export interface QueryParameters {
            lat?: /**
             * Lat
             * Latitude in decimal degrees.
             * example:
             * 52.52
             * 51.55
             */
            Parameters.Lat;
            lon?: /**
             * Lon
             * Longitude in decimal degrees.
             * example:
             * 13.4
             * 9.9
             */
            Parameters.Lon;
            warn_cell_id?: /**
             * Warn Cell Id
             * Municipality warn cell ID.
             * example:
             * 803159016
             * 705515101
             */
            Parameters.WarnCellId;
            tz?: /**
             * Tz
             * Timezone in which record timestamps will be presented, as <a href="https://en.wikipedia.org/wiki/List_of_tz_database_time_zones">tz database name</a>. Will also be used as timezone when parsing `date` and `last_date`, unless these have explicit UTC offsets. If omitted but `date` has an explicit UTC offset, that offset will be used as timezone. Otherwise will default to UTC.
             * example:
             * Europe/Berlin
             * Australia/Darwin
             * Etc/UTC
             */
            Parameters.Tz;
        }
        namespace Responses {
            export type $200 = /* AlertsResponse */ Components.Schemas.AlertsResponse;
            export type $404 = /* NotFoundResponse */ Components.Schemas.NotFoundResponse;
            export type $422 = /* HTTPValidationError */ Components.Schemas.HTTPValidationError;
        }
    }
    namespace GetCurrentWeather {
        namespace Parameters {
            /**
             * Dwd Station Id
             * DWD station ID, typically five alphanumeric characters. You can supply multiple station IDs separated by commas, ordered from highest to lowest priority.
             * example:
             * 01766
             * 00420,00053,00400
             */
            export type DwdStationId = string[];
            /**
             * Lat
             * Latitude in decimal degrees.
             * example:
             * 52.52
             * 51.55
             */
            export type Lat = number;
            /**
             * Lon
             * Longitude in decimal degrees.
             * example:
             * 13.4
             * 9.9
             */
            export type Lon = number;
            /**
             * Max Dist
             * Maximum distance of record location from the location given by `lat` and `lon`, in meters. Only has an effect when using `lat` and `lon`.
             * example:
             * 10000
             */
            export type MaxDist = number;
            /**
             * Source Id
             * Bright Sky source ID, as retrieved from the [`/sources` endpoint](/operations/getSources). You can supply multiple source IDs separated by commas, ordered from highest to lowest priority.
             * example:
             * 1234
             * 1234,2345
             */
            export type SourceId = number[];
            /**
             * Tz
             * Timezone in which record timestamps will be presented, as <a href="https://en.wikipedia.org/wiki/List_of_tz_database_time_zones">tz database name</a>. Will also be used as timezone when parsing `date` and `last_date`, unless these have explicit UTC offsets. If omitted but `date` has an explicit UTC offset, that offset will be used as timezone. Otherwise will default to UTC.
             * example:
             * Europe/Berlin
             * Australia/Darwin
             * Etc/UTC
             */
            export type Tz = string;
            /**
             * Units
             * Physical units in which meteorological parameters will be returned. Set to `si` to use <a href="https://en.wikipedia.org/wiki/International_System_of_Units">SI units</a> (except for precipitation, which is always measured in millimeters). The default `dwd` option uses a set of units that is more common in meteorological applications and civil use:
             * <table>
             *   <tr><td></td><td>DWD</td><td>SI</td></tr>
             *   <tr><td>Cloud cover</td><td>%</td><td>%</td></tr>
             *   <tr><td>Dew point</td><td>°C</td><td>K</td></tr>
             *   <tr><td>Precipitation</td><td>mm</td><td><s>kg / m²</s> <strong>mm</strong></td></tr>
             *   <tr><td>Precipitation probability</td><td>%</td><td>%</td></tr>
             *   <tr><td>Pressure</td><td>hPa</td><td>Pa</td></tr>
             *   <tr><td>Relative humidity</td><td>%</td><td>%</td></tr>
             *   <tr><td>Solar irradiation</td><td>kWh / m²</td><td>J / m²</td></tr>
             *   <tr><td>Sunshine</td><td>min</td><td>s</td></tr>
             *   <tr><td>Temperature</td><td>°C</td><td>K</td></tr>
             *   <tr><td>Visibility</td><td>m</td><td>m</td></tr>
             *   <tr><td>Wind (gust) direction</td><td>°</td><td>°</td></tr>
             *   <tr><td>Wind (gust) speed</td><td>km / h</td><td>m / s</td></tr>
             * </table>
             */
            export type Units = "dwd" | "si";
            /**
             * Wmo Station Id
             * WMO station ID, typically five alphanumeric characters. You can supply multiple station IDs separated by commas, ordered from highest to lowest priority.
             * example:
             * 10315
             * G005,F451,10389
             */
            export type WmoStationId = string[];
        }
        export interface QueryParameters {
            lat?: /**
             * Lat
             * Latitude in decimal degrees.
             * example:
             * 52.52
             * 51.55
             */
            Parameters.Lat;
            lon?: /**
             * Lon
             * Longitude in decimal degrees.
             * example:
             * 13.4
             * 9.9
             */
            Parameters.Lon;
            max_dist?: /**
             * Max Dist
             * Maximum distance of record location from the location given by `lat` and `lon`, in meters. Only has an effect when using `lat` and `lon`.
             * example:
             * 10000
             */
            Parameters.MaxDist;
            dwd_station_id?: /**
             * Dwd Station Id
             * DWD station ID, typically five alphanumeric characters. You can supply multiple station IDs separated by commas, ordered from highest to lowest priority.
             * example:
             * 01766
             * 00420,00053,00400
             */
            Parameters.DwdStationId;
            wmo_station_id?: /**
             * Wmo Station Id
             * WMO station ID, typically five alphanumeric characters. You can supply multiple station IDs separated by commas, ordered from highest to lowest priority.
             * example:
             * 10315
             * G005,F451,10389
             */
            Parameters.WmoStationId;
            source_id?: /**
             * Source Id
             * Bright Sky source ID, as retrieved from the [`/sources` endpoint](/operations/getSources). You can supply multiple source IDs separated by commas, ordered from highest to lowest priority.
             * example:
             * 1234
             * 1234,2345
             */
            Parameters.SourceId;
            tz?: /**
             * Tz
             * Timezone in which record timestamps will be presented, as <a href="https://en.wikipedia.org/wiki/List_of_tz_database_time_zones">tz database name</a>. Will also be used as timezone when parsing `date` and `last_date`, unless these have explicit UTC offsets. If omitted but `date` has an explicit UTC offset, that offset will be used as timezone. Otherwise will default to UTC.
             * example:
             * Europe/Berlin
             * Australia/Darwin
             * Etc/UTC
             */
            Parameters.Tz;
            units?: /**
             * Units
             * Physical units in which meteorological parameters will be returned. Set to `si` to use <a href="https://en.wikipedia.org/wiki/International_System_of_Units">SI units</a> (except for precipitation, which is always measured in millimeters). The default `dwd` option uses a set of units that is more common in meteorological applications and civil use:
             * <table>
             *   <tr><td></td><td>DWD</td><td>SI</td></tr>
             *   <tr><td>Cloud cover</td><td>%</td><td>%</td></tr>
             *   <tr><td>Dew point</td><td>°C</td><td>K</td></tr>
             *   <tr><td>Precipitation</td><td>mm</td><td><s>kg / m²</s> <strong>mm</strong></td></tr>
             *   <tr><td>Precipitation probability</td><td>%</td><td>%</td></tr>
             *   <tr><td>Pressure</td><td>hPa</td><td>Pa</td></tr>
             *   <tr><td>Relative humidity</td><td>%</td><td>%</td></tr>
             *   <tr><td>Solar irradiation</td><td>kWh / m²</td><td>J / m²</td></tr>
             *   <tr><td>Sunshine</td><td>min</td><td>s</td></tr>
             *   <tr><td>Temperature</td><td>°C</td><td>K</td></tr>
             *   <tr><td>Visibility</td><td>m</td><td>m</td></tr>
             *   <tr><td>Wind (gust) direction</td><td>°</td><td>°</td></tr>
             *   <tr><td>Wind (gust) speed</td><td>km / h</td><td>m / s</td></tr>
             * </table>
             */
            Parameters.Units;
        }
        namespace Responses {
            export type $200 = /* CurrentWeatherResponse */ Components.Schemas.CurrentWeatherResponse;
            export type $404 = /* NotFoundResponse */ Components.Schemas.NotFoundResponse;
            export type $422 = /* HTTPValidationError */ Components.Schemas.HTTPValidationError;
        }
    }
    namespace GetRadar {
        namespace Parameters {
            /**
             * Bbox
             * Bounding box (top, left, bottom, right) **in pixels**, edges are inclusive. (_Defaults to full 1200x1100 grid._)
             * example:
             * 100,100,300,300
             */
            export type Bbox = number[];
            /**
             * Date
             * Timestamp of first record to retrieve, in ISO 8601 format. May contain time and/or UTC offset. (_Defaults to 1 hour before latest measurement._)
             * example:
             * 2023-08-07
             * 2023-08-07T19:00+02:00
             */
            export type Date = string; // date-time
            /**
             * Distance
             * Alternative way to set a bounding box, must be used together with `lat` and `lon`. Data will reach `distance` meters to each side of this location, but is possibly cut off at the edges of the radar grid.
             * example:
             * 100000
             */
            export type Distance = number;
            /**
             * Format
             *
             * Determines how the precipitation data is encoded into the `precipitation_5` field:
             * * `compressed`: base64-encoded, zlib-compressed bytestring of 2-byte integers
             * * `bytes`: base64-encoded bytestring of 2-byte integers
             * * `plain`: Nested array of integers
             *
             */
            export type Format = "compressed" | "bytes" | "plain";
            /**
             * Last Date
             * Timestamp of last record to retrieve, in ISO 8601 format. May contain time and/or UTC offset. (_Defaults to 2 hours after `date`._)
             * example:
             * 2023-08-08
             * 2023-08-07T23:00+02:00
             */
            export type LastDate = string; // date-time
            /**
             * Lat
             * Latitude in decimal degrees.
             * example:
             * 52.52
             * 51.55
             */
            export type Lat = number;
            /**
             * Lon
             * Longitude in decimal degrees.
             * example:
             * 13.4
             * 9.9
             */
            export type Lon = number;
            /**
             * Tz
             * Timezone in which record timestamps will be presented, as <a href="https://en.wikipedia.org/wiki/List_of_tz_database_time_zones">tz database name</a>. Will also be used as timezone when parsing `date` and `last_date`, unless these have explicit UTC offsets. If omitted but `date` has an explicit UTC offset, that offset will be used as timezone. Otherwise will default to UTC.
             * example:
             * Europe/Berlin
             * Australia/Darwin
             * Etc/UTC
             */
            export type Tz = string;
        }
        export interface QueryParameters {
            bbox?: /**
             * Bbox
             * Bounding box (top, left, bottom, right) **in pixels**, edges are inclusive. (_Defaults to full 1200x1100 grid._)
             * example:
             * 100,100,300,300
             */
            Parameters.Bbox;
            distance?: /**
             * Distance
             * Alternative way to set a bounding box, must be used together with `lat` and `lon`. Data will reach `distance` meters to each side of this location, but is possibly cut off at the edges of the radar grid.
             * example:
             * 100000
             */
            Parameters.Distance;
            lat?: /**
             * Lat
             * Latitude in decimal degrees.
             * example:
             * 52.52
             * 51.55
             */
            Parameters.Lat;
            lon?: /**
             * Lon
             * Longitude in decimal degrees.
             * example:
             * 13.4
             * 9.9
             */
            Parameters.Lon;
            date?: /**
             * Date
             * Timestamp of first record to retrieve, in ISO 8601 format. May contain time and/or UTC offset. (_Defaults to 1 hour before latest measurement._)
             * example:
             * 2023-08-07
             * 2023-08-07T19:00+02:00
             */
            Parameters.Date /* date-time */;
            last_date?: /**
             * Last Date
             * Timestamp of last record to retrieve, in ISO 8601 format. May contain time and/or UTC offset. (_Defaults to 2 hours after `date`._)
             * example:
             * 2023-08-08
             * 2023-08-07T23:00+02:00
             */
            Parameters.LastDate /* date-time */;
            format?: /**
             * Format
             *
             * Determines how the precipitation data is encoded into the `precipitation_5` field:
             * * `compressed`: base64-encoded, zlib-compressed bytestring of 2-byte integers
             * * `bytes`: base64-encoded bytestring of 2-byte integers
             * * `plain`: Nested array of integers
             *
             */
            Parameters.Format;
            tz?: /**
             * Tz
             * Timezone in which record timestamps will be presented, as <a href="https://en.wikipedia.org/wiki/List_of_tz_database_time_zones">tz database name</a>. Will also be used as timezone when parsing `date` and `last_date`, unless these have explicit UTC offsets. If omitted but `date` has an explicit UTC offset, that offset will be used as timezone. Otherwise will default to UTC.
             * example:
             * Europe/Berlin
             * Australia/Darwin
             * Etc/UTC
             */
            Parameters.Tz;
        }
        namespace Responses {
            export type $200 = /* RadarResponse */ Components.Schemas.RadarResponse;
            export type $404 = /* NotFoundResponse */ Components.Schemas.NotFoundResponse;
            export type $422 = /* HTTPValidationError */ Components.Schemas.HTTPValidationError;
        }
    }
    namespace GetSources {
        namespace Parameters {
            /**
             * Dwd Station Id
             * DWD station ID, typically five alphanumeric characters. You can supply multiple station IDs separated by commas, ordered from highest to lowest priority.
             * example:
             * 01766
             * 00420,00053,00400
             */
            export type DwdStationId = string[];
            /**
             * Lat
             * Latitude in decimal degrees.
             * example:
             * 52.52
             * 51.55
             */
            export type Lat = number;
            /**
             * Lon
             * Longitude in decimal degrees.
             * example:
             * 13.4
             * 9.9
             */
            export type Lon = number;
            /**
             * Max Dist
             * Maximum distance of record location from the location given by `lat` and `lon`, in meters. Only has an effect when using `lat` and `lon`.
             * example:
             * 10000
             */
            export type MaxDist = number;
            /**
             * Source Id
             * Bright Sky source ID, as retrieved from the [`/sources` endpoint](/operations/getSources). You can supply multiple source IDs separated by commas, ordered from highest to lowest priority.
             * example:
             * 1234
             * 1234,2345
             */
            export type SourceId = number[];
            /**
             * Tz
             * Timezone in which record timestamps will be presented, as <a href="https://en.wikipedia.org/wiki/List_of_tz_database_time_zones">tz database name</a>. Will also be used as timezone when parsing `date` and `last_date`, unless these have explicit UTC offsets. If omitted but `date` has an explicit UTC offset, that offset will be used as timezone. Otherwise will default to UTC.
             * example:
             * Europe/Berlin
             * Australia/Darwin
             * Etc/UTC
             */
            export type Tz = string;
            /**
             * Wmo Station Id
             * WMO station ID, typically five alphanumeric characters. You can supply multiple station IDs separated by commas, ordered from highest to lowest priority.
             * example:
             * 10315
             * G005,F451,10389
             */
            export type WmoStationId = string[];
        }
        export interface QueryParameters {
            lat?: /**
             * Lat
             * Latitude in decimal degrees.
             * example:
             * 52.52
             * 51.55
             */
            Parameters.Lat;
            lon?: /**
             * Lon
             * Longitude in decimal degrees.
             * example:
             * 13.4
             * 9.9
             */
            Parameters.Lon;
            max_dist?: /**
             * Max Dist
             * Maximum distance of record location from the location given by `lat` and `lon`, in meters. Only has an effect when using `lat` and `lon`.
             * example:
             * 10000
             */
            Parameters.MaxDist;
            dwd_station_id?: /**
             * Dwd Station Id
             * DWD station ID, typically five alphanumeric characters. You can supply multiple station IDs separated by commas, ordered from highest to lowest priority.
             * example:
             * 01766
             * 00420,00053,00400
             */
            Parameters.DwdStationId;
            wmo_station_id?: /**
             * Wmo Station Id
             * WMO station ID, typically five alphanumeric characters. You can supply multiple station IDs separated by commas, ordered from highest to lowest priority.
             * example:
             * 10315
             * G005,F451,10389
             */
            Parameters.WmoStationId;
            source_id?: /**
             * Source Id
             * Bright Sky source ID, as retrieved from the [`/sources` endpoint](/operations/getSources). You can supply multiple source IDs separated by commas, ordered from highest to lowest priority.
             * example:
             * 1234
             * 1234,2345
             */
            Parameters.SourceId;
            tz?: /**
             * Tz
             * Timezone in which record timestamps will be presented, as <a href="https://en.wikipedia.org/wiki/List_of_tz_database_time_zones">tz database name</a>. Will also be used as timezone when parsing `date` and `last_date`, unless these have explicit UTC offsets. If omitted but `date` has an explicit UTC offset, that offset will be used as timezone. Otherwise will default to UTC.
             * example:
             * Europe/Berlin
             * Australia/Darwin
             * Etc/UTC
             */
            Parameters.Tz;
        }
        namespace Responses {
            export type $200 = /* SourcesResponse */ Components.Schemas.SourcesResponse;
            export type $404 = /* NotFoundResponse */ Components.Schemas.NotFoundResponse;
            export type $422 = /* HTTPValidationError */ Components.Schemas.HTTPValidationError;
        }
    }
    namespace GetSynop {
        namespace Parameters {
            /**
             * Date
             * Timestamp of first weather record (or forecast) to retrieve, in ISO 8601 format. May contain time and/or UTC offset.
             * example:
             * 2023-08-07
             * 2023-08-07T08:00+02:00
             */
            export type Date = string; // date-time
            /**
             * Dwd Station Id
             * DWD station ID, typically five alphanumeric characters. You can supply multiple station IDs separated by commas, ordered from highest to lowest priority.
             * example:
             * 01766
             * 00420,00053,00400
             */
            export type DwdStationId = string[];
            /**
             * Last Date
             * Timestamp of last weather record (or forecast) to retrieve, in ISO 8601 format. Will default to `date + 1 day`.
             * example:
             * 2023-08-08
             * 2023-08-07T23:00+02:00
             */
            export type LastDate = string; // date-time
            /**
             * Source Id
             * Bright Sky source ID, as retrieved from the [`/sources` endpoint](/operations/getSources). You can supply multiple source IDs separated by commas, ordered from highest to lowest priority.
             * example:
             * 1234
             * 1234,2345
             */
            export type SourceId = number[];
            /**
             * Tz
             * Timezone in which record timestamps will be presented, as <a href="https://en.wikipedia.org/wiki/List_of_tz_database_time_zones">tz database name</a>. Will also be used as timezone when parsing `date` and `last_date`, unless these have explicit UTC offsets. If omitted but `date` has an explicit UTC offset, that offset will be used as timezone. Otherwise will default to UTC.
             * example:
             * Europe/Berlin
             * Australia/Darwin
             * Etc/UTC
             */
            export type Tz = string;
            /**
             * Units
             * Physical units in which meteorological parameters will be returned. Set to `si` to use <a href="https://en.wikipedia.org/wiki/International_System_of_Units">SI units</a> (except for precipitation, which is always measured in millimeters). The default `dwd` option uses a set of units that is more common in meteorological applications and civil use:
             * <table>
             *   <tr><td></td><td>DWD</td><td>SI</td></tr>
             *   <tr><td>Cloud cover</td><td>%</td><td>%</td></tr>
             *   <tr><td>Dew point</td><td>°C</td><td>K</td></tr>
             *   <tr><td>Precipitation</td><td>mm</td><td><s>kg / m²</s> <strong>mm</strong></td></tr>
             *   <tr><td>Precipitation probability</td><td>%</td><td>%</td></tr>
             *   <tr><td>Pressure</td><td>hPa</td><td>Pa</td></tr>
             *   <tr><td>Relative humidity</td><td>%</td><td>%</td></tr>
             *   <tr><td>Solar irradiation</td><td>kWh / m²</td><td>J / m²</td></tr>
             *   <tr><td>Sunshine</td><td>min</td><td>s</td></tr>
             *   <tr><td>Temperature</td><td>°C</td><td>K</td></tr>
             *   <tr><td>Visibility</td><td>m</td><td>m</td></tr>
             *   <tr><td>Wind (gust) direction</td><td>°</td><td>°</td></tr>
             *   <tr><td>Wind (gust) speed</td><td>km / h</td><td>m / s</td></tr>
             * </table>
             */
            export type Units = "dwd" | "si";
            /**
             * Wmo Station Id
             * WMO station ID, typically five alphanumeric characters. You can supply multiple station IDs separated by commas, ordered from highest to lowest priority.
             * example:
             * 10315
             * G005,F451,10389
             */
            export type WmoStationId = string[];
        }
        export interface QueryParameters {
            date: /**
             * Date
             * Timestamp of first weather record (or forecast) to retrieve, in ISO 8601 format. May contain time and/or UTC offset.
             * example:
             * 2023-08-07
             * 2023-08-07T08:00+02:00
             */
            Parameters.Date /* date-time */;
            last_date?: /**
             * Last Date
             * Timestamp of last weather record (or forecast) to retrieve, in ISO 8601 format. Will default to `date + 1 day`.
             * example:
             * 2023-08-08
             * 2023-08-07T23:00+02:00
             */
            Parameters.LastDate /* date-time */;
            dwd_station_id?: /**
             * Dwd Station Id
             * DWD station ID, typically five alphanumeric characters. You can supply multiple station IDs separated by commas, ordered from highest to lowest priority.
             * example:
             * 01766
             * 00420,00053,00400
             */
            Parameters.DwdStationId;
            wmo_station_id?: /**
             * Wmo Station Id
             * WMO station ID, typically five alphanumeric characters. You can supply multiple station IDs separated by commas, ordered from highest to lowest priority.
             * example:
             * 10315
             * G005,F451,10389
             */
            Parameters.WmoStationId;
            source_id?: /**
             * Source Id
             * Bright Sky source ID, as retrieved from the [`/sources` endpoint](/operations/getSources). You can supply multiple source IDs separated by commas, ordered from highest to lowest priority.
             * example:
             * 1234
             * 1234,2345
             */
            Parameters.SourceId;
            tz?: /**
             * Tz
             * Timezone in which record timestamps will be presented, as <a href="https://en.wikipedia.org/wiki/List_of_tz_database_time_zones">tz database name</a>. Will also be used as timezone when parsing `date` and `last_date`, unless these have explicit UTC offsets. If omitted but `date` has an explicit UTC offset, that offset will be used as timezone. Otherwise will default to UTC.
             * example:
             * Europe/Berlin
             * Australia/Darwin
             * Etc/UTC
             */
            Parameters.Tz;
            units?: /**
             * Units
             * Physical units in which meteorological parameters will be returned. Set to `si` to use <a href="https://en.wikipedia.org/wiki/International_System_of_Units">SI units</a> (except for precipitation, which is always measured in millimeters). The default `dwd` option uses a set of units that is more common in meteorological applications and civil use:
             * <table>
             *   <tr><td></td><td>DWD</td><td>SI</td></tr>
             *   <tr><td>Cloud cover</td><td>%</td><td>%</td></tr>
             *   <tr><td>Dew point</td><td>°C</td><td>K</td></tr>
             *   <tr><td>Precipitation</td><td>mm</td><td><s>kg / m²</s> <strong>mm</strong></td></tr>
             *   <tr><td>Precipitation probability</td><td>%</td><td>%</td></tr>
             *   <tr><td>Pressure</td><td>hPa</td><td>Pa</td></tr>
             *   <tr><td>Relative humidity</td><td>%</td><td>%</td></tr>
             *   <tr><td>Solar irradiation</td><td>kWh / m²</td><td>J / m²</td></tr>
             *   <tr><td>Sunshine</td><td>min</td><td>s</td></tr>
             *   <tr><td>Temperature</td><td>°C</td><td>K</td></tr>
             *   <tr><td>Visibility</td><td>m</td><td>m</td></tr>
             *   <tr><td>Wind (gust) direction</td><td>°</td><td>°</td></tr>
             *   <tr><td>Wind (gust) speed</td><td>km / h</td><td>m / s</td></tr>
             * </table>
             */
            Parameters.Units;
        }
        namespace Responses {
            export type $200 = /* SynopResponse */ Components.Schemas.SynopResponse;
            export type $404 = /* NotFoundResponse */ Components.Schemas.NotFoundResponse;
            export type $422 = /* HTTPValidationError */ Components.Schemas.HTTPValidationError;
        }
    }
    namespace GetWeather {
        namespace Parameters {
            /**
             * Date
             * Timestamp of first weather record (or forecast) to retrieve, in ISO 8601 format. May contain time and/or UTC offset.
             * example:
             * 2023-08-07
             * 2023-08-07T08:00+02:00
             */
            export type Date = string; // date-time
            /**
             * Dwd Station Id
             * DWD station ID, typically five alphanumeric characters. You can supply multiple station IDs separated by commas, ordered from highest to lowest priority.
             * example:
             * 01766
             * 00420,00053,00400
             */
            export type DwdStationId = string[];
            /**
             * Last Date
             * Timestamp of last weather record (or forecast) to retrieve, in ISO 8601 format. Will default to `date + 1 day`.
             * example:
             * 2023-08-08
             * 2023-08-07T23:00+02:00
             */
            export type LastDate = string; // date-time
            /**
             * Lat
             * Latitude in decimal degrees.
             * example:
             * 52.52
             * 51.55
             */
            export type Lat = number;
            /**
             * Lon
             * Longitude in decimal degrees.
             * example:
             * 13.4
             * 9.9
             */
            export type Lon = number;
            /**
             * Max Dist
             * Maximum distance of record location from the location given by `lat` and `lon`, in meters. Only has an effect when using `lat` and `lon`.
             * example:
             * 10000
             */
            export type MaxDist = number;
            /**
             * Source Id
             * Bright Sky source ID, as retrieved from the [`/sources` endpoint](/operations/getSources). You can supply multiple source IDs separated by commas, ordered from highest to lowest priority.
             * example:
             * 1234
             * 1234,2345
             */
            export type SourceId = number[];
            /**
             * Tz
             * Timezone in which record timestamps will be presented, as <a href="https://en.wikipedia.org/wiki/List_of_tz_database_time_zones">tz database name</a>. Will also be used as timezone when parsing `date` and `last_date`, unless these have explicit UTC offsets. If omitted but `date` has an explicit UTC offset, that offset will be used as timezone. Otherwise will default to UTC.
             * example:
             * Europe/Berlin
             * Australia/Darwin
             * Etc/UTC
             */
            export type Tz = string;
            /**
             * Units
             * Physical units in which meteorological parameters will be returned. Set to `si` to use <a href="https://en.wikipedia.org/wiki/International_System_of_Units">SI units</a> (except for precipitation, which is always measured in millimeters). The default `dwd` option uses a set of units that is more common in meteorological applications and civil use:
             * <table>
             *   <tr><td></td><td>DWD</td><td>SI</td></tr>
             *   <tr><td>Cloud cover</td><td>%</td><td>%</td></tr>
             *   <tr><td>Dew point</td><td>°C</td><td>K</td></tr>
             *   <tr><td>Precipitation</td><td>mm</td><td><s>kg / m²</s> <strong>mm</strong></td></tr>
             *   <tr><td>Precipitation probability</td><td>%</td><td>%</td></tr>
             *   <tr><td>Pressure</td><td>hPa</td><td>Pa</td></tr>
             *   <tr><td>Relative humidity</td><td>%</td><td>%</td></tr>
             *   <tr><td>Solar irradiation</td><td>kWh / m²</td><td>J / m²</td></tr>
             *   <tr><td>Sunshine</td><td>min</td><td>s</td></tr>
             *   <tr><td>Temperature</td><td>°C</td><td>K</td></tr>
             *   <tr><td>Visibility</td><td>m</td><td>m</td></tr>
             *   <tr><td>Wind (gust) direction</td><td>°</td><td>°</td></tr>
             *   <tr><td>Wind (gust) speed</td><td>km / h</td><td>m / s</td></tr>
             * </table>
             */
            export type Units = "dwd" | "si";
            /**
             * Wmo Station Id
             * WMO station ID, typically five alphanumeric characters. You can supply multiple station IDs separated by commas, ordered from highest to lowest priority.
             * example:
             * 10315
             * G005,F451,10389
             */
            export type WmoStationId = string[];
        }
        export interface QueryParameters {
            date: /**
             * Date
             * Timestamp of first weather record (or forecast) to retrieve, in ISO 8601 format. May contain time and/or UTC offset.
             * example:
             * 2023-08-07
             * 2023-08-07T08:00+02:00
             */
            Parameters.Date /* date-time */;
            last_date?: /**
             * Last Date
             * Timestamp of last weather record (or forecast) to retrieve, in ISO 8601 format. Will default to `date + 1 day`.
             * example:
             * 2023-08-08
             * 2023-08-07T23:00+02:00
             */
            Parameters.LastDate /* date-time */;
            lat?: /**
             * Lat
             * Latitude in decimal degrees.
             * example:
             * 52.52
             * 51.55
             */
            Parameters.Lat;
            lon?: /**
             * Lon
             * Longitude in decimal degrees.
             * example:
             * 13.4
             * 9.9
             */
            Parameters.Lon;
            max_dist?: /**
             * Max Dist
             * Maximum distance of record location from the location given by `lat` and `lon`, in meters. Only has an effect when using `lat` and `lon`.
             * example:
             * 10000
             */
            Parameters.MaxDist;
            dwd_station_id?: /**
             * Dwd Station Id
             * DWD station ID, typically five alphanumeric characters. You can supply multiple station IDs separated by commas, ordered from highest to lowest priority.
             * example:
             * 01766
             * 00420,00053,00400
             */
            Parameters.DwdStationId;
            wmo_station_id?: /**
             * Wmo Station Id
             * WMO station ID, typically five alphanumeric characters. You can supply multiple station IDs separated by commas, ordered from highest to lowest priority.
             * example:
             * 10315
             * G005,F451,10389
             */
            Parameters.WmoStationId;
            source_id?: /**
             * Source Id
             * Bright Sky source ID, as retrieved from the [`/sources` endpoint](/operations/getSources). You can supply multiple source IDs separated by commas, ordered from highest to lowest priority.
             * example:
             * 1234
             * 1234,2345
             */
            Parameters.SourceId;
            tz?: /**
             * Tz
             * Timezone in which record timestamps will be presented, as <a href="https://en.wikipedia.org/wiki/List_of_tz_database_time_zones">tz database name</a>. Will also be used as timezone when parsing `date` and `last_date`, unless these have explicit UTC offsets. If omitted but `date` has an explicit UTC offset, that offset will be used as timezone. Otherwise will default to UTC.
             * example:
             * Europe/Berlin
             * Australia/Darwin
             * Etc/UTC
             */
            Parameters.Tz;
            units?: /**
             * Units
             * Physical units in which meteorological parameters will be returned. Set to `si` to use <a href="https://en.wikipedia.org/wiki/International_System_of_Units">SI units</a> (except for precipitation, which is always measured in millimeters). The default `dwd` option uses a set of units that is more common in meteorological applications and civil use:
             * <table>
             *   <tr><td></td><td>DWD</td><td>SI</td></tr>
             *   <tr><td>Cloud cover</td><td>%</td><td>%</td></tr>
             *   <tr><td>Dew point</td><td>°C</td><td>K</td></tr>
             *   <tr><td>Precipitation</td><td>mm</td><td><s>kg / m²</s> <strong>mm</strong></td></tr>
             *   <tr><td>Precipitation probability</td><td>%</td><td>%</td></tr>
             *   <tr><td>Pressure</td><td>hPa</td><td>Pa</td></tr>
             *   <tr><td>Relative humidity</td><td>%</td><td>%</td></tr>
             *   <tr><td>Solar irradiation</td><td>kWh / m²</td><td>J / m²</td></tr>
             *   <tr><td>Sunshine</td><td>min</td><td>s</td></tr>
             *   <tr><td>Temperature</td><td>°C</td><td>K</td></tr>
             *   <tr><td>Visibility</td><td>m</td><td>m</td></tr>
             *   <tr><td>Wind (gust) direction</td><td>°</td><td>°</td></tr>
             *   <tr><td>Wind (gust) speed</td><td>km / h</td><td>m / s</td></tr>
             * </table>
             */
            Parameters.Units;
        }
        namespace Responses {
            export type $200 = /* WeatherResponse */ Components.Schemas.WeatherResponse;
            export type $404 = /* NotFoundResponse */ Components.Schemas.NotFoundResponse;
            export type $422 = /* HTTPValidationError */ Components.Schemas.HTTPValidationError;
        }
    }
}


export interface OperationMethods {
  /**
   * getSources - Weather sources (stations)
   * 
   * Return a list of all Bright Sky sources matching the given location
   * criteria, ordered by distance.
   * 
   * You must supply both `lat` and `lon` _or_ one of `dwd_station_id`,
   * `wmo_station_id`, or `source_id`.
   */
  'getSources'(
    parameters?: Parameters<Paths.GetSources.QueryParameters> | null,
    data?: any,
    config?: AxiosRequestConfig  
  ): OperationResponse<Paths.GetSources.Responses.$200>
  /**
   * getCurrentWeather - Current weather
   * 
   * Returns current weather for a given location.
   * 
   * To set the location for which to retrieve weather, you must supply both
   * `lat` and `lon` _or_ one of `dwd_station_id`, `wmo_station_id`, or
   * `source_id`.
   * 
   * This endpoint is different from the other weather endpoints in that it does
   * not directly correspond to any of the data available from the DWD Open Data
   * server. Instead, it is a best-effort solution to reflect current weather
   * conditions by compiling [SYNOP observations](/operations/getSynop) from the
   * past one and a half hours.
   */
  'getCurrentWeather'(
    parameters?: Parameters<Paths.GetCurrentWeather.QueryParameters> | null,
    data?: any,
    config?: AxiosRequestConfig  
  ): OperationResponse<Paths.GetCurrentWeather.Responses.$200>
  /**
   * getWeather - Hourly weather (including forecasts)
   * 
   * Returns a list of hourly weather records (and/or forecasts) for the time
   * range given by `date` and `last_date`.
   * 
   * To set the location for which to retrieve records (and/or forecasts), you
   * must supply both `lat` and `lon` _or_ one of `dwd_station_id`,
   * `wmo_station_id`, or `source_id`.
   */
  'getWeather'(
    parameters?: Parameters<Paths.GetWeather.QueryParameters> | null,
    data?: any,
    config?: AxiosRequestConfig  
  ): OperationResponse<Paths.GetWeather.Responses.$200>
  /**
   * getSynop - Raw SYNOP observations
   * 
   * Returns a list of ten-minutely SYNOP observations for the time range given
   * by `date` and `last_date`. Note that Bright Sky only stores SYNOP
   * observations from the past 30 hours.
   * 
   * To set the weather station for which to retrieve records, you must supply
   * one of `dwd_station_id`, `wmo_station_id`, or `source_id`. The `/synop`
   * endpoint does not support `lat` and `lon`; use the
   * [`/sources` endpoint](/operations/getSources) if you need to retrieve a
   * SYNOP station ID close to a given location.
   * 
   * SYNOP observations are stored as they were reported, which in particular
   * implies that many parameters are only available at certain timestamps. For
   * example, most stations report `sunshine_60` only on the full hour, and
   * `sunshine_30` only at 30 minutes past the full hour (i.e. also not on the
   * full hour). Check out the
   * [`/current_weather` endpoint](/operations/getCurrentWeather) for an
   * opinionated compilation of recent SYNOP records into a single "current
   * weather" record.
   */
  'getSynop'(
    parameters?: Parameters<Paths.GetSynop.QueryParameters> | null,
    data?: any,
    config?: AxiosRequestConfig  
  ): OperationResponse<Paths.GetSynop.Responses.$200>
  /**
   * getRadar - Radar
   * 
   * Returns radar rainfall data with 1 km spatial and 5 minute temporal
   * resolution, including a forecast for the next two hours.
   * 
   * Radar data is recorded on a 1200 km (North-South) x 1100 km (East-West)
   * grid, with each pixel representing 1 km². **That's quite a lot of data, so
   * use `lat`/`lon` or `bbox` whenever you can (see below).** Past radar
   * records are kept for six hours.
   * 
   * Bright Sky can return the data in a few formats. Use the default
   * `compressed` format if possible – this'll get you the fastest response
   * times by far and reduce load on the server. If you have a small-ish
   * bounding box (e.g. 250 x 250 pixels), using the `plain` format should be
   * fine.
   * 
   * ### Quickstart
   * 
   * This request will get you radar data near Münster, reaching 200 km to the
   * East/West/North/South, as a two-dimensional grid of integers:
   * 
   * [`https://api.brightsky.dev/radar?lat=52&lon=7.6&format=plain`](https://api.brightsky.dev/radar?lat=52&lon=7.6&format=plain)
   * 
   * ### Content
   * 
   * * The grid is a polar stereographic projection of Germany and the regions
   *   bordering it. This is different from the mercator projection used for
   *   most consumer-facing maps like OpenStreetMap or Google Maps, and
   *   overlaying the radar data onto such a map without conversion
   *   (reprojection) will be inaccurate! Check out our [radar
   *   demo](https://brightsky.dev/demo/radar/) for an example of correctly
   *   reprojecting the radar data using OpenLayers. Alternatively, take a look
   *   at the `dwd:RV-Produkt` layer on the [DWD's open
   *   GeoServer](https://maps.dwd.de/geoserver/web/wicket/bookmarkable/org.geoserver.web.demo.MapPreviewPage)
   *   for ready-made tiles you can overlay onto a map.
   * * The [proj-string](https://proj.org/en/9.2/usage/quickstart.html) for the
   *   grid projection is `+proj=stere +lat_0=90 +lat_ts=60 +lon_0=10 +a=6378137
   *   +b=6356752.3142451802 +no_defs +x_0=543196.83521776402
   *   +y_0=3622588.8619310018`. The radar pixels range from `-500` (left) to
   *   `1099500` (right) on the x-axis, and from `500` (top) to `-1199500`
   *   (bottom) on the y-axis, each radar pixel a size of `1000x1000` (1 km²).
   * * The DWD data does not cover the whole grid! Many areas near the edges
   *   will always be `0`.
   * * Values represent 0.01 mm / 5 min. I.e., if a pixel has a value of `45`,
   *   then 0.45 mm of precipitation fell in the corresponding square kilometer
   *   in the past five minutes.
   * * The four corners of the grid are as follows:
   *   * Northwest: Latitude `55.86208711`, Longitude `1.463301510`
   *   * Northeast: Latitude `55.84543856`, Longitude `18.73161645`
   *   * Southeast: Latitude `45.68460578`, Longitude `16.58086935`
   *   * Southwest: Latitude `45.69642538`, Longitude `3.566994635`
   * 
   * You can find details and more information in the [DWD's `RV product info`
   * (German
   * only)](https://www.dwd.de/DE/leistungen/radarprodukte/formatbeschreibung_rv.pdf?__blob=publicationFile&v=3).
   * Below is an example visualization of the rainfall radar data taken from
   * this document, using the correct projection and showing the radar coverage:
   * 
   * ![image](https://github.com/jdemaeyer/brightsky/assets/10531844/09f9bb5f-088a-417e-8a0c-ea5a20fe0969)
   * 
   * ### Code examples
   * 
   * > The radar data is quite big (naively unpacking the default 25-frames
   * > response into Python integer arrays will eat roughly 125 MB of memory),
   * > so use `bbox` whenever you can.
   * 
   * #### `compressed` format
   * 
   * With Javascript using [`pako`](https://github.com/nodeca/pako):
   * 
   * ```js
   * fetch(
   *   'https://api.brightsky.dev/radar'
   * ).then((resp) => resp.json()
   * ).then((respData) => {
   *   const raw = respData.radar[0].precipitation_5;
   *   const compressed = Uint8Array.from(atob(raw), c => c.charCodeAt(0));
   *   const rawBytes = pako.inflate(compressed).buffer;
   *   const precipitation = new Uint16Array(rawBytes);
   * });
   * ```
   * 
   * With Python using `numpy`:
   * 
   * ```python
   * import base64
   * import zlib
   * 
   * import numpy as np
   * import requests
   * 
   * resp = requests.get('https://api.brightsky.dev/radar')
   * raw = resp.json()['radar'][0]['precipitation_5']
   * raw_bytes = zlib.decompress(base64.b64decode(raw))
   * 
   * data = np.frombuffer(
   *     raw_bytes,
   *     dtype='i2',
   * ).reshape(
   *     # Adjust `1200` and `1100` to the height/width of your bbox
   *     (1200, 1100),
   * )
   * ```
   * 
   * With Python using the standard library's `array`:
   * ```python
   * import array
   * 
   * # [... load raw_bytes as above ...]
   * 
   * data = array.array('H')
   * data.frombytes(raw_bytes)
   * data = [
   *     # Adjust `1200` and `1100` to the height/width of your bbox
   *     data[row*1100:(row+1)*1100]
   *     for row in range(1200)
   * ]
   * ```
   * 
   * Simple plot using `matplotlib`:
   * ```python
   * import matplotlib.pyplot as plt
   * 
   * # [... load data as above ...]
   * 
   * plt.imshow(data, vmax=50)
   * plt.show()
   * ```
   * 
   * #### `bytes` format
   * 
   * Same as for `compressed`, but add `?format=bytes` to the URL and remove the
   * call to `zlib.decompress`, using just `raw_bytes = base64.b64decode(raw)`
   * instead.
   * 
   * #### `plain` format
   * 
   * This is obviously a lot simpler than the `compressed` format. It is,
   * however, also a lot slower. Nonetheless, if you have a small-ish `bbox` the
   * performance difference becomes manageable, so just using the `plain` format
   * and not having to deal with unpacking logic can be a good option in this
   * case.
   * 
   * With Python:
   * ```python
   * import requests
   * 
   * resp = requests.get('https://api.brightsky.dev/radar?format=plain')
   * data = resp.json()['radar'][0]['precipitation_5']
   * ```
   * 
   * ### Additional resources
   * 
   * * [Source for our radar demo, including reprojecton via OpenLayers](https://github.com/jdemaeyer/brightsky/blob/master/docs/demo/radar/index.html)
   * * [Raw data on the Open Data Server](https://opendata.dwd.de/weather/radar/composite/rv/)
   * * [Details on the `RV` product (German)](https://www.dwd.de/DE/leistungen/radarprodukte/formatbeschreibung_rv.pdf?__blob=publicationFile&v=3)
   * * [Visualization of current rainfall radar](https://www.dwd.de/DE/leistungen/radarbild_film/radarbild_film.html)
   * * [General info on DWD radar products (German)](https://www.dwd.de/DE/leistungen/radarprodukte/radarprodukte.html)
   * * [Radar status (German)](https://www.dwd.de/DE/leistungen/radarniederschlag/rn_info/home_freie_radarstatus_kartendaten.html?nn=16102)
   * * [DWD notifications for radar products (German)](https://www.dwd.de/DE/leistungen/radolan/radolan_info/radolan_informationen.html?nn=16102)
   */
  'getRadar'(
    parameters?: Parameters<Paths.GetRadar.QueryParameters> | null,
    data?: any,
    config?: AxiosRequestConfig  
  ): OperationResponse<Paths.GetRadar.Responses.$200>
  /**
   * getAlerts - Alerts
   * 
   * Returns a list of weather alerts for the given location, or all weather
   * alerts if no location given.
   * 
   * If you supply either `warn_cell_id` or both `lat` and `lon`, Bright Sky
   * will return additional information on that cell in the `location` field.
   * Warn cell IDs are municipality (_Gemeinde_) cell IDs.
   * 
   * ### Notes
   * 
   * * The DWD divides Germany's area into roughly 11,000 "cells" based on
   *   municipalities (_Gemeinden_), and issues warnings for each of these
   *   cells. Most warnings apply to many cells.
   * * Bright Sky will supply information on the cell that a given lat/lon
   *   belongs to in the `location` field.
   * * There is also a set of roughly 400 cells based on districts
   *   (_Landkreise_) that is not supported by Bright Sky.
   * * The complete list of cells can be found on the DWD GeoServer (see below).
   * 
   * ### Additional resources
   * 
   * * [Live demo of a simple interactive alerts map](https://brightsky.dev/demo/alerts/)
   * * [Source for alerts map demo](https://github.com/jdemaeyer/brightsky/blob/master/docs/demo/alerts/index.html)
   * * [Map view of all current alerts by the DWD](https://www.dwd.de/DE/wetter/warnungen_gemeinden/warnWetter_node.html)
   * * [List of municipality cells](https://maps.dwd.de/geoserver/wfs?SERVICE=WFS&VERSION=2.0.0&REQUEST=GetFeature&TYPENAMES=Warngebiete_Gemeinden&OUTPUTFORMAT=json)
   * * [List of district cells (*not used by Bright Sky!*)](https://maps.dwd.de/geoserver/wfs?SERVICE=WFS&VERSION=2.0.0&REQUEST=GetFeature&TYPENAMES=Warngebiete_Kreise&OUTPUTFORMAT=json)
   * * [Raw data on the Open Data Server](https://opendata.dwd.de/weather/alerts/cap/COMMUNEUNION_DWD_STAT/)
   * * [DWD Documentation on alert fields and their allowed contents (English)](https://www.dwd.de/DE/leistungen/opendata/help/warnungen/cap_dwd_profile_en_pdf_2_1_13.pdf?__blob=publicationFile&v=3)
   * * [DWD Documentation on alert fields and their allowed contents (German)](https://www.dwd.de/DE/leistungen/opendata/help/warnungen/cap_dwd_profile_de_pdf_2_1_13.pdf?__blob=publicationFile&v=3)
   */
  'getAlerts'(
    parameters?: Parameters<Paths.GetAlerts.QueryParameters> | null,
    data?: any,
    config?: AxiosRequestConfig  
  ): OperationResponse<Paths.GetAlerts.Responses.$200>
}

export interface PathsDictionary {
  ['/sources']: {
    /**
     * getSources - Weather sources (stations)
     * 
     * Return a list of all Bright Sky sources matching the given location
     * criteria, ordered by distance.
     * 
     * You must supply both `lat` and `lon` _or_ one of `dwd_station_id`,
     * `wmo_station_id`, or `source_id`.
     */
    'get'(
      parameters?: Parameters<Paths.GetSources.QueryParameters> | null,
      data?: any,
      config?: AxiosRequestConfig  
    ): OperationResponse<Paths.GetSources.Responses.$200>
  }
  ['/current_weather']: {
    /**
     * getCurrentWeather - Current weather
     * 
     * Returns current weather for a given location.
     * 
     * To set the location for which to retrieve weather, you must supply both
     * `lat` and `lon` _or_ one of `dwd_station_id`, `wmo_station_id`, or
     * `source_id`.
     * 
     * This endpoint is different from the other weather endpoints in that it does
     * not directly correspond to any of the data available from the DWD Open Data
     * server. Instead, it is a best-effort solution to reflect current weather
     * conditions by compiling [SYNOP observations](/operations/getSynop) from the
     * past one and a half hours.
     */
    'get'(
      parameters?: Parameters<Paths.GetCurrentWeather.QueryParameters> | null,
      data?: any,
      config?: AxiosRequestConfig  
    ): OperationResponse<Paths.GetCurrentWeather.Responses.$200>
  }
  ['/weather']: {
    /**
     * getWeather - Hourly weather (including forecasts)
     * 
     * Returns a list of hourly weather records (and/or forecasts) for the time
     * range given by `date` and `last_date`.
     * 
     * To set the location for which to retrieve records (and/or forecasts), you
     * must supply both `lat` and `lon` _or_ one of `dwd_station_id`,
     * `wmo_station_id`, or `source_id`.
     */
    'get'(
      parameters?: Parameters<Paths.GetWeather.QueryParameters> | null,
      data?: any,
      config?: AxiosRequestConfig  
    ): OperationResponse<Paths.GetWeather.Responses.$200>
  }
  ['/synop']: {
    /**
     * getSynop - Raw SYNOP observations
     * 
     * Returns a list of ten-minutely SYNOP observations for the time range given
     * by `date` and `last_date`. Note that Bright Sky only stores SYNOP
     * observations from the past 30 hours.
     * 
     * To set the weather station for which to retrieve records, you must supply
     * one of `dwd_station_id`, `wmo_station_id`, or `source_id`. The `/synop`
     * endpoint does not support `lat` and `lon`; use the
     * [`/sources` endpoint](/operations/getSources) if you need to retrieve a
     * SYNOP station ID close to a given location.
     * 
     * SYNOP observations are stored as they were reported, which in particular
     * implies that many parameters are only available at certain timestamps. For
     * example, most stations report `sunshine_60` only on the full hour, and
     * `sunshine_30` only at 30 minutes past the full hour (i.e. also not on the
     * full hour). Check out the
     * [`/current_weather` endpoint](/operations/getCurrentWeather) for an
     * opinionated compilation of recent SYNOP records into a single "current
     * weather" record.
     */
    'get'(
      parameters?: Parameters<Paths.GetSynop.QueryParameters> | null,
      data?: any,
      config?: AxiosRequestConfig  
    ): OperationResponse<Paths.GetSynop.Responses.$200>
  }
  ['/radar']: {
    /**
     * getRadar - Radar
     * 
     * Returns radar rainfall data with 1 km spatial and 5 minute temporal
     * resolution, including a forecast for the next two hours.
     * 
     * Radar data is recorded on a 1200 km (North-South) x 1100 km (East-West)
     * grid, with each pixel representing 1 km². **That's quite a lot of data, so
     * use `lat`/`lon` or `bbox` whenever you can (see below).** Past radar
     * records are kept for six hours.
     * 
     * Bright Sky can return the data in a few formats. Use the default
     * `compressed` format if possible – this'll get you the fastest response
     * times by far and reduce load on the server. If you have a small-ish
     * bounding box (e.g. 250 x 250 pixels), using the `plain` format should be
     * fine.
     * 
     * ### Quickstart
     * 
     * This request will get you radar data near Münster, reaching 200 km to the
     * East/West/North/South, as a two-dimensional grid of integers:
     * 
     * [`https://api.brightsky.dev/radar?lat=52&lon=7.6&format=plain`](https://api.brightsky.dev/radar?lat=52&lon=7.6&format=plain)
     * 
     * ### Content
     * 
     * * The grid is a polar stereographic projection of Germany and the regions
     *   bordering it. This is different from the mercator projection used for
     *   most consumer-facing maps like OpenStreetMap or Google Maps, and
     *   overlaying the radar data onto such a map without conversion
     *   (reprojection) will be inaccurate! Check out our [radar
     *   demo](https://brightsky.dev/demo/radar/) for an example of correctly
     *   reprojecting the radar data using OpenLayers. Alternatively, take a look
     *   at the `dwd:RV-Produkt` layer on the [DWD's open
     *   GeoServer](https://maps.dwd.de/geoserver/web/wicket/bookmarkable/org.geoserver.web.demo.MapPreviewPage)
     *   for ready-made tiles you can overlay onto a map.
     * * The [proj-string](https://proj.org/en/9.2/usage/quickstart.html) for the
     *   grid projection is `+proj=stere +lat_0=90 +lat_ts=60 +lon_0=10 +a=6378137
     *   +b=6356752.3142451802 +no_defs +x_0=543196.83521776402
     *   +y_0=3622588.8619310018`. The radar pixels range from `-500` (left) to
     *   `1099500` (right) on the x-axis, and from `500` (top) to `-1199500`
     *   (bottom) on the y-axis, each radar pixel a size of `1000x1000` (1 km²).
     * * The DWD data does not cover the whole grid! Many areas near the edges
     *   will always be `0`.
     * * Values represent 0.01 mm / 5 min. I.e., if a pixel has a value of `45`,
     *   then 0.45 mm of precipitation fell in the corresponding square kilometer
     *   in the past five minutes.
     * * The four corners of the grid are as follows:
     *   * Northwest: Latitude `55.86208711`, Longitude `1.463301510`
     *   * Northeast: Latitude `55.84543856`, Longitude `18.73161645`
     *   * Southeast: Latitude `45.68460578`, Longitude `16.58086935`
     *   * Southwest: Latitude `45.69642538`, Longitude `3.566994635`
     * 
     * You can find details and more information in the [DWD's `RV product info`
     * (German
     * only)](https://www.dwd.de/DE/leistungen/radarprodukte/formatbeschreibung_rv.pdf?__blob=publicationFile&v=3).
     * Below is an example visualization of the rainfall radar data taken from
     * this document, using the correct projection and showing the radar coverage:
     * 
     * ![image](https://github.com/jdemaeyer/brightsky/assets/10531844/09f9bb5f-088a-417e-8a0c-ea5a20fe0969)
     * 
     * ### Code examples
     * 
     * > The radar data is quite big (naively unpacking the default 25-frames
     * > response into Python integer arrays will eat roughly 125 MB of memory),
     * > so use `bbox` whenever you can.
     * 
     * #### `compressed` format
     * 
     * With Javascript using [`pako`](https://github.com/nodeca/pako):
     * 
     * ```js
     * fetch(
     *   'https://api.brightsky.dev/radar'
     * ).then((resp) => resp.json()
     * ).then((respData) => {
     *   const raw = respData.radar[0].precipitation_5;
     *   const compressed = Uint8Array.from(atob(raw), c => c.charCodeAt(0));
     *   const rawBytes = pako.inflate(compressed).buffer;
     *   const precipitation = new Uint16Array(rawBytes);
     * });
     * ```
     * 
     * With Python using `numpy`:
     * 
     * ```python
     * import base64
     * import zlib
     * 
     * import numpy as np
     * import requests
     * 
     * resp = requests.get('https://api.brightsky.dev/radar')
     * raw = resp.json()['radar'][0]['precipitation_5']
     * raw_bytes = zlib.decompress(base64.b64decode(raw))
     * 
     * data = np.frombuffer(
     *     raw_bytes,
     *     dtype='i2',
     * ).reshape(
     *     # Adjust `1200` and `1100` to the height/width of your bbox
     *     (1200, 1100),
     * )
     * ```
     * 
     * With Python using the standard library's `array`:
     * ```python
     * import array
     * 
     * # [... load raw_bytes as above ...]
     * 
     * data = array.array('H')
     * data.frombytes(raw_bytes)
     * data = [
     *     # Adjust `1200` and `1100` to the height/width of your bbox
     *     data[row*1100:(row+1)*1100]
     *     for row in range(1200)
     * ]
     * ```
     * 
     * Simple plot using `matplotlib`:
     * ```python
     * import matplotlib.pyplot as plt
     * 
     * # [... load data as above ...]
     * 
     * plt.imshow(data, vmax=50)
     * plt.show()
     * ```
     * 
     * #### `bytes` format
     * 
     * Same as for `compressed`, but add `?format=bytes` to the URL and remove the
     * call to `zlib.decompress`, using just `raw_bytes = base64.b64decode(raw)`
     * instead.
     * 
     * #### `plain` format
     * 
     * This is obviously a lot simpler than the `compressed` format. It is,
     * however, also a lot slower. Nonetheless, if you have a small-ish `bbox` the
     * performance difference becomes manageable, so just using the `plain` format
     * and not having to deal with unpacking logic can be a good option in this
     * case.
     * 
     * With Python:
     * ```python
     * import requests
     * 
     * resp = requests.get('https://api.brightsky.dev/radar?format=plain')
     * data = resp.json()['radar'][0]['precipitation_5']
     * ```
     * 
     * ### Additional resources
     * 
     * * [Source for our radar demo, including reprojecton via OpenLayers](https://github.com/jdemaeyer/brightsky/blob/master/docs/demo/radar/index.html)
     * * [Raw data on the Open Data Server](https://opendata.dwd.de/weather/radar/composite/rv/)
     * * [Details on the `RV` product (German)](https://www.dwd.de/DE/leistungen/radarprodukte/formatbeschreibung_rv.pdf?__blob=publicationFile&v=3)
     * * [Visualization of current rainfall radar](https://www.dwd.de/DE/leistungen/radarbild_film/radarbild_film.html)
     * * [General info on DWD radar products (German)](https://www.dwd.de/DE/leistungen/radarprodukte/radarprodukte.html)
     * * [Radar status (German)](https://www.dwd.de/DE/leistungen/radarniederschlag/rn_info/home_freie_radarstatus_kartendaten.html?nn=16102)
     * * [DWD notifications for radar products (German)](https://www.dwd.de/DE/leistungen/radolan/radolan_info/radolan_informationen.html?nn=16102)
     */
    'get'(
      parameters?: Parameters<Paths.GetRadar.QueryParameters> | null,
      data?: any,
      config?: AxiosRequestConfig  
    ): OperationResponse<Paths.GetRadar.Responses.$200>
  }
  ['/alerts']: {
    /**
     * getAlerts - Alerts
     * 
     * Returns a list of weather alerts for the given location, or all weather
     * alerts if no location given.
     * 
     * If you supply either `warn_cell_id` or both `lat` and `lon`, Bright Sky
     * will return additional information on that cell in the `location` field.
     * Warn cell IDs are municipality (_Gemeinde_) cell IDs.
     * 
     * ### Notes
     * 
     * * The DWD divides Germany's area into roughly 11,000 "cells" based on
     *   municipalities (_Gemeinden_), and issues warnings for each of these
     *   cells. Most warnings apply to many cells.
     * * Bright Sky will supply information on the cell that a given lat/lon
     *   belongs to in the `location` field.
     * * There is also a set of roughly 400 cells based on districts
     *   (_Landkreise_) that is not supported by Bright Sky.
     * * The complete list of cells can be found on the DWD GeoServer (see below).
     * 
     * ### Additional resources
     * 
     * * [Live demo of a simple interactive alerts map](https://brightsky.dev/demo/alerts/)
     * * [Source for alerts map demo](https://github.com/jdemaeyer/brightsky/blob/master/docs/demo/alerts/index.html)
     * * [Map view of all current alerts by the DWD](https://www.dwd.de/DE/wetter/warnungen_gemeinden/warnWetter_node.html)
     * * [List of municipality cells](https://maps.dwd.de/geoserver/wfs?SERVICE=WFS&VERSION=2.0.0&REQUEST=GetFeature&TYPENAMES=Warngebiete_Gemeinden&OUTPUTFORMAT=json)
     * * [List of district cells (*not used by Bright Sky!*)](https://maps.dwd.de/geoserver/wfs?SERVICE=WFS&VERSION=2.0.0&REQUEST=GetFeature&TYPENAMES=Warngebiete_Kreise&OUTPUTFORMAT=json)
     * * [Raw data on the Open Data Server](https://opendata.dwd.de/weather/alerts/cap/COMMUNEUNION_DWD_STAT/)
     * * [DWD Documentation on alert fields and their allowed contents (English)](https://www.dwd.de/DE/leistungen/opendata/help/warnungen/cap_dwd_profile_en_pdf_2_1_13.pdf?__blob=publicationFile&v=3)
     * * [DWD Documentation on alert fields and their allowed contents (German)](https://www.dwd.de/DE/leistungen/opendata/help/warnungen/cap_dwd_profile_de_pdf_2_1_13.pdf?__blob=publicationFile&v=3)
     */
    'get'(
      parameters?: Parameters<Paths.GetAlerts.QueryParameters> | null,
      data?: any,
      config?: AxiosRequestConfig  
    ): OperationResponse<Paths.GetAlerts.Responses.$200>
  }
}

export type Client = OpenAPIClient<OperationMethods, PathsDictionary>


export type Alert = Components.Schemas.Alert;
export type AlertsResponse = Components.Schemas.AlertsResponse;
export type CurrentWeatherRecord = Components.Schemas.CurrentWeatherRecord;
export type CurrentWeatherResponse = Components.Schemas.CurrentWeatherResponse;
export type HTTPValidationError = Components.Schemas.HTTPValidationError;
export type Location = Components.Schemas.Location;
export type NotFoundResponse = Components.Schemas.NotFoundResponse;
export type RadarRecord = Components.Schemas.RadarRecord;
export type RadarResponse = Components.Schemas.RadarResponse;
export type Source = Components.Schemas.Source;
export type SourcesResponse = Components.Schemas.SourcesResponse;
export type SynopRecord = Components.Schemas.SynopRecord;
export type SynopResponse = Components.Schemas.SynopResponse;
export type ValidationError = Components.Schemas.ValidationError;
export type WeatherRecord = Components.Schemas.WeatherRecord;
export type WeatherResponse = Components.Schemas.WeatherResponse;
