defmodule Wetterhaecker.Weather.Brightsky.NotFoundResponse do
  @moduledoc """
  Provides struct and type for a NotFoundResponse
  """

  @type t :: %__MODULE__{detail: String.t() | nil}

  defstruct [:detail]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [detail: {:string, :generic}]
  end
end
