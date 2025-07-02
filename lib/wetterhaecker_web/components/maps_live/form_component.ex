defmodule WetterhaeckerWeb.Components.MapsLive.FormComponent do
  @moduledoc """
  A component that renders the form for configuring the route and weather calculation.

  This component handles user input for GPX file upload, start date/time,
  average speed, and sampling rate.
  """
  use WetterhaeckerWeb, :live_component

  alias Wetterhaecker.Gpx.Utils

  defmodule Form do
    @moduledoc """
    Form schema for the map page.

    Defines the data structure and validation rules for the form.
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

  @doc """
  Renders the form component.

  ## Examples

      <.live_component
        module={WetterhaeckerWeb.Components.MapsLive.FormComponent}
        id="form"
        form={@form}
        gpx={@gpx}
      />
  """
  attr :id, :string, required: true
  attr :form, :map, required: true, doc: "the form data in form of a `Form` struct"
  attr :gpx, :map, required: true, doc: "the GPX map in form of a `Wetterhaecker.Gpx.gpx_with_length`"

  @impl true
  def mount(socket) do
    # Initialize form with default values
    now = DateTime.utc_now()
    two_hours_later = DateTime.add(now, 2, :hour)

    changeset =
      Form.changeset(%Form{}, %{
        "average_speed" => 20.0,
        "sampling_rate" => 20,
        "start_date_time" => two_hours_later
      })

    socket =
      socket
      |> assign(:form, to_form(changeset))
      |> allow_upload(:gpx_file,
        accept: ~w(.gpx),
        max_entries: 1
      )

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="weather-form" class="lg:col-span-3">
      <.form
        class="space-y-6 p-4 border rounded shadow"
        for={@form}
        id="map-form"
        phx-submit="save"
        phx-change="validate"
        phx-target={@myself}
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

  @doc """
  Handles the validate event.

  This is required for live file uploads to work properly:
  https://hexdocs.pm/phoenix_live_view/uploads.html#render-reactive-elements
  """
  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  # Handles the save event when the form is submitted.
  # Validates the form data, processes any uploaded GPX file,
  # and sends events to update the map and chart components.
  @impl true
  def handle_event("save", %{"form" => form_params}, socket) do
    changeset =
      Form.changeset(%Form{}, form_params)

    # Process form data
    if changeset.valid? do
      form = to_form(changeset)

      # Process any uploaded GPX file
      maybe_gpx_file = consume_gpx_upload(socket)

      # Send the form data and GPX file result to the parent component
      send(
        self(),
        {:form_submitted,
         %{
           form: form,
           gpx_result: maybe_gpx_file
         }}
      )

      {:noreply, assign(socket, form: form)}
    else
      {:noreply, socket |> put_flash(:error, "Invalid form data")}
    end
  end

  defp consume_gpx_upload(socket) do
    socket
    |> consume_uploaded_entries(:gpx_file, fn %{path: path}, _entry ->
      {:ok, Wetterhaecker.Gpx.get_from_path(path)}
    end)
    |> List.first()
  end
end
