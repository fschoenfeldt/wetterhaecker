defmodule Wetterhaecker.Brightsky.RadarResponse do
  @moduledoc """
  Provides struct and type for a RadarResponse
  """

  @type t :: %__MODULE__{
          bbox: [integer] | nil,
          geometry: map | nil,
          latlon_position: map | nil,
          radar: [Wetterhaecker.Brightsky.RadarRecord.t()] | nil
        }

  defstruct [:bbox, :geometry, :latlon_position, :radar]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      bbox: [:integer],
      geometry: :map,
      latlon_position: :map,
      radar: [{Wetterhaecker.Brightsky.RadarRecord, :t}]
    ]
  end
end
