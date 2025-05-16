defmodule Wetterhaecker.Brightsky.SourcesResponse do
  @moduledoc """
  Provides struct and type for a SourcesResponse
  """

  @type t :: %__MODULE__{sources: [Wetterhaecker.Brightsky.Source.t()] | nil}

  defstruct [:sources]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [sources: [{Wetterhaecker.Brightsky.Source, :t}]]
  end
end
