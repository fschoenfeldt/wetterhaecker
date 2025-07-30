defmodule Wetterhaecker.Weather.Brightsky.Operations do
  @moduledoc """
  Provides API endpoints related to operations
  """

  alias Wetterhaecker.Weather.Brightsky.AlertsResponse
  alias Wetterhaecker.Weather.Brightsky.Client
  alias Wetterhaecker.Weather.Brightsky.CurrentWeatherResponse
  alias Wetterhaecker.Weather.Brightsky.HTTPValidationError
  alias Wetterhaecker.Weather.Brightsky.NotFoundResponse
  alias Wetterhaecker.Weather.Brightsky.Operations
  alias Wetterhaecker.Weather.Brightsky.RadarResponse
  alias Wetterhaecker.Weather.Brightsky.WeatherResponse

  @default_client Client

  @doc """
  Alerts

  Returns a list of weather alerts for the given location, or all weather
  alerts if no location given.

  If you supply either `warn_cell_id` or both `lat` and `lon`, Bright Sky
  will return additional information on that cell in the `location` field.
  Warn cell IDs are municipality (_Gemeinde_) cell IDs.

  ### Notes

  * The DWD divides Germany's area into roughly 11,000 "cells" based on
    municipalities (_Gemeinden_), and issues warnings for each of these
    cells. Most warnings apply to many cells.
  * Bright Sky will supply information on the cell that a given lat/lon
    belongs to in the `location` field.
  * There is also a set of roughly 400 cells based on districts
    (_Landkreise_) that is not supported by Bright Sky.
  * The complete list of cells can be found on the DWD GeoServer (see below).

  ### Additional resources

  * [Live demo of a simple interactive alerts map](https://brightsky.dev/demo/alerts/)
  * [Source for alerts map demo](https://github.com/jdemaeyer/brightsky/blob/master/docs/demo/alerts/index.html)
  * [Map view of all current alerts by the DWD](https://www.dwd.de/DE/wetter/warnungen_gemeinden/warnWetter_node.html)
  * [List of municipality cells](https://maps.dwd.de/geoserver/wfs?SERVICE=WFS&VERSION=2.0.0&REQUEST=GetFeature&TYPENAMES=Warngebiete_Gemeinden&OUTPUTFORMAT=json)
  * [List of district cells (*not used by Bright Sky!*)](https://maps.dwd.de/geoserver/wfs?SERVICE=WFS&VERSION=2.0.0&REQUEST=GetFeature&TYPENAMES=Warngebiete_Kreise&OUTPUTFORMAT=json)
  * [Raw data on the Open Data Server](https://opendata.dwd.de/weather/alerts/cap/COMMUNEUNION_DWD_STAT/)
  * [DWD Documentation on alert fields and their allowed contents (English)](https://www.dwd.de/DE/leistungen/opendata/help/warnungen/cap_dwd_profile_en_pdf_2_1_13.pdf?__blob=publicationFile&v=3)
  * [DWD Documentation on alert fields and their allowed contents (German)](https://www.dwd.de/DE/leistungen/opendata/help/warnungen/cap_dwd_profile_de_pdf_2_1_13.pdf?__blob=publicationFile&v=3)

  ## Options

    * `lat`: Latitude in decimal degrees.
    * `lon`: Longitude in decimal degrees.
    * `warn_cell_id`: Municipality warn cell ID.
    * `tz`: Timezone in which record timestamps will be presented, as <a href="https://en.wikipedia.org/wiki/List_of_tz_database_time_zones">tz database name</a>. Will also be used as timezone when parsing `date` and `last_date`, unless these have explicit UTC offsets. If omitted but `date` has an explicit UTC offset, that offset will be used as timezone. Otherwise will default to UTC.

  """
  @spec get_alerts(keyword) ::
          {:ok, AlertsResponse.t()}
          | {:error,
             HTTPValidationError.t()
             | NotFoundResponse.t()}
  def get_alerts(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:lat, :lon, :tz, :warn_cell_id])

    client.request(%{
      args: [],
      call: {Operations, :get_alerts},
      url: "/alerts",
      method: :get,
      query: query,
      response: [
        {200, {AlertsResponse, :t}},
        {404, {NotFoundResponse, :t}},
        {422, {HTTPValidationError, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Current weather

  Returns current weather for a given location.

  To set the location for which to retrieve weather, you must supply both
  `lat` and `lon` _or_ one of `dwd_station_id`, `wmo_station_id`, or
  `source_id`.

  This endpoint is different from the other weather endpoints in that it does
  not directly correspond to any of the data available from the DWD Open Data
  server. Instead, it is a best-effort solution to reflect current weather
  conditions by compiling [SYNOP observations](/operations/getSynop) from the
  past one and a half hours.

  ## Options

    * `lat`: Latitude in decimal degrees.
    * `lon`: Longitude in decimal degrees.
    * `max_dist`: Maximum distance of record location from the location given by `lat` and `lon`, in meters. Only has an effect when using `lat` and `lon`.
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
  @spec get_current_weather(keyword) ::
          {:ok, CurrentWeatherResponse.t()}
          | {:error,
             HTTPValidationError.t()
             | NotFoundResponse.t()}
  def get_current_weather(opts \\ []) do
    client = opts[:client] || @default_client

    query =
      Keyword.take(opts, [
        :dwd_station_id,
        :lat,
        :lon,
        :max_dist,
        :source_id,
        :tz,
        :units,
        :wmo_station_id
      ])

    client.request(%{
      args: [],
      call: {Operations, :get_current_weather},
      url: "/current_weather",
      method: :get,
      query: query,
      response: [
        {200, {CurrentWeatherResponse, :t}},
        {404, {NotFoundResponse, :t}},
        {422, {HTTPValidationError, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Radar

  Returns radar rainfall data with 1 km spatial and 5 minute temporal
  resolution, including a forecast for the next two hours.

  Radar data is recorded on a 1200 km (North-South) x 1100 km (East-West)
  grid, with each pixel representing 1 km². **That's quite a lot of data, so
  use `lat`/`lon` or `bbox` whenever you can (see below).** Past radar
  records are kept for six hours.

  Bright Sky can return the data in a few formats. Use the default
  `compressed` format if possible – this'll get you the fastest response
  times by far and reduce load on the server. If you have a small-ish
  bounding box (e.g. 250 x 250 pixels), using the `plain` format should be
  fine.

  ### Quickstart

  This request will get you radar data near Münster, reaching 200 km to the
  East/West/North/South, as a two-dimensional grid of integers:

  [`https://api.brightsky.dev/radar?lat=52&lon=7.6&format=plain`](https://api.brightsky.dev/radar?lat=52&lon=7.6&format=plain)

  ### Content

  * The grid is a polar stereographic projection of Germany and the regions
    bordering it. This is different from the mercator projection used for
    most consumer-facing maps like OpenStreetMap or Google Maps, and
    overlaying the radar data onto such a map without conversion
    (reprojection) will be inaccurate! Check out our [radar
    demo](https://brightsky.dev/demo/radar/) for an example of correctly
    reprojecting the radar data using OpenLayers. Alternatively, take a look
    at the `dwd:RV-Produkt` layer on the [DWD's open
    GeoServer](https://maps.dwd.de/geoserver/web/wicket/bookmarkable/org.geoserver.web.demo.MapPreviewPage)
    for ready-made tiles you can overlay onto a map.
  * The [proj-string](https://proj.org/en/9.2/usage/quickstart.html) for the
    grid projection is `+proj=stere +lat_0=90 +lat_ts=60 +lon_0=10 +a=6378137
    +b=6356752.3142451802 +no_defs +x_0=543196.83521776402
    +y_0=3622588.8619310018`. The radar pixels range from `-500` (left) to
    `1099500` (right) on the x-axis, and from `500` (top) to `-1199500`
    (bottom) on the y-axis, each radar pixel a size of `1000x1000` (1 km²).
  * The DWD data does not cover the whole grid! Many areas near the edges
    will always be `0`.
  * Values represent 0.01 mm / 5 min. I.e., if a pixel has a value of `45`,
    then 0.45 mm of precipitation fell in the corresponding square kilometer
    in the past five minutes.
  * The four corners of the grid are as follows:
    * Northwest: Latitude `55.86208711`, Longitude `1.463301510`
    * Northeast: Latitude `55.84543856`, Longitude `18.73161645`
    * Southeast: Latitude `45.68460578`, Longitude `16.58086935`
    * Southwest: Latitude `45.69642538`, Longitude `3.566994635`

  You can find details and more information in the [DWD's `RV product info`
  (German
  only)](https://www.dwd.de/DE/leistungen/radarprodukte/formatbeschreibung_rv.pdf?__blob=publicationFile&v=3).
  Below is an example visualization of the rainfall radar data taken from
  this document, using the correct projection and showing the radar coverage:

  ![image](https://github.com/jdemaeyer/brightsky/assets/10531844/09f9bb5f-088a-417e-8a0c-ea5a20fe0969)

  ### Code examples

  > The radar data is quite big (naively unpacking the default 25-frames
  > response into Python integer arrays will eat roughly 125 MB of memory),
  > so use `bbox` whenever you can.

  #### `compressed` format

  With Javascript using [`pako`](https://github.com/nodeca/pako):

  ```js
  fetch(
    'https://api.brightsky.dev/radar'
  ).then((resp) => resp.json()
  ).then((respData) => {
    const raw = respData.radar[0].precipitation_5;
    const compressed = Uint8Array.from(atob(raw), c => c.charCodeAt(0));
    const rawBytes = pako.inflate(compressed).buffer;
    const precipitation = new Uint16Array(rawBytes);
  });
  ```

  With Python using `numpy`:

  ```python
  import base64
  import zlib

  import numpy as np
  import requests

  resp = requests.get('https://api.brightsky.dev/radar')
  raw = resp.json()['radar'][0]['precipitation_5']
  raw_bytes = zlib.decompress(base64.b64decode(raw))

  data = np.frombuffer(
      raw_bytes,
      dtype='i2',
  ).reshape(
      # Adjust `1200` and `1100` to the height/width of your bbox
      (1200, 1100),
  )
  ```

  With Python using the standard library's `array`:
  ```python
  import array

  # [... load raw_bytes as above ...]

  data = array.array('H')
  data.frombytes(raw_bytes)
  data = [
      # Adjust `1200` and `1100` to the height/width of your bbox
      data[row*1100:(row+1)*1100]
      for row in range(1200)
  ]
  ```

  Simple plot using `matplotlib`:
  ```python
  import matplotlib.pyplot as plt

  # [... load data as above ...]

  plt.imshow(data, vmax=50)
  plt.show()
  ```

  #### `bytes` format

  Same as for `compressed`, but add `?format=bytes` to the URL and remove the
  call to `zlib.decompress`, using just `raw_bytes = base64.b64decode(raw)`
  instead.

  #### `plain` format

  This is obviously a lot simpler than the `compressed` format. It is,
  however, also a lot slower. Nonetheless, if you have a small-ish `bbox` the
  performance difference becomes manageable, so just using the `plain` format
  and not having to deal with unpacking logic can be a good option in this
  case.

  With Python:
  ```python
  import requests

  resp = requests.get('https://api.brightsky.dev/radar?format=plain')
  data = resp.json()['radar'][0]['precipitation_5']
  ```

  ### Additional resources

  * [Source for our radar demo, including reprojecton via OpenLayers](https://github.com/jdemaeyer/brightsky/blob/master/docs/demo/radar/index.html)
  * [Raw data on the Open Data Server](https://opendata.dwd.de/weather/radar/composite/rv/)
  * [Details on the `RV` product (German)](https://www.dwd.de/DE/leistungen/radarprodukte/formatbeschreibung_rv.pdf?__blob=publicationFile&v=3)
  * [Visualization of current rainfall radar](https://www.dwd.de/DE/leistungen/radarbild_film/radarbild_film.html)
  * [General info on DWD radar products (German)](https://www.dwd.de/DE/leistungen/radarprodukte/radarprodukte.html)
  * [Radar status (German)](https://www.dwd.de/DE/leistungen/radarniederschlag/rn_info/home_freie_radarstatus_kartendaten.html?nn=16102)
  * [DWD notifications for radar products (German)](https://www.dwd.de/DE/leistungen/radolan/radolan_info/radolan_informationen.html?nn=16102)

  ## Options

    * `bbox`: Bounding box (top, left, bottom, right) **in pixels**, edges are inclusive. (_Defaults to full 1200x1100 grid._)
    * `distance`: Alternative way to set a bounding box, must be used together with `lat` and `lon`. Data will reach `distance` meters to each side of this location, but is possibly cut off at the edges of the radar grid.
    * `lat`: Latitude in decimal degrees.
    * `lon`: Longitude in decimal degrees.
    * `date`: Timestamp of first record to retrieve, in ISO 8601 format. May contain time and/or UTC offset. (_Defaults to 1 hour before latest measurement._)
    * `last_date`: Timestamp of last record to retrieve, in ISO 8601 format. May contain time and/or UTC offset. (_Defaults to 2 hours after `date`._)
    * `format`: 
      Determines how the precipitation data is encoded into the `precipitation_5` field:
      * `compressed`: base64-encoded, zlib-compressed bytestring of 2-byte integers
      * `bytes`: base64-encoded bytestring of 2-byte integers
      * `plain`: Nested array of integers
              
    * `tz`: Timezone in which record timestamps will be presented, as <a href="https://en.wikipedia.org/wiki/List_of_tz_database_time_zones">tz database name</a>. Will also be used as timezone when parsing `date` and `last_date`, unless these have explicit UTC offsets. If omitted but `date` has an explicit UTC offset, that offset will be used as timezone. Otherwise will default to UTC.

  """
  @spec get_radar(keyword) ::
          {:ok, RadarResponse.t()}
          | {:error,
             HTTPValidationError.t()
             | NotFoundResponse.t()}
  def get_radar(opts \\ []) do
    client = opts[:client] || @default_client
    query = Keyword.take(opts, [:bbox, :date, :distance, :format, :last_date, :lat, :lon, :tz])

    client.request(%{
      args: [],
      call: {Operations, :get_radar},
      url: "/radar",
      method: :get,
      query: query,
      response: [
        {200, {RadarResponse, :t}},
        {404, {NotFoundResponse, :t}},
        {422, {HTTPValidationError, :t}}
      ],
      opts: opts
    })
  end

  @doc """
  Hourly weather (including forecasts)

  Returns a list of hourly weather records (and/or forecasts) for the time
  range given by `date` and `last_date`.

  To set the location for which to retrieve records (and/or forecasts), you
  must supply both `lat` and `lon` _or_ one of `dwd_station_id`,
  `wmo_station_id`, or `source_id`.

  ## Options

    * `date`: Timestamp of first weather record (or forecast) to retrieve, in ISO 8601 format. May contain time and/or UTC offset.
    * `last_date`: Timestamp of last weather record (or forecast) to retrieve, in ISO 8601 format. Will default to `date + 1 day`.
    * `lat`: Latitude in decimal degrees.
    * `lon`: Longitude in decimal degrees.
    * `max_dist`: Maximum distance of record location from the location given by `lat` and `lon`, in meters. Only has an effect when using `lat` and `lon`.
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
  @spec get_weather(keyword) ::
          {:ok, WeatherResponse.t()}
          | {:error,
             HTTPValidationError.t()
             | NotFoundResponse.t()}
  def get_weather(opts \\ []) do
    client = opts[:client] || @default_client

    query =
      Keyword.take(opts, [
        :date,
        :dwd_station_id,
        :last_date,
        :lat,
        :lon,
        :max_dist,
        :source_id,
        :tz,
        :units,
        :wmo_station_id
      ])

    client.request(%{
      args: [],
      call: {Operations, :get_weather},
      url: "/weather",
      method: :get,
      query: query,
      response: [
        {200, {WeatherResponse, :t}},
        {404, {NotFoundResponse, :t}},
        {422, {HTTPValidationError, :t}}
      ],
      opts: opts
    })
  end
end
