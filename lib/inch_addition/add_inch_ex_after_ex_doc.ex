defmodule InchAddition.AddInchExAfterExDoc do
  @doc """
    Finds the :ex_doc dependency in a config file.
  """
  def run(string) do
    lines = String.split(string, ~r{\r\n?|\n})

    case find_ex_doc_entry(lines) do
      {:ok, ex_doc_entry, indent} -> add_after(string, ex_doc_entry, indent)
      {:error} -> nil
    end
  end

  defp add_after(string, ex_doc_entry, indent) do
    inch_ex_entry = InchAddition.AddInchEx.inch_ex_entry
    replacement = "#{ex_doc_entry},\n#{indent}#{inch_ex_entry}"
    String.replace(string, ex_doc_entry, replacement)
  end

  defp find_ex_doc_entry(lines)

  defp find_ex_doc_entry([first | lines]) do
    if Regex.run(~r/({\s*:ex_doc.+?\})/m, first) do
      exdoc_matches = Regex.run(~r/({\s*:ex_doc.+?\})/, first)
      indent_matches = Regex.run(~r/(^\s*)/, first)
      indent = Enum.at(indent_matches, 1)
      {:ok, Enum.at(exdoc_matches, 1), indent}
    else
      find_ex_doc_entry(lines)
    end
  end

  defp find_ex_doc_entry([]) do
    {:error}
  end
end
