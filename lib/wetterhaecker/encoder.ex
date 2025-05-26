defmodule Wetterhaecker.Encoder do
  require Protocol
  Protocol.derive(Jason.Encoder, GpxEx.TrackPoint)
  Protocol.derive(Jason.Encoder, Wetterhaecker.Brightsky.Source)
  Protocol.derive(Jason.Encoder, Wetterhaecker.Brightsky.WeatherResponse)
  Protocol.derive(Jason.Encoder, Wetterhaecker.Brightsky.WeatherRecord)
end
