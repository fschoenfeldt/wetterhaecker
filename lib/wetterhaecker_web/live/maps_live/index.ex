defmodule WetterhaeckerWeb.MapsLive.Index do
  use WetterhaeckerWeb, :live_view
  alias Wetterhaecker.Gpx.Utils

  defmodule Form do
    @moduledoc """
    Form for the map page.
    """
    use Ecto.Schema
    import Ecto.Changeset

    embedded_schema do
      field :average_speed, :float
      field :sampling_rate, :integer
      field :start_date_time, :utc_datetime
    end

    def changeset(form, params \\ %{}) do
      form
      |> cast(params, [:average_speed, :sampling_rate, :start_date_time])
      |> validate_required([:start_date_time])
      |> validate_required([:average_speed, :sampling_rate])
      |> validate_number(:average_speed, greater_than: 0)
      |> validate_number(:sampling_rate, greater_than: 4, less_than: 121)
    end
  end

  @impl true
  def mount(_params, _session, socket) do
    changeset =
      Form.changeset(%Form{}, %{
        "average_speed" => 20.0,
        "sampling_rate" => 20,
        "start_date_time" => DateTime.utc_now() |> DateTime.add(2, :hour) |> date_time_to_input()
      })

    # initially we use a preset GPX file
    {:ok, gpx} = Wetterhaecker.Gpx.get_from_preset()

    socket =
      socket
      |> assign(:gpx, gpx)
      |> assign(
        :form,
        to_form(changeset)
      )
      |> allow_upload(:gpx_file,
        accept: ~w(.gpx),
        max_entries: 1
      )

    if connected?(socket) do
      {:ok,
       socket
       |> push_event("map:init", %{
         initial: %{
           lat: 53.551086,
           lon: 9.993682,
           zoom: 10
         },
         points: gpx.points
       })}
    else
      {:ok, socket}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-4 lg:grid lg:grid-cols-8 lg:gap-4 lg:min-h-screen">
      <div class="h-full w-full lg:col-span-5">
        <div id="map" phx-hook="Map" phx-update="ignore" class="h-[50vh] lg:h-[calc(100vh-16rem)]">
        </div>
        <div id="chart" phx-hook="Chart" phx-update="ignore" class="h-[50vh] lg:h-64 p-2">
          <div class="flex items-center justify-center h-full bg-gray-50">
            <p class="text-center text-gray-500">
              Weather data will be displayed here after you submit the form.
            </p>
          </div>
        </div>
      </div>

      <.form
        class="space-y-6 p-4 border rounded shadow lg:col-span-3"
        for={@form}
        id="map-form"
        phx-submit="save"
        multipart
      >
        <h1 class="text-2xl">Wetterhaecker</h1>
        <.form_item>
          <%!-- # HACK: this is a workaround so that the form label works
                        for the live_file_input. --%>
          <.form_label field={
            %Phoenix.HTML.FormField{
              id: @uploads.gpx_file.ref,
              name: @uploads.gpx_file.ref,
              field: :gpx_file,
              value: nil,
              form: %Phoenix.HTML.Form{},
              errors: []
            }
          }>
            GPX File
          </.form_label>
          <.form_control>
            <div>
              <.live_file_input upload={@uploads.gpx_file} />
            </div>
          </.form_control>
          <.form_description>
            Upload a custom GPX file to visualize the route on the map.
          </.form_description>
        </.form_item>
        <.form_item>
          <.form_label field={@form[:start_date_time]}>
            Start Date/Time
          </.form_label>
          <.form_control>
            <.input type="datetime-local" field={@form[:start_date_time]} required />
          </.form_control>
          <.form_description>
            The date and time when you start your route, timezone is MESZ (+02:00).
          </.form_description>
        </.form_item>
        <div class="md:flex gap-x-4">
          <.form_item>
            <.form_label field={@form[:average_speed]}>
              Average Speed (km/h)
            </.form_label>
            <.form_control>
              <.input type="number" phx-debounce="500" field={@form[:average_speed]} required />
            </.form_control>
            <.form_description>
              Average speed you expect to travel.
            </.form_description>
          </.form_item>
          <.form_item>
            <.form_label field={@form[:sampling_rate]}>Sampling Rate (mins)</.form_label>
            <.form_control>
              <.input
                type="number"
                min="5"
                max="120"
                phx-debounce="500"
                field={@form[:sampling_rate]}
                required
              />
            </.form_control>
            <.form_description>
              The rate at which the weather data is sampled.
            </.form_description>
          </.form_item>
        </div>

        <hr />
        <fieldset class="relative space-y-4 flex pb-12">
          <%= with route_length = Utils.route_length_km(@gpx),
                   calc_hrs <- Utils.estimated_route_time_hours(@gpx, @form) do %>
            <div class="md:flex gap-x-4">
              <.form_item>
                <.form_label>Total Route length (km)</.form_label>
                <.form_control>
                  <.input type="number" name="route_length" disabled value={route_length} />
                </.form_control>
              </.form_item>
              <.form_item>
                <.form_label>Estimated time (hrs)</.form_label>
                <.form_control>
                  <%!-- # TODO: display as ##h ##mins instead. --%>
                  <.input name="calc_hrs" type="number" value={calc_hrs} disabled />
                </.form_control>
              </.form_item>
            </div>
            <legend class="absolute bottom-0 block text-sm text-gray-800">
              These values are calculated based on the GPX file and the given average speed.
            </legend>
          <% end %>
        </fieldset>
        <div class="w-full flex flex-row-reverse">
          <.button type="submit" phx-disable-with="Saving...">
            Get Weather!!1
          </.button>
        </div>
      </.form>
    </div>
    """
  end

  @impl true
  def handle_event("save", %{"form" => form_params}, socket) do
    IO.inspect(form_params, label: "save")

    changeset =
      Form.changeset(%Form{}, form_params) |> IO.inspect(label: "changeset")

    socket =
      if changeset.valid? do
        form = to_form(changeset)

        socket
        |> assign(:form, form)
      else
        socket |> put_flash(:error, "Invalid form data")
      end

    maybe_gpx_file = consume_gpx_upload(socket)

    socket =
      case maybe_gpx_file do
        {:ok, gpx} ->
          socket |> assign(:gpx, gpx)

        # no GPX file uploaded
        nil ->
          socket

        {:error, reason} ->
          socket |> put_flash(:error, "Failed to process GPX file: #{reason}")
      end

    socket =
      socket
      |> push_event("map:drawGpxFileUpdate", %{
        points: socket.assigns.gpx.points
      })
      |> push_event("map:drawWeatherUpdate", %{
        points: add_time_and_weather(socket.assigns.form, socket.assigns.gpx)
      })
      |> push_event("chart:drawWeatherUpdate", %{
        points: add_time_and_weather(socket.assigns.form, socket.assigns.gpx)
      })

    {:noreply, socket}
  end

  defp consume_gpx_upload(socket) do
    socket
    |> consume_uploaded_entries(:gpx_file, fn %{path: path}, _entry ->
      {:ok, Wetterhaecker.Gpx.get_from_path(path)}
    end)
    |> List.first()
  end

  defp add_time_and_weather(form, gpx) do
    points = gpx.points
    estimated_time = Utils.estimated_route_time(gpx, form)
    sampling_rate = Phoenix.HTML.Form.input_value(form, :sampling_rate)

    start_date_time =
      form
      |> Phoenix.HTML.Form.input_value(:start_date_time)

    points
    |> Utils.wrap_with_index()
    |> Utils.update_points_time(
      estimated_time,
      start_date_time
    )
    |> Utils.sample_weather_points(
      estimated_time,
      sampling_rate
    )
    |> Utils.add_weather_data()
  end
end
