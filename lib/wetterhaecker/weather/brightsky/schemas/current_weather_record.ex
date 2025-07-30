defmodule Wetterhaecker.Weather.Brightsky.CurrentWeatherRecord do
  @moduledoc """
  Provides struct and type for a CurrentWeatherRecord
  """

  @type t :: %__MODULE__{
          cloud_cover: number | nil,
          condition: String.t() | nil,
          dew_point: number | nil,
          fallback_source_ids: map | nil,
          icon: String.t() | nil,
          precipitation_10: number | nil,
          precipitation_30: number | nil,
          precipitation_60: number | nil,
          pressure_msl: number | nil,
          relative_humidity: integer | nil,
          solar_10: number | nil,
          solar_30: number | nil,
          solar_60: number | nil,
          source_id: integer | nil,
          sunshine_30: integer | nil,
          sunshine_60: integer | nil,
          temperature: number | nil,
          timestamp: DateTime.t() | nil,
          visibility: integer | nil,
          wind_direction_10: integer | nil,
          wind_direction_30: integer | nil,
          wind_direction_60: integer | nil,
          wind_gust_direction_10: integer | nil,
          wind_gust_direction_30: integer | nil,
          wind_gust_direction_60: integer | nil,
          wind_gust_speed_10: number | nil,
          wind_gust_speed_30: number | nil,
          wind_gust_speed_60: number | nil,
          wind_speed_10: number | nil,
          wind_speed_30: number | nil,
          wind_speed_60: number | nil
        }

  defstruct [
    :cloud_cover,
    :condition,
    :dew_point,
    :fallback_source_ids,
    :icon,
    :precipitation_10,
    :precipitation_30,
    :precipitation_60,
    :pressure_msl,
    :relative_humidity,
    :solar_10,
    :solar_30,
    :solar_60,
    :source_id,
    :sunshine_30,
    :sunshine_60,
    :temperature,
    :timestamp,
    :visibility,
    :wind_direction_10,
    :wind_direction_30,
    :wind_direction_60,
    :wind_gust_direction_10,
    :wind_gust_direction_30,
    :wind_gust_direction_60,
    :wind_gust_speed_10,
    :wind_gust_speed_30,
    :wind_gust_speed_60,
    :wind_speed_10,
    :wind_speed_30,
    :wind_speed_60
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      cloud_cover: :number,
      condition: {:enum, ["dry", "fog", "rain", "sleet", "snow", "hail", "thunderstorm"]},
      dew_point: :number,
      fallback_source_ids: :map,
      icon:
        {:enum,
         [
           "clear-day",
           "clear-night",
           "partly-cloudy-day",
           "partly-cloudy-night",
           "cloudy",
           "fog",
           "wind",
           "rain",
           "sleet",
           "snow",
           "hail",
           "thunderstorm"
         ]},
      precipitation_10: :number,
      precipitation_30: :number,
      precipitation_60: :number,
      pressure_msl: :number,
      relative_humidity: :integer,
      solar_10: :number,
      solar_30: :number,
      solar_60: :number,
      source_id: :integer,
      sunshine_30: :integer,
      sunshine_60: :integer,
      temperature: :number,
      timestamp: {:string, :date_time},
      visibility: :integer,
      wind_direction_10: :integer,
      wind_direction_30: :integer,
      wind_direction_60: :integer,
      wind_gust_direction_10: :integer,
      wind_gust_direction_30: :integer,
      wind_gust_direction_60: :integer,
      wind_gust_speed_10: :number,
      wind_gust_speed_30: :number,
      wind_gust_speed_60: :number,
      wind_speed_10: :number,
      wind_speed_30: :number,
      wind_speed_60: :number
    ]
  end
end
