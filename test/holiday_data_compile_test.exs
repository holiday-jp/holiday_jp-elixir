defmodule HolidayDataCompileTest do
  use ExUnit.Case, async: true

  test "compilation rejects empty, duplicate and unordered holiday data" do
    dir = Path.join(System.tmp_dir!(), "holiday-jp-compile-#{System.unique_integer([:positive])}")
    File.mkdir_p!(Path.join(dir, "lib/holiday_jp"))
    File.mkdir_p!(Path.join(dir, "priv"))
    on_exit(fn -> File.rm_rf!(dir) end)

    for name <- ["holiday.ex", "holidays.ex"] do
      File.cp!(Path.expand("../lib/holiday_jp/#{name}", __DIR__), Path.join(dir, "lib/holiday_jp/#{name}"))
    end

    first = ~s({"2017-01-01", "日", "Sunday", "元日", "New Year"})
    last = ~s({"2017-01-02", "月", "Monday", "休日", "Holiday"})

    for {data, error} <- [
          {"[]", "holiday data is empty"},
          {"[#{first}, #{first}]", "holiday dates must be strictly increasing"},
          {"[#{last}, #{first}]", "holiday dates must be strictly increasing"}
        ] do
      File.write!(Path.join(dir, "priv/holidays.exs"), data)

      {output, status} =
        System.cmd("elixir", ["-r", "lib/holiday_jp/holiday.ex", "-r", "lib/holiday_jp/holidays.ex", "-e", "nil"],
          cd: dir,
          stderr_to_stdout: true,
          env: [{"ERL_FLAGS", "+S 2:2"}]
        )

      assert status != 0
      assert output =~ error
    end
  end
end
