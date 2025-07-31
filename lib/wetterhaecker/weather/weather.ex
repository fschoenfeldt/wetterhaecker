defmodule Wetterhaecker.Weather do
  @moduledoc """
  Context that provides weather data for a specific location and date.
  """

  use Knigge, otp_app: :wetterhaecker, default: Wetterhaecker.Weather.Brightsky.Operations

  @doc """
  Gets weather data for a specific location and date.

  ## Parameters

  - opts: Options for the weather API
    - `:date` - The date for which to get weather data
    - `:lat` - Latitude
    - `:lon` - Longitude
    - other options as supported by Brightsky API

  ## Returns

  - `{:ok, result}` on success
  - `{:error, reason}` on failure
  """
  @callback get_weather(Keyword.t()) :: {:ok, map()} | {:error, term()}
end
