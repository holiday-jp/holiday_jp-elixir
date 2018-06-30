defmodule HolidayJp do
  @moduledoc """
  Japanese holiday.
  """

  alias __MODULE__.{Holiday, Holidays}

  @doc """
  Returns holidays in Japan between start and last.

      iex> HolidayJp.between ~D[2016-03-01], ~D[2016-03-31]
      [
        %HolidayJp.Holiday{date: ~D[2016-03-20], week: "日", week_en: "Sunday", name: "春分の日", name_en: "Vernal Equinox Day"},
        %HolidayJp.Holiday{date: ~D[2016-03-21], week: "月", week_en: "Monday", name: "春分の日 振替休日", name_en: "Holiday in lieu"},
      ]
  """
  @spec between(Date.t(), Date.t()) :: [Holiday.t()]
  def between(start, last), do: Holidays.between(start, last)

  @doc """
  Detect the date is a holiday in Japan.

      iex> HolidayJp.holiday? ~D[2017-01-02]
      true

      iex> HolidayJp.holiday? ~D[2016-01-02]
      false
  """
  @spec holiday?(Date.t()) :: boolean
  def holiday?(date), do: Holidays.holiday?(date)

  @doc """
  Returns a list of holidays on the date.

      iex> HolidayJp.on ~D[2017-02-11]
      [%HolidayJp.Holiday{date: ~D[2017-02-11], week: "土", week_en: "Saturday", name: "建国記念の日", name_en: "National Foundation Day"}]

      iex> HolidayJp.on ~D[2017-02-13]
      []
  """
  @spec on(Date.t()) :: [Holiday.t()]
  def on(date), do: Holidays.between(date, date)
end
