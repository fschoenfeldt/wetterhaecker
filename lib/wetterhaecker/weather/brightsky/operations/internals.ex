defmodule Wetterhaecker.Weather.Brightsky.Internals do
  @moduledoc """
  Provides API endpoints related to internals
  """

  alias Wetterhaecker.Weather.Brightsky.Client
  alias Wetterhaecker.Weather.Brightsky.HTTPValidationError
  alias Wetterhaecker.Weather.Brightsky.Internals
  alias Wetterhaecker.Weather.Brightsky.NotFoundResponse
  alias Wetterhaecker.Weather.Brightsky.SourcesResponse
  alias Wetterhaecker.Weather.Brightsky.SynopResponse

  @default_client Client

  @doc """
  Weather sources (stations)

  Return a list of all Bright Sky sources matching the given location
  criteria, ordered by distance.

  You must supply both `lat` and `lon` _or_ one of `dwd_station_id`,
  `wmo_station_id`, or `source_id`.

  ## Options

    * `lat`: Latitude in decimal degrees.
    * `lon`: Longitude in decimal degrees.
    * `max_dist`: Maximum distance of record location from the location given by `lat` and `lon`, in meters. Only has an effect when using `lat` and `lon`.
    * `dwd_station_id`: DWD station ID, typically five alphanumeric characters. You can supply multiple station IDs separated by commas, ordered from highest to lowest priority.
    * `wmo_station_id`: WMO station ID, typically five alphanumeric characters. You can supply multiple station IDs separated by commas, ordered from highest to lowest priority.
    * `source_id`: Bright Sky source ID, as retrieved from the [`/sources` endpoint](/operations/getSources). You can supply multiple source IDs separated by commas, ordered from highest to lowest priority.
    * `tz`: Timezone in which record timestamps will be presented, as <a href="https://en.wikipedia.org/wiki/List_of_tz_database_time_zones">tz database name</a>. Will also be used as timezone when parsing `date` and `last_date`, unless these have explicit UTC offsets. If omitted but `date` has an explicit UTC offset, that offset will be used as timezone. Otherwise will default to UTC.

  """
  @spec get_sources(keyword) ::
          {:ok, SourcesResponse.t()}
          | {:error,
             HTTPValidationError.t()
             | NotFoundResponse.t()}
  def get_sources(opts \\ []) do
    client = opts[:client] || @default_client

    query =
      Keyword.take(opts, [
        :dwd_station_id,
        :lat,
        :lon,
        :max_dist,
        :source_id,
        :tz,
        :wmo_station_id
      ])

    client.request(%{
      args: [],
      call: {Internals, :get_sources},
      url: "/sources",
      method: :get,
      query: query,
      response: [
        {200, {SourcesResponse, :t}},
        {404, {NotFoundResponse, :t}},
        {422, {HTTPValidationError, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Raw SYNOP observations

  Returns a list of ten-minutely SYNOP observations for the time range given
  by `date` and `last_date`. Note that Bright Sky only stores SYNOP
  observations from the past 30 hours.

  To set the weather station for which to retrieve records, you must supply
  one of `dwd_station_id`, `wmo_station_id`, or `source_id`. The `/synop`
  endpoint does not support `lat` and `lon`; use the
  [`/sources` endpoint](/operations/getSources) if you need to retrieve a
  SYNOP station ID close to a given location.

  SYNOP observations are stored as they were reported, which in particular
  implies that many parameters are only available at certain timestamps. For
  example, most stations report `sunshine_60` only on the full hour, and
  `sunshine_30` only at 30 minutes past the full hour (i.e. also not on the
  full hour). Check out the
  [`/current_weather` endpoint](/operations/getCurrentWeather) for an
  opinionated compilation of recent SYNOP records into a single "current
  weather" record.

  ## Options

    * `date`: Timestamp of first weather record (or forecast) to retrieve, in ISO 8601 format. May contain time and/or UTC offset.
    * `last_date`: Timestamp of last weather record (or forecast) to retrieve, in ISO 8601 format. Will default to `date + 1 day`.
    * `dwd_station_id`: DWD station ID, typically five alphanumeric characters. You can supply multiple station IDs separated by commas, ordered from highest to lowest priority.
    * `wmo_station_id`: WMO station ID, typically five alphanumeric characters. You can supply multiple station IDs separated by commas, ordered from highest to lowest priority.
    * `source_id`: Bright Sky source ID, as retrieved from the [`/sources` endpoint](/operations/getSources). You can supply multiple source IDs separated by commas, ordered from highest to lowest priority.
    * `tz`: Timezone in which record timestamps will be presented, as <a href="https://en.wikipedia.org/wiki/List_of_tz_database_time_zones">tz database name</a>. Will also be used as timezone when parsing `date` and `last_date`, unless these have explicit UTC offsets. If omitted but `date` has an explicit UTC offset, that offset will be used as timezone. Otherwise will default to UTC.
    * `units`: Physical units in which meteorological parameters will be returned. Set to `si` to use <a href="https://en.wikipedia.org/wiki/International_System_of_Units">SI units</a> (except for precipitation, which is always measured in millimeters). The default `dwd` option uses a set of units that is more common in meteorological applications and civil use:
      <table>
        <tr><td></td><td>DWD</td><td>SI</td></tr>
        <tr><td>Cloud cover</td><td>%</td><td>%</td></tr>
        <tr><td>Dew point</td><td>°C</td><td>K</td></tr>
        <tr><td>Precipitation</td><td>mm</td><td><s>kg / m²</s> <strong>mm</strong></td></tr>
        <tr><td>Precipitation probability</td><td>%</td><td>%</td></tr>
        <tr><td>Pressure</td><td>hPa</td><td>Pa</td></tr>
        <tr><td>Relative humidity</td><td>%</td><td>%</td></tr>
        <tr><td>Solar irradiation</td><td>kWh / m²</td><td>J / m²</td></tr>
        <tr><td>Sunshine</td><td>min</td><td>s</td></tr>
        <tr><td>Temperature</td><td>°C</td><td>K</td></tr>
        <tr><td>Visibility</td><td>m</td><td>m</td></tr>
        <tr><td>Wind (gust) direction</td><td>°</td><td>°</td></tr>
        <tr><td>Wind (gust) speed</td><td>km / h</td><td>m / s</td></tr>
      </table>

  """
  @spec get_synop(keyword) ::
          {:ok, SynopResponse.t()}
          | {:error,
             HTTPValidationError.t()
             | NotFoundResponse.t()}
  def get_synop(opts \\ []) do
    client = opts[:client] || @default_client

    query =
      Keyword.take(opts, [
        :date,
        :dwd_station_id,
        :last_date,
        :source_id,
        :tz,
        :units,
        :wmo_station_id
      ])

    client.request(%{
      args: [],
      call: {Internals, :get_synop},
      url: "/synop",
      method: :get,
      query: query,
      response: [
        {200, {SynopResponse, :t}},
        {404, {NotFoundResponse, :t}},
        {422, {HTTPValidationError, :t}}
      ],
      opts: opts
    })
  end
end
