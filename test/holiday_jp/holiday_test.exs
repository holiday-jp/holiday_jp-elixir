defmodule HolidayJpHolidayTest do
  use ExUnit.Case, async: true

  doctest HolidayJp.Holiday

  test "requires all holiday fields when constructed" do
    assert_raise ArgumentError, fn ->
      struct!(HolidayJp.Holiday, date: ~D[2017-11-23])
    end
  end
end
