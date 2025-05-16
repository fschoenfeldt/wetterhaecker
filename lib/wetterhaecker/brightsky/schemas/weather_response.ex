defmodule Wetterhaecker.Brightsky.WeatherResponse do
  @moduledoc """
  Provides struct and type for a WeatherResponse
  """

  @type t :: %__MODULE__{
          sources: [Wetterhaecker.Brightsky.Source.t()] | nil,
          weather: [Wetterhaecker.Brightsky.WeatherRecord.t()] | nil
        }

  defstruct [:sources, :weather]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      sources: [{Wetterhaecker.Brightsky.Source, :t}],
      weather: [{Wetterhaecker.Brightsky.WeatherRecord, :t}]
    ]
  end
end
