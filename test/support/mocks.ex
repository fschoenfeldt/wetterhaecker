defmodule Wetterhaecker.Test.Mocks do
  @moduledoc """
  Defines mocks for testing.
  """

  # Define mocks using Hammox
  Hammox.defmock(Wetterhaecker.Brightsky.WeatherMock, for: Wetterhaecker.Brightsky.WeatherBehaviour)
end
