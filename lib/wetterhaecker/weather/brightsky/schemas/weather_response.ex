defmodule Wetterhaecker.Weather.Brightsky.WeatherResponse do
  @moduledoc """
  Provides struct and type for a WeatherResponse
  """

  alias Wetterhaecker.Weather.Brightsky.Source
  alias Wetterhaecker.Weather.Brightsky.WeatherRecord

  @type t :: %__MODULE__{
          sources: [Source.t()] | nil,
          weather: [WeatherRecord.t()] | nil
        }

  defstruct [:sources, :weather]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      sources: [{Source, :t}],
      weather: [{WeatherRecord, :t}]
    ]
  end
end
