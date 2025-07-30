defmodule Wetterhaecker.Weather.WeatherBehaviour do
  @moduledoc """
  Behaviour for Weather context.
  """

  @callback get_weather(Keyword.t()) :: {:ok, map()} | {:error, term()}
end
