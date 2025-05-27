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
    end

    def changeset(form, params \\ %{}) do
      form
      |> cast(params, [:average_speed, :sampling_rate])
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
        "sampling_rate" => 60
      })

    {:ok, gpx} = Wetterhaecker.Gpx.get("Langeoog.gpx")

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
        <div id="map" phx-hook="Map" phx-update="ignore" class="h-96 lg:h-screen"></div>
      </div>

      <.form
        class="space-y-6 p-4 border rounded shadow lg:col-span-3"
        for={@form}
        id="map-form"
        phx-change="validate"
        phx-submit="save"
      >
        <h1 class="text-2xl">Wetterhaecker</h1>
        <.form_item>
          <.form_label field={@form[:average_speed]}>
            Average Speed (km/h)
          </.form_label>
          <.form_control>
            <.input type="number" phx-debounce="500" field={@form[:average_speed]} />
          </.form_control>
          <.form_description>
            Average speed you expect to travel.
          </.form_description>
        </.form_item>
        <.form_item>
          <.form_label field={@form[:sampling_rate]}>Sampling Rate (mins)</.form_label>
          <.form_control>
            <.input type="number" min="5" max="120" phx-debounce="500" field={@form[:sampling_rate]} />
          </.form_control>
          <.form_description>
            The rate at which the weather data is sampled.
          </.form_description>
        </.form_item>
        <fieldset class="relative space-y-4 flex pb-12">
          <%= with route_length = Utils.route_length_km(@gpx),
                   calc_hrs <- Utils.estimated_route_time_hours(@gpx, @form) do %>
            <div class="flex gap-x-4">
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
            <legend class="absolute bottom-0 block text-sm text-gray-500">
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

  # TODO: do we really need this?
  @impl true
  def handle_event("validate", params, socket) do
    IO.inspect(params, label: "validate")
    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"form" => form_params}, socket) do
    changeset =
      Form.changeset(%Form{}, form_params)

    # TODO: handle error case
    if changeset.valid? do
      form = to_form(changeset)

      {:noreply,
       socket
       |> assign(:form, form)
       |> push_event("map:drawUpdate", %{
         points: add_time_and_weather(form, socket.assigns.gpx)
       })}
    else
      {:noreply, socket |> put_flash(:error, "Invalid form data")}
    end
  end

  defp add_time_and_weather(form, gpx) do
    points = gpx.points
    estimated_time = Utils.estimated_route_time(gpx, form)
    sampling_rate = Phoenix.HTML.Form.input_value(form, :sampling_rate)

    points
    |> Utils.wrap_with_index()
    |> Utils.update_points_time(
      estimated_time,
      # TODO: use the start date from the form
      DateTime.utc_now()
    )
    |> Utils.sample_weather_points(
      estimated_time,
      sampling_rate
    )
    |> Utils.add_weather_data()
  end
end
