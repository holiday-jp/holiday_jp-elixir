defmodule GenerateHolidaysTest do
  use ExUnit.Case, async: true

  alias Mix.Tasks.Generate.Holidays

  test "rejects empty and duplicate data without overwriting the output" do
    dir = Path.join(System.tmp_dir!(), "holiday-jp-#{System.unique_integer([:positive])}")
    File.mkdir_p!(dir)
    on_exit(fn -> File.rm_rf!(dir) end)
    source = Path.join(dir, "holidays.yml")
    dest = Path.join(dir, "holidays.exs")
    File.write!(dest, "unchanged")

    entry = "2017-01-01:\n  week: 日\n  week_en: Sunday\n  name: 元日\n  name_en: New Year\n"
    File.write!(source, entry)
    Holidays.generate(source, dest)
    output = File.read!(dest)
    Holidays.generate(source, dest)
    assert File.read!(dest) == output
    File.write!(dest, "unchanged")

    for empty <- ["", "\n", "---\n", "{}\n"] do
      File.write!(source, empty)
      assert_raise RuntimeError, ~r/empty/, fn -> Holidays.generate(source, dest) end
      assert File.read!(dest) == "unchanged"
    end

    File.write!(source, entry <> entry)
    assert_raise RuntimeError, ~r/duplicate/, fn -> Holidays.generate(source, dest) end
    assert File.read!(dest) == "unchanged"

    for invalid <- [
          String.replace(entry, "  name_en: New Year\n", ""),
          String.replace(entry, "  week: 日", "  week: ''"),
          String.replace(entry, "  name: 元日", "  name: '  '")
        ] do
      File.write!(source, invalid)
      assert_raise RuntimeError, ~r/missing|empty/, fn -> Holidays.generate(source, dest) end
      assert File.read!(dest) == "unchanged"
    end

    assert Path.wildcard(dest <> ".*.tmp") == []
  end

  test "a failed rename leaves the destination and no temporary file" do
    dir = Path.join(System.tmp_dir!(), "holiday-jp-rename-#{System.unique_integer([:positive])}")
    File.mkdir_p!(dir)
    on_exit(fn -> File.rm_rf!(dir) end)
    source = Path.join(dir, "holidays.yml")
    dest = Path.join(dir, "existing_directory")
    File.mkdir!(dest)
    File.write!(Path.join(dest, "keep"), "unchanged")
    File.write!(source, "2017-01-01:\n  week: 日\n  week_en: Sunday\n  name: 元日\n  name_en: New Year\n")

    assert_raise File.RenameError, fn -> Holidays.generate(source, dest) end
    assert File.read!(Path.join(dest, "keep")) == "unchanged"
    assert Path.wildcard(dest <> ".*.tmp") == []
  end
end
