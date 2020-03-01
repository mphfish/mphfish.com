defmodule MapUtil do
  @moduledoc false
  @doc """
  Elixirizes the given `Map`.
  By that, we:
  - Normalize the keys to be `Atom`
  - Transform the keys to snake_case

  Callers should be weary of using this function for truly dynamic data,
  as Atoms are not GC'd, and there is a hard limit on them.

  """
  def elixirize(map) when is_map(map), do: Map.new(map, &transform_elixir/1)
  def elixirize(value), do: value

  defp transform_elixir({key, value}) when is_atom(key),
    do: {key |> Atom.to_string() |> Recase.to_snake() |> String.to_atom(), elixirize_value(value)}

  defp transform_elixir({key, value}) when is_bitstring(key),
    do: {key |> Recase.to_snake() |> String.to_atom(), elixirize_value(value)}

  defp elixirize_value(value) when is_list(value), do: Enum.map(value, &elixirize_value/1)
  defp elixirize_value(%DateTime{} = value), do: value
  defp elixirize_value(%Date{} = value), do: value
  defp elixirize_value(%Time{} = value), do: value
  defp elixirize_value(value) when is_map(value), do: elixirize(value)
  defp elixirize_value(value), do: value
end
