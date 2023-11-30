defmodule AdventOfCode2022.Day5 do
  defp load do
    {:ok, data} = File.read("lib/resources/day5.txt")
    data
  end

  def calculate_1 do
    load()
    |> String.split("\n")
    |> Enum.reduce(%{stacks: [], moves: [], stack_count: 0}, &split_stacks_commands/2)
    |> map_stacks()
    |> map_moves()
    |> complete_moves()
    |> top_of_each_stack()
  end

  def calculate_2 do
    load()
    |> String.split("\n")
    |> Enum.reduce(%{stacks: [], moves: [], stack_count: 0}, &split_stacks_commands/2)
    |> map_stacks()
    |> map_moves()
    |> complete_moves_ordered()
    |> IO.inspect()
    |> (fn {stacks, _} -> stacks end).()
    |> top_of_each_stack()
  end

  defp split_stacks_commands(data, acc) do
    cond do
      String.contains?(data, "[") ->
        Map.update!(acc, :stacks, fn stacks -> [data | stacks] end)

      String.contains?(data, "move") ->
        Map.update!(acc, :moves, fn moves -> [data | moves] end)

      String.contains?(data, "1") ->
        %{
          acc
          | stack_count:
              String.split(data, " ", trim: true)
              |> List.last()
              |> String.to_integer()
        }

      true ->
        acc
    end
  end

  defp map_stacks(%{stacks: stacks, stack_count: stack_count} = data) do
    %{
      data
      | stacks:
          stacks
          |> Enum.map(&map_stack(&1, stack_count))
          |> Enum.reverse()
          |> Enum.zip()
          |> Enum.map(&Tuple.to_list/1)
          |> Enum.map(&filter_empty/1)
    }
  end

  defp map_stack(data, stack_count) do
    chunk_length = round(String.length(data) / stack_count)

    data
    |> String.graphemes()
    |> Enum.chunk_every(chunk_length)
    |> filter_stacks()
  end

  defp filter_stacks(stacks) do
    Enum.map(stacks, &filter_stack/1)
  end

  defp filter_stack(stack) do
    Enum.filter(stack, fn column -> String.match?(column, ~r/[a-z]|[A-Z]/) end)
  end

  defp filter_empty(values) do
    Enum.filter(values, &(&1 != []))
  end

  defp map_moves(%{moves: moves} = data) do
    %{
      data
      | moves:
          extract_moves(moves)
          |> Enum.map(fn [qty, from, to] ->
            %{
              qty: String.to_integer(qty),
              from: String.to_integer(from) - 1,
              to: String.to_integer(to) - 1
            }
          end)
          |> Enum.reverse()
    }
  end

  defp extract_moves(moves) do
    Enum.map(moves, fn move ->
      String.split(move, " ")
      |> Enum.filter(&String.match?(&1, ~r/\d+/))
    end)
  end

  defp complete_moves(%{moves: moves, stacks: stacks}) do
    Enum.reduce(moves, stacks, &complete_move/2)
  end

  defp complete_move(%{qty: qty}, stacks) when qty == 0 do
    stacks
  end

  defp complete_move(%{to: to, from: from, qty: qty} = move, stacks) do
    to_col = Enum.at(stacks, to)
    [box | from_col_updated] = Enum.at(stacks, from)
    to_col_updated = [box | to_col]

    udpated_stacks =
      List.replace_at(stacks, from, from_col_updated) |> List.replace_at(to, to_col_updated)

    complete_move(%{move | qty: qty - 1}, udpated_stacks)
  end

  defp complete_moves_ordered(%{moves: moves, stacks: stacks}) do
    Enum.reduce(moves, {stacks, []}, &complete_move_ordered/2)
  end

  defp complete_move_ordered(%{qty: qty, to: to}, {stacks, moved}) when qty == 0 do
    to_col = Enum.at(stacks, to)
    IO.inspect(moved)
    to_col_updated = Enum.reverse(moved) ++ to_col
    udpated_stacks = List.replace_at(stacks, to, to_col_updated)
    {udpated_stacks, []}
  end

  defp complete_move_ordered(%{from: from, qty: qty} = move, {stacks, moved}) do
    IO.inspect(move)
    [box | from_col_updated] = Enum.at(stacks, from)

    udpated_stacks =
      List.replace_at(stacks, from, from_col_updated)

    complete_move_ordered(%{move | qty: qty - 1}, {udpated_stacks, [box | moved]})
  end

  defp top_of_each_stack(stacks) do
    Enum.reduce(stacks, "", fn stack, code ->
      top = List.first(stack)
      "#{code}#{top}"
    end)
  end


end
