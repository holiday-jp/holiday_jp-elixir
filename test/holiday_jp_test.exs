defmodule HolidayJpTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  doctest HolidayJp

  describe "HolidayJp.between/2" do
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
