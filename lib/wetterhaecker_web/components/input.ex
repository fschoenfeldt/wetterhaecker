defmodule WetterhaeckerWeb.Components.Input do
  @moduledoc false
  use WetterhaeckerWeb.Component

  @doc """
  Displays a form input field or a component that looks like an input field.

  ## Examples

      <.input type="text" placeholder="Enter your name" />
      <.input type="email" placeholder="Enter your email" />
      <.input type="password" placeholder="Enter your password" />
  """
  attr :id, :any, default: nil
  attr :name, :any, default: nil
  attr :value, :any

  attr :type, :string,
    default: "text",
    values: ~w(date datetime-local email file hidden month number password tel text time url week)

  attr :"default-value", :any

  attr :field, Phoenix.HTML.FormField, doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :class, :any, default: nil

  attr :rest, :global, include: ~w(accept autocomplete capture cols disabled form list max maxlength min minlength
                multiple pattern placeholder readonly required rows size step)

  def input(assigns) do
    assigns = assigns |> prepare_assign() |> normalize_value()

    rest =
      Map.merge(assigns.rest, Map.take(assigns, [:id, :name, :value, :type]))

    assigns = assign(assigns, :rest, rest)

    ~H"""
    <input
      class={
        classes([
          "flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50",
          @class
        ])
      }
      {@rest}
    />
    """
  end

  defp normalize_value(%{type: type, value: value} = assigns) do
    case type do
      "datetime-local" ->
        Map.put(assigns, :value, date_time_to_input(value))

      _ ->
        assigns
    end
  end

  defp normalize_value(assigns), do: assigns

  # workaround with fixed timezone
  def date_time_from_input(value) do
    {:ok, date, _offet_secs} = DateTime.from_iso8601("#{value}:00Z+02:00")

    date
  end

  def date_time_to_input(%DateTime{} = date) do
    date
    |> DateTime.to_iso8601()
    |> String.slice(0..15//1)
  end
end
