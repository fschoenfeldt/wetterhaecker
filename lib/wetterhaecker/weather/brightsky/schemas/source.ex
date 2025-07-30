defmodule Wetterhaecker.Weather.Brightsky.Source do
  @moduledoc """
  Provides struct and type for a Source
  """

  @type t :: %__MODULE__{
          distance: integer | nil,
          dwd_station_id: String.t() | nil,
          first_record: DateTime.t() | nil,
          height: number | nil,
          id: integer | nil,
          last_record: DateTime.t() | nil,
          lat: number | nil,
          lon: number | nil,
          observation_type: String.t() | nil,
          station_name: String.t() | nil,
          wmo_station_id: String.t() | nil
        }

  defstruct [
    :distance,
    :dwd_station_id,
    :first_record,
    :height,
    :id,
    :last_record,
    :lat,
    :lon,
    :observation_type,
    :station_name,
    :wmo_station_id
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      distance: :integer,
      dwd_station_id: {:string, :generic},
      first_record: {:string, :date_time},
      height: :number,
      id: :integer,
      last_record: {:string, :date_time},
      lat: :number,
      lon: :number,
      observation_type: {:enum, ["historical", "current", "synop", "forecast"]},
      station_name: {:string, :generic},
      wmo_station_id: {:string, :generic}
    ]
  end
end
