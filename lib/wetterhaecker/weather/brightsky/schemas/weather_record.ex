defmodule Wetterhaecker.Weather.Brightsky.WeatherRecord do
  @moduledoc """
  Provides struct and type for a WeatherRecord
  """

  @type t :: %__MODULE__{
          cloud_cover: number | nil,
          condition: String.t() | nil,
          dew_point: number | nil,
          fallback_source_ids: map | nil,
          icon: String.t() | nil,
          precipitation: number | nil,
          precipitation_probability: integer | nil,
          precipitation_probability_6h: integer | nil,
          pressure_msl: number | nil,
          relative_humidity: integer | nil,
          solar: number | nil,
          source_id: integer | nil,
          sunshine: integer | nil,
          temperature: number | nil,
          timestamp: DateTime.t() | nil,
          visibility: integer | nil,
          wind_direction: integer | nil,
          wind_gust_direction: integer | nil,
          wind_gust_speed: number | nil,
          wind_speed: number | nil
        }

  defstruct [
    :cloud_cover,
    :condition,
    :dew_point,
    :fallback_source_ids,
    :icon,
    :precipitation,
    :precipitation_probability,
    :precipitation_probability_6h,
    :pressure_msl,
    :relative_humidity,
    :solar,
    :source_id,
    :sunshine,
    :temperature,
    :timestamp,
    :visibility,
    :wind_direction,
    :wind_gust_direction,
    :wind_gust_speed,
    :wind_speed
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
      precipitation: :number,
      precipitation_probability: :integer,
      precipitation_probability_6h: :integer,
      pressure_msl: :number,
      relative_humidity: :integer,
      solar: :number,
      source_id: :integer,
      sunshine: :integer,
      temperature: :number,
      timestamp: {:string, :date_time},
      visibility: :integer,
      wind_direction: :integer,
      wind_gust_direction: :integer,
      wind_gust_speed: :number,
      wind_speed: :number
    ]
  end
end
