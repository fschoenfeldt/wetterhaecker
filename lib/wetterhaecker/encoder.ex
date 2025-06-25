defmodule Wetterhaecker.Encoder do
  @moduledoc """
  Protocol derivations for JSON encoding.
  """

  require Protocol

  Protocol.derive(Jason.Encoder, GpxEx.TrackPoint)
  Protocol.derive(Jason.Encoder, Wetterhaecker.Brightsky.Source)
  Protocol.derive(Jason.Encoder, Wetterhaecker.Brightsky.WeatherResponse)
  Protocol.derive(Jason.Encoder, Wetterhaecker.Brightsky.WeatherRecord)
end
