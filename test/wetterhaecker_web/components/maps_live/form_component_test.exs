defmodule WetterhaeckerWeb.Components.MapsLive.FormComponentTest do
  use WetterhaeckerWeb.ConnCase, async: true

  import LiveIsolatedComponent
  import Phoenix.Component, only: [to_form: 1]
  import Phoenix.LiveViewTest

  alias Wetterhaecker.Gpx

  # alias Wetterhaecker.Gpx
  alias WetterhaeckerWeb.Components.MapsLive.FormComponent
  alias WetterhaeckerWeb.Components.MapsLive.FormComponent.Form

  setup do
    form =
      to_form(
        Form.changeset(%Form{}, %{
          "average_speed" => 20.0,
          "sampling_rate" => 20,
          "start_date_time" => DateTime.utc_now() |> DateTime.add(2, :hour)
        })
      )

    {:ok, gpx} = Gpx.get_from_preset()

    {:ok, view, _html} =
      live_isolated_component(
        FormComponent,
        assigns: %{
          id: "form",
          form: form,
          gpx: gpx
        }
      )

    %{
      gpx: gpx,
      form: form,
      view: view
    }
  end

  describe "mount/3" do
    test "initial render renders form with all inputs", %{form: form, gpx: gpx} do
      actual = render_component(FormComponent, id: "form", form: form, gpx: gpx)

      assert actual =~ "GPX File"
      assert actual =~ "Start Date/Time"
      assert actual =~ "Average Speed (km/h)"

      assert actual =~ "Sampling Rate"
      assert actual =~ "Average Speed (km/h)"
    end
  end

  test "save event with valid form sends form_submitted message", %{form: form, view: view} do
    view
    |> element("form")
    |> render_submit()

    assert_handle_info(view, {:form_submitted, actual})

    assert actual.form.data == form.data
    # we haven't selected a file so gpx_result should be nil
    assert actual.gpx_result == nil
  end

  test "save event with invalid form doesn't send form_submitted message", %{view: view} do
    view
    |> element("#map-form")
    |> render_submit(%{
      "form" => %{
        average_speed: "invalid_input",
        sampling_rate: 99,
        start_date_time: DateTime.utc_now() |> DateTime.add(2, :hour)
      }
    })

    refute_handle_info(view, {:form_submitted, _})
  end
end
