defmodule Wetterhaecker.Test.Mocks do
  @moduledoc """
  Defines mocks for testing.
  """

  # Define mocks using Hammox
  Hammox.defmock(Wetterhaecker.Weather.WeatherMock, for: Wetterhaecker.Weather)
end
