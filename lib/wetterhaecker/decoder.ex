defmodule Wetterhaecker.Decoder do
  @moduledoc false

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
  @spec decode(map(), module()) :: struct()
  def decode(decoded, module) when is_map(decoded) do
    fields = module.__fields__(:t)

    struct_fields =
      Enum.map(fields, fn
        {key, {submodule, :t}} ->
          value = Map.get(decoded, Atom.to_string(key)) || Map.get(decoded, key)

          if is_map(value) do
            {key, decode(value, submodule)}
          else
            {key, value}
          end

        {key, [{submodule, :t}]} ->
          value = Map.get(decoded, Atom.to_string(key)) || Map.get(decoded, key)

          if is_list(value) do
            {key, Enum.map(value, &decode(&1, submodule))}
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
