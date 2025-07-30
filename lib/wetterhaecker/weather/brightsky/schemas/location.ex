defmodule Wetterhaecker.Weather.Brightsky.Location do
  @moduledoc """
  Provides struct and type for a Location
  """

  @type t :: %__MODULE__{
          district: String.t() | nil,
          name: String.t() | nil,
          name_short: String.t() | nil,
          state: String.t() | nil,
          state_short: String.t() | nil,
          warn_cell_id: integer | nil
        }

  defstruct [:district, :name, :name_short, :state, :state_short, :warn_cell_id]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      district: {:string, :generic},
      name: {:string, :generic},
      name_short: {:string, :generic},
      state: {:string, :generic},
      state_short: {:string, :generic},
      warn_cell_id: :integer
    ]
  end
end
