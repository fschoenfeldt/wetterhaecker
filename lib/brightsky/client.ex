defmodule Wetterhaecker.Brightsky.Client do
  @base_url "https://api.brightsky.dev/"

  def request(%{
        method: method,
        query: query,
        url: url,
        response: response
      }) do
    request = %HTTPoison.Request{
      method: method,
      url: @base_url <> url,
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

      map(decoded, module)
    end
  end

  @doc """
  Recursively maps a decoded map (typically from JSON) to a struct of the given module.

  This function inspects the fields of the target module and attempts to populate them
  from the provided `decoded` map. It handles nested structs and lists of structs by
  recursively calling itself for fields that are themselves structs or lists of structs.

  ## Parameters

    - decoded: The map containing the data to be mapped into the struct.
    - module: The module representing the struct to be created.

  ## Returns

    - A struct of type `module` populated with data from `decoded`.

  ## Example

      iex> map(%{"foo" => 1, "bar" => %{"baz" => 2}}, MyStruct)
      %MyStruct{foo: 1, bar: %BarStruct{baz: 2}}

  """
  defp map(decoded, module) do
    fields = module.__fields__(:t)

    struct_fields =
      Enum.map(fields, fn
        {key, {submodule, :t}} ->
          value = Map.get(decoded, Atom.to_string(key)) || Map.get(decoded, key)

          if is_map(value) do
            {key, map(value, submodule)}
          else
            {key, value}
          end

        {key, [{submodule, :t}]} ->
          value = Map.get(decoded, Atom.to_string(key)) || Map.get(decoded, key)

          if is_list(value) do
            {key, Enum.map(value, &map(&1, submodule))}
          else
            {key, value}
          end

        {key, _type} ->
          value = Map.get(decoded, Atom.to_string(key)) || Map.get(decoded, key)
          {key, value}
      end)
      |> Enum.into(%{})

    struct(module, struct_fields)
  end
end
