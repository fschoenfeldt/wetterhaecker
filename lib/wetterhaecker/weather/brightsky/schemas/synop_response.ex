defmodule Wetterhaecker.Weather.Brightsky.SynopResponse do
  @moduledoc """
  Provides struct and type for a SynopResponse
  """

  alias Wetterhaecker.Weather.Brightsky.Source
  alias Wetterhaecker.Weather.Brightsky.SynopRecord

  @type t :: %__MODULE__{
          sources: [Source.t()] | nil,
          weather: [SynopRecord.t()] | nil
        }

  defstruct [:sources, :weather]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      sources: [{Source, :t}],
      weather: [{SynopRecord, :t}]
    ]
  end
end
