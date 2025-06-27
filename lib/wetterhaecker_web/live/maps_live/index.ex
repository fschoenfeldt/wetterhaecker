defmodule WetterhaeckerWeb.MapsLive.Index do
  use WetterhaeckerWeb, :live_view

  alias WetterhaeckerWeb.Components.MapsLive.{
    MapComponent,
    ChartComponent,
    FormComponent,
    Utils
  }

  @impl true
  def mount(_params, _session, socket) do
    changeset =
      FormComponent.Form.changeset(%FormComponent.Form{}, %{
        "average_speed" => 20.0,
        "sampling_rate" => 20,
        "start_date_time" => DateTime.utc_now() |> DateTime.add(2, :hour)
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

    if connected?(socket) do
      {:ok,
       socket
       |> MapComponent.init_map(
         %{
           lat: 53.551086,
           lon: 9.993682,
           zoom: 10
         },
         gpx.points
       )}
    else
      {:ok, socket}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-4 lg:space-y-0 lg:grid lg:grid-cols-8 lg:gap-4 lg:min-h-screen p-4 lg:p-8">
      <div class="h-full w-full lg:col-span-5">
        <.live_component module={MapComponent} id="map" />
        <.live_component module={ChartComponent} id="chart" />
      </div>

      <.live_component module={FormComponent} id="form" form={@form} gpx={@gpx} />
    </div>
    """
  end

  # we need to implement the validate callback because
  # of the live file upload: https://hexdocs.pm/phoenix_live_view/uploads.html#render-reactive-elements
  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info({:form_submitted, %{form: form, gpx_result: gpx_result}}, socket) do
    socket =
      case gpx_result do
        {:ok, gpx} ->
          socket |> assign(:gpx, gpx)

        # no GPX file uploaded
        nil ->
          socket

        {:error, reason} ->
          socket |> put_flash(:error, "Failed to process GPX file: #{reason}")
      end

    # Update the form
    socket = assign(socket, :form, form)

    # Calculate weather points
    weather_points = Utils.add_time_and_weather(socket.assigns.form, socket.assigns.gpx)

    # Update the map and chart components
    socket =
      socket
      |> MapComponent.update_gpx_points(socket.assigns.gpx.points)
      |> MapComponent.update_weather_points(weather_points)
      |> ChartComponent.update_weather_data(weather_points)

    {:noreply, socket}
  end
end
