defmodule Wetterhaecker.Weather.Brightsky.RadarRecord do
  @moduledoc """
  Provides struct and type for a RadarRecord
  """

  @type t :: %__MODULE__{
          precipitation_5: String.t() | nil,
          source: String.t() | nil,
          timestamp: DateTime.t() | nil
        }

  defstruct [:precipitation_5, :source, :timestamp]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      precipitation_5: {:string, :generic},
      source: {:string, :generic},
      timestamp: {:string, :date_time}
    ]
  end
end
