defmodule InchAddition.AddInchEx do
  def inch_ex_entry do
    "{:inch_ex, only: :docs}"
  end

  def on_string(string) do
    result = InchAddition.AddInchExAfterExDoc.run(string)
    if is_nil(result) do
      result = InchAddition.AddInchExInDepsBlock.run(string)
    end
    result
  end
end
