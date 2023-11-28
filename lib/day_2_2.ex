defmodule AdventOfCode2022.Day2_2 do
  alias AdventOfCode2022.Resources.Day2_1

  # A = Rock
  # B = Paper
  # C = Scissors
  # Y = Paper
  # X = Rock
  # Z = Scissors

  # Y = Draw
  # X = Loose
  # Z = Win

  def play do
    Day2_1.data()
    |> Enum.filter(&(length(&1) != 0))
    |> Enum.map(&choose_round/1)
    |> Enum.map(&([map_round(&1)] ++ &1))
    |> Enum.map(&map_score(&1))
    |> Enum.map(&calc_score(&1))
    |> Enum.reduce([0, 0], &calc_total_score(&1, &2))
  end

  defp choose_round([o, y]) when o == "A" do
    case y do
      "Y" -> [o, "X"]
      "X" -> [o, "Z"]
      "Z" -> [o, "Y"]
    end
  end

  defp choose_round([o, y]) when o == "B" do
    case y do
      "Y" -> [o, "Y"]
      "X" -> [o, "X"]
      "Z" -> [o, "Z"]
    end
  end

  defp choose_round([o, y]) when o == "C" do
    case y do
      "Y" -> [o, "Z"]
      "X" -> [o, "Y"]
      "Z" -> [o, "X"]
    end
  end

  defp map_round([o, y]) when o == "A" do
    case y do
      "Y" -> [0, 6]
      "X" -> [3, 3]
      "Z" -> [6, 0]
    end
  end

  defp map_round([o, y]) when o == "B" do
    case y do
      "Y" -> [3, 3]
      "X" -> [6, 0]
      "Z" -> [0, 6]
    end
  end

  defp map_round([o, y]) when o == "C" do
    case y do
      "Y" -> [6, 0]
      "X" -> [0, 6]
      "Z" -> [3, 3]
    end
  end

  defp map_score([score, o, y]) do
    [score, [get_play_score(o), get_play_score(y)]]
  end

  defp get_play_score(play) do
    case play do
      "A" -> 1
      "B" -> 2
      "C" -> 3
      "Y" -> 2
      "X" -> 1
      "Z" -> 3
    end
  end

  defp calc_score([[o1, y1], [o2, y2]]) do
    [o1 + o2, y1 + y2]
  end

  defp calc_total_score([o, y], [a_o, a_y]) do
    [o + a_o, y + a_y]
  end
end
