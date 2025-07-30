defmodule Wetterhaecker.Encoder do
  @moduledoc """
  Protocol derivations for JSON encoding.
  """

  alias Wetterhaecker.Weather.Brightsky.Source
  alias Wetterhaecker.Weather.Brightsky.WeatherRecord
  alias Wetterhaecker.Weather.Brightsky.WeatherResponse

  require Protocol

  Protocol.derive(Jason.Encoder, GpxEx.TrackPoint)
  Protocol.derive(Jason.Encoder, Source)
  Protocol.derive(Jason.Encoder, WeatherResponse)
  Protocol.derive(Jason.Encoder, WeatherRecord)
end
