defmodule Wetterhaecker.Brightsky.Weather do
  @moduledoc """
  Service that wraps the automatically generated Brightsky API clients.
  This service is designed to be mockable in tests.
  """

  @behaviour Wetterhaecker.Brightsky.WeatherBehaviour

  alias Wetterhaecker.Brightsky.Operations

  defp implementation, do: Application.get_env(:wetterhaecker, :brightsky_service, Operations)

  @impl true
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
  def get_weather(opts) do
    implementation().get_weather(opts)
  end
end
