defmodule HolidayJpTest.ISOCalendar do
  defdelegate date_to_iso_days(year, month, day), to: Calendar.ISO
  defdelegate day_rollover_relative_to_midnight_utc(), to: Calendar.ISO
  defdelegate naive_datetime_to_iso_days(year, month, day, hour, minute, second, microsecond), to: Calendar.ISO
end

defmodule HolidayJpTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  doctest HolidayJp

  test "lookups reject date-time values" do
    datetime = ~N[2017-01-01 12:00:00]
    assert_raise FunctionClauseError, fn -> HolidayJp.holiday?(datetime) end
    assert_raise FunctionClauseError, fn -> HolidayJp.between(datetime, ~D[2017-01-01]) end
    assert_raise FunctionClauseError, fn -> HolidayJp.between(~D[2017-01-01], datetime) end
    assert_raise FunctionClauseError, fn -> HolidayJp.on(datetime) end
  end

  test "lookups compare dates in compatible calendars" do
    holiday = %Date{~D[2017-01-01] | calendar: HolidayJpTest.ISOCalendar}
    weekday = %Date{~D[2017-01-03] | calendar: HolidayJpTest.ISOCalendar}
    assert HolidayJp.holiday?(holiday)
    refute HolidayJp.holiday?(weekday)
    assert [%{date: ~D[2017-01-01]}] = HolidayJp.on(holiday)
  end

  test "the complete dataset is ordered and lookup agrees at every date" do
    holidays = HolidayJp.between(~D[0000-01-01], ~D[9999-12-31])
    dates = Enum.map(holidays, & &1.date)
    assert dates == Enum.sort(dates, Date)
    assert length(dates) == length(Enum.uniq(dates))

    for holiday <- holidays do
      assert HolidayJp.holiday?(holiday.date)
      assert HolidayJp.on(holiday.date) == [holiday]
    end
  end

  property "range lookup agrees with a linear scan" do
    holidays = HolidayJp.between(~D[0000-01-01], ~D[9999-12-31])

    check all(
            start <- date(min: ~D[1940-01-01], max: ~D[2160-12-31]),
            last <- date(min: ~D[1940-01-01], max: ~D[2160-12-31])
          ) do
      expected =
        Enum.filter(holidays, fn holiday ->
          Date.compare(start, holiday.date) != :gt and Date.compare(holiday.date, last) != :gt
        end)

      assert HolidayJp.between(start, last) == expected
    end
  end

  describe "HolidayJp.between/2" do
    test "returns no holidays for a reversed range" do
      assert HolidayJp.between(~D[2017-01-10], ~D[2017-01-01]) == []
      assert HolidayJp.between(~D[2017-01-02], ~D[2017-01-01]) == []
    end

    property "includes a known holiday at either boundary and excludes it outside the range" do
      check all(
              date <- member_of([~D[2017-01-01], ~D[2017-01-09], ~D[2017-02-11], ~D[2017-12-23]]),
              distance <- integer(1..30)
            ) do
        previous = Date.add(date, -distance)
        following = Date.add(date, distance)

        assert Enum.any?(HolidayJp.between(date, following), &(&1.date == date))
        assert Enum.any?(HolidayJp.between(previous, date), &(&1.date == date))
        refute Enum.any?(HolidayJp.between(previous, Date.add(date, -1)), &(&1.date == date))
        refute Enum.any?(HolidayJp.between(Date.add(date, 1), following), &(&1.date == date))
        assert [%{date: ^date}] = HolidayJp.between(date, date)
        assert HolidayJp.between(following, previous) == []
      end
    end

    test "it returns holidays in Japan between the start<= and <=the last" do
      expected = [
        %HolidayJp.Holiday{
          date: ~D[2017-01-01],
          week: "日",
          week_en: "Sunday",
          name: "元日",
          name_en: "New Year's Day"
        },
        %HolidayJp.Holiday{
          date: ~D[2017-01-02],
          week: "月",
          week_en: "Monday",
          name: "元日 振替休日",
          name_en: "Holiday in lieu"
        },
        %HolidayJp.Holiday{
          date: ~D[2017-01-09],
          week: "月",
          week_en: "Monday",
          name: "成人の日",
          name_en: "Coming of Age Day"
        },
        %HolidayJp.Holiday{
          date: ~D[2017-02-11],
          week: "土",
          week_en: "Saturday",
          name: "建国記念の日",
          name_en: "National Foundation Day"
        },
        %HolidayJp.Holiday{
          date: ~D[2017-03-20],
          week: "月",
          week_en: "Monday",
          name: "春分の日",
          name_en: "Vernal Equinox Day"
        },
        %HolidayJp.Holiday{
          date: ~D[2017-04-29],
          week: "土",
          week_en: "Saturday",
          name: "昭和の日",
          name_en: "Showa Day"
        },
        %HolidayJp.Holiday{
          date: ~D[2017-05-03],
          week: "水",
          week_en: "Wednesday",
          name: "憲法記念日",
          name_en: "Constitution Memorial Day"
        },
        %HolidayJp.Holiday{
          date: ~D[2017-05-04],
          week: "木",
          week_en: "Thursday",
          name: "みどりの日",
          name_en: "Greenery Day"
        },
        %HolidayJp.Holiday{
          date: ~D[2017-05-05],
          week: "金",
          week_en: "Friday",
          name: "こどもの日",
          name_en: "Children's Day"
        },
        %HolidayJp.Holiday{
          date: ~D[2017-07-17],
          week: "月",
          week_en: "Monday",
          name: "海の日",
          name_en: "Marine Day"
        },
        %HolidayJp.Holiday{
          date: ~D[2017-08-11],
          week: "金",
          week_en: "Friday",
          name: "山の日",
          name_en: "Mountain Day"
        },
        %HolidayJp.Holiday{
          date: ~D[2017-09-18],
          week: "月",
          week_en: "Monday",
          name: "敬老の日",
          name_en: "Respect for the Aged Day"
        },
        %HolidayJp.Holiday{
          date: ~D[2017-09-23],
          week: "土",
          week_en: "Saturday",
          name: "秋分の日",
          name_en: "Autumnal Equinox Day"
        },
        %HolidayJp.Holiday{
          date: ~D[2017-10-09],
          week: "月",
          week_en: "Monday",
          name: "体育の日",
          name_en: "Health and Sports Day"
        },
        %HolidayJp.Holiday{
          date: ~D[2017-11-03],
          week: "金",
          week_en: "Friday",
          name: "文化の日",
          name_en: "National Culture Day"
        },
        %HolidayJp.Holiday{
          date: ~D[2017-11-23],
          week: "木",
          week_en: "Thursday",
          name: "勤労感謝の日",
          name_en: "Labor Thanksgiving Day"
        },
        %HolidayJp.Holiday{
          date: ~D[2017-12-23],
          week: "土",
          week_en: "Saturday",
          name: "天皇誕生日",
          name_en: "Emperor's Birthday"
        }
      ]

      assert expected === HolidayJp.between(~D[2017-01-01], ~D[2017-12-31])
    end
  end

  describe "HolidayJp.holiday?/1" do
    test "it is true when the date is a holiday in Japan" do
      assert HolidayJp.holiday?(~D[2017-01-01])
      assert HolidayJp.holiday?(~D[2017-01-02])
      assert HolidayJp.holiday?(~D[2017-01-09])
      assert HolidayJp.holiday?(~D[2017-02-11])
      assert HolidayJp.holiday?(~D[2017-03-20])
      assert HolidayJp.holiday?(~D[2017-04-29])
      assert HolidayJp.holiday?(~D[2017-05-03])
      assert HolidayJp.holiday?(~D[2017-05-04])
      assert HolidayJp.holiday?(~D[2017-05-05])
      assert HolidayJp.holiday?(~D[2017-07-17])
      assert HolidayJp.holiday?(~D[2017-08-11])
      assert HolidayJp.holiday?(~D[2017-09-18])
      assert HolidayJp.holiday?(~D[2017-09-23])
      assert HolidayJp.holiday?(~D[2017-10-09])
      assert HolidayJp.holiday?(~D[2017-11-03])
      assert HolidayJp.holiday?(~D[2017-11-23])
      assert HolidayJp.holiday?(~D[2017-12-23])
    end

    test "it isn't true when the date isn't a holiday in Japan" do
      refute HolidayJp.holiday?(~D[2017-01-03])
      refute HolidayJp.holiday?(~D[2017-01-08])
      refute HolidayJp.holiday?(~D[2017-01-10])
      refute HolidayJp.holiday?(~D[2017-02-12])
      refute HolidayJp.holiday?(~D[2017-03-19])
      refute HolidayJp.holiday?(~D[2017-03-21])
      refute HolidayJp.holiday?(~D[2017-04-28])
      refute HolidayJp.holiday?(~D[2017-04-30])
      refute HolidayJp.holiday?(~D[2017-05-02])
      refute HolidayJp.holiday?(~D[2017-05-06])
      refute HolidayJp.holiday?(~D[2017-07-16])
      refute HolidayJp.holiday?(~D[2017-07-18])
      refute HolidayJp.holiday?(~D[2017-08-10])
      refute HolidayJp.holiday?(~D[2017-08-12])
      refute HolidayJp.holiday?(~D[2017-09-17])
      refute HolidayJp.holiday?(~D[2017-09-19])
      refute HolidayJp.holiday?(~D[2017-09-22])
      refute HolidayJp.holiday?(~D[2017-09-24])
      refute HolidayJp.holiday?(~D[2017-10-08])
      refute HolidayJp.holiday?(~D[2017-10-10])
      refute HolidayJp.holiday?(~D[2017-11-02])
      refute HolidayJp.holiday?(~D[2017-11-04])
      refute HolidayJp.holiday?(~D[2017-11-22])
      refute HolidayJp.holiday?(~D[2017-11-24])
      refute HolidayJp.holiday?(~D[2017-12-22])
      refute HolidayJp.holiday?(~D[2017-12-24])
    end
  end
end
