defmodule Wetterhaecker.Brightsky.Client do
  # fire up mock with
  # prism mock priv/static/brightsky_openapi.json
  # defp base_url, do: "http://127.0.0.1:4010"
  defp base_url, do: "https://api.brightsky.dev"

  def request(%{
        method: method,
        query: query,
        url: url,
        response: response
      }) do
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

      Wetterhaecker.Decoder.decode(decoded, module)
    end
  end
end
