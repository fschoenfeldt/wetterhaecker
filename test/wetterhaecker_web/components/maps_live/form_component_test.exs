defmodule WetterhaeckerWeb.Components.MapsLive.FormComponentTest do
  use WetterhaeckerWeb.ConnCase, async: true

  import Phoenix.Component, only: [to_form: 1]
  import Phoenix.LiveViewTest

  alias Wetterhaecker.Gpx
  alias WetterhaeckerWeb.Components.MapsLive.FormComponent

  setup do
    {:ok, gpx} = Gpx.get_from_preset()

    %{
      gpx: gpx,
      form:
        to_form(
          FormComponent.Form.changeset(%FormComponent.Form{}, %{
            "average_speed" => 20.0,
            "sampling_rate" => 20,
            "start_date_time" => DateTime.utc_now() |> DateTime.add(2, :hour)
          })
        )
    }
  end

  @tag :todo
  test "renders form with all inputs", %{conn: conn, form: form, gpx: gpx} do
    # TODO: Implement test to check if the form renders all expected inputs and elements
    # Hint: Use render_component/3 for LiveComponents
  end

  @tag :todo
  test "form component initializes with default values", %{conn: conn, gpx: gpx} do
    # TODO: Implement test to check if the form initializes with correct default values
  end

  @tag :todo
  test "validate event returns unchanged socket", %{conn: conn, form: form, gpx: gpx} do
    # TODO: Implement test to check if the validate event returns the unchanged socket
  end

  @tag :todo
  test "save event with valid form sends form_submitted message", %{conn: conn, form: form, gpx: gpx} do
    # TODO: Implement test to check if the save event sends the correct message to the parent
  end

  @tag :todo
  test "save event with invalid form shows error", %{conn: conn, gpx: gpx} do
    # TODO: Teste die save-Event-Verarbeitung mit ungültigen Formulardaten
  end
end
