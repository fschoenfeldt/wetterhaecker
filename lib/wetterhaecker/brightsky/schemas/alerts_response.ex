defmodule Wetterhaecker.Brightsky.AlertsResponse do
  @moduledoc """
  Provides struct and type for a AlertsResponse
  """

  @type t :: %__MODULE__{
          alerts: [Wetterhaecker.Brightsky.Alert.t()] | nil,
          location: Wetterhaecker.Brightsky.Location.t() | nil
        }

  defstruct [:alerts, :location]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      alerts: [{Wetterhaecker.Brightsky.Alert, :t}],
      location: {Wetterhaecker.Brightsky.Location, :t}
    ]
  end
end
