defmodule Wetterhaecker.Brightsky.WeatherBehaviour do
  @moduledoc """
  Behaviour for Brightsky API service.
  """

  @callback get_weather(Keyword.t()) :: {:ok, map()} | {:error, term()}
end
