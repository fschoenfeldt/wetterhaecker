defmodule Wetterhaecker.Weather.Brightsky.Client do
  @moduledoc """
  Client for Brightsky API requests.
  """

  # TODO: don't use Brightsky directly!
  alias Wetterhaecker.Weather.Brightsky.WeatherResponse

  defp base_url, do: Application.get_env(:wetterhaecker, __MODULE__)[:base_url]

  @spec request(map()) :: {:ok, any()} | {:error, any()}
  def request(%{method: method, query: query, url: url, response: response}) do
    request =
      %HTTPoison.Request{
        method: method,
        url: base_url() <> url,
        headers: [
          {"Content-Type", "application/json"},
          {"Accept", "application/json"}
        ],
        params: query
      }

    with {:ok, %HTTPoison.Response{status_code: status_code, body: body}} <-
           HTTPoison.request(request),
         {:ok, decoded} <- Jason.decode(body) do
      # response is a list of tuples of the form {status_code, {module, type}}
      # e.g. {200, {Wetterhaecker.Brightsky.CurrentWeatherResponse, :t}}
      # so based on the status code we can find the right module and type
      # and decode the response into the right struct
      {_status_code, {module, _type}} =
        Enum.find(response, fn {code, _} -> code == status_code end)

      decoded
      |> Wetterhaecker.Decoder.decode(module)
      |> response()
    end
  end

  @spec response(any()) :: {:ok, any()} | {:error, any()}
  defp response(%WeatherResponse{} = result) do
    {:ok, result}
  end

  defp response(error) do
    {:error, error}
  end
end
