defmodule Wetterhaecker.Weather.Brightsky.SourcesResponse do
  @moduledoc """
  Provides struct and type for a SourcesResponse
  """

  alias Wetterhaecker.Weather.Brightsky.Source

  @type t :: %__MODULE__{sources: [Source.t()] | nil}

  defstruct [:sources]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [sources: [{Source, :t}]]
  end
end
