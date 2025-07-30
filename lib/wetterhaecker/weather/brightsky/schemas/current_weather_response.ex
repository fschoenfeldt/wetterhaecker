defmodule Wetterhaecker.Weather.Brightsky.CurrentWeatherResponse do
  @moduledoc """
  Provides struct and type for a CurrentWeatherResponse
  """

  alias Wetterhaecker.Weather.Brightsky.CurrentWeatherRecord
  alias Wetterhaecker.Weather.Brightsky.Source

  @type t :: %__MODULE__{
          sources: [Source.t()] | nil,
          weather: CurrentWeatherRecord.t() | nil
        }

  defstruct [:sources, :weather]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      sources: [{Source, :t}],
      weather: {CurrentWeatherRecord, :t}
    ]
  end
end
