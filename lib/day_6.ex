defmodule AdventOfCode2022.Day6 do
  defp load do
    {:ok, data} = File.read("lib/resources/day6.txt")
    data
  end

  def find(length) do
    load()
    |> String.graphemes()
    |> Enum.with_index(fn element, index -> {index + 1, element} end)
    |> check_for_code(length)
  end

  defp check_for_code(data, length) when length(data) < length do
    0
  end

  defp check_for_code(data, length) do
    code = Enum.take(data, length)

    case validate_code(code, length) do
      true ->
        [{index, _code} | _] = Enum.reverse(code)
        index

      false ->
        check_for_code(tl(data), length)
    end
  end

  defp validate_code(code, length) do
    code = Enum.map(code, fn {_, key} -> key end)

    validated_code =
      Enum.frequencies(code)
      |> Map.to_list()
      |> Enum.filter(fn {_key, count} -> count == 1 end)

    length(validated_code) == length
  end
end
