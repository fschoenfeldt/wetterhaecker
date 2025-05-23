defmodule Wetterhaecker.Encoder do
  require Protocol
  Protocol.derive(Jason.Encoder, GpxEx.TrackPoint)
end
