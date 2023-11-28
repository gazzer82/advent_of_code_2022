defmodule AdventOfCode2022.Day3_1 do
  defp load do
    {:ok, data} = File.read("lib/resources/day3_1.txt")
    data
  end

  def sort do
    load()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Enum.filter(&(length(&1) != 0))
    |> Enum.map(&split/1)
    |> Enum.map(&find_common/1)
    |> Enum.map(&map_value/1)
    |> Enum.reduce(0, &(&1 + &2))
  end

  defp split(list) do
    length = round(length(list) / 2)
    {p1, p2} = Enum.split(list, length)
    [p1, p2]
  end

  defp find_common([p1, p2]) do
    Enum.filter(p1, &Enum.member?(p2, &1))
    |> Enum.take(1)
  end

  defp map_value([item]) do
    get_char_value(:binary.first(item))
  end

  defp get_char_value(index) when index >= 97 and index <= 122 do
    index - 96
  end

  defp get_char_value(index) when index >= 65 and index <= 90 do
    index - 38
  end
end
