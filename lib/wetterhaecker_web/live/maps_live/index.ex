defmodule WetterhaeckerWeb.MapsLive.Index do
  use WetterhaeckerWeb, :live_view

  defmodule Form do
    @moduledoc """
    Form for the map page.
    """
    use Ecto.Schema
    import Ecto.Changeset

    embedded_schema do
      field :average_speed, :float
    end

    def changeset(form, params \\ %{}) do
      form
      |> cast(params, [:average_speed])
      |> validate_required([:average_speed])
      |> validate_number(:average_speed, greater_than: 0)
    end
  end

  @impl true
  def mount(_params, _session, socket) do
    changeset =
      Form.changeset(%Form{}, %{
        "average_speed" => 20.0
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
         points: Enum.map(gpx.points, &Map.from_struct/1)
       })}
    else
      {:ok, socket}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-4">
      <.form
        class="space-y-6 p-4 border rounded shadow"
        for={@form}
        id="map-form"
        phx-change="validate"
        phx-submit="save"
      >
        <h1 class="text-2xl">Wetterhaecker</h1>
        <.form_item>
          <.form_label>Average Speed (km/h)</.form_label>
          <.form_control>
            <.input phx-debounce="500" field={@form[:average_speed]} />
          </.form_control>
          <%!-- <.form_description>
                This is your public display name.
              </.form_description> --%>
        </.form_item>
        <fieldset class="relative space-y-4 flex pb-8">
          <%= with route_length = Float.ceil(@gpx.total_length / 1000, 2),
                   calc_hrs <- (@gpx.total_length / 1000 / @form[:average_speed].value) |> Float.ceil(2)  do %>
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
                  <.input name="calc_hrs" type="number" value={calc_hrs} disabled />
                </.form_control>
              </.form_item>
            </div>
            <legend class="absolute bottom-2 block text-sm text-gray-700">
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

      <div id="map" phx-hook="Map" phx-update="ignore" class="h-96"></div>
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
      Form.changeset(%Form{}, form_params |> IO.inspect(label: "form_params"))
      |> IO.inspect(label: "changeset")

    {:noreply, assign(socket, :form, to_form(changeset))}
  end
end
