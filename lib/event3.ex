defmodule Event3 do
  def run do
    part1_ruleset = [{3, 1}]
    part2_ruleset = [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    IO.puts("Test part1: #{solver("input/event3/test.txt", part1_ruleset)}")
    IO.puts("Puzzle part1: #{solver("input/event3/puzzle.txt", part1_ruleset)}")
    IO.puts("Test part2: #{solver("input/event3/test.txt", part2_ruleset)}")
    IO.puts("Puzzle part2: #{solver("input/event3/puzzle.txt", part2_ruleset)}")
  end

  def solver(path, ruleset) do
    accs = Enum.map(ruleset, &rule_to_acc/1)

    input_stream(path)
    |> Stream.drop(1)
    |> Stream.transform(accs, &transform_fun2/2)
    |> Stream.take(-length(ruleset))
    |> Stream.flat_map(& &1)
    |> Enum.reduce(&(&1 * &2))
  end

  def input_stream(path), do: path |> File.stream!() |> Stream.map(&parse_input/1)

  def parse_input(input), do: String.trim(input) |> String.graphemes() |> Enum.map(&(&1 == "#"))

  def transform_fun(input, {count, index, step, step_down, step_down}) do
    width = length(input)

    next_index =
      case index + step do
        new when new > width - 1 -> new - width
        new -> new
      end

    count = count + ((Enum.at(input, index - 1) && 1) || 0)
    {[count], {count, next_index, step, step_down, 1}}
  end

  def transform_fun(_input, {count, index, step, step_down, down_counter}),
    do: {[count], {count, index, step, step_down, down_counter + 1}}

  def transform_fun2(input, acc) do
    Enum.map(acc, &transform_fun(input, &1))
    |> Enum.unzip()
  end

  def rule_to_acc({right, down}), do: {0, right + 1, right, down, 1}
end
