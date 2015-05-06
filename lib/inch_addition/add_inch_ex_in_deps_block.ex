defmodule InchAddition.AddInchExInDepsBlock do
  @doc """
    Finds the dependencies block in a config file.
  """
  def run(string) do
    lines = String.split(string, ~r{\r\n?|\n})

    add(string, find_deps_block(lines))
  end

  defp add(string, deps_string) do
    new_deps_string = String.replace(deps_string, ~r/(\s*\]\s*end\s*)$/m, ", #{inch_ex_entry}\\1")
                      |> replace_empty_deps_list
    String.replace(string, deps_string, new_deps_string)
  end

  defp inch_ex_entry do
    InchAddition.AddInchEx.inch_ex_entry
  end

  defp replace_empty_deps_list(deps_string) do
    String.replace(deps_string, "[, #{inch_ex_entry}]", "[#{inch_ex_entry}]")
  end

  defp find_deps_block(lines, found_lines \\ [], in_deps_block \\ false)

  defp find_deps_block([first | lines], found_lines, in_deps_block) do
    if in_deps_block do
      found_lines = found_lines ++ [first]
      if Regex.run(~r/^\s*end\s*$/m, first) do
        in_deps_block = false
      end
    else
      if Regex.run(~r/defp* deps.+/m, first) do
        in_deps_block = true
        found_lines = found_lines ++ [first]
      end
    end
    find_deps_block(lines, found_lines, in_deps_block)
  end

  defp find_deps_block([], found_lines, _) do
    case Enum.count(found_lines) do
      0 -> nil
      _ -> Enum.join(found_lines, "\n")
    end
  end
end
