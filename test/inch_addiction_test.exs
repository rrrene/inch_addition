defmodule InchAdditionTest do
  use ExUnit.Case

  defp config_range do
    1..21
  end

  defp test_mix_config(nr) do
    string = InchAdditionFixtures.mix_config(nr)

    # assert code compiles
    case Code.string_to_quoted(string) do
      {:ok, _} -> assert 1 == 1
      {:error, error} ->
        IO.inspect error
        assert 1 == 0, "Syntax error in fixture #{nr}."
    end
  end

  defp test_add_inch_ex_dep(nr) do
    string = InchAdditionFixtures.mix_config(nr)

    # assert code compiles
    assert {:ok, _} = Code.string_to_quoted(string)

    result = InchAddition.add_inch_ex_dep string

    # assert :inch_ex was inserted *somewhere*
    assert !is_nil( Regex.run(~r/\:inch_ex,/m, result) )
    # assert code compiles
    assert {:ok, _} = Code.string_to_quoted(result)
  end

  test "no syntax errors in fixtures" do
    Enum.each(config_range, &test_mix_config/1)
  end

  test "the truth" do
    Enum.each(config_range, &test_add_inch_ex_dep/1)
  end
end
