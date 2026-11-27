defmodule HolidayDataCompileTest do
  use ExUnit.Case, async: true

  test "compilation rejects invalid holiday data" do
    dir = Path.join(System.tmp_dir!(), "holiday-jp-compile-#{System.unique_integer([:positive])}")
    File.mkdir_p!(Path.join(dir, "lib/holiday_jp"))
    File.mkdir_p!(Path.join(dir, "priv"))
    on_exit(fn -> File.rm_rf!(dir) end)

    source = File.read!(Path.expand("../lib/holiday_jp/holidays.ex", __DIR__))
    source = String.replace(source, "defmodule HolidayJp.Holidays do", "defmodule HolidayDataCompileTest.Generated do")
    module_path = Path.join(dir, "lib/holiday_jp/holidays.ex")
    File.write!(module_path, source)

    first = ~s({"2017-01-01", "日", "Sunday", "元日", "New Year"})
    last = ~s({"2017-01-02", "月", "Monday", "休日", "Holiday"})

    for {data, error} <- [
          {"[]", "holiday data is empty"},
          {"[#{first}, #{first}]", "holiday dates must be strictly increasing"},
          {"[#{last}, #{first}]", "holiday dates must be strictly increasing"},
          {"[{:bad}]", "row 1: expected five fields"},
          {~s([{"2017-01-01", nil, "Sunday", "元日", "New Year"}]), "row 1: week must be a nonempty string"},
          {~s([{"2017-02-30", "日", "Sunday", "元日", "New Year"}]), "row 1: invalid date"}
        ] do
      File.write!(Path.join(dir, "priv/holidays.exs"), data)
      exception = assert_raise RuntimeError, fn -> Code.compile_file(module_path) end
      assert exception.message =~ error
    end
  end
end
