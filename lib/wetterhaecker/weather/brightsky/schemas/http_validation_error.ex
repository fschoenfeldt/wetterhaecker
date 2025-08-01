defmodule Wetterhaecker.Weather.Brightsky.HTTPValidationError do
  @moduledoc """
  Provides struct and type for a HTTPValidationError
  """

  alias Wetterhaecker.Weather.Brightsky.ValidationError

  @type t :: %__MODULE__{detail: [ValidationError.t()] | nil}

  defstruct [:detail]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [detail: [{ValidationError, :t}]]
  end
end
