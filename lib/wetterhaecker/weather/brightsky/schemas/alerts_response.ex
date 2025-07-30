defmodule Wetterhaecker.Weather.Brightsky.AlertsResponse do
  @moduledoc """
  Provides struct and type for a AlertsResponse
  """

  alias Wetterhaecker.Weather.Brightsky.Alert
  alias Wetterhaecker.Weather.Brightsky.Location

  @type t :: %__MODULE__{
          alerts: [Alert.t()] | nil,
          location: Location.t() | nil
        }

  defstruct [:alerts, :location]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      alerts: [{Alert, :t}],
      location: {Location, :t}
    ]
  end
end
