defmodule AdventOfCode2022.Day4 do
  defp load do
    {:ok, data} = File.read("lib/resources/day4.txt")
    data
  end

  def calculate_1 do
    load()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(&make_integers/1)
    |> Enum.map(&contains?/1)
    |> Enum.filter(&filter_contains_overlaps/1)
    |> Enum.count()
  end

  def calculate_2 do
    load()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(&make_integers/1)
    |> Enum.map(&overlaps?/1)
    |> Enum.map(&contains?/1)
    |> Enum.filter(&filter_contains_overlaps/1)
    |> Enum.count()
  end

  defp make_integers([s, e]) do
    [s1, e1] = String.split(s, "-")
    [s2, e2] = String.split(e, "-")
    {String.to_integer(s1), String.to_integer(e1), String.to_integer(s2), String.to_integer(e2)}
  end

  defp contains?({s1, e1, s2, e2}) when s1 <= s2 and e1 >= e2 do
    {s1, e1, s2, e2, true, :rf}
  end

  defp contains?({s1, e1, s2, e2}) when s2 <= s1 and e2 >= e1 do
    {s1, e1, s2, e2, true, :lh}
  end

  defp contains?({s1, e1, s2, e2}) do
    {s1, e1, s2, e2, false}
  end

  defp contains?(coords) do
    coords
  end

  defp overlaps?({s1, e1, s2, e2}) when s1 >= s2 and s1 <= e2 do
    {s1, e1, s2, e2, true, :rh}
  end

  defp overlaps?({s1, e1, s2, e2}) when e1 >= s2 and e1 <= e2 do
    {s1, e1, s2, e2, true, :lh}
  end

  defp overlaps?(coords), do: coords

  defp filter_contains_overlaps({_s1, _e1, _s2, _e2, true, _}), do: true

  defp filter_contains_overlaps(_), do: false
end
