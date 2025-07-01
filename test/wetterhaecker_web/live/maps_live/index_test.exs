defmodule WetterhaeckerWeb.MapsLive.IndexTest do
  use WetterhaeckerWeb.ConnCase, async: true

  import Phoenix.Component, only: [to_form: 1]
  import Phoenix.LiveViewTest

  alias WetterhaeckerWeb.Components.MapsLive.{
    MapComponent,
    ChartComponent,
    FormComponent
  }

  alias WetterhaeckerWeb.MapsLive.Index

  test "renders all components correctly", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/")

    assert html =~ "id=\"map\""
    assert html =~ "id=\"chart\""
    assert html =~ "id=\"weather-form\""
  end

  test "handles gpx error and displays flash message", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    form = %{}
    gpx_result = {:error, "reason"}

    send(
      view.pid,
      {:form_submitted,
       %{
         form: form,
         gpx_result: gpx_result
       }}
    )

    html_after = render(view)

    assert html_after =~ "Failed to process GPX file"
  end

  @tag :todo
  test "handles form submission when no gpx file is provided", %{conn: conn} do
  end

  # TODO: in order to do this test, we need to mock brightsky.
  @tag :todo
  @tag :skip
  test "handles form submission and updates map and chart", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    form =
      FormComponent.Form.changeset(
        %FormComponent.Form{},
        %{
          "total_length" => 100,
          "average_speed" => 20
        }
      )
      |> to_form()

    gpx_result =
      {:ok,
       %{
         points: []
       }}

    send(
      view.pid,
      {:form_submitted,
       %{
         form: form,
         gpx_result: gpx_result
       }}
    )

    render(view)
  end

  @tag :todo
  test "processes uploaded GPX file when available", %{conn: conn} do
    # TODO: Implement test to simulate GPX file upload and check if map and chart are updated accordingly
    # Hint: Simulate the form_submitted event with a successful GPX file
  end

  @tag :todo
  test "handles form submission with error result", %{conn: conn} do
    # TODO: Implement test to simulate form submission with an error and check if error flash is shown
    # Hint: Check if the error message is displayed correctly
  end
end
